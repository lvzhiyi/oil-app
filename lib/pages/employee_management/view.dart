import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/employee_management/controller.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/pages/employee_management/state.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/date_util.dart';
import 'package:lottery_app/utils/text_util.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';
import 'package:lottery_app/widgets/common/sports_app_bar.dart';
// import 'package:lottery_app/widgets/common/section_card.dart';
import 'package:lottery_app/widgets/common/labeled_input.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';

import 'model/rest_employee_response_data.dart';
import 'widgets/new_password_info_dialog.dart';

class EmployeeManagementView extends HookWidget {
  final EmployeeManagementState state;

  const EmployeeManagementView({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EmployeeManagementCtrl>();
    final searchController =
        useTextEditingController(text: state.searchKeyword);

    return Scaffold(
      appBar: SportsAppBar(
        title: '员工管理',
        actions: [
          IconButton(
            onPressed: () {
              // 点击按钮时也隐藏键盘
              FocusScope.of(context).unfocus();
              controller.navigateToCreateEmployee(context);
            },
            icon: Icon(
              Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // 确保即使点击到子组件也能触发
        onTap: () {
          // 点击任何区域时隐藏键盘
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8FAFF),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildSearchAndFilter(
                context,
                controller,
                searchController,
              ),
              Expanded(
                child: _buildEmployeeList(context, controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建搜索和筛选区域
  Widget _buildSearchAndFilter(
    BuildContext context,
    EmployeeManagementCtrl controller,
    TextEditingController searchController,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(pt(20), pt(16), pt(20), 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(pt(16)),
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: pt(1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: pt(16),
                    offset: Offset(0, pt(4)),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: pt(12)),
              height: pt(48),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: AppColors.textSecondary, size: pt(20)),
                  Gap(pt(8)),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: '搜索员工名称',
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style:
                          SportsTextStyle.baseNormal.copyWith(fontSize: pt(14)),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        controller.searchEmployees(value.trim());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(pt(12)),
          Container(
            height: pt(48),
            padding: EdgeInsets.symmetric(horizontal: pt(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(pt(16)),
              border: Border.all(
                color: const Color(0xFFE8E8E8),
                width: pt(1),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: pt(16),
                  offset: Offset(0, pt(4)),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(pt(16)),
              onTap: () {
                _openFilterBottomSheet(context, controller);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_list, color: AppColors.textPrimary),
                  Gap(pt(6)),
                  Text(
                    '筛选',
                    style: SportsTextStyle.baseNormal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterBottomSheet(
    BuildContext context,
    EmployeeManagementCtrl controller,
  ) {
    final TextEditingController usernameController =
        TextEditingController(text: state.usernameFilter);
    final TextEditingController phoneController =
        TextEditingController(text: state.phoneFilter);
    String orderByName = state.orderByName;
    String orderByType = state.orderByType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(pt(16))),
      ),
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent, // 确保即使点击到子组件也能触发
          onTap: () {
            // 点击空白区域时隐藏键盘
            FocusScope.of(ctx).unfocus();
          },
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部手柄
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => FocusScope.of(ctx).unfocus(),
                      child: Padding(
                        padding: EdgeInsets.only(top: pt(8)),
                        child: Center(
                          child: Container(
                            width: pt(40),
                            height: pt(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(pt(2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(pt(16)),
                      child: Row(
                        children: [
                          Text(
                            '筛选条件',
                            style: SportsTextStyle.baseBold
                                .copyWith(fontSize: pt(16)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              FocusScope.of(ctx).unfocus();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(height: pt(1)),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(pt(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledInput(
                              label: '员工名称',
                              hintText: '请输入员工名称',
                              controller: usernameController,
                            ),
                            Gap(pt(12)),
                            LabeledInput(
                              label: '手机号',
                              hintText: '请输入手机号',
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                            ),
                            Gap(pt(12)),
                            Text(
                              '排序方式',
                              style: SportsTextStyle.grayNormal.copyWith(
                                fontSize: pt(12),
                              ),
                            ),
                            Gap(pt(8)),
                            StatefulBuilder(builder: (context, setStateSB) {
                              return Wrap(
                                spacing: pt(8),
                                runSpacing: pt(8),
                                children: [
                                  _buildChoicePill(
                                    label: '升序',
                                    selected: orderByType == 'ASC',
                                    onTap: () {
                                      FocusScope.of(ctx).unfocus();
                                      setStateSB(() {
                                        orderByType = 'ASC';
                                      });
                                    },
                                  ),
                                  _buildChoicePill(
                                    label: '降序',
                                    selected: orderByType == 'DESC',
                                    onTap: () {
                                      FocusScope.of(ctx).unfocus();
                                      setStateSB(() {
                                        orderByType = 'DESC';
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: pt(1)),
                    Padding(
                      padding: EdgeInsets.all(pt(16)),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(ctx).unfocus();
                                usernameController.clear();
                                phoneController.clear();
                                orderByName = 'createTime';
                                orderByType = 'DESC';
                                controller.clearFilters();
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                '重置',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                          Gap(pt(12)),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: () {
                                FocusScope.of(ctx).unfocus();
                                controller.updateUsernameFilter(
                                    usernameController.text.trim());
                                controller.updatePhoneFilter(
                                    phoneController.text.trim());
                                controller.updateOrderByName(orderByName);
                                controller.updateOrderByType(orderByType);
                                controller.applyFilters();
                                Navigator.of(ctx).pop();
                              },
                              child: const Text(
                                '查询',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 旧的角色/状态筛选UI已移除

  /// 构建员工列表
  Widget _buildEmployeeList(
    BuildContext context,
    EmployeeManagementCtrl controller,
  ) {
    return LotteryPageLoading(
      status: state.pageStatus,
      child: PullOrRefreshEasy(
        refreshController:
            context.read<EmployeeManagementCtrl>().refreshController,
        onRefresh: () => controller.refreshData(),
        onLoading: () => controller.onLoading(),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(16)),
          itemCount: state.employees.length,
          itemBuilder: (context, index) {
            final employee = state.employees[index];
            return _buildEmployeeCard(context, controller, employee);
          },
        ),
      ),
    );
  }

  /// 构建员工卡片
  Widget _buildEmployeeCard(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: pt(16)),
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: pt(16),
            offset: Offset(0, pt(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 头像
              CircleAvatar(
                radius: pt(20),
                backgroundColor: Colors.blue[100],
                child: Text(
                  employee.username.isNotEmpty ? employee.username[0] : '?',
                  style: SportsTextStyle.baseBold.copyWith(
                    fontSize: pt(16),
                    color: Colors.blue[700],
                  ),
                ),
              ),
              Gap(pt(12)),
              // 基本信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.username,
                          style: SportsTextStyle.baseBold.copyWith(
                            fontSize: pt(16),
                            color: Colors.black,
                          ),
                        ),
                        Gap(pt(8)),
                        Flexible(
                          child: Wrap(
                            spacing: pt(4),
                            runSpacing: pt(2),
                            children: employee.roles
                                .map((role) => _buildRoleBadge(role))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    Gap(pt(4)),
                    Text(
                      '账号: ${employee.phone}',
                      style: SportsTextStyle.grayNormal.copyWith(
                        fontSize: pt(12),
                      ),
                    ),
                    Text(
                      '手机: ${employee.phone}',
                      style: SportsTextStyle.grayNormal.copyWith(
                        fontSize: pt(12),
                      ),
                    ),
                  ],
                ),
              ),
              // 操作按钮
              _buildEmployeeActionsMenu(context, controller, employee),
            ],
          ),
          ...[
            Gap(pt(8)),
            Text(
              '创建时间: ${_formatDateTime(employee.createTime)}',
              style: SportsTextStyle.grayNormal.copyWith(
                fontSize: pt(10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmployeeActionsMenu(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) {
    final bool isEnabled = employee.status == EmployeeStatus.Active;
    return PopupMenuButton<String>(
      tooltip: '更多操作',
      color: Colors.white,
      elevation: 10,
      offset: Offset(0, pt(8)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      constraints: BoxConstraints(minWidth: pt(160)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _navigateToEditEmployeePage(context, controller, employee);
            break;
          case 'reset_password':
            _confirmResetPassword(context, controller, employee);
            break;
          case 'toggle_status':
            _confirmToggleStatus(context, controller, employee);
            break;
          case 'delete':
            _confirmDeleteEmployee(context, controller, employee);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: _buildMenuRow(Icons.edit_outlined, '编辑'),
        ),
        PopupMenuItem(
          value: 'reset_password',
          child: _buildMenuRow(Icons.lock_reset, '重置密码'),
        ),
        PopupMenuItem(
          value: 'toggle_status',
          child: _buildMenuRow(
            isEnabled ? Icons.block : Icons.check_circle_outline,
            isEnabled ? '禁用' : '启用',
            color: isEnabled ? Colors.orange : AppColors.success,
          ),
        ),
        PopupMenuDivider(height: pt(8)),
        PopupMenuItem(
          value: 'delete',
          child: _buildMenuRow(
            Icons.delete_outline,
            '删除',
            color: AppColors.error,
          ),
        ),
      ],
      child: Container(
        width: pt(36),
        height: pt(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(pt(10)),
          border: Border.all(color: const Color(0xFFE8E8E8), width: pt(1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: pt(8),
              offset: Offset(0, pt(2)),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.more_horiz,
          color: AppColors.textSecondary,
          size: pt(20),
        ),
      ),
    );
  }

  Widget _buildMenuRow(
    IconData icon,
    String label, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: pt(18), color: color ?? AppColors.textPrimary),
        Gap(pt(10)),
        Expanded(
          child: Text(
            label,
            style: SportsTextStyle.baseNormal.copyWith(
              fontSize: pt(14),
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoicePill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pt(14), vertical: pt(8)),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(pt(20)),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: pt(8),
                    offset: Offset(0, pt(2)),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(12),
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 构建角色标签
  Widget _buildRoleBadge(EmployeeRole role) {
    Color color;
    switch (role) {
      case EmployeeRole.owner:
        color = Colors.red;
        break;
      case EmployeeRole.admin:
        color = Colors.orange;
        break;
      case EmployeeRole.employee:
        color = Colors.blue;
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: pt(4)),
      padding: EdgeInsets.symmetric(horizontal: pt(6), vertical: pt(2)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(pt(10)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        role.displayName,
        style: SportsTextStyle.baseNormal.copyWith(
          fontSize: pt(10),
          color: color,
        ),
      ),
    );
  }

  /// 格式化日期时间
  String _formatDateTime(int dateTime) {
    return formatDateFromMilliSecond(dateTime, format: 'yyyy-MM-dd HH:mm:ss');
  }

  /// 导航到编辑员工页面
  void _navigateToEditEmployeePage(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) {
    controller.navigateToEditEmployee(context, employee.uuid);
  }

  /// 确认切换员工状态
  void _confirmToggleStatus(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) {
    final isEnabled = employee.status == EmployeeStatus.Active;
    String action = isEnabled ? '禁用' : '启用';

    SportsDialog.show(
      title: '确认$action',
      body: Text('确定要$action员工${employee.username}吗？'),
      okText: action,
      cancelText: '取消',
      onOk: () {
        controller.toggleEmployeeStatus(employee.uuid,
            isEnabled ? EmployeeStatus.Disabled : EmployeeStatus.Active);
        SportsDialog.dismiss();
      },
      onCancel: () {
        SportsDialog.dismiss();
      },
    );
  }

  /// 确认重置密码
  Future<void> _confirmResetPassword(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) async {
    await SportsDialog.show(
      title: '提示',
      bodyText: '确定要重置员工 ${employee.username} 的密码吗？',
      okText: '确定',
      cancelText: '取消',
      onOk: () async {
        SportsDialog.dismiss();
        final data = await _resetPassword(context, controller, employee);
        if (data != null && context.mounted) {
          _showNewPassswordDialog(context, data);
        }
      },
    );
  }

  Future<RestEmployeeResponseData?> _resetPassword(BuildContext context,
      EmployeeManagementCtrl controller, EmployeeInfo employee) async {
    return await controller.resetEmployeePassword(employee.uuid);
  }

  _showNewPassswordDialog(BuildContext context, RestEmployeeResponseData data) {
    SportsDialog.show(
      title: '密码重置成功',
      body: NewPasswordInfoDialog(data: data),
      okText: '一键复制',
      // footer: _buildFooter(context, data),
      onOk: () {
        TextUtil.copyText(
          '手机号: ${data.phone}\n新密码: ${data.password}',
        );
        SportsDialog.dismiss();
      },
    );
  }

  /// 确认删除员工
  void _confirmDeleteEmployee(
    BuildContext context,
    EmployeeManagementCtrl controller,
    EmployeeInfo employee,
  ) {
    SportsDialog.show(
      title: '确认删除',
      body: Text('确定要删除员工 ${employee.username} 吗？此操作不可撤销。'),
      okText: '确定',
      cancelText: '取消',
      onOk: () {
        controller.deleteEmployee(employee.uuid);
        SportsDialog.dismiss();
      },
      onCancel: () {
        SportsDialog.dismiss();
      },
    );
  }
}

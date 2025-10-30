import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/profile/controller.dart';
import 'package:oil_business_app/pages/profile/state.dart';
import 'package:oil_business_app/pages/profile/skeleton.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/app_version_util.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/base/btn.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/common/pull_refresh_easy.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';
import 'package:oil_business_app/widgets/common/balance_info_card_widget.dart';

class ProfileView extends HookWidget {
  final ProfileState state;

  const ProfileView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ProfileCtrl>();

    // 只有首次加载且正在加载时才显示骨架屏
    if (state.isFirstLoad && state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFF),
        body: ProfileSkeleton(),
      );
    }

    // 如果有错误，显示错误页面
    if (state.hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: Container(
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
          child: SafeArea(
            child: LotteryPageLoading(
              status: PageStatus.error,
              child: Container(),
            ),
          ),
        ),
      );
    }

    // 正常显示内容（包括后续的loading状态）
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Container(
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
        child: SafeArea(
          child: _buildProfileContent(context, ctrl),
        ),
      ),
    );
  }

  /// 构建个人中心内容
  Widget _buildProfileContent(BuildContext context, ProfileCtrl ctrl) {
    return PullOrRefreshEasy(
      refreshController: context.read<ProfileCtrl>().refreshController,
      onRefresh: ctrl.refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context, ctrl),
            Gap(pt(8)),
            const BalanceInfoCardWidget(),
            Gap(pt(8)),
            _buildMenuItems(context, ctrl),
            Gap(pt(8)),
            _buildVersionInfo(),
            Gap(pt(20)),
            _buildLogoutButton(ctrl),
            Gap(pt(20)),
          ],
        ),
      ),
    );
  }

  /// 构建顶部Header
  Widget _buildHeader(BuildContext context, ProfileCtrl ctrl) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(16)),
      child: Row(
        children: [
          Text(
            '个人中心',
            style: SportsTextStyle.baseBold.copyWith(
              fontSize: pt(24),
              color: AppColors.accentBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // 非首次加载时显示loading指示器
          if (!state.isFirstLoad && state.isLoading)
            SizedBox(
              width: pt(16),
              height: pt(16),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建功能菜单项
  Widget _buildMenuItems(BuildContext context, ProfileCtrl ctrl) {
    final user = state.userProfile;
    if (user == null) return const SizedBox();

    final List<Map<String, dynamic>> menuItems = [
      {
        'title': '修改密码',
        'icon': Icons.lock_outline,
        'onTap': () => ctrl.navigateToChangePassword(context),
        'showAlways': true,
      },
      {
        'title': '员工管理',
        'icon': Icons.group_outlined,
        'onTap': () {
          ctrl.navigateToEmployeeManagement(context);
        },
        'showAlways': false,
        'permission': 'canManageEmployees',
      },
      {
        'title': '赠送记录',
        'icon': Icons.record_voice_over_outlined,
        'onTap': () {
          ctrl.navigateToGiftRecords(context);
        },
        'showAlways': false,
      },
      {
        'title': '开放平台信息',
        'icon': Icons.api_outlined,
        'onTap': () => _showOpenPlatformInfo(context),
        'showAlways': false,
        'permission': 'canSetManager', // 只有老板可以访问
      },
      {
        'title': '支持的彩种',
        'icon': Icons.confirmation_number_outlined,
        'onTap': () => {},
        'showAlways': true,
      },
    ];

    // 过滤菜单项
    final visibleItems = menuItems.where((item) {
      if (item['showAlways'] == true) return true;
      if (item['permission'] != null) {
        return ctrl.hasPermission(item['permission']);
      }
      return true;
    }).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
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
        children: visibleItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == visibleItems.length - 1;

          return _buildMenuItem(
            item['title'],
            item['icon'],
            isLast,
            item['onTap'],
          );
        }).toList(),
      ),
    );
  }

  /// 构建单个菜单项
  Widget _buildMenuItem(
    String title,
    IconData icon,
    bool isLast,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(pt(16)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: pt(24),
              color: Colors.grey[600],
            ),
            Gap(pt(12)),
            Expanded(
              child: Text(
                title,
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(16),
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: pt(20),
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  /// 显示开放平台信息
  void _showOpenPlatformInfo(BuildContext context) {}

  /// 显示更新对话框
  void _showUpdateDialog() {
    AppVersionUtil.showUpdateDialog();
  }

  /// 构建版本信息
  Widget _buildVersionInfo() {
    return GestureDetector(
      onTap: () {
        if (AppVersionUtil.hasNewVersionUpdate() == true) {
          _showUpdateDialog();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: pt(20)),
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
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: pt(20),
              color: Colors.grey[600],
            ),
            Gap(pt(8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '版本信息',
                    style: SportsTextStyle.baseNormal.copyWith(
                      fontSize: pt(14),
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '当前版本: ${AppVersionUtil.appVersionText}',
                    style: SportsTextStyle.grayNormal.copyWith(
                      fontSize: pt(12),
                    ),
                  ),
                ],
              ),
            ),
            if (AppVersionUtil.hasNewVersionUpdate() == true)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: pt(8),
                  vertical: pt(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(pt(10)),
                ),
                child: Text(
                  '有更新',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(10),
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建退出登录按钮
  Widget _buildLogoutButton(ProfileCtrl ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pt(20)),
      child: SportsBtn(
        text: '退出登录',
        width: double.infinity,
        height: pt(52),
        btnLoading: state.isLoggingOut,
        tapHandle: () => _showLogoutDialog(ctrl),
      ),
    );
  }

  /// 显示退出登录确认对话框
  void _showLogoutDialog(ProfileCtrl ctrl) {
    SportsDialog.show(
      title: '退出登录',
      bodyText: '确定要退出登录吗？',
      onOk: () {
        SportsDialog.dismiss();
        ctrl.logout();
      },
      onCancel: () {
        SportsDialog.dismiss();
      },
    );
  }
}

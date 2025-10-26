import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/controller.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/state.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/utils/form_validators.dart';
import 'package:lottery_app/widgets/common/section_card.dart';
import 'package:lottery_app/widgets/common/labeled_input.dart';

/// 编辑员工视图校验器单例
class EditEmployeeViewValidator {
  static final EditEmployeeViewValidator _instance =
      EditEmployeeViewValidator._internal();
  static EditEmployeeViewValidator get instance => _instance;

  EditEmployeeViewValidator._internal();

  bool Function()? _validator;

  void setValidator(bool Function() validator) {
    _validator = validator;
  }

  bool validate() {
    return _validator?.call() ?? false;
  }
}

class EditEmployeeView extends StatefulWidget {
  const EditEmployeeView({Key? key}) : super(key: key);

  @override
  State<EditEmployeeView> createState() => _EditEmployeeViewState();
}

class _EditEmployeeViewState extends State<EditEmployeeView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 将校验方法暴露给父组件
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EditEmployeeViewValidator.instance.setValidator(() {
        return _formKey.currentState?.validate() ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEmployeeController, EditEmployeeState>(
      listenWhen: (previous, current) => previous.hasError != current.hasError,
      listener: (context, state) {
        if (state.hasError && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            // 使用手势探测器包裹整个内容
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, // 确保即使点击到子组件也能触发
              onTap: () {
                // 点击空白区域时隐藏键盘
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: EdgeInsets.all(pt(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(context, state),
                      Gap(pt(20)),
                      _buildRoleSelector(context, state),
                      Gap(pt(20)),
                      _buildLotteryGiftConfig(context, state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard(BuildContext context, EditEmployeeState state) {
    final controller = context.read<EditEmployeeController>();

    return SectionCard(
      title: '基本信息',
      children: [
        LabeledInput(
          label: '员工姓名',
          hintText: '请输入员工姓名',
          value: state.username,
          onChanged: controller.updateUsername,
          validator: FormValidators.validateEmployeeName,
          maxLength: 20,
          key: const Key('username'),
        ),
        Gap(pt(20)),
        LabeledInput(
          label: '手机号/账号',
          hintText: '请输入手机号/账号',
          keyboardType: TextInputType.phone,
          value: state.phone,
          onChanged: controller.updatePhone,
          enabled: !state.isEditMode,
          validator: FormValidators.validatePhone,
          maxLength: 11,
          key: const Key('phone'),
        ),
        if (!state.isEditMode) ...[
          Gap(pt(20)),
          LabeledInput(
            label: '密码',
            hintText: '请输入密码',
            obscureText: true,
            value: state.password,
            onChanged: controller.updatePassword,
            validator: FormValidators.validatePassword,
            maxLength: 20,
            key: const Key('password'),
          ),
        ],
      ],
    );
  }

  /// 构建角色选择器
  Widget _buildRoleSelector(BuildContext context, EditEmployeeState state) {
    final controller = context.read<EditEmployeeController>();

    // 检查角色选择是否有效
    final roleValidationError = FormValidators.validateRoles(state.roles);
    final hasRoleError = roleValidationError != null;

    return SectionCard(
      title: '角色设置',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...EmployeeRole.values
                .where((role) => role != EmployeeRole.owner)
                .map((role) {
              final bool isEmployee = role == EmployeeRole.employee;
              final bool isSelected =
                  isEmployee ? true : state.roles.contains(role);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  role.displayName,
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: Checkbox(
                  activeColor: AppColors.primary,
                  value: isSelected,
                  onChanged: isEmployee
                      ? null
                      : (value) {
                          // 点击复选框时隐藏键盘
                          FocusScope.of(context).unfocus();
                          if (value == true) {
                            controller.updateRoles([...state.roles, role]);
                          } else {
                            controller.updateRoles(
                                state.roles.where((r) => r != role).toList());
                          }
                        },
                ),
                onTap: isEmployee
                    ? null
                    : () {
                        // 点击选项时隐藏键盘
                        FocusScope.of(context).unfocus();
                        if (isSelected) {
                          controller.updateRoles(
                              state.roles.where((r) => r != role).toList());
                        } else {
                          controller.updateRoles([...state.roles, role]);
                        }
                      },
              );
            }).toList(),
            if (hasRoleError) ...[
              Gap(pt(8)),
              Text(
                roleValidationError,
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(12),
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void handleStaticCheckboxChange(
      BuildContext context, EditEmployeeController controller, bool value) {
    final state = context.read<EditEmployeeController>().state;
    FocusScope.of(context).unfocus();
    if (!state.hasStatic) {
      controller.addCodeConfItem(type: LotteryTempCouponTypeEnum.static);
    } else {
      controller.removeCodeConfItem(LotteryTempCouponTypeEnum.static);
    }
  }

  void handleDynamicCheckboxChange(
      BuildContext context, EditEmployeeController controller, bool value) {
    final state = context.read<EditEmployeeController>().state;
    FocusScope.of(context).unfocus();
    if (!state.hasDynamic) {
      controller.addCodeConfItem(type: LotteryTempCouponTypeEnum.dynamic);
    } else {
      controller.removeCodeConfItem(LotteryTempCouponTypeEnum.dynamic);
    }
  }

  /// 构建彩票赠送权限配置
  Widget _buildLotteryGiftConfig(
    BuildContext context,
    EditEmployeeState state,
  ) {
    final controller = context.read<EditEmployeeController>();

    return SectionCard(
      title: '彩票赠送权限',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '配置项',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        handleDynamicCheckboxChange(
                            context, controller, state.hasDynamic);
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            key: const Key('static_checkbox'),
                            value: state.hasDynamic,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              handleDynamicCheckboxChange(
                                  context, controller, state.hasDynamic);
                            },
                          ),
                          Text(
                            '动态二维码',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(14),
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(pt(12)),
                    GestureDetector(
                      onTap: () {
                        handleStaticCheckboxChange(
                            context, controller, state.hasStatic);
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            key: const Key('static_checkbox'),
                            value: state.hasStatic,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              handleStaticCheckboxChange(
                                  context, controller, state.hasStatic);
                            },
                          ),
                          Text(
                            '静态二维码',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(14),
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(pt(12)),
            if (state.codeConf.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(pt(20)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFF),
                  borderRadius: BorderRadius.circular(pt(8)),
                  border: Border.all(
                    color: const Color(0xFFE8E8E8),
                    width: 1,
                  ),
                ),
                child: Text(
                  '暂无配置项，点击添加按钮创建',
                  textAlign: TextAlign.center,
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ...state.codeConf.asMap().entries.map((entry) {
                final config = entry.value;
                return _buildCodeConfItem(context, controller, config);
              }).toList(),
          ],
        ),
      ],
    );
  }

  /// 构建单个配置项
  Widget _buildCodeConfItem(
    BuildContext context,
    EditEmployeeController controller,
    LotteryGiftConfig config,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(8)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '配置项 ${config.type.displayName}',
                style: SportsTextStyle.baseBold.copyWith(
                  fontSize: pt(14),
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  controller.removeCodeConfItem(config.type);
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: pt(20),
                  color: Colors.red,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: pt(24),
                  minHeight: pt(24),
                ),
              ),
            ],
          ),
          Gap(pt(12)),
          Row(
            children: [
              Expanded(
                flex: config.type == LotteryTempCouponTypeEnum.dynamic ? 1 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '类型',
                      style: SportsTextStyle.baseNormal.copyWith(
                        fontSize: pt(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gap(pt(4)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: pt(12),
                      ),
                      child: Text(
                        config.type.displayName,
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(14),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (config.type == LotteryTempCouponTypeEnum.static) ...[
                Gap(pt(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '数量',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Gap(pt(4)),
                      TextFormField(
                        initialValue: config.num,
                        decoration: InputDecoration(
                          hintText: '请输入数量',
                          hintStyle: SportsTextStyle.grayNormal.copyWith(
                            fontSize: pt(14),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: pt(12),
                            vertical: pt(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(pt(6)),
                            borderSide: const BorderSide(
                              color: Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(pt(6)),
                            borderSide: const BorderSide(
                              color: Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(pt(6)),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          controller.updateCodeConfItemNum(config.type, value);
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Gap(pt(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '数量',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Gap(pt(4)),
                      Container(
                        height: pt(42),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          // color: const Color(0xFFF8FAFF),
                          borderRadius: BorderRadius.circular(pt(6)),
                        ),
                        child: Text(
                          '不限制',
                          style: SportsTextStyle.baseNormal.copyWith(
                            fontSize: pt(14),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          Gap(pt(12)),
          Row(
            children: [
              Checkbox(
                value: config.enable == 1,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  // 点击复选框时隐藏键盘
                  FocusScope.of(context).unfocus();
                  if (value != null) {
                    // 使用安全的方式更新配置
                    if (mounted && context.mounted) {
                      Future.microtask(() {
                        if (mounted && context.mounted) {
                          controller.updateCodeConfItem(
                            config.type,
                            value ? 1 : 0,
                          );
                        }
                      });
                    }
                  }
                },
              ),
              Gap(pt(8)),
              Text(
                '启用此配置',
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(14),
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

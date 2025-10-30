import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/login/register/controller.dart';
import 'package:oil_business_app/pages/login/register/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/base/btn.dart';
import 'package:oil_business_app/widgets/base/card.dart';
import 'package:oil_business_app/widgets/common/base_appbar.dart';
import 'package:oil_business_app/widgets/common/inputs/default_input.dart';
import 'package:oil_business_app/widgets/common/inputs/mobile_number.dart';
import 'package:oil_business_app/widgets/common/inputs/password.dart';
import 'package:oil_business_app/widgets/common/inputs/verify_code.dart';

class RegisterView extends HookWidget {
  final RegisterState state;

  const RegisterView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<RegisterCtrl>();

    return Scaffold(
      backgroundColor: AppColors.pageBack,
      resizeToAvoidBottomInset: true,
      appBar: const BaseAppBar(
        title: '用户注册',
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FormBuilder(
            key: context.read<RegisterCtrl>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(pt(18)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用户名称',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    const CardContainer(
                      boxShadow: [],
                      padding: EdgeInsets.zero,
                      child: DefaultInput(
                        name: 'name',
                        showUnderling: false,
                        hintText: '请输入用户名称',
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '手机号',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    const CardContainer(
                      boxShadow: [],
                      padding: EdgeInsets.zero,
                      child: MobileNumberInput(
                        showUnderling: false,
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '验证码',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      boxShadow: const [],
                      padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                      child: VerifyCode(
                        formkey: context.read<RegisterCtrl>().formKey,
                        showPreIcon: false,
                        showUnderling: false,
                        sence: 'register',
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '密码',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      padding: EdgeInsets.zero,
                      boxShadow: const [],
                      child: PasswordInput(
                        name: 'password',
                        showPreIcon: false,
                        showUnderling: false,
                        hintText: '请输入密码',
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: '请输入密码',
                            ),
                            FormBuilderValidators.match(
                              RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$'),
                              errorText: '密码格式不正确，至少8位且包含字母和数字',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '确认密码',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      padding: EdgeInsets.zero,
                      boxShadow: const [],
                      child: PasswordInput(
                        name: 'confirmPassword',
                        showPreIcon: false,
                        showUnderling: false,
                        hintText: '请再次输入密码',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: '请确认密码',
                          ),
                          (value) {
                            if (value !=
                                ctrl.formKey.currentState?.fields['password']
                                    ?.value) {
                              return '两次输入的密码不一致';
                            }
                            return null;
                          }
                        ]),
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Gap(pt(30)),
                SportsBtn(
                  btnLoading: ctrl.state.loading,
                  text: '确认注册',
                  tapHandle: () {
                    context.read<RegisterCtrl>().submit();
                  },
                ),
                // 错误提示区域
                if (state.errorMessage != null) ...[
                  Gap(pt(16)),
                  _buildErrorDisplay(context, ctrl),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建错误显示区域
  Widget _buildErrorDisplay(BuildContext context, RegisterCtrl ctrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(16)),
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
        border: Border.all(color: AppColors.error, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: pt(20),
          ),
          Gap(pt(8)),
          Expanded(
            child: Text(
              state.errorMessage!,
              style: SportsTextStyle.baseNormal.copyWith(
                color: AppColors.error,
                fontSize: pt(14),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ctrl.clearError(),
            child: Icon(
              Icons.close,
              color: AppColors.error,
              size: pt(18),
            ),
          ),
        ],
      ),
    );
  }
}

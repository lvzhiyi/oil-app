import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/pages/login/changePw/controller.dart';
import 'package:lottery_app/pages/login/changePw/state.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';
import 'package:lottery_app/widgets/base/card.dart';
import 'package:lottery_app/widgets/common/base_appbar.dart';
import 'package:lottery_app/widgets/common/inputs/mobile_number.dart';
import 'package:lottery_app/widgets/common/inputs/password.dart';
import 'package:lottery_app/widgets/common/inputs/verify_code.dart';

class ChangePwView extends HookWidget {
  final ChangePwState state;

  const ChangePwView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ChangePwCtrl>();

    return Scaffold(
      backgroundColor: AppColors.pageBack,
      resizeToAvoidBottomInset: true,
      appBar: const BaseAppBar(
        title: '修改密码',
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FormBuilder(
            key: context.read<ChangePwCtrl>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(pt(18)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '手机号',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      boxShadow: const [],
                      bgColor: AppColors.inputTextBg,
                      padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                      child: const MobileNumberInput(
                        phoneNumber: '13800138000',
                        readOnly: false,
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
                        formkey: context.read<ChangePwCtrl>().formKey,
                        showPreIcon: false,
                        showUnderling: false,
                        sence: 'updatePassword',
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '旧密码',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      boxShadow: const [],
                      padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                      child: const PasswordInput(
                        name: 'oldPassword',
                        showPreIcon: false,
                        showUnderling: false,
                        hintText: '请输入旧密码',
                      ),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '新密码',
                      style: SportsTextStyle.baseBold,
                    ),
                    const Gap(8),
                    CardContainer(
                      padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                      boxShadow: const [],
                      child: PasswordInput(
                        name: 'newPassword',
                        showPreIcon: false,
                        showUnderling: false,
                        hintText: '请输入新密码',
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: '请输入新密码',
                            ),
                            FormBuilderValidators.match(
                              RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$'),
                              errorText: '密码格式不正确',
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
                      padding: EdgeInsets.only(left: pt(16), right: pt(16)),
                      boxShadow: const [],
                      child: PasswordInput(
                          name: 'confirmPassword',
                          showPreIcon: false,
                          showUnderling: false,
                          hintText: '请输入确认密码',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '请输入确认密码'),
                            (value) {
                              if (value !=
                                  ctrl.formKey.currentState
                                      ?.fields['newPassword']?.value) {
                                return '密码不一致';
                              }
                              return null;
                            }
                          ])),
                    ),
                    Gap(pt(14)),
                  ],
                ),
                Gap(pt(30)),
                SportsBtn(
                  btnLoading: ctrl.state.loading,
                  text: '确认',
                  tapHandle: () {
                    context.read<ChangePwCtrl>().submit();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/commom/rxg.dart';
import 'package:lottery_app/pages/profile/change_password/controller.dart';
import 'package:lottery_app/pages/profile/change_password/state.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';
import 'package:lottery_app/widgets/common/sports_app_bar.dart';
import 'package:lottery_app/widgets/common/inputs/password.dart';

class ProfileChangePasswordView extends HookWidget {
  final ProfileChangePasswordState state;

  const ProfileChangePasswordView({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ProfileChangePasswordCtrl>();
    // 已由 PasswordInput 组件内部管理明文/密文状态

    return Scaffold(
      backgroundColor: AppColors.pageBack,
      resizeToAvoidBottomInset: true,
      appBar: const SportsAppBar(title: '修改密码'),
      body: SingleChildScrollView(
        child: Center(
          child: FormBuilder(
            key: ctrl.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(pt(18)),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: pt(16)),
                  padding: EdgeInsets.all(pt(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(pt(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '旧密码',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(14),
                          color: const Color(0xff333333),
                        ),
                      ),
                      Gap(pt(16)),
                      PasswordInput(
                        name: 'oldPassword',
                        hintText: '请输入旧密码',
                        validator: FormBuilderValidators.required(
                          errorText: '请输入旧密码',
                        ),
                      ),
                      Gap(pt(16)),
                      Text(
                        '新密码',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(14),
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Gap(pt(16)),
                      PasswordInput(
                        name: 'password',
                        hintText: '请输入新密码',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: '请输入新密码',
                          ),
                          FormBuilderValidators.match(
                            CommonRegExp.password,
                            errorText: '密码格式不正确',
                          ),
                        ]),
                      ),
                      Gap(pt(16)),
                      Text(
                        '确认密码',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(14),
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Gap(pt(16)),
                      PasswordInput(
                        name: 'confirmPassword',
                        hintText: '请输入确认密码',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: '请输入确认密码'),
                          (value) {
                            final formState = ctrl.formKey.currentState;
                            final pw = formState?.fields['password']?.value;
                            if (value != pw) {
                              return '密码不一致';
                            }
                            return null;
                          }
                        ]),
                      ),
                    ],
                  ),
                ),
                Gap(pt(24)),
                SportsBtn(
                  btnLoading: state.loading,
                  text: '确认',
                  tapHandle: () {
                    ctrl.submit();
                  },
                ),
                Gap(pt(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

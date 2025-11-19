import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/change_password/controller.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ChangePasswordCtrl>();
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
          child: SingleChildScrollView(
            child: Column(children: [
              InkWell(
                onTap: () => {
                  BaseRouter.pop(),
                },
                child: Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(61)),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      AssetsIcon.IC_LEFT_ARROW,
                      width: AppSizes.setWidth(20),
                      height: AppSizes.setHeight(20),
                    ),
                  ),
                ),
              ),
              Image.asset(
                AssetsImg.LOGO,
                width: AppSizes.setWidth(80),
                height: AppSizes.setHeight(80),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(15)),
                child: CommonText(
                  text: '修改密码',
                  fontWeight: FontWeight.w700,
                  fontSize: AppSizes.setFontSize(24),
                ),
              ),
              FormBuilder(
                key: ctrl.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonTextFormField(
                      name: 'password',
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PASSWORD,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '新密码',
                      isPasswordField: true,
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入新密码'),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSizes.setHeight(16)),
                      child: CommonTextFormField(
                        borderColor: CustomAppColor.of(context).textFieldBorder,
                        leadingIcon: Image.asset(
                          AssetsIcon.IC_PASSWORD,
                          width: AppSizes.setHeight(20),
                          height: AppSizes.setHeight(20),
                        ),
                        hintText: '确认密码',
                        isPasswordField: true,
                        validators: FormBuilderValidators.compose([
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSizes.setHeight(20)),
                      child: CommonButton(
                        isLoading: ctrl.state.loading,
                        btnText: '确认修改',
                        onTap: () {
                          ctrl.submit();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}


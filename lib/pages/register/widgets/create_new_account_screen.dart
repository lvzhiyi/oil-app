import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/register/controller.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class CreateNewAccountScreen extends StatelessWidget {
  const CreateNewAccountScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const CreateNewAccountScreen());
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<RegisterCtrl>();
    return Scaffold(
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
                text: '创建您的账户',
                fontWeight: FontWeight.w700,
                fontSize: AppSizes.setFontSize(24),
              ),
            ),
            FormBuilder(
              key: ctrl.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
                    child: CommonTextFormField(
                      name: 'name',
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PROFILE,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '姓名',
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入全名'),
                      ]),
                    ),
                  ),
                  CommonTextFormField(
                    name: 'phone',
                    borderColor: CustomAppColor.of(context).textFieldBorder,
                    leadingIcon: Icon(
                      Icons.phone_outlined,
                      color: CustomAppColor.of(context).txtGrey,
                    ),
                    hintText: '手机号',
                    keyboardType: TextInputType.phone,
                    inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    maxLength: 11,
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '请输入手机号'),
                      FormBuilderValidators.minLength(
                        11,
                        errorText: '手机号必须是11位数字',
                      ),
                      FormBuilderValidators.maxLength(
                        11,
                        errorText: '手机号必须是11位数字',
                      ),
                    ]),
                  ),
                  CommonTextFormField(
                    name: 'password',
                    borderColor: CustomAppColor.of(context).textFieldBorder,
                    leadingIcon: Image.asset(
                      AssetsIcon.IC_PASSWORD,
                      width: AppSizes.setHeight(20),
                      height: AppSizes.setHeight(20),
                    ),
                    hintText: '密码',
                    isPasswordField: true,
                    validators: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '请输入密码'),
                    ]),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
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
                  CommonTextFormField(
                    name: 'code',
                    borderColor: CustomAppColor.of(context).textFieldBorder,
                    leadingIcon: Image.asset(
                      AssetsIcon.IC_REFER,
                      width: AppSizes.setHeight(20),
                      height: AppSizes.setHeight(20),
                    ),
                    hintText: '邀请码',
                    validators: FormBuilderValidators.compose([]),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
                    child: CommonButton(
                      isLoading: ctrl.state.loading,
                      btnText: '确认',
                      onTap: () {
                        ctrl.goToOtpPage();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.setWidth(8),
                        vertical: AppSizes.setHeight(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: CustomAppColor.of(context).dividerGrey,
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.setWidth(8)),
                          child: CommonText(
                            text: '或继续使用',
                            fontSize: AppSizes.setFontSize(13),
                            fontWeight: FontWeight.w500,
                            textColor: CustomAppColor.of(context).txtGrey,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: CustomAppColor.of(context).dividerGrey,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          text: '有账户？',
                          textColor: CustomAppColor.of(context).txtGrey,
                          fontWeight: FontWeight.w500,
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: InkWell(
                            onTap: () => {
                              BaseRouter.replace(url: AppPage.loginPage.path),
                            },
                            child: CommonText(
                              text: '登录',
                              textColor: CustomAppColor.of(context).txtPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

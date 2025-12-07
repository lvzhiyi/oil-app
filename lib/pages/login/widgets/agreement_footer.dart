import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/login/controller.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

/// 用户协议底部组件
class AgreementFooter extends StatelessWidget {
  const AgreementFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<LoginCtrl>();

    return BlocBuilder<LoginCtrl, LoginState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 复选框
            GestureDetector(
              onTap: () {
                ctrl.toggleAgreement(!state.agreementAccepted);
              },
              child: Container(
                width: 16,
                height: 16,
                margin: EdgeInsets.only(
                  top: AppSizes.setHeight(2),
                  right: AppSizes.setWidth(8),
                ),
                decoration: BoxDecoration(
                  color: state.agreementAccepted
                      ? AppColor.txtPurple
                      : Colors.transparent,
                  border: Border.all(
                    color: state.agreementAccepted
                        ? AppColor.txtPurple
                        : const Color(0xFFD1D5DB),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: state.agreementAccepted
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            // 协议文本
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(12),
                    color: const Color(0xFF9CA3AF),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: '登录即代表您同意 '),
                    TextSpan(
                      text: '《用户服务协议》',
                      style: const TextStyle(
                        color: AppColor.txtPurple,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          BaseRouter.push(
                              url: AppPage.serviceAgreementPage.path);
                        },
                    ),
                    const TextSpan(text: ' 和 '),
                    TextSpan(
                      text: '《隐私政策》',
                      style: const TextStyle(
                        color: AppColor.txtPurple,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          BaseRouter.push(url: AppPage.privacyPolicyPage.path);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

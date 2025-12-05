import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 操作链接组件（注册和忘记密码）
class ActionLinks extends StatelessWidget {
  const ActionLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 注册链接
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: '没有账户？',
              textColor: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              fontSize: AppSizes.setFontSize(13),
            ),
            SizedBox(width: AppSizes.setWidth(4)),
            InkWell(
              onTap: () {
                BaseRouter.push(
                  url: AppPage.registerPage.path,
                  extra: null,
                );
              },
              child: CommonText(
                text: '立即注册',
                textColor: AppColor.txtPurple,
                fontWeight: FontWeight.w600,
                fontSize: AppSizes.setFontSize(13),
              ),
            ),
          ],
        ),
        // 忘记密码链接
        InkWell(
          onTap: () {
            // TODO: 实现忘记密码功能
            // BaseRouter.push(url: AppPage.forgotPasswordPage.path);
          },
          child: CommonText(
            text: '忘记密码?',
            textColor: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
            fontSize: AppSizes.setFontSize(13),
          ),
        ),
      ],
    );
  }
}

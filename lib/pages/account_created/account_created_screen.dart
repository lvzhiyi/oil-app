import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});
  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const AccountCreatedScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        body: SizedBox(
          width: AppSizes.fullWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSizes.setHeight(116),
                    left: AppSizes.setWidth(22),
                    right: AppSizes.setWidth(22),
                  ),
                  child: Image.asset(
                    AssetsImg.IMG_ACCOUNT_CREATED,
                    width: AppSizes.setWidth(258),
                    height: AppSizes.setHeight(233),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(58)),
                  child: CommonText(
                    text: '账户创建成功',
                    fontSize: AppSizes.setFontSize(35),
                    fontWeight: FontWeight.w800,
                    textColor: CustomAppColor.of(context).txtBlack,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(25)),
                  child: CommonText(
                    text: '您的账户已创建成功，点击继续按钮绑定加油站，然后开始使用 app',
                    fontSize: AppSizes.setFontSize(15),
                    fontWeight: FontWeight.w600,
                    textColor: CustomAppColor.of(context).txtGrey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(88)),
                  child: CommonButton(
                    btnText: '继续',
                    onTap: () => {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

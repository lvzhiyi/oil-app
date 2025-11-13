import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class PendingReviewScreen extends StatefulWidget {
  const PendingReviewScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (context) => const PendingReviewScreen());
  }

  @override
  State<PendingReviewScreen> createState() => _PendingReviewScreenState();
}

class _PendingReviewScreenState extends State<PendingReviewScreen> {
  bool isEmailSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // GestureDetector(
              //   child: Padding(
              //     padding: EdgeInsets.only(top: AppSizes.setHeight(61)),
              //     child: Align(
              //       alignment: Alignment.topLeft,
              //       child: Image.asset(
              //         AssetsIcon.IC_LEFT_ARROW,
              //         width: AppSizes.setWidth(20),
              //         height: AppSizes.setHeight(20),
              //       ),
              //     ),
              //   ),
              // ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(61)),
                  child: Container(),
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
                  text: '审核中',
                  fontWeight: FontWeight.w700,
                  fontSize: AppSizes.setFontSize(24),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: AppSizes.setHeight(12),
                    left: AppSizes.setWidth(12),
                    right: AppSizes.setWidth(12)),
                child: CommonText(
                  text: '您绑定的加油正在审核中，请耐心等待，或联系业务人员',
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: AppSizes.setHeight(12),
                    horizontal: AppSizes.setWidth(80)),
                child: Image.asset(
                  AssetsImg.IMG_PENDING_REVIEW,
                  height: AppSizes.setHeight(195),
                  width: AppSizes.setWidth(200),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
              //   child: CommonButton(
              //     onTap: () =>
              //         BaseRouter.push(url: AppPage.bindStationPage.path),
              //     btnText: '新增加油站',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

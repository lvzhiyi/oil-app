import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class PendingReviewScreen extends StatefulWidget {
  const PendingReviewScreen({super.key, this.station});

  final Station? station;

  static Route route() {
    return MaterialPageRoute(builder: (context) => const PendingReviewScreen());
  }

  @override
  State<PendingReviewScreen> createState() => _PendingReviewScreenState();
}

class _PendingReviewScreenState extends State<PendingReviewScreen> {
  bool get isRejected => widget.station?.status == StationStatus.rejected;
  bool get canEdit =>
      widget.station?.status == StationStatus.rejected ||
      widget.station?.status == StationStatus.pending_review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  text: isRejected ? '审核失败' : '审核中',
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
                  text: isRejected
                      ? '您绑定的加油站审核未通过，请根据失败原因进行修改后重新提交'
                      : '您绑定的加油正在审核中，请耐心等待，或联系业务人员',
                  textColor: CustomAppColor.of(context).txtGrey,
                  textAlign: TextAlign.center,
                ),
              ),
              if (isRejected && widget.station?.rejectionReason != null)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSizes.setHeight(12),
                    left: AppSizes.setWidth(12),
                    right: AppSizes.setWidth(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.setWidth(16)),
                    decoration: BoxDecoration(
                      color: AppColor.containerRed.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSizes.setWidth(12)),
                      border: Border.all(
                        color: AppColor.txtRed.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: AppSizes.setHeight(1),
                            right: AppSizes.setWidth(12),
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: AppSizes.setFontSize(22),
                            color: AppColor.txtRed,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: '失败原因',
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.setFontSize(15),
                                textColor: AppColor.txtRed,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: AppSizes.setHeight(10)),
                              Text(
                                widget.station!.rejectionReason!,
                                style: TextStyle(
                                  fontSize: AppSizes.setFontSize(14),
                                  color: AppColor.txtRed,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
              if (canEdit)
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
                  child: CommonButton(
                    onTap: () {
                      if (widget.station != null) {
                        BaseRouter.push(
                          url: AppPage.stationEditPage.path,
                          extra: {
                            'stationId': widget.station!.idString,
                            'isFromPendingReview': true
                          },
                        );
                      }
                    },
                    btnText: '修改加油站信息',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

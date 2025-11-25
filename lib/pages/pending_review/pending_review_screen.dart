import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:oil_business_app/widgets/common/base_appbar.dart';

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
  Station? _currentStation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _currentStation = widget.station;
  }

  bool get isRejected => _currentStation?.status == StationStatus.rejected;
  bool get canEdit =>
      _currentStation?.status == StationStatus.rejected ||
      _currentStation?.status == StationStatus.pending_review;

  /// 刷新审核状态
  Future<void> _refreshStatus() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final station = await bindStationProcess(isFromLogin: true);

      setState(() {
        _currentStation = station;
      });
    } catch (e) {
      // 刷新失败，保持当前状态
      print('刷新审核状态失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<Station> bindStationProcess({bool isFromLogin = false}) async {
    final activeStation = await appController.getStationStatus(1, 1, [
      StationStatus.active,
    ]);
    if (activeStation.list?.isNotEmpty ?? false) {
      BaseRouter.replace(url: AppPage.mainLayoutPage.path, extra: {
        'isFromLogin': isFromLogin,
      });
      return activeStation.list?[0] ?? Station();
    } else {
      final pendingStation = await appController.getStationStatus(1, 1, [
        StationStatus.pending_review,
        StationStatus.rejected,
      ]);

      if (pendingStation.list?.isNotEmpty ?? false) {
        return pendingStation.list?[0] ?? Station();
      }

      return Station();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      appBar: BaseAppBar(
        title: '审核状态',
        actions: [
          IconButton(
            icon: _isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(
                      color: CustomAppColor.of(context).txtBlack,
                    ),
                  )
                : Icon(
                    Icons.refresh,
                    color: CustomAppColor.of(context).txtBlack,
                  ),
            onPressed: _isRefreshing ? null : _refreshStatus,
            tooltip: '刷新',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppSizes.setHeight(20)),
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
              if (isRejected && _currentStation?.rejectionReason != null)
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
                                _currentStation!.rejectionReason!,
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
                      if (_currentStation != null) {
                        BaseRouter.push(
                          url: AppPage.stationEditPage.path,
                          extra: {
                            'station': _currentStation,
                            'isFromPendingReview': true
                          },
                        ).then((result) {
                          // 如果从编辑页面返回且需要刷新，则刷新状态
                          if (result is Map && result['refresh'] == true) {
                            _refreshStatus();
                          }
                        });
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

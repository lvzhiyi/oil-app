import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: const Color(0xFF1F2937),
        //     size: AppSizes.setWidth(20),
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: CommonText(
          text: '审核状态',
          fontWeight: FontWeight.w700,
          fontSize: AppSizes.setFontSize(18),
          textColor: const Color(0xFF1F2937),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(
                      color: const Color(0xFF1F2937),
                    ),
                  )
                : Icon(
                    Icons.refresh,
                    color: const Color(0xFF1F2937),
                    size: AppSizes.setWidth(20),
                  ),
            onPressed: _isRefreshing ? null : _refreshStatus,
            tooltip: '刷新',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppSizes.setHeight(20)),
                // 品牌头部
                Column(
                  children: [
                    // Logo 盒子
                    Center(
                      child: Image.asset(
                        AssetsImg.LOGO,
                        width: AppSizes.setWidth(132),
                        height: AppSizes.setHeight(132),
                      ),
                    ),
                    SizedBox(height: AppSizes.setHeight(16)),
                    CommonText(
                      text: isRejected ? '审核失败' : '审核中',
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.setFontSize(24),
                      textColor: const Color(0xFF1F2937),
                    ),
                    SizedBox(height: AppSizes.setHeight(8)),
                    CommonText(
                      text: isRejected
                          ? '您绑定的加油站审核未通过，请根据失败原因进行修改后重新提交'
                          : '您绑定的加油正在审核中，请耐心等待，或联系业务人员',
                      textColor: const Color(0xFF6B7280),
                      textAlign: TextAlign.center,
                      fontSize: AppSizes.setFontSize(14),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.setHeight(32)),
                // 失败原因提示
                if (isRejected && _currentStation?.rejectionReason != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.setHeight(24)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSizes.setWidth(16)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: AppSizes.setFontSize(20),
                            color: const Color(0xFFEF4444),
                          ),
                          SizedBox(width: AppSizes.setWidth(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: '失败原因',
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppSizes.setFontSize(14),
                                  textColor: const Color(0xFFEF4444),
                                ),
                                SizedBox(height: AppSizes.setHeight(8)),
                                Text(
                                  _currentStation!.rejectionReason!,
                                  style: TextStyle(
                                    fontSize: AppSizes.setFontSize(13),
                                    color: const Color(0xFFEF4444),
                                    height: 1.5,
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
                // 中间的插图（不替换）
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.setHeight(24),
                  ),
                  child: Image.asset(
                    AssetsImg.IMG_PENDING_REVIEW,
                    height: AppSizes.setHeight(195),
                    width: AppSizes.setWidth(200),
                  ),
                ),
                // 修改按钮
                if (canEdit)
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.setHeight(24),
                      bottom: AppSizes.setHeight(20),
                    ),
                    child: CommonButton(
                      btnText: '修改加油站信息',
                      radius: 26,
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

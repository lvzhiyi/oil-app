import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/model/common_type.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class GiftLotteryQrDynamicState {
  /// 页面状态
  final PageStatus pageStatus;

  /// 当前选中的彩票类型
  final LotteryType selectedLotteryType;

  /// 当前选中的二维码类型
  final QrCodeType selectedQrType;

  /// 动态二维码信息
  final QrCodeDynamicInfo? dynamicQrCode;

  /// 二维码生成状态
  final QrCodeStatus qrCodeStatus;

  /// 是否正在刷新动态二维码
  final bool isExpired;

  /// 是否正在生成动态二维码
  final bool isGenerating;

  /// 动态二维码刷新倒计时
  final int dynamicRefreshCountdown;

  const GiftLotteryQrDynamicState({
    this.pageStatus = PageStatus.success,
    this.selectedLotteryType = LotteryType.doubleColorBall,
    this.selectedQrType = QrCodeType.dynamic,
    this.dynamicQrCode,
    this.qrCodeStatus = QrCodeStatus.unredeemed,
    this.isExpired = false,
    this.isGenerating = false,
    this.dynamicRefreshCountdown = 0,
  });

  GiftLotteryQrDynamicState copyWith({
    PageStatus? pageStatus,
    LotteryType? selectedLotteryType,
    QrCodeType? selectedQrType,
    QrCodeDynamicInfo? dynamicQrCode,
    int? dynamicRefreshCountdown,
    QrCodeStatus? qrCodeStatus,
    bool? isExpired,
    bool? isGenerating,
  }) {
    return GiftLotteryQrDynamicState(
      pageStatus: pageStatus ?? this.pageStatus,
      selectedLotteryType: selectedLotteryType ?? this.selectedLotteryType,
      selectedQrType: selectedQrType ?? this.selectedQrType,
      dynamicQrCode: dynamicQrCode ?? this.dynamicQrCode,
      qrCodeStatus: qrCodeStatus ?? this.qrCodeStatus,
      isExpired: isExpired ?? this.isExpired,
      isGenerating: isGenerating ?? this.isGenerating,
      dynamicRefreshCountdown:
          dynamicRefreshCountdown ?? this.dynamicRefreshCountdown,
    );
  }

  /// 获取彩票单价
  double get lotteryPrice => selectedLotteryType.price;
}

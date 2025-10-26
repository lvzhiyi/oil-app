import 'package:lottery_app/global/enum/common.dart';

class GiftLotteryState {
  /// 是否正在加载
  final bool isLoading;

  /// 当前选中的彩票类型
  final LotteryType selectedLotteryType;

  /// 当前选中的二维码类型
  final QrCodeType selectedQrType;

  /// 批量生成数量
  final int batchCount;

  /// 是否有错误
  final bool hasError;

  /// 错误信息
  final String? errorMessage;

  /// 当前余额
  final String currentBalance;

  /// 当前可用套餐张数
  final int availablePackageCount;

  /// 是否正在刷新动态二维码
  final bool isRefreshingDynamic;

  /// 批量生成进度
  final double batchProgress;

  const GiftLotteryState({
    this.isLoading = false,
    this.selectedLotteryType = LotteryType.doubleColorBall,
    this.selectedQrType = QrCodeType.dynamic,
    this.batchCount = 10,
    this.hasError = false,
    this.errorMessage,
    this.currentBalance = '0.0',
    this.availablePackageCount = 0,
    this.isRefreshingDynamic = false,
    this.batchProgress = 0.0,
  });

  GiftLotteryState copyWith({
    bool? isLoading,
    LotteryType? selectedLotteryType,
    QrCodeType? selectedQrType,
    int? batchCount,
    bool? hasError,
    String? errorMessage,
    String? currentBalance,
    int? availablePackageCount,
    bool? isRefreshingDynamic,
    double? batchProgress,
  }) {
    return GiftLotteryState(
      isLoading: isLoading ?? this.isLoading,
      selectedLotteryType: selectedLotteryType ?? this.selectedLotteryType,
      selectedQrType: selectedQrType ?? this.selectedQrType,
      batchCount: batchCount ?? this.batchCount,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentBalance: currentBalance ?? this.currentBalance,
      availablePackageCount:
          availablePackageCount ?? this.availablePackageCount,
      isRefreshingDynamic: isRefreshingDynamic ?? this.isRefreshingDynamic,
      batchProgress: batchProgress ?? this.batchProgress,
    );
  }

  /// 获取彩票单价
  double get lotteryPrice => selectedLotteryType.price;

  /// 检查是否有足够余额生成动态二维码
  bool get canGenerateDynamic => double.parse(currentBalance) >= lotteryPrice;

  /// 检查是否有足够套餐张数生成静态二维码
  bool get canGenerateStatic => availablePackageCount > 0;

  /// 检查是否可以生成二维码
  bool get canGenerate {
    if (selectedQrType == QrCodeType.dynamic) {
      return canGenerateDynamic;
    } else {
      return canGenerateStatic;
    }
  }

  /// 获取不能生成的原因
  String? get cannotGenerateReason {
    if (!canGenerate) {
      if (selectedQrType == QrCodeType.dynamic) {
        return '余额不足，请先充值';
      } else {
        return '套餐张数不足，请先购买套餐';
      }
    }
    return null;
  }
}

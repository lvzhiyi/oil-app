import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/unified_payment/model/selected_package_info.dart';
import 'model/lottery_package_info.dart';

/// 统一支付页面状态
class UnifiedPaymentState {
  /// 是否正在加载
  final bool isLoading;

  /// 是否有错误
  final bool hasError;

  /// 错误信息
  final String? errorMessage;

  /// 当前支付类型
  final PaymentType paymentType;

  /// 可用套餐列表
  final List<LotteryPackageInfo> packages;

  /// 选中的套餐
  final SelectedPackageInfo? selectedPackage;

  /// 自定义充值金额
  final double customAmount;

  /// 备注信息
  final String remark;

  /// 是否正在支付
  final bool isProcessing;

  /// 当前账户余额
  final double accountBalance;

  /// 当前选择的彩票类型
  final LotteryType currentLotteryType;

  /// 是否已经处理过未完成订单提示
  final bool hasHandledUnpaidPrompt;

  const UnifiedPaymentState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.paymentType = PaymentType.Balance,
    this.packages = const [],
    this.selectedPackage,
    this.customAmount = 0.0,
    this.remark = '',
    this.isProcessing = false,
    this.accountBalance = 0.0,
    this.currentLotteryType = LotteryType.doubleColorBall,
    this.hasHandledUnpaidPrompt = false,
  });

  UnifiedPaymentState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    PaymentType? paymentType,
    List<LotteryPackageInfo>? packages,
    SelectedPackageInfo? selectedPackage,
    bool clearSelectedPackage = false,
    double? customAmount,
    String? remark,
    bool? isProcessing,
    double? accountBalance,
    LotteryType? currentLotteryType,
    bool? hasHandledUnpaidPrompt,
  }) {
    return UnifiedPaymentState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      paymentType: paymentType ?? this.paymentType,
      packages: packages ?? this.packages,
      selectedPackage: clearSelectedPackage
          ? null
          : (selectedPackage ?? this.selectedPackage),
      customAmount: customAmount ?? this.customAmount,
      remark: remark ?? this.remark,
      isProcessing: isProcessing ?? this.isProcessing,
      accountBalance: accountBalance ?? this.accountBalance,
      currentLotteryType: currentLotteryType ?? this.currentLotteryType,
      hasHandledUnpaidPrompt: hasHandledUnpaidPrompt ?? this.hasHandledUnpaidPrompt,
    );
  }

  /// 最小充值金额
  static const double minRechargeAmount = 100.0;

  /// 获取当前应支付金额
  double get paymentAmount {
    if (paymentType == PaymentType.Package && selectedPackage != null) {
      return double.parse(selectedPackage!.rechargeAmount!);
    }
    return customAmount;
  }

  /// 是否可以发起支付
  bool get canPay {
    if (paymentType == PaymentType.Package) {
      return selectedPackage != null && !isProcessing && !isLoading;
    } else {
      return customAmount >= minRechargeAmount && !isProcessing && !isLoading;
    }
  }

  /// 验证充值金额
  bool get isRechargeAmountValid => customAmount >= minRechargeAmount;

  /// 检查余额是否足够购买套餐（套餐购买不支持余额扣减，直接走支付流程）
  bool get hasInsufficientBalance => false;

  /// 获取所需充值金额
  double get needRechargeAmount => 0.0;
}

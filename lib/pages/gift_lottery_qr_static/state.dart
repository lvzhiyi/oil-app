import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class GiftLotteryQrStaticState {
  /// 当前选中的彩票类型
  final LotteryType selectedLotteryType;

  /// 当前选中的彩票类型
  final LotteryType selectedLotteryTypeOfNewCode;

  /// 批量生成数量
  final int batchCount;

  /// 静态码列表
  final List<QrCodeStaticItem> staticCodes;

  /// 二维码生成状态
  final QrCodeStatus selectedStatus;

  /// 当前选中的时间排序
  final SortType selectedSortType;

  /// page状态
  final PageStatus pageStatus;

  /// 当前余额
  final String currentBalance;

  /// 当前可用套餐张数
  final int availablePackageCount;

  /// 是否正在刷新动态二维码
  final bool isRefreshingDynamic;

  /// 批量生成进度
  final double batchProgress;

  const GiftLotteryQrStaticState({
    this.selectedLotteryType = LotteryType.doubleColorBall,
    this.selectedSortType = SortType.timeDesc,
    this.selectedLotteryTypeOfNewCode = LotteryType.doubleColorBall,
    this.batchCount = 10,
    this.staticCodes = const [],
    this.selectedStatus = QrCodeStatus.all,
    this.pageStatus = PageStatus.success,
    this.currentBalance = '0.0',
    this.availablePackageCount = 0,
    this.isRefreshingDynamic = false,
    this.batchProgress = 0.0,
  });

  GiftLotteryQrStaticState copyWith({
    LotteryType? selectedLotteryType,
    QrCodeType? selectedQrType,
    SortType? selectedSortType,
    LotteryType? selectedLotteryTypeOfNewCode,
    int? batchCount,
    int? dynamicRefreshCountdown,
    QrCodeStatus? selectedStatus,
    List<QrCodeStaticItem>? staticCodes,
    PageStatus? pageStatus,
    String? currentBalance,
    int? availablePackageCount,
    bool? isRefreshingDynamic,
    double? batchProgress,
  }) {
    return GiftLotteryQrStaticState(
      selectedLotteryType: selectedLotteryType ?? this.selectedLotteryType,
      selectedSortType: selectedSortType ?? this.selectedSortType,
      selectedLotteryTypeOfNewCode:
          selectedLotteryTypeOfNewCode ?? this.selectedLotteryTypeOfNewCode,
      batchCount: batchCount ?? this.batchCount,
      staticCodes: staticCodes ?? this.staticCodes,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      currentBalance: currentBalance ?? this.currentBalance,
      pageStatus: pageStatus ?? this.pageStatus,
      availablePackageCount:
          availablePackageCount ?? this.availablePackageCount,
      batchProgress: batchProgress ?? this.batchProgress,
    );
  }

  /// 获取彩票单价
  double get lotteryPrice => selectedLotteryType.price;

  /// 检查是否有足够余额生成动态二维码
  bool get canGenerateDynamic => double.parse(currentBalance) >= lotteryPrice;

  /// 检查是否有足够套餐张数生成静态二维码
  bool get canGenerateStatic => availablePackageCount > 0;
}

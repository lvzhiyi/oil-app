import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/recharge_records/model/common_type.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class RechargeRecordsState {
  /// 记录列表数据
  final List<RechargeRecord> records;

  /// 支付方式
  final PaymentMethod paymentMethod;

  /// 充值类型
  final RechargeType rechargeType;

  /// 排序类型
  final SortType sortType;

  /// 用户余额
  final String userBalance;

  /// 套餐信息
  final Map<LotteryType, int> packageInfo;

  /// 分页加载状态
  final PageStatus pageStatus;

  const RechargeRecordsState({
    this.records = const [],
    this.paymentMethod = PaymentMethod.CorpToCorp,
    this.rechargeType = RechargeType.all,
    this.sortType = SortType.timeDesc,
    this.userBalance = '0.00',
    this.packageInfo = const {},
    this.pageStatus = PageStatus.loading,
  });

  RechargeRecordsState copyWith({
    List<RechargeRecord>? records,
    String? userBalance,
    Map<LotteryType, int>? packageInfo,
    PaymentMethod? paymentMethod,
    RechargeType? rechargeType,
    SortType? sortType,
    PageStatus? pageStatus,
  }) {
    return RechargeRecordsState(
      records: records ?? this.records,
      userBalance: userBalance ?? this.userBalance,
      packageInfo: packageInfo ?? this.packageInfo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rechargeType: rechargeType ?? this.rechargeType,
      sortType: sortType ?? this.sortType,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}

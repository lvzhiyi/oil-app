import 'package:lottery_app/pages/dashboard/model/dashboard_type.dart';

/// 赠送记录数据
class GiftRecord {
  final String date;
  final int count;

  GiftRecord({required this.date, required this.count});
}

/// 账户统计数据
class AccountStats {
  final int todayGiftCount;
  final int cumulativeGiftCount;

  AccountStats({
    required this.todayGiftCount,
    required this.cumulativeGiftCount,
  });
}

class DashboardState {
  /// 是否正在加载
  bool isLoading;

  /// 数据是否已加载
  bool isDataLoaded;

  /// 是否有错误
  bool hasError;

  /// 错误信息
  String? errorMessage;

  /// 账户统计数据
  AccountStats? accountStats;

  /// 最近7日赠送走势数据
  List<DashboardTrendsDataItem> recentGiftTrend;

  /// 是否是首次加载
  bool get isFirstLoad => accountStats == null && !hasError;

  DashboardState({
    this.isLoading = false,
    this.isDataLoaded = false,
    this.hasError = false,
    this.errorMessage,
    this.accountStats,
    this.recentGiftTrend = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? isDataLoaded,
    bool? hasError,
    String? errorMessage,
    AccountStats? accountStats,
    List<DashboardTrendsDataItem>? recentGiftTrend,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isDataLoaded: isDataLoaded ?? this.isDataLoaded,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      accountStats: accountStats ?? this.accountStats,
      recentGiftTrend: recentGiftTrend ?? this.recentGiftTrend,
    );
  }
}

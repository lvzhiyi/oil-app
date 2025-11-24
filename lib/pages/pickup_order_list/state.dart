import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

class PickupOrderListState {
  /// 当前标签索引 (0: 待提油, 1: 已完成)
  final int tabIndex;

  /// 订单列表
  final List<WithdrawOrderModel> orderList;

  /// 当前页码
  final int page;

  /// 是否还有更多数据
  final bool hasMore;

  /// 是否正在加载
  final bool isLoading;

  /// 是否正在加载更多
  final bool isLoadingMore;

  /// 错误信息
  final String? errorMessage;

  PickupOrderListState({
    this.tabIndex = 0,
    this.orderList = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  PickupOrderListState copyWith({
    int? tabIndex,
    List<WithdrawOrderModel>? orderList,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return PickupOrderListState(
      tabIndex: tabIndex ?? this.tabIndex,
      orderList: orderList ?? this.orderList,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}

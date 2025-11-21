import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

class PickupListState {
  /// 当前选中的标签索引 (0: 待提油, 1: 已完成)
  int tabIndex;

  /// 提油订单列表
  List<WithdrawOrderModel> orderList;

  /// 是否正在加载
  bool isLoading;

  /// 是否有更多数据
  bool hasMore;

  /// 当前页码
  int page;

  /// 错误信息
  String? errorMessage;

  PickupListState({
    this.tabIndex = 0,
    this.orderList = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.errorMessage,
  });

  PickupListState copyWith({
    int? tabIndex,
    List<WithdrawOrderModel>? orderList,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? errorMessage,
  }) {
    return PickupListState(
      tabIndex: tabIndex ?? this.tabIndex,
      orderList: orderList ?? this.orderList,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


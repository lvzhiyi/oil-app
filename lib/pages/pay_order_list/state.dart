import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

class PayOrderListState {
  final List<OrderModel> orderList;
  final int currentPage;
  final int total;
  final String? errorMessage;
  final PageStatus pageStatus;

  // Pagination
  final bool hasMore;
  final bool isLoadingMore;

  PayOrderListState({
    this.orderList = const [],
    this.currentPage = 1,
    this.total = 0,
    this.errorMessage,
    this.pageStatus = PageStatus.loading,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PayOrderListState copyWith({
    List<OrderModel>? orderList,
    bool? isLoading,
    int? currentPage,
    int? total,
    String? errorMessage,
    PageStatus? pageStatus,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PayOrderListState(
      orderList: orderList ?? this.orderList,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
      pageStatus: pageStatus ?? this.pageStatus,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

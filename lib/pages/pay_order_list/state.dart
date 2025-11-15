import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

class PayOrderListState {
  final List<OrderModel> orderList;
  final int currentPage;
  final int total;
  final String? errorMessage;
  final PageStatus pageStatus;
  PayOrderListState({
    this.orderList = const [],
    this.currentPage = 1,
    this.total = 0,
    this.errorMessage,
    this.pageStatus = PageStatus.loading,
  });

  PayOrderListState copyWith({
    List<OrderModel>? orderList,
    bool? isLoading,
    int? currentPage,
    int? total,
    String? errorMessage,
    PageStatus? pageStatus,
  }) {
    return PayOrderListState(
      orderList: orderList ?? this.orderList,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}

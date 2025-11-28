import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

class PickupOrderDetailState {
  final WithdrawOrderModel? order;
  final bool isLoading;
  final String? errorMessage;

  PickupOrderDetailState({
    this.order,
    this.isLoading = false,
    this.errorMessage,
  });

  PickupOrderDetailState copyWith({
    WithdrawOrderModel? order,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PickupOrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

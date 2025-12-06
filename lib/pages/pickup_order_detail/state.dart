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
    Object? errorMessage = _copyWithPlaceholder,
  }) {
    return PickupOrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _copyWithPlaceholder
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _copyWithPlaceholder = Object();

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';

class PickupOrderDetailCtrl extends Cubit<PickupOrderDetailState> {
  PickupOrderDetailCtrl({WithdrawOrderModel? order})
      : super(PickupOrderDetailState(order: order));

  void setOrder(WithdrawOrderModel order) {
    emit(state.copyWith(order: order));
  }
}


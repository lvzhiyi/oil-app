import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';

import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class PickupOrderDetailCtrl extends Cubit<PickupOrderDetailState> {
  PickupOrderDetailCtrl({WithdrawOrderModel? order})
      : super(PickupOrderDetailState(order: order));

  Future<void> loadOrderDetail(int withdrawId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final detail = await oilPickupService.getWithdrawDetail(withdrawId);
      emit(
        state.copyWith(
          order: detail,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '获取订单详情失败',
        ),
      );
      SportsToast.showWarning('获取订单详情失败，请重试');
    }
  }

  void setOrder(WithdrawOrderModel order) {
    emit(state.copyWith(order: order));
  }

  Future<bool> cancelOrder() async {
    if (state.order?.withdrawId == null) return false;

    emit(state.copyWith(isLoading: true));
    try {
      await oilPickupService.cancelWithdraw(state.order!.withdrawId!);
      SportsToast.showSuccess('订单已取消');
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      SportsToast.showWarning('取消失败，请重试');
      return false;
    }
  }
}

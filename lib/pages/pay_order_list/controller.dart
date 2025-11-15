import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';

class PayOrderListCtrl extends Cubit<PayOrderListState> {
  PayOrderListCtrl()
      : super(
          PayOrderListState(),
        ) {
    initState();
  }

  initState() async {}
}

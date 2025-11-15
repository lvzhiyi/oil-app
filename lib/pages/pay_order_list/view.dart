import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';

import 'widgets/orders_screen.dart';

class PayOrderListView extends HookWidget {
  final PayOrderListState state;

  const PayOrderListView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrdersScreen(state: state);
  }
}

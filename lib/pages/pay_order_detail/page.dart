import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_detail/view.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';
import 'state.dart';

class PayOrderDetailPage extends BasePage {
  const PayOrderDetailPage({Key? key, required this.extra}) : super(key: key);

  final Map<String, dynamic>? extra;

  @override
  State<PayOrderDetailPage> createState() => _PayOrderDetailPage();
}

class _PayOrderDetailPage extends BaseState<PayOrderDetailPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    final order = widget.extra?['order'] as OrderModel?;
    final orderId = widget.extra?['orderId'] as int?;
    final from = widget.extra?['from'] as String?;
    return BlocProvider(
      create: (BuildContext context) =>
          PayOrderDetailCtrl(order, orderId: orderId),
      child: BlocBuilder<PayOrderDetailCtrl, PayOrderDetailState>(
          builder: (context, state) {
        return PayOrderDetailView(
            state: state, order: state.order ?? order, from: from);
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_detail/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';
import 'state.dart';

class PayOrderDetailPage extends BasePage {
  const PayOrderDetailPage({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  State<PayOrderDetailPage> createState() => _PayOrderDetailPage();
}

class _PayOrderDetailPage extends BaseState<PayOrderDetailPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => PayOrderDetailCtrl(widget.uuid),
      child: BlocBuilder<PayOrderDetailCtrl, PayOrderDetailState>(
          builder: (context, state) {
        return PayOrderDetailView(state: state, uuid: widget.uuid);
      }),
    );
  }
}

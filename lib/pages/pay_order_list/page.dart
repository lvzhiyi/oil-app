import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';
import 'package:oil_business_app/pages/pay_order_list/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class PayOrderListPage extends BasePage {
  const PayOrderListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PayOrderListPage();
}

class _PayOrderListPage extends BaseState<PayOrderListPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => PayOrderListCtrl(),
      child: BlocBuilder<PayOrderListCtrl, PayOrderListState>(
          builder: (context, state) {
        return PayOrderListView(state: state);
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pickup_order_list/controller.dart';
import 'package:oil_business_app/pages/pickup_order_list/state.dart';
import 'package:oil_business_app/pages/pickup_order_list/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class PickupOrderListPage extends BasePage {
  const PickupOrderListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickupOrderListPageState();
}

class _PickupOrderListPageState extends BaseState<PickupOrderListPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => PickupOrderListCtrl(),
      child: BlocBuilder<PickupOrderListCtrl, PickupOrderListState>(
        builder: (context, state) {
          return PickupOrderListView(state: state);
        },
      ),
    );
  }
}

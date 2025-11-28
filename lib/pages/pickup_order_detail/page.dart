import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/controller.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';
import 'package:oil_business_app/pages/pickup_order_detail/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class PickupOrderDetailPage extends BasePage {
  final WithdrawOrderModel? order;

  const PickupOrderDetailPage({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickupOrderDetailPage();
}

class _PickupOrderDetailPage extends BaseState<PickupOrderDetailPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => PickupOrderDetailCtrl(
        order: widget.order,
      ),
      child: BlocBuilder<PickupOrderDetailCtrl, PickupOrderDetailState>(
        builder: (context, state) {
          return PickupOrderDetailView(state: state);
        },
      ),
    );
  }

  String get title => '提油订单详情';
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pickup_order_detail/controller.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';
import 'package:oil_business_app/pages/pickup_order_detail/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class PickupOrderDetailPage extends BasePage {
  final int withdrawId;

  const PickupOrderDetailPage({
    Key? key,
    required this.withdrawId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickupOrderDetailPage();
}

class _PickupOrderDetailPage extends BaseState<PickupOrderDetailPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PickupOrderDetailCtrl(
          withdrawId: widget.withdrawId,
        );
      },
      child: BlocBuilder<PickupOrderDetailCtrl, PickupOrderDetailState>(
        builder: (context, state) {
          return PickupOrderDetailView(state: state);
        },
      ),
    );
  }

  String get title => '提油订单详情';
}

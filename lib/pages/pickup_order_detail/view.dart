import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/pickup_order_detail/state.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart';

class PickupOrderDetailView extends StatelessWidget {
  final PickupOrderDetailState state;

  const PickupOrderDetailView({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickupOrderDetailScreen(
      order: state.order,
    );
  }
}


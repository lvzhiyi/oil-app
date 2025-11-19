import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/controller.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';

import 'widgets/oil_pickup_detail_screen.dart';

class OilPickupDetailView extends StatelessWidget {
  final OilPickupDetailState state;

  const OilPickupDetailView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<OilPickupDetailCtrl>();
    return OilPickupDetailScreen(state: state, controller: ctrl);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/controller.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';

import 'widgets/oil_pickup_screen.dart';

class OilPickupView extends StatelessWidget {
  final OilPickupState state;

  const OilPickupView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<OilPickupCtrl>();
    return OilPickupScreen(state: state, controller: ctrl);
  }
}


import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/oil_pickup/controller.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';

import 'inventory_list_screen.dart';

class OilPickupScreen extends StatefulWidget {
  final OilPickupState state;
  final OilPickupCtrl controller;

  const OilPickupScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<OilPickupScreen> createState() => _OilPickupScreenState();
}

class _OilPickupScreenState extends State<OilPickupScreen> {
  @override
  Widget build(BuildContext context) {
    return GlobalUpdateUi(
      builder: (context, appCtrl) {
        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),
          body: InventoryListScreen(
            state: widget.state,
            controller: widget.controller,
          ),
        );
      },
    );
  }
}

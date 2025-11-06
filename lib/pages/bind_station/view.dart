import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/bind_station/state.dart';

import 'widgets/bind_station_screen.dart';

class BindStationView extends StatefulWidget {
  const BindStationView({super.key, required this.state, required this.extra});
  final BindStationState state;
  final Map<String, dynamic>? extra;

  @override
  State<BindStationView> createState() => _BindStationViewState();
}

class _BindStationViewState extends State<BindStationView> {
  @override
  Widget build(BuildContext context) {
    return BindStationScreen(extra: widget.extra);
  }
}

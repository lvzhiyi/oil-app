import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/station_management_list/controller.dart';
import 'package:oil_business_app/pages/station_management_list/state.dart';

import 'widgets/station_management_list_screen.dart';

class StationManagementListView extends StatelessWidget {
  final StationManagementListState state;

  const StationManagementListView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<StationManagementListCtrl>();
    return StationManagementListScreen(state: state, controller: ctrl);
  }
}


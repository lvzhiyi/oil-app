import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/station_list/controller.dart';
import 'package:oil_business_app/pages/station_list/state.dart';

import 'widgets/station_list_screen.dart';

class StationListView extends StatelessWidget {
  final StationListState state;
  final bool allowEdit;

  const StationListView({
    Key? key,
    required this.state,
    this.allowEdit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<StationListCtrl>();
    return StationListScreen(
      state: state,
      controller: ctrl,
      allowEdit: allowEdit,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/station_edit/controller.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';

import 'widgets/station_edit_form.dart';

class StationEditView extends StatelessWidget {
  final StationEditState state;

  const StationEditView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<StationEditCtrl>();
    return StationEditForm(state: state, controller: ctrl);
  }
}

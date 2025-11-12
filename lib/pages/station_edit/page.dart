import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/pages/station_edit/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class StationEditPage extends BasePage {
  const StationEditPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StationEditPage();
}

class _StationEditPage extends BaseState<StationEditPage> with BasicInitPage {
  @override
  Widget body(context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final stationId = extra?['stationId'] as String?;

    return BlocProvider(
      create: (BuildContext context) => StationEditCtrl(stationId: stationId),
      child: BlocBuilder<StationEditCtrl, StationEditState>(
        builder: (context, state) {
          return StationEditView(state: state);
        },
      ),
    );
  }
}


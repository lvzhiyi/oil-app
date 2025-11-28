import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
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
    final station = extra?['station'] as Station?;
    final isFromPendingReview = extra?['isFromPendingReview'] as bool?;

    return BlocProvider(
      create: (BuildContext context) => StationEditCtrl(
          station: station, isFromPendingReview: isFromPendingReview ?? false),
      child: BlocBuilder<StationEditCtrl, StationEditState>(
        builder: (context, state) {
          return StationEditView(state: state);
        },
      ),
    );
  }
}

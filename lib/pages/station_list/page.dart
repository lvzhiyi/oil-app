import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/pages/station_list/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class StationListPage extends BasePage {
  const StationListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StationListPage();
}

class _StationListPage extends BaseState<StationListPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => StationListCtrl(),
      child: BlocBuilder<StationListCtrl, StationListState>(
        builder: (context, state) {
          return StationListView(state: state);
        },
      ),
    );
  }
}


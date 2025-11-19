import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/station_management_list/state.dart';
import 'package:oil_business_app/pages/station_management_list/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class StationManagementListPage extends BasePage {
  const StationManagementListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StationManagementListPage();
}

class _StationManagementListPage extends BaseState<StationManagementListPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => StationManagementListCtrl(),
      child: BlocBuilder<StationManagementListCtrl, StationManagementListState>(
        builder: (context, state) {
          return StationManagementListView(state: state);
        },
      ),
    );
  }
}


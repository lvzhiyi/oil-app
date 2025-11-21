import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pickup_list/controller.dart';
import 'package:oil_business_app/pages/pickup_list/state.dart';
import 'package:oil_business_app/pages/pickup_list/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class PickupListPage extends BasePage {
  const PickupListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickupListPageState();
}

class _PickupListPageState extends BaseState<PickupListPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => PickupListCtrl(),
      child: BlocBuilder<PickupListCtrl, PickupListState>(
        builder: (context, state) {
          return PickupListView(state: state);
        },
      ),
    );
  }
}

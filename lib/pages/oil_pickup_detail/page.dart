import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class OilPickupDetailPage extends BasePage {
  final InventoryModel inventory;

  const OilPickupDetailPage({Key? key, required this.inventory}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OilPickupDetailPage();
}

class _OilPickupDetailPage extends BaseState<OilPickupDetailPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => OilPickupDetailCtrl(widget.inventory),
      child: BlocBuilder<OilPickupDetailCtrl, OilPickupDetailState>(
        builder: (context, state) {
          return OilPickupDetailView(state: state);
        },
      ),
    );
  }
  
  String get title => '提油详情';
}

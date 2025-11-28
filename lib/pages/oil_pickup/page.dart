import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/pages/oil_pickup/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class OilPickupPage extends BasePage {
  const OilPickupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OilPickupPage();
}

class _OilPickupPage extends BaseState<OilPickupPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => OilPickupCtrl(),
      child: BlocBuilder<OilPickupCtrl, OilPickupState>(
        builder: (context, state) {
          return OilPickupView(state: state);
        },
      ),
    );
  }
}

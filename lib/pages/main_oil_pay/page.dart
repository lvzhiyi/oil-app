import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';
import 'state.dart';
import 'view.dart';

class MainOilPayPage extends BasePage {
  const MainOilPayPage({super.key, this.extra});
  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _MainOilPayPage();
}

class _MainOilPayPage extends BaseState<MainOilPayPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => OilPayCtrl(),
      child:
          BlocBuilder<OilPayCtrl, MainOilPayState>(builder: (context, state) {
        return MainOilPayView(state: state, extra: widget.extra);
      }),
    );
  }
}

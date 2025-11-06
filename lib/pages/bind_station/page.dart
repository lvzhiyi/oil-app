import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';
import 'state.dart';
import 'view.dart';

class BindStationPage extends BasePage {
  const BindStationPage({Key? key, this.extra}) : super(key: key);
  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _BindStationPage();
}

class _BindStationPage extends BaseState<BindStationPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => BindStationCtrl(
        extra: widget.extra,
      ),
      child: BlocBuilder<BindStationCtrl, BindStationState>(
        builder: (context, state) {
          return BindStationView(state: state, extra: widget.extra);
        },
      ),
    );
  }
}

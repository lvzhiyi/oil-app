import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/splase/state.dart';
import 'package:lottery_app/pages/splase/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class SplasePage extends BasePage {
  const SplasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplasePage();
}

class _SplasePage extends BaseState<SplasePage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => SplaseCtrl(),
      child: BlocBuilder<SplaseCtrl, SplaseState>(builder: (context, state) {
        return SplaseView(state: state);
      }),
    );
  }
}

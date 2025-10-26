import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/login/changePw/state.dart';
import 'package:lottery_app/pages/login/changePw/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class ChangePwPage extends BasePage {
  const ChangePwPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePwPage();
}

class _ChangePwPage extends BaseState<ChangePwPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => ChangePwCtrl(),
      child:
          BlocBuilder<ChangePwCtrl, ChangePwState>(builder: (context, state) {
        return ChangePwView(state: state);
      }),
    );
  }
}

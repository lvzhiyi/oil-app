import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/login/state.dart';
import 'package:lottery_app/pages/login/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class LoginPage extends BasePage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends BaseState<LoginPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCtrl(),
      child: BlocBuilder<LoginCtrl, LoginState>(builder: (context, state) {
        return LoginView(state: state);
      }),
    );
  }
}

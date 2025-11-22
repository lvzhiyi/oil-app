import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:oil_business_app/pages/login/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class LoginPage extends BasePage {
  final Map<String, dynamic>? extra;
  const LoginPage({Key? key, this.extra}) : super(key: key);

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

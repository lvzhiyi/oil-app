import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/register/state.dart';
import 'package:oil_business_app/pages/register/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class RegisterPage extends BasePage {
  const RegisterPage({Key? key, this.extra}) : super(key: key);
  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends BaseState<RegisterPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCtrl(
        extra: widget.extra,
      ),
      child: BlocListener<RegisterCtrl, RegisterState>(
        listener: (context, state) {
          if (state.registerSuccess) {}
        },
        child: BlocBuilder<RegisterCtrl, RegisterState>(
          builder: (context, state) {
            return RegisterView(state: state);
          },
        ),
      ),
    );
  }
}

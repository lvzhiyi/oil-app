import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/change_password/state.dart';

import 'widgets/change_password_screen.dart';

class ChangePasswordView extends HookWidget {
  final ChangePasswordState state;

  const ChangePasswordView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordScreen();
  }
}


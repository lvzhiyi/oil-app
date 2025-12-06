import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';
import 'package:oil_business_app/pages/forgot_password/widgets/forgot_password_screen.dart';

/// 找回密码视图
class ForgotPasswordView extends HookWidget {
  final ForgotPasswordState state;

  const ForgotPasswordView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordScreen();
  }
}

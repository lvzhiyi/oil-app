import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/login/state.dart';

import 'controller.dart';
import 'widgets/unified_login_screen.dart';

class LoginView extends StatefulWidget {
  final LoginState state;

  const LoginView({super.key, required this.state});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<LoginCtrl>();

    return BlocListener<LoginCtrl, LoginState>(
      listener: (context, state) {
        if (state.loginSuccess) {
          // 使用WidgetsBinding.instance.addPostFrameCallback避免在构建期间导航
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ctrl.navigateToHome(context);
            }
          });
        }
      },
      child: const UnifiedLoginScreen(),
    );
  }
}

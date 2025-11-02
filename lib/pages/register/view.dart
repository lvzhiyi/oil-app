import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/register/controller.dart';
import 'package:oil_business_app/pages/register/state.dart';

import 'widgets/create_new_account_screen.dart';

class RegisterView extends HookWidget {
  final RegisterState state;

  const RegisterView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<RegisterCtrl>();

    return const CreateNewAccountScreen();
  }
}

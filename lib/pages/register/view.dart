import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/register/controller.dart';
import 'package:oil_business_app/pages/register/state.dart';

class RegisterView extends HookWidget {
  final RegisterState state;

  const RegisterView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<RegisterCtrl>();

    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Text('Register'),
        ],
      ),
    );
  }
}

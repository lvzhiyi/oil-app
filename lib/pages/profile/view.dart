import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/profile/controller.dart';
import 'package:oil_business_app/pages/profile/state.dart';

class ProfileView extends HookWidget {
  final ProfileState state;

  const ProfileView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ProfileCtrl>();
    return const Scaffold(
      body: Text('Profile Page'),
    );
  }
}

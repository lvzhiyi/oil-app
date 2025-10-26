import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottery_app/pages/login/changePhone/state.dart';

class ChangePhoneCtrl extends Cubit<ChangePhoneState> {
  ChangePhoneCtrl()
      : super(
          ChangePhoneState(loading: false),
        ) {
    initState();
  }

  final formKey = GlobalKey<FormBuilderState>();

  submit() async {
    if (state.loading) return;

    final isValid = formKey.currentState?.saveAndValidate();
    if (isValid == false) return;

    final formVal = formKey.currentState?.value;
    emit(state.copyWith()..loading = true);
    print('------$formVal---------');

    try {} catch (e) {
      print('------$e---------');
      emit(state.copyWith()..loading = false);
    }
  }

  initState() async {}
}

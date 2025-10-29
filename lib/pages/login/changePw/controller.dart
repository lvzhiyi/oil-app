import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/pages/login/changePw/state.dart';

class ChangePwCtrl extends Cubit<ChangePwState> {
  ChangePwCtrl()
      : super(
          ChangePwState(loading: false),
        ) {
    initState();
  }

  final formKey = GlobalKey<FormBuilderState>();

  initState() async {}

  submit() async {
    if (state.loading) return;

    final isValid = formKey.currentState?.saveAndValidate();
    if (isValid == false) return;

    emit(state.copyWith()..loading = true);
    try {} finally {
      emit(state.copyWith()..loading = false);
    }
  }
}

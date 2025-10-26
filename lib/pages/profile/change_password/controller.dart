import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/pages/employee_management/service/employee_service.dart';
import 'package:lottery_app/pages/profile/change_password/state.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/widgets/popup/toast.dart';

class ProfileChangePasswordCtrl extends Cubit<ProfileChangePasswordState> {
  ProfileChangePasswordCtrl()
      : super(
          ProfileChangePasswordState(loading: false),
        ) {
    initState();
  }

  final formKey = GlobalKey<FormBuilderState>();

  initState() async {}

  Future<void> submit() async {
    if (state.loading) return;
    final isValid = formKey.currentState?.saveAndValidate();
    if (isValid == false) return;

    final values = formKey.currentState!.value;
    final String oldPassword = values['oldPassword'] ?? '';
    final String newPassword = values['password'] ?? '';

    emit(state.copyWith(loading: true));
    try {
      final user =
          BaseConfig.appContext!.read<AppController>().getCurrentEmployee();
      final String? uuid = user?.uuid;
      if (uuid == null || uuid.isEmpty) {
        SportsToast.showError('无法获取用户标识');
        return;
      }

      await employeeService.updateEmployee(uuid, {
        'oldPassword': oldPassword,
        'password': newPassword,
      });

      SportsToast.showSuccess('密码修改成功');
      BaseRouter.replace(url: AppPage.loginPage.path);
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }
}

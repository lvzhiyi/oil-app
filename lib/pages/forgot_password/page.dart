import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/forgot_password/controller.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';
import 'package:oil_business_app/pages/forgot_password/view.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

/// 找回密码页面
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCtrl(),
      child: BlocListener<ForgotPasswordCtrl, ForgotPasswordState>(
        listener: (context, state) {
          // 显示错误消息
          if (state.errorMessage != null) {
            SportsToast.showError(state.errorMessage!);
            context.read<ForgotPasswordCtrl>().clearError();
          }
        },
        child: BlocBuilder<ForgotPasswordCtrl, ForgotPasswordState>(
          builder: (context, state) {
            return ForgotPasswordView(state: state);
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

import 'state.dart';

class OtpCtrl extends Cubit<OtpState> {
  OtpCtrl()
      : super(
          OtpState(),
        ) {
    initState();
  }

  final phoneController = TextEditingController();

  final codeController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  initState() async {}

  sendOtp({required String type}) async {
    emit(state.copyWith(phone: phoneController.text));

    try {
      // await authService.sendCode(
      //   SendCodeRequest(phone: phoneController.text, type: 'register'),
      // );

      BaseRouter.push(url: AppPage.otpVerificationPage.path, extra: {
        "type": type,
      });
    } catch (e) {
      l.e('Otp', '发送验证码失败: $e');
    }
  }

  submit({required String type}) async {
    if (type == "register") {
      print('submit register');
      BaseRouter.push(url: AppPage.registerPage.path, extra: {
        "phone": phoneController.text,
        "code": codeController.map((e) => e.text).join(''),
      });
    } else {
      BaseRouter.push(url: AppPage.mainLayoutPage.path, extra: {
        "type": type,
      });
    }
  }
}

final otpCtrl = OtpCtrl();

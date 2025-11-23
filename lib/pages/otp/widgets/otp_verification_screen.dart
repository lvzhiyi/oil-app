import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/otp/controller.dart';
import 'package:oil_business_app/pages/otp/state.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_digit_textformfield.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, this.extra});
  final Map<String, dynamic>? extra;

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const OtpVerificationScreen());
  }

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  void initState() {
    super.initState();
    // 如果倒计时未启动，则启动倒计时
    final ctrl = context.read<OtpCtrl>();
    if (ctrl.state.countdownSeconds == null) {
      ctrl.startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 直接使用全局 otpCtrl，不再创建新的 BlocProvider
    // 避免在页面销毁时关闭全局单例
    final ctrl = context.read<OtpCtrl>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(120)),
                child: CommonText(
                  text: 'OTP验证',
                  fontSize: AppSizes.setFontSize(35),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(25)),
                child: CommonText(
                  text: '请输入我们发送给您的4位验证码',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                child: CommonText(
                  text: widget.extra?["phone"] ?? '',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(52)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSizes.setWidth(58),
                      height: AppSizes.setHeight(60),
                      child: SingleDigitTextField(
                        controller: ctrl.codeController[0],
                        focusNode: ctrl.focusNode[0],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: ctrl.codeController[1],
                          focusNode: ctrl.focusNode[1],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: ctrl.codeController[2],
                          focusNode: ctrl.focusNode[2],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: ctrl.codeController[3],
                          focusNode: ctrl.focusNode[3],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(43)),
                child: CommonButton(
                  btnText: '继续',
                  onTap: () {
                    // 传递表单数据

                    ctrl.submit(extra: widget.extra ?? {});
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                child: CommonText(
                  text: '没有收到验证码？',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),

              BlocBuilder<OtpCtrl, OtpState>(
                bloc: ctrl,
                builder: (context, state) {
                  final countdownSeconds = state.countdownSeconds ?? 0;
                  final canResend = countdownSeconds == 0;

                  return GestureDetector(
                    onTap: canResend
                        ? () {
                            ctrl.resendOtp(extra: widget.extra ?? {});
                          }
                        : null,
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                      child: CommonText(
                        text: canResend ? '重新发送' : '${countdownSeconds}s 后重新发送',
                        fontSize: AppSizes.setFontSize(15),
                        fontWeight: FontWeight.w600,
                        textColor: canResend
                            ? CustomAppColor.of(context).txtPurple
                            : CustomAppColor.of(context).txtGrey,
                        textDecoration: canResend
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  );
                },
              ),

              // Padding(
              //   padding: EdgeInsets.only(
              //       top: AppSizes.setHeight(39),
              //       left: AppSizes.setWidth(41),
              //       right: AppSizes.setWidth(30)),
              //   child: CommonText(
              //     text: '通过继续，您同意买油呗的',
              //     fontSize: AppSizes.setFontSize(15),
              //     fontWeight: FontWeight.w600,
              //     textColor: CustomAppColor.of(context).txtGrey,
              //   ),
              // ),
              // CommonText(
              //   text: '条款和条件和隐私政策',
              //   fontSize: AppSizes.setFontSize(15),
              //   fontWeight: FontWeight.w600,
              //   textColor: CustomAppColor.of(context).txtGrey,
              // )
            ],
          ),
        ),
      ),
    );
  }
}

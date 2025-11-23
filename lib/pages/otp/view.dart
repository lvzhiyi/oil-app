import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/otp/state.dart';
import 'widgets/otp_verification_screen.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.state, required this.extra});
  final OtpState state;
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return OtpVerificationScreen(extra: extra);
  }
}

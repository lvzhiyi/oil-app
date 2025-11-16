import 'package:flutter/material.dart';
import 'state.dart';
import 'widgets/sign_up_screen.dart';

class OtpView extends StatefulWidget {
  final OtpState state;
  final Map<String, dynamic>? extra;

  const OtpView({super.key, required this.state, this.extra});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignUpScreen(extra: widget.extra);
  }
}

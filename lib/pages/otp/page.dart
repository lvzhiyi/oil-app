import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/otp/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';
import 'state.dart';

class OtpPage extends BasePage {
  const OtpPage({super.key, this.extra});
  final Map<String, dynamic>? extra;

  @override
  State<StatefulWidget> createState() => _OtpPage();
}

class _OtpPage extends BaseState<OtpPage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => otpCtrl,
      child: BlocBuilder<OtpCtrl, OtpState>(builder: (context, state) {
        return OtpView(state: state, extra: widget.extra);
      }),
    );
  }
}

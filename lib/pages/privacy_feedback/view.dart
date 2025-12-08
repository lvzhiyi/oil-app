import 'package:flutter/material.dart';
import 'package:oil_business_app/widgets/common/html_webview_container.dart';
import 'state.dart';

class PrivacyFeedbackView extends StatelessWidget {
  final PrivacyFeedbackState state;

  const PrivacyFeedbackView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HtmlWebViewContainer(
      url: 'https://www.maiyoubei.com/privacy_policy.html',
      title: '隐私政策',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:oil_business_app/widgets/common/html_webview_container.dart';
import 'package:oil_business_app/pages/service_agreement/state.dart';

class ServiceAgreementView extends StatelessWidget {
  final ServiceAgreementState state;

  const ServiceAgreementView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HtmlWebViewContainer(
      url: 'https://www.maiyoubei.com/service_agreement.html',
      title: '用户协议',
    );
  }
}

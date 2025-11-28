import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/service_agreement/state.dart';
import 'package:oil_business_app/pages/service_agreement/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class ServiceAgreementPage extends BasePage {
  const ServiceAgreementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServiceAgreementPage();
}

class _ServiceAgreementPage extends BaseState<ServiceAgreementPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => ServiceAgreementCtrl(),
      child: BlocBuilder<ServiceAgreementCtrl, ServiceAgreementState>(
          builder: (context, state) {
        return ServiceAgreementView(state: state);
      }),
    );
  }
}

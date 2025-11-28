import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/service_agreement/state.dart';

class ServiceAgreementCtrl extends Cubit<ServiceAgreementState> {
  ServiceAgreementCtrl()
      : super(
          ServiceAgreementState(),
        ) {
    initState();
  }

  initState() async {}
}

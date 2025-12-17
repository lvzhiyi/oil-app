import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/account_security/state.dart';

import 'widgets/account_security_screen.dart';

class AccountSecurityView extends StatelessWidget {
  final AccountSecurityState state;

  const AccountSecurityView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccountSecurityScreen(state: state);
  }
}


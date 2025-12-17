import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/account_security/state.dart';
import 'package:oil_business_app/pages/account_security/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

import 'controller.dart';

class AccountSecurityPage extends BasePage {
  const AccountSecurityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountSecurityPage();
}

class _AccountSecurityPage extends BaseState<AccountSecurityPage>
    with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => AccountSecurityCtrl(),
      child: BlocBuilder<AccountSecurityCtrl, AccountSecurityState>(
        builder: (context, state) {
          return AccountSecurityView(state: state);
        },
      ),
    );
  }
}


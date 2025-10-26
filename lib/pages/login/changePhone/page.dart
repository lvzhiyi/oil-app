import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/login/changePhone/state.dart';
import 'package:lottery_app/pages/login/changePhone/view.dart';
import 'package:lottery_app/widgets/common/base_page.dart';

import 'controller.dart';

class ChangePhonePage extends BasePage {
  final Map<String, dynamic> extra;
  const ChangePhonePage({
    Key? key,
    required this.extra,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePhonePage();
}

class _ChangePhonePage extends BaseState<ChangePhonePage> with BasicInitPage {
  @override
  Widget body(context) {
    return BlocProvider(
      create: (BuildContext context) => ChangePhoneCtrl(),
      child: BlocBuilder<ChangePhoneCtrl, ChangePhoneState>(
        builder: (context, state) {
          return ChangePhoneView(
            state: state,
            extra: widget.extra,
          );
        },
      ),
    );
  }
}

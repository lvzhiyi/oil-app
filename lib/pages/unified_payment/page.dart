import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/unified_payment/controller.dart';
import 'package:lottery_app/pages/unified_payment/state.dart';
import 'package:lottery_app/pages/unified_payment/view.dart';

class UnifiedPaymentPage extends StatelessWidget {
  const UnifiedPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnifiedPaymentCtrl(),
      child: BlocBuilder<UnifiedPaymentCtrl, UnifiedPaymentState>(
        builder: (context, state) {
          return UnifiedPaymentView(state: state);
        },
      ),
    );
  }
}

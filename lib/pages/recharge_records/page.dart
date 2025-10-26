import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/recharge_records/controller.dart';
import 'package:lottery_app/pages/recharge_records/state.dart';
import 'package:lottery_app/pages/recharge_records/view.dart';

class RechargeRecordsPage extends StatelessWidget {
  const RechargeRecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RechargeRecordsCtrl(),
      child: BlocBuilder<RechargeRecordsCtrl, RechargeRecordsState>(
        builder: (context, state) {
          return RechargeRecordView(state: state);
        },
      ),
    );
  }
}

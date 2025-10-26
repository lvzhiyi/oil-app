import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:lottery_app/pages/gift_records/controller.dart';
import 'package:lottery_app/pages/gift_records/state.dart';
import 'package:lottery_app/pages/gift_records/view.dart';

import 'service/gift_records_service.dart';

class GiftRecordsPage extends StatelessWidget {
  const GiftRecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GiftRecordsCtrl(
        service: GiftRecordsService(netManager.clientDio!),
      ),
      child: BlocBuilder<GiftRecordsCtrl, GiftRecordsState>(
        builder: (context, state) {
          return GiftRecordsView(state: state);
        },
      ),
    );
  }
}

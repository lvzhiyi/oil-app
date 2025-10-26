import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/controller.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/state.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/view.dart';

class GiftLotteryQrDynamicPage extends StatelessWidget {
  const GiftLotteryQrDynamicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GiftLotteryQrDynamicCtrl(),
      child: BlocBuilder<GiftLotteryQrDynamicCtrl, GiftLotteryQrDynamicState>(
        builder: (context, state) {
          return GiftLotteryQrDynamicView(state: state);
        },
      ),
    );
  }
}

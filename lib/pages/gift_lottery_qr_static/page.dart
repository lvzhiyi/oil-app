import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/controller.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/state.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/view.dart';

class GiftLotteryQrStaticPage extends StatelessWidget {
  const GiftLotteryQrStaticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GiftLotteryQrStaticCtrl(),
      child: BlocBuilder<GiftLotteryQrStaticCtrl, GiftLotteryQrStaticState>(
        builder: (context, state) {
          return GiftLotteryQrStaticView(state: state);
        },
      ),
    );
  }
}

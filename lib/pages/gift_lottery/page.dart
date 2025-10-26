import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/gift_lottery/controller.dart';
import 'package:lottery_app/pages/gift_lottery/state.dart';
import 'package:lottery_app/pages/gift_lottery/view.dart';

class GiftLotteryPage extends StatelessWidget {
  const GiftLotteryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GiftLotteryCtrl(),
      child: BlocBuilder<GiftLotteryCtrl, GiftLotteryState>(
        builder: (context, state) {
          return GiftLotteryView(state: state);
        },
      ),
    );
  }
}

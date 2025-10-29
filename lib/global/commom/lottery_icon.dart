import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';

/// 获取彩票类型对应的图标
IconData getLotteryTypeIcon(LotteryType type) {
  switch (type) {
    case LotteryType.doubleColorBall:
      return Icons.sports_soccer;
    case LotteryType.threeDimensional:
      return Icons.casino;
    case LotteryType.happyEight:
      return Icons.emoji_events;
    case LotteryType.sevenHappyColor:
      return Icons.color_lens;
  }
}

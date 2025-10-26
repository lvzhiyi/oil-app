import 'package:flutter/material.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:intl/intl.dart';

import 'pt.dart';

class FormattedAmountWidget extends StatelessWidget {
  final double? amount;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const FormattedAmountWidget({
    Key? key,
    required this.amount,
    this.fontSize,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedAmount = numberFormat(amount ?? 0);
    return Text(
      formattedAmount,
      style: TextStyle(
        fontSize: fontSize ?? pt(16),
        color: color ?? AppColors.appText,
        fontWeight: fontWeight,
      ),
    );
  }

  String numberFormat(double number) {
    return NumberFormat.currency(locale: 'en', symbol: '').format(number);
  }
}

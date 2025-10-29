import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/pt.dart';

class AppSize {
  static final EdgeInsets pagePadding =
      EdgeInsets.symmetric(vertical: 0, horizontal: pt(12));
  static final BorderRadius radius = BorderRadius.circular(12);
  static final List<BoxShadow> boxShadow = [
    BoxShadow(
      color: const Color(0xffe6e6e6),
      offset: const Offset(0, 4),
      blurRadius: pt(8),
      spreadRadius: 0,
    )
  ];
}

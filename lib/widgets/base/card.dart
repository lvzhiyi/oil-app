import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/utils/pt.dart';

///**
/// 通用白色背景容器
/// */
class CardContainer extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? bgColor;
  final Widget child;
  final List<BoxShadow>? boxShadow;
  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.bgColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pt(351),
      padding: padding ?? EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: AppSize.radius,
        boxShadow: boxShadow ?? AppSize.boxShadow,
      ),
      child: child,
    );
  }
}

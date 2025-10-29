// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/resources/size.dart';

class EmptyCard extends StatelessWidget {
  final String desc;

  final Widget? button;

  final Widget icon;

  const EmptyCard({
    Key? key,
    this.button,
    required this.desc,
    required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        width: 105,
        height: 83,
        child: icon,
      ),
      const Gap(12),
      Text(desc,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.45,
          )),
    ];
    if (button != null) {
      children.addAll([
        const Gap(12),
        button!,
      ]);
    }
    return Column(
      children: [
        const Gap(12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSize.radius,
            boxShadow: AppSize.boxShadow,
          ),
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ],
    );
  }
}

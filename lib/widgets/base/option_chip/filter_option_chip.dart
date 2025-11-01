import 'package:flutter/material.dart';

import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function()? onTap;

  const FilterOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(8), vertical: AppSizes.setHeight(3)),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? CustomAppColor.of(context).borderPurple
                  : CustomAppColor.of(context).borderGrey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CommonText(
          text: label,
          textColor: isSelected
              ? CustomAppColor.of(context).borderPurple
              : CustomAppColor.of(context).borderGrey,
          fontWeight: FontWeight.w500,
          fontSize: AppSizes.setFontSize(12),
        ),
      ),
    );
  }
}

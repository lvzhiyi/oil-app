import 'package:flutter/material.dart';

import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import '../text/common_text.dart';

class CommonActionWidget {
  static Widget icon(String asset) {
    return Image.asset(
      asset,
      height: AppSizes.setHeight(14),
      width: AppSizes.setWidth(21),
    );
  }

  static Widget actionRow({
    required String text,
    required String iconAsset,
    required BuildContext context,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CommonText(
            text: text,
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.setFontSize(12),
          ),
          SizedBox(width: AppSizes.setWidth(4)),
          icon(iconAsset),
        ],
      ),
    );
  }

  static Widget divider(BuildContext context) {
    return Container(
      height: AppSizes.setHeight(16),
      width: AppSizes.setWidth(1),
      color: CustomAppColor.of(context).borderGrey,
    );
  }

  static Widget action(
    BuildContext context, {
    Function()? sortByTap,
    Function()? categoryTap,
    Function()? genderTap,
    Function()? filterTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(20),
        vertical: AppSizes.setHeight(21),
      ),
      color: CustomAppColor.of(context).bgScaffold,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          actionRow(
            text: 'sortBy',
            iconAsset: AssetsIcon.IC_DOWN_FILTER,
            context: context,
            onTap: sortByTap,
          ),
          divider(context),
          actionRow(
            text: 'category',
            iconAsset: AssetsIcon.IC_DOWN_ARROW,
            context: context,
            onTap: categoryTap,
          ),
          divider(context),
          actionRow(
            text: 'gender',
            iconAsset: AssetsIcon.IC_DOWN_ARROW,
            context: context,
            onTap: genderTap,
          ),
          divider(context),
          actionRow(
            text: 'filter',
            iconAsset: AssetsIcon.IC_FILTER,
            context: context,
            onTap: filterTap,
          ),
        ],
      ),
    );
  }
}

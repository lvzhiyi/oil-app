import 'package:flutter/material.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/utils.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import '../text/common_text.dart';

class TopBar extends StatelessWidget {
  const TopBar(this.clickListener,
      {super.key,
      this.title,
      this.alignment = Alignment.centerLeft,
      this.isShowTitle = true,
      this.subTitle = "",
      this.isShowNotification = false,
      this.isShowSearch = false,
      this.isShowSearchField = false,
      this.isShowBack = false,
      this.isShowShadow = true,
      this.topBarColor = AppColor.white,
      this.textColor = AppColor.txtWhite,
      this.height = 100,
      this.isShowCart = false,
      this.isShowLike = false,
      this.isShowProfile = false,
      this.isShowCartCount,
      this.isShowEditProfile = false,
      this.isBackIconWhite = false});

  final String? title;
  final AlignmentGeometry alignment;
  final String subTitle;
  final TopBarClickListener clickListener;
  final bool isShowTitle;
  final bool isShowProfile;
  final bool isShowNotification;
  final bool isShowSearch;
  final bool isShowCart;
  final bool isShowSearchField;
  final bool isShowBack;
  final bool isShowLike;
  final Color? topBarColor;
  final Color textColor;
  final double height;
  final bool isShowShadow;
  final bool? isShowCartCount;
  final bool? isShowEditProfile;
  final bool? isBackIconWhite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.setHeight(height),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(18),
      ),
      decoration: BoxDecoration(
        color: topBarColor ?? CustomAppColor(context).txtWhite,
        boxShadow: isShowShadow
            ? [
                BoxShadow(
                  color: CustomAppColor.of(context)
                      .txtBlack
                      .withOpacityPercent(0.01),
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      alignment: Alignment.centerLeft,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isShowBack)
              InkWell(
                onTap: () {
                  clickListener.onTopBarClick('back');
                },
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.setWidth(5)),
                  child: Image.asset(
                    AssetsIcon.IC_LEFT,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(24),
                    color: isBackIconWhite ?? false
                        ? CustomAppColor.of(context).white
                        : CustomAppColor.of(context).icBlack,
                    fit: BoxFit.fill,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            if (isShowProfile)
              Container(
                margin: EdgeInsets.only(right: AppSizes.setWidth(15)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomAppColor.of(context).white),
                child: Image.asset(
                  AssetsIcon.IC_AVATAR,
                  height: AppSizes.setHeight(35),
                  width: AppSizes.setWidth(35),
                ),
              ),
            if (isShowTitle)
              CommonText(
                text: title ?? '',
                textColor: textColor,
                fontWeight: FontWeight.w600,
                fontSize: AppSizes.setFontSize(20),
              ),
            const Spacer(),
            if (isShowSearchField)
              InkWell(
                onTap: () {
                  clickListener.onTopBarClick('search');
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.setWidth(12)),
                  child: Image.asset(
                    AssetsIcon.IC_SEARCH,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(24),
                    color: CustomAppColor.of(context).icBlack,
                  ),
                ),
              ),
            if (isShowLike)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.setWidth(12)),
                child: InkWell(
                  onTap: () {
                    clickListener.onTopBarClick('wishlist');
                  },
                  child: Image.asset(
                    AssetsIcon.IC_HEART,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(24),
                    gaplessPlayback: true,
                    color: CustomAppColor.of(context).icBlack,
                  ),
                ),
              ),
            if (isShowNotification)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.setWidth(12)),
                child: InkWell(
                  onTap: () {
                    clickListener.onTopBarClick('notification');
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AssetsIcon.IC_NOTIFICATION,
                        height: AppSizes.setHeight(24),
                        width: AppSizes.setWidth(24),
                        gaplessPlayback: true,
                        color: CustomAppColor.of(context).icBlack,
                      ),
                      Positioned(
                        top: AppSizes.setHeight(3),
                        right: AppSizes.setWidth(3),
                        child: Container(
                          height: AppSizes.setHeight(8),
                          width: AppSizes.setWidth(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomAppColor.of(context).white),
                            color: CustomAppColor.of(context).red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isShowCart)
              Padding(
                padding: EdgeInsets.only(left: AppSizes.setWidth(12)),
                child: InkWell(
                  onTap: () {
                    clickListener.onTopBarClick('pay_order_list');
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AssetsIcon.IC_BUY,
                        height: AppSizes.setHeight(24),
                        width: AppSizes.setWidth(24),
                        gaplessPlayback: true,
                        color: CustomAppColor.of(context).icBlack,
                      ),
                      Visibility(
                        visible: isShowCartCount ?? false,
                        child: Positioned(
                          top: -AppSizes.setHeight(5),
                          right: -AppSizes.setWidth(3),
                          bottom: AppSizes.setHeight(16),
                          child: Container(
                            height: AppSizes.setHeight(16),
                            width: AppSizes.setWidth(16),
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomAppColor.of(context).white),
                              color: CustomAppColor.of(context).icPurple,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: CommonText(
                              text: "4",
                              textColor: CustomAppColor.of(context).white,
                              fontSize: AppSizes.setFontSize(8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isShowEditProfile ?? false)
              Padding(
                padding: EdgeInsets.only(left: AppSizes.setWidth(22)),
                child: InkWell(
                  onTap: () {
                    clickListener.onTopBarClick('edit');
                  },
                  child: Image.asset(
                    AssetsIcon.IC_EDIT_PROFILE,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(24),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

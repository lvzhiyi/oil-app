import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/bottom_sheet/bottom_sheet.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

import 'account_data.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AccountScreen());
  }

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    implements TopBarClickListener {
  bool isAccountCreated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgTopBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileDetailHorizontal(),
            Padding(
              padding: EdgeInsets.only(
                  top: AppSizes.setHeight(15),
                  bottom: isAccountCreated
                      ? AppSizes.setHeight(0)
                      : AppSizes.setHeight(5)),
              child: _accountActionList(isAccountCreated),
            ),
            _appVersionInfo(),
          ],
        ),
      ),
    );
  }

  _profileDetailHorizontal() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.setWidth(20), vertical: AppSizes.setHeight(16)),
      width: AppSizes.fullWidth,
      color: CustomAppColor.of(context).bgScaffold,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            AssetsIcon.IC_AVATAR,
            height: AppSizes.setHeight(74),
            width: AppSizes.setWidth(74),
            fit: BoxFit.contain,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonText(
                text: context
                        .read<AppController>()
                        .state
                        .authResponse
                        ?.account
                        ?.phone ??
                    '',
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                fontSize: AppSizes.setFontSize(18),
              ),
              // CommonText(
              //   text: '查看并更新您的资料',
              //   fontWeight: FontWeight.w600,
              //   textColor: CustomAppColor.of(context).txtGrey,
              //   fontSize: AppSizes.setFontSize(12),
              // ),
            ],
          ),
          const SizedBox(width: 10),
          // Image.asset(
          //   AssetsIcon.IC_RIGHT_ARROW,
          //   height: AppSizes.setHeight(24),
          //   width: AppSizes.setWidth(24),
          // )
        ],
      ),
    );
  }

  _accountActionList(bool isAccountCreated) {
    int itemCount =
        isAccountCreated ? accountList.length : accountList.length - 1;

    return Container(
      color: CustomAppColor.of(context).txtWhite,
      width: AppSizes.setWidth(375),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount >= 0 ? itemCount : 0,
        itemBuilder: (context, index) {
          final accountData = accountList[index];

          return Container(
            height: AppSizes.setHeight(58),
            decoration: BoxDecoration(
              color: CustomAppColor.of(context).bgScaffold,
              border: Border(
                bottom: BorderSide(
                  color: CustomAppColor.of(context)
                      .borderGrey
                      .withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                onTap: () {
                  if (accountData.label == '退出登录') {
                    logoutBottomSheet(context);
                  } else if (accountData.label == '修改密码') {
                    BaseRouter.push(
                        url: AppPage.otpPage.path,
                        extra: {'type': 'password_change'});
                  } else if (accountData.label == '加油站管理') {
                    BaseRouter.push(url: AppPage.stationManagementListPage.path);
                  } else if (accountData.label == '买油订单') {
                    BaseRouter.push(url: AppPage.payOrderListPage.path);
                  } else if (accountData.label == '提油订单') {
                  } else if (accountData.label == '隐私政策') {
                  } else {}
                },
                leading: Image.asset(
                  accountData.leadingIcon,
                  height: AppSizes.setHeight(22),
                  width: AppSizes.setWidth(22),
                  color: CustomAppColor.of(context).txtGrey,
                ),
                title: CommonText(
                  text: accountData.label,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.setFontSize(15),
                  textAlign: TextAlign.start,
                ),
                trailing: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.setWidth(1)),
                  child: Image.asset(
                    AssetsIcon.IC_RIGHT_ARROW,
                    height: AppSizes.setHeight(24),
                    width: AppSizes.setWidth(24),
                  ),
                )),
          );
        },
      ),
    );
  }

  _appVersionInfo() {
    return Container(
      color: CustomAppColor.of(context).txtWhite,
      width: AppSizes.setWidth(375),
      height: AppSizes.setHeight(120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(
            text: '买油呗',
            fontWeight: FontWeight.w700,
            fontSize: AppSizes.setFontSize(24),
            textColor: CustomAppColor.of(context).txtPurple,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonText(
                text: "V1.0",
                fontWeight: FontWeight.w500,
                fontSize: AppSizes.setFontSize(15),
                textColor: CustomAppColor.of(context).txtGrey,
              ),
              SizedBox(width: AppSizes.setWidth(10)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(3)),
            width: AppSizes.setWidth(70),
            height: AppSizes.setHeight(23),
            decoration: BoxDecoration(
              color: CustomAppColor.of(context)
                  .bgContainerRed
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CommonText(
              text: '更新版本',
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.setFontSize(12),
              textColor: CustomAppColor.of(context).white,
            ),
          ),
        ],
      ),
    );
  }

  void logoutBottomSheet(BuildContext context) {
    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      maxHeightRatio: 0.4,
      context: context,
      title: '退出登录',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: CommonText(
              text: '您确定要退出登录吗？',
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w500,
              textColor: CustomAppColor.of(context).txtGrey,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSizes.setHeight(24)),
          Container(
            decoration: BoxDecoration(
              color: CustomAppColor.of(context).btnWhite,
              border: Border(
                top: BorderSide(
                  color: CustomAppColor.of(context)
                      .borderGrey
                      .withValues(alpha: 0.4),
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(6)),
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(20),
                      vertical: AppSizes.setHeight(12)),
                  child: CommonButton(
                    height: AppSizes.setHeight(44),
                    btnText: '取消',
                    onTap: () {},
                    buttonColor: CustomAppColor.of(context).btnWhite,
                    isButtonShadow: false,
                    borderColor: CustomAppColor.of(context).borderPurple,
                    radius: 3,
                    child: CommonText(
                      text: '取消',
                      textColor: CustomAppColor.of(context).txtPurple,
                      fontSize: AppSizes.setFontSize(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(20),
                      vertical: AppSizes.setHeight(6)),
                  child: CommonButton(
                      radius: 3,
                      height: AppSizes.setHeight(44),
                      btnText: '退出登录',
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void referralBottomSheet(BuildContext context) {
    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      maxHeightRatio: 0.4,
      context: context,
      title: '输入推荐码'.toUpperCase(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.setWidth(20),
                vertical: AppSizes.setHeight(10)),
            child: CommonText(
              text: '获取额外奖励',
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              textColor: CustomAppColor.of(context).txtGrey,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(20),
                  vertical: AppSizes.setHeight(16)),
              child: CommonTextFormField(
                hintText: '输入推荐码',
                radius: 8,
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(6)),
              child: const Divider()),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.setWidth(20),
                vertical: AppSizes.setHeight(6)),
            child: CommonButton(radius: 3, btnText: '提交', onTap: () {}),
          ),
        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {String value = ""}) {}
}

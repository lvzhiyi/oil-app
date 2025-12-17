import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/app_state.dart';
import 'package:oil_business_app/pages/account_security/controller.dart';
import 'package:oil_business_app/pages/account_security/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/base_appbar.dart';

class AccountSecurityScreen extends StatelessWidget {
  final AccountSecurityState state;

  const AccountSecurityScreen({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgTopBar,
      appBar: const BaseAppBar(
        title: '帐号与安全',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 手机号码显示区域（不包含换绑功能）
          Padding(
            padding: EdgeInsets.only(
              top: AppSizes.setHeight(20),
              left: AppSizes.setWidth(16),
              right: AppSizes.setWidth(16),
            ),
            child: _buildPhoneSection(context),
          ),

          // 使用 Expanded 让按钮区域固定在底部
          const Spacer(),

          // 底部按钮区域
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(BuildContext context) {
    return BlocBuilder<AppController, AppState>(
      builder: (context, appState) {
        final phone = appState.authResponse?.account?.phone ?? '';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.setWidth(16)),
          decoration: BoxDecoration(
            color: CustomAppColor.of(context).white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: '绑定手机号码',
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w400,
                textColor: CustomAppColor.of(context).txtGrey,
              ),
              SizedBox(height: AppSizes.setHeight(8)),
              CommonText(
                text: phone.isNotEmpty ? phone : '-',
                fontSize: AppSizes.setFontSize(20),
                fontWeight: FontWeight.w600,
                textColor: CustomAppColor.of(context).txtBlack,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(20),
        bottom: AppSizes.setHeight(20),
      ),
      // decoration: BoxDecoration(
      //   color: CustomAppColor.of(context).white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.05),
      //       blurRadius: 6,
      //       offset: const Offset(0, -2),
      //     ),
      //   ],
      // ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 修改密码按钮
            _buildChangePasswordButton(context),

            SizedBox(height: AppSizes.setHeight(12)),

            // 注销帐号按钮
            _buildCancelAccountButton(context),

            SizedBox(height: AppSizes.setHeight(12)),

            // 退出帐号按钮
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.setHeight(50),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () {
          context.read<AccountSecurityCtrl>().navigateToChangePassword(context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: CommonText(
          text: '修改密码',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(16),
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCancelAccountButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.setHeight(50),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () {
          context.read<AccountSecurityCtrl>().cancelAccount(context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: CommonText(
          text: '注销帐号',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(16),
          textColor: CustomAppColor.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.setHeight(50),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () {
          context.read<AccountSecurityCtrl>().logout(context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: CommonText(
          text: '退出帐号',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(16),
          textColor: CustomAppColor.of(context).primaryColor,
        ),
      ),
    );
  }
}

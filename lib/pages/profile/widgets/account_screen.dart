import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/app_state.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/app_version_util.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          CustomAppColor.of(context).bgTopBar, // Light grey background
      body: Stack(
        children: [
          // Purple Header Background
          Container(
            height: AppSizes.setHeight(220),
            width: double.infinity,
            color: CustomAppColor.of(context).btnPurple,
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height:
                        AppSizes.setHeight(60)), // Top padding for status bar

                // User Info
                _buildUserInfo(),

                SizedBox(height: AppSizes.setHeight(30)),

                // Floating Action Bar (Orders & Station)
                _buildActionBar(),

                SizedBox(height: AppSizes.setHeight(16)),

                // Menu List (Password & Privacy)
                _buildMenuCard(),

                SizedBox(height: AppSizes.setHeight(30)),

                // Logout Button
                _buildLogoutButton(),

                SizedBox(height: AppSizes.setHeight(20)),

                // Version Info
                _buildVersionInfo(),

                SizedBox(height: AppSizes.setHeight(50)), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return BlocBuilder<AppController, AppState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  AssetsIcon.IC_AVATAR,
                  height: AppSizes.setHeight(64),
                  width: AppSizes.setWidth(64),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: AppSizes.setWidth(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: state.authResponse?.account?.name ?? '-',
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  fontSize: AppSizes.setFontSize(20),
                ),
                SizedBox(height: AppSizes.setHeight(4)),
                CommonText(
                  text: _maskPhone(state.authResponse?.account?.phone),
                  fontWeight: FontWeight.w400,
                  textColor: Colors.white,
                  fontSize: AppSizes.setFontSize(14),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  String _maskPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    final normalized = phone.replaceAll(RegExp(r'\s+'), '');
    if (normalized.length < 8) return normalized;
    final head = normalized.substring(0, 3);
    final tail = normalized.substring(normalized.length - 4);
    return '$head****$tail';
  }

  Widget _buildActionBar() {
    final Color primary = CustomAppColor.of(context).primaryColor;
    final Color iconBg = primary.withValues(alpha: 0.1);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
      padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionItem(
            icon: AssetsIcon.IC_BUY,
            label: '买油订单',
            iconColor: primary,
            bgIconColor: iconBg,
            onTap: () => BaseRouter.push(url: AppPage.payOrderListPage.path),
          ),
          _buildVerticalDivider(),
          _buildActionItem(
            icon: AssetsIcon.IC_BAG,
            label: '提油订单',
            iconColor: primary,
            bgIconColor: iconBg,
            onTap: () => BaseRouter.push(url: AppPage.pickupListPage.path),
          ),
          _buildVerticalDivider(),
          _buildActionItem(
            icon: AssetsIcon.IC_CATEGORY,
            label: '加油站管理',
            iconColor: primary,
            bgIconColor: iconBg,
            onTap: () =>
                BaseRouter.push(url: AppPage.stationManagementListPage.path),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String icon,
    required String label,
    required Color iconColor,
    required Color bgIconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.setWidth(10)),
            decoration: BoxDecoration(
              color: bgIconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              icon,
              height: AppSizes.setHeight(24),
              width: AppSizes.setWidth(24),
              color: iconColor,
            ),
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          CommonText(
            text: label,
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.setFontSize(13),
            textColor: CustomAppColor.of(context).txtBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: AppSizes.setHeight(30),
      width: 1,
      color: CustomAppColor.of(context).dividerGrey,
    );
  }

  Widget _buildMenuCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: AssetsIcon.IC_PASSWORD,
            label: '修改密码',
            onTap: () => BaseRouter.push(url: AppPage.changePasswordPage.path),
          ),
          Divider(
              height: 1,
              color: CustomAppColor.of(context).dividerGrey.withValues(alpha: 0.5),
              indent: 50,
              endIndent: 16),
          _buildMenuItem(
            icon: AssetsIcon
                .IC_RATE, // Using IC_RATE as placeholder for Privacy Policy if specific icon missing
            label: '隐私政策',
            onTap: () => BaseRouter.push(url: AppPage.privacyPolicyPage.path),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.setWidth(16), vertical: AppSizes.setHeight(4)),
      leading: Image.asset(
        icon,
        height: AppSizes.setHeight(22),
        width: AppSizes.setWidth(22),
        color: CustomAppColor.of(context).txtBlack, // Darker icon color
      ),
      title: CommonText(
        text: label,
        fontWeight: FontWeight.w500,
        fontSize: AppSizes.setFontSize(15),
        textAlign: TextAlign.start,
        textColor: CustomAppColor.of(context).txtBlack,
      ),
      trailing: Image.asset(
        AssetsIcon.IC_RIGHT_ARROW,
        height: AppSizes.setHeight(16),
        width: AppSizes.setWidth(16),
        color: CustomAppColor.of(context).txtGrey,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
      width: double.infinity,
      height: AppSizes.setHeight(50),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () => logoutBottomSheet(context),
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: CommonText(
          text: '退出登录',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(16),
          textColor: CustomAppColor.of(context).txtGrey,
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        CommonText(
          text: '买油呗',
          fontWeight: FontWeight.w700,
          fontSize: AppSizes.setFontSize(18),
          textColor: CustomAppColor.of(context).btnPurple,
        ),
        SizedBox(height: AppSizes.setHeight(4)),
        CommonText(
          text: AppVersionUtil.appVersionText,
          fontWeight: FontWeight.w400,
          fontSize: AppSizes.setFontSize(12),
          textColor: CustomAppColor.of(context).txtGrey,
        ),
        if (AppVersionUtil.hasNewVersionUpdate() == true) ...[
          SizedBox(height: AppSizes.setHeight(8)),
          GestureDetector(
            onTap: () => AppVersionUtil.showUpdateDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(12),
                  vertical: AppSizes.setHeight(4)),
              decoration: BoxDecoration(
                color: CustomAppColor.of(context).bgContainerRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CommonText(
                text: '更新版本',
                fontWeight: FontWeight.w600,
                fontSize: AppSizes.setFontSize(11),
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void logoutBottomSheet(BuildContext context) {

    SportsDialog.show(
      title: '退出登录',
      bodyText: '确定要退出登录吗？退出后将返回登录页面。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          BaseConfig.appContext?.read<AppController>().logout();
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void onTopBarClick(String name, {String value = ""}) {}
}

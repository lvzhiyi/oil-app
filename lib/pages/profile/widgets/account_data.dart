import 'package:oil_business_app/static/icon.dart';

class AccountData {
  final String leadingIcon;
  final String label;
  final bool? isSuffixIcon;
  final bool? isNavigate;

  AccountData({
    required this.leadingIcon,
    required this.label,
    this.isSuffixIcon,
    this.isNavigate,
  });
}

List<AccountData> accountList = [
  AccountData(
    leadingIcon: AssetsIcon.IC_PASSWORD,
    label: '修改密码',
    isSuffixIcon: true,
  ),
  AccountData(
      leadingIcon: AssetsIcon.IC_CATEGORY, label: '加油站管理', isSuffixIcon: true),
  AccountData(
      leadingIcon: AssetsIcon.IC_BUY, label: '买油订单', isSuffixIcon: true),
  AccountData(
      leadingIcon: AssetsIcon.IC_BAG, label: '提油订单', isSuffixIcon: true),
  AccountData(leadingIcon: AssetsIcon.IC_RATE, label: '隐私政策', isNavigate: true),
  AccountData(
      leadingIcon: AssetsIcon.IC_LOGOUT, label: '退出登录', isNavigate: true),
];

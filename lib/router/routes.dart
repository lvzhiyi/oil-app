import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/pages/login/changePw/page.dart';
import 'package:oil_business_app/pages/splase/page.dart';
import 'package:oil_business_app/pages/login/page.dart';
import 'package:oil_business_app/pages/login/register/page.dart';

import 'package:oil_business_app/pages/profile/page.dart';
import 'package:oil_business_app/pages/main_layout/page.dart';
import 'package:oil_business_app/router/pageTransition/bottom_to_top_page.dart';
import 'package:oil_business_app/router/router.dart';

enum AppPage {
  /// 启动页
  splasePage("/splase"),

  /// 登录
  loginPage("/login"),

  /// 注册
  registerPage("/register"),

  /// 主布局页面 (包含TabBar)
  mainLayoutPage('/'),

  /// 设置页面
  setting("/setting"),

  /// 个人中心
  my('/my'),

  /// 用户信息页
  basicInfo('/basicInfo'),

  /// 仪表盘
  dashboardPage('/dashboard'),

  /// 个人中心
  profilePage('/profile'),

  /// 员工管理
  employeeManagementPage('/employeeManagement'),

  /// 赠送彩票
  giftLotteryPage('/giftLottery'),

  /// 赠送彩票二维码静态
  giftLotteryQrStaticPage('/giftLotteryQrStatic'),

  /// 赠送彩票二维码动态
  giftLotteryQrDynamicPage('/giftLotteryQrDynamic'),

  /// 赠送记录
  giftRecordsPage('/giftRecords'),

  /// 统一支付页面
  unifiedPaymentPage('/unifiedPayment'),

  payOrderDetailPage('/payOrderDetail/:uuid'),

  /// 修改密码（个人中心）
  changePasswordPage('/changePassword'),
  ;

  const AppPage(this.path);

  final String path;

  static final routes = AppPage.values
      .map((page) => BaseRoute(
            path: page.path,
            builder: page.builder,
            pageBuilder: page.pageBuilder,
          ))
      .toList();
}

extension PageRoute on AppPage {
  GoRouterWidgetBuilder get builder {
    switch (this) {
      case AppPage.splasePage:
        return (context, state) => const SplasePage();

      case AppPage.loginPage:
        return (context, state) => const LoginPage();

      case AppPage.registerPage:
        return (context, state) => const RegisterPage();

      case AppPage.changePasswordPage:
        return (context, state) => const ChangePwPage();

      case AppPage.mainLayoutPage:
        return (context, state) => const MainLayoutPage();

      case AppPage.profilePage:
        return (context, state) => const ProfilePage();

      default:
        return (context, state) => const Text('404');
    }
  }

  GoRouterPageBuilder? get pageBuilder {
    if (this == AppPage.loginPage) {
      return (context, state) => bottomToTopPageTransition(
          context: context, state: state, child: const LoginPage());
    }

    if (this == AppPage.registerPage) {
      return (context, state) => bottomToTopPageTransition(
          context: context, state: state, child: const RegisterPage());
    }

    return null;
  }
}

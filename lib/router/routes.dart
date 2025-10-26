import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/page.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/page.dart';
import 'package:lottery_app/pages/pay_order_detail/page.dart';
import 'package:lottery_app/pages/splase/page.dart';
import 'package:lottery_app/pages/login/page.dart';
import 'package:lottery_app/pages/dashboard/page.dart';

import 'package:lottery_app/pages/unified_payment/page.dart';
import 'package:lottery_app/pages/profile/page.dart';
import 'package:lottery_app/pages/profile/change_password/page.dart';
import 'package:lottery_app/pages/employee_management/page.dart';
import 'package:lottery_app/pages/gift_lottery/page.dart';
import 'package:lottery_app/pages/gift_records/page.dart';
import 'package:lottery_app/pages/main_layout/page.dart';
import 'package:lottery_app/router/pageTransition/bottom_to_top_page.dart';
import 'package:lottery_app/router/router.dart';

enum AppPage {
  /// 启动页
  splasePage("/splase"),

  /// 登录
  loginPage("/login"),

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

      case AppPage.mainLayoutPage:
        return (context, state) => const MainLayoutPage();

      case AppPage.dashboardPage:
        return (context, state) => const DashboardPage();

      case AppPage.profilePage:
        return (context, state) => const ProfilePage();

      case AppPage.employeeManagementPage:
        return (context, state) => const EmployeeManagementPage();

      case AppPage.giftLotteryPage:
        return (context, state) => const GiftLotteryPage();

      case AppPage.giftLotteryQrStaticPage:
        return (context, state) => const GiftLotteryQrStaticPage();

      case AppPage.giftLotteryQrDynamicPage:
        return (context, state) => const GiftLotteryQrDynamicPage();

      case AppPage.giftRecordsPage:
        return (context, state) => const GiftRecordsPage();

      case AppPage.unifiedPaymentPage:
        return (context, state) => const UnifiedPaymentPage();

      case AppPage.changePasswordPage:
        return (context, state) => const ProfileChangePasswordPage();

      case AppPage.payOrderDetailPage:
        return (context, state) => PayOrderDetailPage(
              uuid: state.extra as String,
            );

      default:
        return (context, state) => const Text('404');
    }
  }

  GoRouterPageBuilder? get pageBuilder {
    if (this == AppPage.loginPage) {
      return (context, state) => bottomToTopPageTransition(
          context: context, state: state, child: const LoginPage());
    }

    return null;
  }
}

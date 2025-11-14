import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/pages/bind_station/page.dart';
import 'package:oil_business_app/pages/otp/page.dart';
import 'package:oil_business_app/pages/otp/widgets/otp_verification_screen.dart';
import 'package:oil_business_app/pages/pay_order_detail/page.dart';
import 'package:oil_business_app/pages/pending_review/pending_review_screen.dart';
import 'package:oil_business_app/pages/splase/page.dart';
import 'package:oil_business_app/pages/login/page.dart';
import 'package:oil_business_app/pages/register/page.dart';

import 'package:oil_business_app/pages/profile/page.dart';
import 'package:oil_business_app/pages/main_layout/page.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/page.dart';
import 'package:oil_business_app/router/pageTransition/bottom_to_top_page.dart';
import 'package:oil_business_app/router/router.dart';

enum AppPage {
  /// 审核中
  pendingReviewPage("/pendingReview"),

  /// 绑定加油站
  bindStationPage("/bindStation"),

  /// 启动页
  splasePage("/splase"),

  /// 登录
  loginPage("/login"),

  /// 验证码登录
  otpPage("/otp"),

  /// 验证码登录
  otpVerificationPage("/otpVerification"),

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

  /// 统一支付页面
  unifiedPaymentPage('/unifiedPayment'),

  /// 修改密码（个人中心）
  changePasswordPage('/changePassword'),

  /// 买油详情页面
  oilPurchaseDetailPage('/oilPurchaseDetail'),

  /// 支付订单详情页面
  payOrderDetailPage('/payOrderDetail'),
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
      case AppPage.pendingReviewPage:
        return (context, state) => const PendingReviewScreen();

      case AppPage.bindStationPage:
        return (context, state) =>
            BindStationPage(extra: state.extra as Map<String, dynamic>? ?? {});

      case AppPage.splasePage:
        return (context, state) => const SplasePage();

      case AppPage.loginPage:
        return (context, state) => const LoginPage();

      case AppPage.otpPage:
        return (context, state) =>
            OtpPage(extra: state.extra as Map<String, dynamic>? ?? {});

      case AppPage.otpVerificationPage:
        return (context, state) => OtpVerificationScreen(
            extra: state.extra as Map<String, dynamic>? ?? {});

      case AppPage.registerPage:
        return (context, state) {
          print('registerPage state: ${state.extra}');
          return RegisterPage(
              extra: state.extra as Map<String, dynamic>? ?? {});
        };

      case AppPage.changePasswordPage:
        return (context, state) => const Text('Change Password');

      case AppPage.mainLayoutPage:
        return (context, state) => const MainLayoutPage();

      case AppPage.profilePage:
        return (context, state) => const ProfilePage();

      case AppPage.oilPurchaseDetailPage:
        return (context, state) => OilPurchaseDetailPage(
              extra: state.extra as Map<String, dynamic>? ?? {},
            );

      case AppPage.payOrderDetailPage:
        return (context, state) =>
            PayOrderDetailPage(uuid: state.extra as String? ?? '');

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

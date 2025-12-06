import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/pages/bind_station/page.dart';
import 'package:oil_business_app/pages/otp/page.dart';
import 'package:oil_business_app/pages/otp/widgets/otp_verification_screen.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/page.dart';
import 'package:oil_business_app/pages/oil_pickup_success/page.dart';
import 'package:oil_business_app/pages/pay_order_detail/page.dart';
import 'package:oil_business_app/pages/pay_order_list/page.dart';
import 'package:oil_business_app/pages/pending_review/pending_review_screen.dart';
import 'package:oil_business_app/pages/pickup_order_list/page.dart';
import 'package:oil_business_app/pages/pickup_order_detail/page.dart';
import 'package:oil_business_app/pages/splase/page.dart';
import 'package:oil_business_app/pages/login/page.dart';
import 'package:oil_business_app/pages/register/page.dart';
import 'package:oil_business_app/pages/change_password/page.dart';
import 'package:oil_business_app/pages/privacy_feedback/page.dart';
import 'package:oil_business_app/pages/service_agreement/page.dart';
import 'package:oil_business_app/pages/forgot_password/page.dart';

import 'package:oil_business_app/pages/profile/page.dart';
import 'package:oil_business_app/pages/main_layout/page.dart';
import 'package:oil_business_app/pages/oil_pickup/page.dart';
import 'package:oil_business_app/pages/station_list/page.dart';
import 'package:oil_business_app/pages/station_edit/page.dart';
import 'package:oil_business_app/pages/station_management_list/page.dart';
import 'package:oil_business_app/pages/invoice_edit/page.dart';
import 'package:oil_business_app/pages/main_oil_pay/oil_purchase_detail/page.dart';
import 'package:oil_business_app/router/pageTransition/bottom_to_top_page.dart';
import 'package:oil_business_app/router/router.dart';

enum AppPage {
  /// 支付订单列表
  payOrderListPage("/payOrderList"),

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

  /// 个人中心
  profilePage('/profile'),

  /// 员工管理
  employeeManagementPage('/employeeManagement'),

  /// 修改密码（个人中心）
  changePasswordPage('/changePassword'),

  /// 提油页面
  oilPickupPage('/oilPickup'),

  /// 提油列表页面
  pickupListPage('/pickupList'),

  /// 加油站列表页面
  stationListPage('/stationList'),

  /// 加油站编辑页面
  stationEditPage('/stationEdit'),

  /// 加油站管理列表页面
  stationManagementListPage('/stationManagementList'),

  /// 买油详情页面
  oilPurchaseDetailPage('/oilPurchaseDetail'),

  /// 支付订单详情页面
  payOrderDetailPage('/payOrderDetail'),

  /// 提油详情页面
  oilPickupDetailPage('/oilPickupDetail'),

  /// 提油成功页面
  oilPickupSuccessPage('/oilPickupSuccess'),

  /// 提油订单详情页面
  pickupOrderDetailPage('/pickupOrderDetail'),

  /// 隐私政策
  privacyPolicyPage('/privacyPolicy'),

  /// 用户协议
  serviceAgreementPage('/serviceAgreement'),

  /// 发票编辑页面
  invoiceEditPage('/invoiceEdit'),

  /// 找回密码页面
  forgotPasswordPage('/forgotPassword'),
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
      case AppPage.payOrderListPage:
        return (context, state) => const PayOrderListPage();

      case AppPage.pendingReviewPage:
        return (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final station = extra['station'] as Station?;
          return PendingReviewScreen(station: station);
        };

      case AppPage.bindStationPage:
        return (context, state) =>
            BindStationPage(extra: state.extra as Map<String, dynamic>? ?? {});

      case AppPage.splasePage:
        return (context, state) => const SplasePage();

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
        return (context, state) => ChangePasswordPage(
              extra: state.extra as Map<String, dynamic>? ?? {},
            );

      case AppPage.mainLayoutPage:
        return (context, state) => const MainLayoutPage();

      case AppPage.profilePage:
        return (context, state) => const ProfilePage();

      case AppPage.oilPickupPage:
        return (context, state) => const OilPickupPage();

      case AppPage.pickupListPage:
        return (context, state) => const PickupOrderListPage();

      case AppPage.stationListPage:
        return (context, state) => StationListPage();

      case AppPage.stationEditPage:
        return (context, state) => const StationEditPage();

      case AppPage.stationManagementListPage:
        return (context, state) => const StationManagementListPage();

      case AppPage.oilPurchaseDetailPage:
        return (context, state) => OilPurchaseDetailPage(
              extra: state.extra as Map<String, dynamic>? ?? {},
            );

      case AppPage.payOrderDetailPage:
        return (context, state) => PayOrderDetailPage(
            extra: state.extra as Map<String, dynamic>? ?? {});

      case AppPage.oilPickupDetailPage:
        return (context, state) =>
            OilPickupDetailPage(inventory: state.extra as InventoryModel);

      case AppPage.oilPickupSuccessPage:
        return (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OilPickupSuccessPage(
            response: extra['response'] as WithdrawResponse,
            inventory: extra['inventory'] as InventoryModel,
            station: extra['station'] as Station,
            oilAmount: extra['oilAmount'] as String,
            vehicleModel: extra['vehicleModel'] as VehicleModel,
            dispatchInfo: extra['dispatchInfo'] as String? ?? '',
          );
        };

      case AppPage.pickupOrderDetailPage:
        return (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final withdrawId = extra['withdrawId'] as int?;
          if (withdrawId == null) {
            return const Text('参数缺失：withdrawId');
          }
          return PickupOrderDetailPage(withdrawId: withdrawId);
        };

      case AppPage.privacyPolicyPage:
        return (context, state) => const PrivacyFeedbackPage();

      case AppPage.serviceAgreementPage:
        return (context, state) => const ServiceAgreementPage();

      case AppPage.invoiceEditPage:
        return (context, state) => const InvoiceEditPage();

      case AppPage.forgotPasswordPage:
        return (context, state) => const ForgotPasswordPage();

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

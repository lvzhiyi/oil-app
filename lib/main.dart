import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/storage.dart';
import 'package:oil_business_app/sports_run.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/widgets/popup/popup.dart';

void main() {
  oilAppFlutterRun(() async {
    BaseRouter.registerRoutes(AppPage.routes);

    BaseRouter.init(
      initialLocation: AppPage.mainLayoutPage.path,
      observers: [SportsPopup.observer],
      redirect: (context, state) {
        final isLoggedIn = appController.state.authResponse?.accessToken != null;
        final isLoginPage = state.matchedLocation == AppPage.loginPage.path;
        final isRegisterPage = state.matchedLocation == AppPage.registerPage.path;
        final isOtpPage = state.matchedLocation == AppPage.otpPage.path;
        final isOtpVerificationPage = state.matchedLocation == AppPage.otpVerificationPage.path;
        final isForgotPasswordPage = state.matchedLocation == AppPage.forgotPasswordPage.path;
        final isPrivacyPolicyPage = state.matchedLocation == AppPage.privacyPolicyPage.path;
        final isServiceAgreementPage = state.matchedLocation == AppPage.serviceAgreementPage.path;

        // 允许访问的公开页面
        final isPublicPage = isLoginPage ||
            isRegisterPage ||
            isOtpPage ||
            isOtpVerificationPage ||
            isForgotPasswordPage ||
            isPrivacyPolicyPage ||
            isServiceAgreementPage;

        // 未登录且不在公开页面，重定向到登录页
        if (!isLoggedIn && !isPublicPage) {
          return AppPage.loginPage.path;
        }

        return null;
      },
    );

    await GlobalStorage.init();

    await BaseConfig.share.init();
  });
}

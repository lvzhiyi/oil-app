import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/pages/login/widgets/action_links.dart';
import 'package:oil_business_app/router/router.dart';

void main() {
  for (final entry in {
    '立即注册': '/register',
    '忘记密码?': '/forgotPassword',
  }.entries) {
    testWidgets('${entry.key} opens its page and allows returning to login',
        (tester) async {
      BaseRouter.observer = NavigatorObserver();
      final router = GoRouter(
        navigatorKey: BaseConfig.navigatorKey,
        initialLocation: '/login',
        observers: [BaseRouter.observer],
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, __) => const Scaffold(body: ActionLinks()),
          ),
          for (final path in ['/register', '/forgotPassword'])
            GoRoute(
              path: path,
              builder: (_, __) => Scaffold(body: Text('Destination: $path')),
            ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp.router(routerConfig: router),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      expect(find.text('Destination: ${entry.value}'), findsOneWidget);
      expect(router.canPop(), isTrue);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.byType(ActionLinks), findsOneWidget);
      expect(router.canPop(), isFalse);
    });
  }
}

import 'package:go_router/go_router.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/storage.dart';
import 'package:lottery_app/sports_run.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/employee_routes.dart';
import 'package:lottery_app/widgets/popup/popup.dart';

void main() {
  sportsFlutterRun(() async {
    BaseRouter.registerRoutes(AppPage.routes);
    for (var route in employeeRoutes) {
      if (route is GoRoute) {
        BaseRouter.registerRoutes([
          BaseRoute(
            path: route.path,
            name: route.name,
            builder: route.builder,
          )
        ]);
      }
    }
    BaseRouter.init(
      initialLocation: AppPage.splasePage.path,
      observers: [SportsPopup.observer],
    );

    await GlobalStorage.init();

    await BaseConfig.share.init();
  });
}

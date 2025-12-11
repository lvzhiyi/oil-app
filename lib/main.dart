import 'package:oil_business_app/config/config.dart';
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
    );

    await GlobalStorage.init();

    await BaseConfig.share.init();
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';

import 'package:oil_business_app/pages/splase/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class SplaseCtrl extends Cubit<SplaseState> {
  SplaseCtrl() : super(SplaseState(percent: 0)) {
    _initStateDelayed();
  }

  /// 延迟初始化，避免在构建过程中调用路由跳转
  _initStateDelayed() {
    Future.microtask(() => initState());
  }

  initState() async {
    try {
      final appController = BaseConfig.appContext?.read<AppController>();
      final authResponse = appController?.state.authResponse;
      if (authResponse == null) {
        BaseRouter.replace(url: AppPage.loginPage.path);
      } else {
        // BaseRouter.replace(url: AppPage.mainLayoutPage.path);

        appController?.bindStationProcess();
      }
    } catch (e) {
      l.e('SplaseCtrl', '启动页初始化失败: $e');
      BaseRouter.replace(url: AppPage.loginPage.path);
    }
  }
}

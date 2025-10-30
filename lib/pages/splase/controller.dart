import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oil_business_app/pages/splase/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/token_manager.dart';

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
      // await AppVersionUtil.checkVersionShowDialog();

      /// 替换当前页面跳转到登录页，避免返回时显示启动页
      final currentUserToken = TokenManager.instance.getAccessToken();
      if (currentUserToken == null) {
        BaseRouter.replace(url: AppPage.loginPage.path);
      } else {
        BaseRouter.replace(url: AppPage.mainLayoutPage.path);
      }
    } catch (e) {
      l.e('SplaseCtrl', '启动页初始化失败: $e');
      BaseRouter.replace(url: AppPage.loginPage.path);
    }
  }
}

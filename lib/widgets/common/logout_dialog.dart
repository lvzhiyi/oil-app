import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';

/// 退出登录弹窗
showLogoutDialog() async {
  try {
    await SportsDialog.dismiss();
    await SportsDialog.show(
      showClose: false,
      title: '登录已过期',
      bodyText: '您的登录已过期，请重新登录',
      onOk: () async {
        try {
          await SportsDialog.dismiss();
          // 使用Future.microtask避免阻塞
          Future.microtask(() {
            BaseRouter.push(url: AppPage.loginPage.path);
          });
        } catch (e) {
          print('Navigation error: $e');
        }
      },
      onCancel: () async {
        try {
          await SportsDialog.dismiss();
        } catch (e) {
          print('Dialog dismiss error: $e');
        }
      },
    );
  } catch (e) {
    print('showLogoutDialog error: $e');
  }
}

/// 用户被加入黑名单弹窗
showBlackLogoutDialog() {
  SportsDialog.show(
    showClose: false,
    title: '登录已过期',
    bodyText:
        'You are on PAGCOR\'S list of restricted,that are not allowed on sports betting',
    onOk: () {
      SportsDialog.dismiss();
      BaseRouter.pop();
    },
  );
}

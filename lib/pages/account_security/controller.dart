import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/pages/account_security/state.dart';
import 'package:oil_business_app/pages/profile/service/profile_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

class AccountSecurityCtrl extends Cubit<AccountSecurityState> {
  AccountSecurityCtrl() : super(AccountSecurityState());

  /// 退出登录
  Future<void> logout(BuildContext context) async {
    SportsDialog.show(
      title: '退出登录',
      bodyText: '确定要退出登录吗？退出后将返回登录页面。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          BaseConfig.appContext?.read<AppController>().logout();
          Navigator.pop(context);
        }
      },
    );
  }

  /// 注销账号
  Future<void> cancelAccount(BuildContext context) async {
    SportsDialog.show(
      title: '注销帐号',
      bodyText: '确定要注销帐号吗？注销后将无法恢复，请谨慎操作。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          await _performCancelAccount(context);
        }
      },
    );
  }

  Future<void> _performCancelAccount(BuildContext context) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      await profileService.cancelAccount();
      l.d('AccountSecurity', '注销账号成功');

      // 注销成功后退出登录
      if (context.mounted) {
        BaseConfig.appContext?.read<AppController>().logout();
      }
    } catch (e) {
      l.e('AccountSecurity', '注销账号失败: $e');
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));

      if (context.mounted) {
        SportsDialog.show(
          title: '注销失败',
          bodyText: '注销账号失败，请稍后重试。',
          onCancel: () {},
          onOk: () async {
            await SportsDialog.dismiss();
          },
        );
      }
    }
  }

  /// 跳转到修改密码页面
  void navigateToChangePassword(BuildContext context) {
    BaseRouter.push(url: AppPage.changePasswordPage.path);
  }
}


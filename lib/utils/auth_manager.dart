import 'package:lottery_app/global/model/auth_type.dart';
import 'package:lottery_app/global/service/auth_service.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/utils/token_manager.dart';
import 'package:lottery_app/utils/log.dart';

/// 认证管理器
///
/// 集成安全监控和双token管理
class AuthManager {
  static AuthManager? _instance;
  static AuthManager get instance => _instance ??= AuthManager._();

  AuthManager._();

  /// 退出登录
  Future<bool> logout() async {
    try {
      // 调用退出登录接口
      await authService.logout();

      // 清除本地认证信息
      await TokenManager.instance.clearAuth();

      BaseRouter.replace(url: AppPage.loginPage.path);

      l.d('AuthManager', '退出登录成功');
      return true;
    } catch (e) {
      l.e('AuthManager', '退出登录失败: $e');

      // 即使接口调用失败，也清除本地认证信息
      await TokenManager.instance.clearAuth();
      return true;
    }
  }

  /// 刷新token
  ///
  /// 使用refresh_token获取新的access_token和refresh_token
  /// 实现refresh token轮换和重用检测
  /// 请求参数格式：{"refresh_token": "..."}
  Future<bool> refreshToken() async {
    try {
      final refreshToken = TokenManager.instance.getRefreshToken();
      if (refreshToken == null) {
        l.e('AuthManager', '没有refresh token');
        return false;
      }

      // 检查refresh token是否已被使用（重用检测）
      // if (TokenManager.instance.isRefreshTokenUsed()) {
      //   l.w('AuthManager', '检测到refresh token重用，可能存在安全风险');

      //   // 清除所有认证信息并强制重新登录
      //   await TokenManager.instance.clearAuth();
      //   return false;
      // }

      // 检测异常refresh行为
      if (TokenManager.instance.detectAbnormalRefreshBehavior()) {
        l.w('AuthManager', '检测到异常refresh行为，暂停刷新');

        return false;
      }

      // 标记当前refresh token为已使用
      await TokenManager.instance.markRefreshTokenAsUsed();

      // 调用刷新token接口，使用正确的参数格式
      final refreshRequest = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await authService.refreshToken(refreshRequest);

      if (response.code == 200 || response.code == 0) {
        // 保存新的双token（会自动重置使用状态）
        if (response.data?.accessToken != null) {
          await TokenManager.instance
              .saveAccessToken(response.data!.accessToken!);
        }
        if (response.data?.refreshToken != null) {
          await TokenManager.instance
              .saveRefreshToken(response.data!.refreshToken!);
        }

        l.d('AuthManager', 'Token刷新成功');

        // 不需要额外记录，SecurityMonitor内部会处理

        return true;
      } else {
        l.e('AuthManager', 'Token刷新失败: ${response.message}');

        // 如果服务器返回刷新失败，可能是refresh token已过期或无效
        // 清除本地认证信息
        await TokenManager.instance.clearAuth();
        return false;
      }
    } catch (e) {
      l.e('AuthManager', 'Token刷新异常: $e');

      // 异常情况下也清除认证信息，防止使用无效token
      await TokenManager.instance.clearAuth();
      return false;
    }
  }

  /// 检查登录状态
  bool isLoggedIn() {
    return TokenManager.instance.isLoggedIn();
  }
}

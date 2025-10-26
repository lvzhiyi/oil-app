import 'package:dio/dio.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/models/device_info.dart';
import 'package:lottery_app/net/base_interceptor.dart';
import 'package:lottery_app/utils/token_manager.dart';

/// 请求header拦截器
/// 主要是为每个请求添加header
class HttpHeaderInterceptor extends BaseInterceptor {
  final dynamic deviceInfo;

  HttpHeaderInterceptor({this.deviceInfo})
      : super(tag: 'HttpHeaderInterceptor');

  @override
  onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 登录接口不需要携带以下三个header
    final bool isLoginApi =
        options.path == '/auths/login' || options.path.endsWith('auths/login');
    // 获取认证信息
    var _accessToken = TokenManager.instance.getAccessToken();
    var _refreshToken = TokenManager.instance.getRefreshToken();
    var _tenantUuid = TokenManager.instance.getTenantUuid();

    DeviceInfo _deviceDetail = deviceInfo ?? BaseConfig.share.deviceInfo;

    if (options.method == "GET") {
      options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    } else if (options.method == "POST") {
      options.headers["Content-Type"] = "application/json;charset=UTF-8";
    }

    // 登录页不需要传这几个header
    if (!isLoginApi) {
      if (_accessToken != null && _accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $_accessToken';
      }
      if (_tenantUuid != null && _tenantUuid.isNotEmpty) {
        options.headers['x-tenant-id'] = _tenantUuid;
      }
      if (_refreshToken != null && _refreshToken.isNotEmpty) {
        options.headers['x-refresh-token'] = _refreshToken;
      }
    }

    // 设备信息headers
    options.headers["UserAgent-deviceName"] =
        Uri.encodeComponent(_deviceDetail.name ?? '');
    options.headers["UserAgent-systemName"] = _deviceDetail.systemName;
    options.headers["UserAgent-systemVersion"] = _deviceDetail.systemVersion;
    options.headers["UserAgent-deviceId"] = _deviceDetail.identifierForVendor;
    options.headers["UserAgent-appVersion"] = BaseConfig.appVersion;
    options.headers["UserAgent-appType"] = 'App';

    return handler.next(options);
  }
}

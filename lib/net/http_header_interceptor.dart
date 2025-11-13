import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/models/global.dart';
import 'package:oil_business_app/net/base_interceptor.dart';

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
    final authResponse =
        BaseConfig.appContext?.read<AppController>().state.authResponse;
    // 获取认证信息
    final _accessToken = authResponse?.accessToken;
    print('authResponse: $_accessToken');
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

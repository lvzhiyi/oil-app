import 'package:dio/dio.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/net/response.dart';
import 'package:oil_business_app/net/http_log_interceptor.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'package:oil_business_app/utils/auth_manager.dart';
import 'package:oil_business_app/utils/token_manager.dart';
import 'dart:async';

/// 响应拦截器=>返回数据转换
class HttpRespInterceptor extends InterceptorsWrapper {
  /// 用于控制并发刷新，确保同时只有一个刷新请求
  static Completer<bool>? _refreshCompleter;

  HttpRespInterceptor() : super();

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    BaseResponse res = BaseResponse.fromJson(response.data);
    if (res.code == HttpCode.success) {
      return handler.next(
        Response(
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          data: response.data, // 传递完整的响应数据，而不是只传递data字段
        ),
      );
    }

    l.e(
      "业务请求错误：",
      '\n path:${response.requestOptions.path} \n code:${response.data['code']} \n message:${response.data['message']} \n requestId:${response.data['requestId']} ',
    );

    /// 默认弹出错误提示，当noShowToast为true时，不弹出错误提示
    if (response.requestOptions.extra['noShowToast'] != true) {
      SportsToast.showWarning(res.message ?? '服务器出错了');
    }

    return handler.reject(DioException.badResponse(
      statusCode: response.statusCode ?? -1,
      requestOptions: response.requestOptions,
      response: response,
    ));
  }

  @override
  onError(err, ErrorInterceptorHandler handler) async {
    // 检查是否是401错误，如果是则尝试token刷新
    if ([401, 403].contains(err.response?.statusCode)) {
      l.i('HttpRespInterceptor', '检测到401错误，尝试token刷新');

      final refreshResult = await _handleTokenExpiry(err.requestOptions);
      if (refreshResult) {
        // 刷新成功，重试原始请求
        try {
          return _retryOriginalRequestFromError(err.requestOptions, handler);
        } catch (retryError) {
          l.e('HttpRespInterceptor', '重试请求失败: $retryError');
          _handleForceLogoutFromError(handler, err);
          return handler.reject(err);
        }
      } else {
        // 刷新失败，强制登出
        return _handleForceLogoutFromError(handler, err);
      }
    }

    if (err.response?.data['message'] != null) {
      SportsToast.showWarning(err.response?.data['message']);
    } else {
      SportsToast.showWarning('网络错误');
    }

    return handler.reject(err);
  }

  /// 处理token过期，实现并发控制的自动刷新
  Future<bool> _handleTokenExpiry(RequestOptions originalOptions) async {
    // 检查是否是刷新token的接口，避免循环刷新
    if (originalOptions.path.contains('/auths/refresh')) {
      l.w('HttpRespInterceptor', '刷新token接口本身返回401，停止重试');
      return false;
    }

    // 检查是否是重试请求，避免对重试请求再次刷新token
    if (originalOptions.extra['isRetryRequest'] == true) {
      l.w('HttpRespInterceptor', '重试请求返回401，停止再次刷新');
      return false;
    }

    // 并发控制：如果已经有刷新在进行，等待结果
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      l.d('HttpRespInterceptor', '等待正在进行的token刷新');
      return await _refreshCompleter!.future;
    }

    // 创建新的刷新任务
    _refreshCompleter = Completer<bool>();

    try {
      l.d('HttpRespInterceptor', '开始刷新token');
      final refreshResult = await AuthManager.instance.refreshToken();

      if (refreshResult) {
        l.d('HttpRespInterceptor', 'Token刷新成功');
        _refreshCompleter!.complete(true);
        return true;
      } else {
        l.e('HttpRespInterceptor', 'Token刷新失败');
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      l.e('HttpRespInterceptor', 'Token刷新异常: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      // 清理completer，允许新的刷新请求
      _refreshCompleter = null;
    }
  }

  /// 重试原始请求 (用于ErrorInterceptorHandler)
  Future<void> _retryOriginalRequestFromError(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      l.d('HttpRespInterceptor', '从错误处理器重试原始请求: ${options.path}');

      // 更新请求头中的token和tenant ID，保持与Header拦截器一致的格式
      final newAccessToken = TokenManager.instance.getAccessToken();
      final tenantUuid = TokenManager.instance.getTenantUuid();
      final refreshToken = TokenManager.instance.getRefreshToken();

      if (newAccessToken != null) {
        options.headers['Authorization'] = 'Bearer $newAccessToken';
      }
      if (tenantUuid != null && tenantUuid.isNotEmpty) {
        options.headers['x-tenant-id'] = tenantUuid;
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        options.headers['x-refresh-token'] = refreshToken;
      }

      // 标记这是重试请求，避免再次进入token刷新逻辑
      options.extra['isRetryRequest'] = true;

      // 创建新的Dio实例并添加必要的拦截器（但不包括响应拦截器避免循环）
      final retryDio = Dio(BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        sendTimeout: const Duration(milliseconds: 30000),
      ));

      // 只添加日志拦截器，不添加响应拦截器避免循环
      retryDio.interceptors.add(HttpLogInterceptor());

      final retryResponse = await retryDio.fetch(options);
      return handler.resolve(retryResponse);
    } catch (e) {
      l.e('HttpRespInterceptor', '重试请求失败: $e');
      _handleForceLogoutFromError(
        handler,
        DioException.requestCancelled(
          requestOptions: options,
          reason: '重试请求失败',
        ),
      );
    }
  }

  /// 处理强制登出 (用于ErrorInterceptorHandler)
  Future<void> _handleForceLogoutFromError(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    // 清除本地认证信息
    await TokenManager.instance.clearAuth();

    if (err.requestOptions.path.contains('/auths/login')) return;
    handler.reject(err);
    BaseRouter.replace(url: AppPage.loginPage.path);
  }
}

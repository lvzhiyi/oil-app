import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/net/response.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'dart:async';

/// 响应拦截器=>返回数据转换
class HttpRespInterceptor extends InterceptorsWrapper {
  /// 用于控制并发刷新，确保同时只有一个刷新请求
  static Completer<bool>? _refreshCompleter;

  /// 标记是否正在刷新token
  static bool _isRefreshing = false;

  HttpRespInterceptor() : super();

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    BaseResponse res = BaseResponse.fromJson(response.data);
    final noShowToast = response.requestOptions.extra['noShowToast'] ?? false;

    if (res.code == HttpCode.success) {
      return handler.next(
        Response(
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          data: noShowToast
              ? response.data
              : response.data['data'], // 传递完整的响应数据，而不是只传递data字段
        ),
      );
    }

    l.e(
      "业务请求错误：",
      '\n path:${response.requestOptions.path}'
          '\n code:${response.data['code']}'
          '\n message:${response.data['message']}'
          '\n requestId:${response.data['requestId']}'
          '\n traceId:${response.headers['x-trace-id']?[0]} ',
    );

    handleResponseError(response, handler);
  }

  handleResponseError(
      Response response, ResponseInterceptorHandler handler) async {
    final statusCode = response.data['code'];
    final badRes = DioException.badResponse(
      statusCode: response.statusCode ?? 0,
      requestOptions: response.requestOptions,
      response: response,
    );

    // 检查是否是401错误，如果是则尝试token刷新
    if (statusCode == 401 || statusCode == 403) {
      final requestOptions = response.requestOptions;

      // 如果是刷新token的请求本身返回401，说明refreshToken也过期了，需要重新登录
      if (requestOptions.path == '/auth/refresh-token') {
        l.e('HttpRespInterceptor', 'refreshToken已过期，需要重新登录');
        BaseConfig.appContext?.read<AppController>().logout();

        SportsToast.showWarning('登录已过期，请重新登录');
        return handler.reject(badRes);
      }

      // 如果正在刷新token，等待刷新完成
      if (_isRefreshing && _refreshCompleter != null) {
        l.i('HttpRespInterceptor', '正在刷新token，等待刷新完成');
        try {
          final refreshSuccess = await _refreshCompleter!.future;
          if (refreshSuccess) {
            // 刷新成功，重新发送原始请求
            return await _retryRequest(response, handler, badRes);
          } else {
            // 刷新失败，直接拒绝请求
            return handler.reject(badRes);
          }
        } catch (e) {
          l.e('HttpRespInterceptor', '等待token刷新时出错: $e');
          return handler.reject(badRes);
        }
      }

      // 开始刷新token
      _isRefreshing = true;
      _refreshCompleter = Completer<bool>();

      try {
        final appController = BaseConfig.appContext?.read<AppController>();
        final refreshToken = appController?.state.authResponse?.refreshToken;

        if (refreshToken == null || refreshToken.isEmpty) {
          l.e('HttpRespInterceptor', 'refreshToken为空，无法刷新');
          _isRefreshing = false;
          _refreshCompleter?.complete(false);
          _refreshCompleter = null;
          BaseConfig.appContext?.read<AppController>().logout();
          SportsToast.showWarning('登录已过期，请重新登录');
          return handler.reject(badRes);
        }

        l.i('HttpRespInterceptor', '开始刷新token');

        // 调用刷新token接口
        final refreshRequest = RefreshTokenRequest(refreshToken: refreshToken);
        final authResponse = await authService.refreshToken(refreshRequest);

        // 更新AppController中的token
        appController?.setAuthResponse(
          authResponse.copyWith(
            accessToken: authResponse.accessToken,
            refreshToken: refreshToken,
            account: appController.state.authResponse?.account,
          ),
        );

        l.i('HttpRespInterceptor', 'token刷新成功');
        _isRefreshing = false;
        _refreshCompleter?.complete(true);
        _refreshCompleter = null;

        // 刷新成功，重新发送原始请求
        return await _retryRequest(response, handler, badRes);
      } catch (e) {
        l.e('HttpRespInterceptor', '刷新token失败: $e');
        _isRefreshing = false;
        _refreshCompleter?.complete(false);
        _refreshCompleter = null;

        // 刷新失败，清除认证信息并跳转到登录页
        BaseConfig.appContext?.read<AppController>().logout();
        SportsToast.showWarning('登录已过期，请重新登录');
        return handler.reject(badRes);
      }
    }

    final noShowToast = response.requestOptions.extra['noShowToast'] ?? false;

    if (!noShowToast) {
      // 处理其他错误
      if (response.data is String) {
        SportsToast.showWarning(response.data['message'] as String);
        return handler.reject(badRes);
      }

      if (response.data['message'] != null) {
        SportsToast.showWarning(response.data['message']);
      } else {
        SportsToast.showWarning('网络错误');
      }
      return handler.reject(badRes);
    }

    return handler.resolve(response);
  }

  /// 重新发送原始请求
  Future<void> _retryRequest(
    Response response,
    ResponseInterceptorHandler handler,
    DioException? badRes,
  ) async {
    try {
      // 获取Dio实例
      final dio = netManager.clientDio;
      if (dio == null) {
        l.e('HttpRespInterceptor', 'Dio实例为空，无法重新发送请求');
        return handler.reject(DioException(
          requestOptions: response.requestOptions,
          error: 'Dio实例为空',
        ));
      }

      // 更新请求头中的Authorization
      final appController = BaseConfig.appContext?.read<AppController>();
      final newAccessToken = appController?.state.authResponse?.accessToken;

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        response.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
      }

      // 构建完整的URL，使用原始请求的baseUrl，避免baseUrl混乱
      // RequestOptions.uri 已经包含了完整的URI（包括baseUrl和path的组合）
      final fullUrl = response.requestOptions.uri.toString();

      l.d('HttpRespInterceptor',
          '重试请求 - baseUrl: ${response.requestOptions.baseUrl}, path: ${response.requestOptions.path}, fullUrl: $fullUrl');

      // 重新发送请求，使用完整URL
      final options = Options(
        method: response.requestOptions.method,
        headers: response.requestOptions.headers,
        extra: response.requestOptions.extra,
      );

      final newResponse = await dio.request<dynamic>(
        fullUrl,
        data: response.requestOptions.data,
        queryParameters: response.requestOptions.queryParameters,
        options: options,
        cancelToken: response.requestOptions.cancelToken,
        onReceiveProgress: response.requestOptions.onReceiveProgress,
        onSendProgress: response.requestOptions.onSendProgress,
      );

      // 返回成功响应，需要再次经过onResponse处理
      return handler.resolve(newResponse);
    } catch (e) {
      l.e('HttpRespInterceptor', '重新发送请求失败: $e');
      return handler.reject(badRes ??
          DioException(
            requestOptions: response.requestOptions,
            error: '重新发送请求失败',
          ));
    }
  }
}

import 'package:dio/dio.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/net/response.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'dart:async';

/// 响应拦截器=>返回数据转换
class HttpRespInterceptor extends InterceptorsWrapper {
  /// 用于控制并发刷新，确保同时只有一个刷新请求
  // static Completer<bool>? _refreshCompleter;

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
    }

    if (err.response?.data is String) {
      SportsToast.showWarning(err.response?.data as String);
    }

    if (err.response?.data['message'] != null) {
      SportsToast.showWarning(err.response?.data['message']);
    } else {
      SportsToast.showWarning('网络错误');
    }

    return handler.reject(err);
  }
}

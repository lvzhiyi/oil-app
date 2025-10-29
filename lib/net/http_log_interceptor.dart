import 'package:dio/dio.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/net/base_interceptor.dart';
import 'package:oil_business_app/utils/log.dart';

/// 网络日志拦截器
class HttpLogInterceptor extends BaseInterceptor {
  HttpLogInterceptor() : super(tag: 'http_log');

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    l.d(
      tag,
      'method:${options.method}  path:${options.path.toString()} url:${options.uri.toString()}\n',
    );
    if (options.method == "POST") {
      l.i(
        tag,
        'bodyParam:${options.data.toString()} extra:${options.extra.toString()}\n',
      );
    } else if (options.method == "GET") {
      l.i(
        tag,
        'queryParam:${options.queryParameters.toString()} extra:${options.extra.toString()}\n',
      );
    }
    l.d(
      tag,
      'header:${options.headers.toString()}\n',
    );

    return handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    l.d(
      tag,
      'url:${response.requestOptions.uri}  path:${response.requestOptions.path}\n',
    );
    if (BaseConfig.debug) {
      l.d(
        tag,
        'begin resp: ${response.toString()}\n',
      );
    }

    return handler.next(response);
  }

  @override
  onError(DioException err, ErrorInterceptorHandler handler) {
    l.e(
      "服务器请求错误：",
      '\n path:${err.requestOptions.path} \n url:${err.requestOptions.uri} \n statusCode:${err.response?.statusCode} \n message:${err.message} ',
    );
    return handler.next(err);
  }
}

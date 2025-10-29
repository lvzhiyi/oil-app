import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:oil_business_app/global/storage.dart';
import 'package:oil_business_app/net/dio_io.dart';
import 'package:oil_business_app/net/http_header_interceptor.dart';
import 'package:oil_business_app/net/http_log_interceptor.dart';
import 'package:oil_business_app/net/http_resp_interceptor.dart';
import 'package:oil_business_app/utils/log.dart';

/// 连接超时30秒 - 增加超时时间
const int timeOut = 30 * 1000;

/// 重试次数
const int retryCount = 3;

final netManager = _NetManager();

final netDio = netManager.clientDio;

class _NetManager {
  Dio? clientDio;

  /// 网络管理器初始化状态
  bool _isInitialized = false;

  /// 获取初始化状态
  bool get isInitialized => _isInitialized;

  init(
    String baseUrl, {
    required bool withCredentials, // 控制跨域请求中是否发送凭据
    bool nativeNetInterceptor = false,
  }) {
    try {
      var dio = createDio(
        BaseOptions(
          connectTimeout: const Duration(milliseconds: timeOut),
          receiveTimeout: const Duration(milliseconds: timeOut),
          sendTimeout: const Duration(milliseconds: timeOut),
          baseUrl: baseUrl,
          responseType: ResponseType.json,
        ),
        withCredentials,
      );

      /** 配置代理设置（如果需要） */
      final proxyUri = GlobalStorage.dioProxyUri;
      if (proxyUri.isNotEmpty) {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          client.findProxy = (uri) => "PROXY $proxyUri";
          return client;
        };
      }

      /** header 拦截器 */
      dio.interceptors.add(HttpHeaderInterceptor());

      /** 返回 responese 拦截器 */
      dio.interceptors.add(HttpRespInterceptor());

      /** 日志 拦截器 */
      dio.interceptors.add(HttpLogInterceptor());

      clientDio = dio;
      _isInitialized = true;

      l.d('NetManager', 'baseUrl：$baseUrl');
      l.d('NetManager', '网络管理器初始化成功');
    } catch (e) {
      l.e('NetManager', '网络管理器初始化失败: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// 检查网络连接状态
  Future<bool> checkConnection() async {
    if (!_isInitialized || clientDio == null) {
      return false;
    }

    return true;
  }
}

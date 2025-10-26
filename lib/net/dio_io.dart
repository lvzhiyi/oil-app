import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

Dio createDio(
  BaseOptions options,
  bool withCredentials,
) {
  var clientDio = Dio(options);
  // (clientDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
  //     HttpClient()
  //       ..badCertificateCallback =
  //           (X509Certificate cert, String host, int port) => true;
  return clientDio;
}

/// 用于在Dio中添加元数据
class DioMetaData extends TypedExtras {
  /// 是否显示Toast, 默认显示
  final bool noShowToast;

  const DioMetaData({this.noShowToast = false});
}

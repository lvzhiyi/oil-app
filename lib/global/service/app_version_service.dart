import 'package:dio/dio.dart';
import 'package:oil_business_app/global/model/app_version_type.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'app_version_service.g.dart';

@RestApi()
abstract class AppVersionService {
  factory AppVersionService(Dio dio, {String baseUrl}) = _AppVersionService;

  /// 获取版本信息
  @GET('/version/latest')
  Future<AppVersionInfoResponse> appVersion();
}

/// 获取AuthService实例，确保网络管理器已初始化
AppVersionService get appVersionService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return AppVersionService(netManager.clientDio!);
}

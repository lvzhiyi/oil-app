import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/pages/profile/model/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_service.g.dart';

/// 用户个人资料服务API
@RestApi()
abstract class ProfileService {
  factory ProfileService(Dio dio, {String baseUrl}) = _ProfileService;

  /// 获取用户个人资料（包含库存信息）
  @GET('/users/profile')
  Future<ProfileResponse> getUserProfile();

  /// 注销账号
  @POST('/users/cancel')
  Future<void> cancelAccount();
}

/// 获取ProfileService实例
ProfileService get profileService =>
    ProfileService(netManager.clientDio ?? Dio());

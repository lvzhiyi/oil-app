import 'package:dio/dio.dart';
import 'package:oil_business_app/global/model/auth_type.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  /// 用户登录
  @POST('/auths/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// 刷新Token
  @POST('/auths/refresh')
  Future<RefreshTokenResponse> refreshToken(
      @Body() RefreshTokenRequest request);

  /// 用户注册
  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  /// 发送验证码
  @POST('/auth/send-verification')
  Future sendCode(@Body() SendCodeRequest request);

  /// 退出登录
  @POST('/auth/logout')
  Future<LogoutResponse> logout();
}

/// 获取AuthService实例，确保网络管理器已初始化
AuthService get authService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return AuthService(netManager.clientDio!);
}

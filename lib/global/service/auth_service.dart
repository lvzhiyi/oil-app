import 'package:dio/dio.dart';
import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

import '../model/auth_req_type.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  /// 用户登录
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  /// 刷新Token
  @POST('/auth/refresh-token')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  /// 用户注册
  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterRequest request);

  /// 发送验证码
  @POST('/auth/send-verification')
  Future sendCode(@Body() SendCodeRequest request);

  /// 修改密码
  @POST('/auth/change-password')
  Future<AuthResponse> changePassword(@Body() ChangePasswordRequest request);

  // /// 退出登录
  // @POST('/auth/logout')
  // Future<LogoutResponse> logout();
}

/// 获取AuthService实例，确保网络管理器已初始化
AuthService get authService => AuthService(netManager.clientDio ?? Dio());

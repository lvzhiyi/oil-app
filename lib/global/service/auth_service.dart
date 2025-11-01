import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  // /// 用户登录
  // @POST('/auths/login')
  // Future<LoginResponse> login(@Body() LoginRequest request);

  // /// 刷新Token
  // @POST('/auths/refresh')
  // Future<RefreshTokenResponse> refreshToken(
  //     @Body() RefreshTokenRequest request);

  /// 用户注册
  @POST('/auth/register')
  Future register(@Body() RegisterRequest request);

  /// 发送验证码
  @POST('/auth/send-verification')
  Future sendCode(@Body() SendCodeRequest request);

  // /// 退出登录
  // @POST('/auth/logout')
  // Future<LogoutResponse> logout();
}

/// 获取AuthService实例，确保网络管理器已初始化
AuthService get authService => AuthService(netManager.clientDio!);

/// 注册请求
/// [phone] 手机号
/// [password] 密码
/// [code] 验证码
/// [name] 用户名
class RegisterRequest {
  final String phone;
  final String password;
  final String code;
  final String name;

  RegisterRequest(
      {required this.phone,
      required this.password,
      required this.code,
      required this.name});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'code': code,
        'name': name,
      };
}

/// 发送验证码请求
/// [phone] 手机号
/// [type] 验证码类型
class SendCodeRequest {
  final String phone;
  final String type;

  SendCodeRequest({required this.phone, required this.type});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'type': type,
      };
}

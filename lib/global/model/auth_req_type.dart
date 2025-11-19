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

/// 登录请求
/// [phone] 手机号
/// [password] 密码
class LoginRequest {
  final String phone;
  final String? password;
  final String? code;

  LoginRequest({required this.phone, this.password, this.code});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'code': code,
      };
}

/// 刷新Token请求
/// [refreshToken] 刷新令牌
class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
      };
}

/// 修改密码请求
/// [phone] 手机号
/// [code] 验证码
/// [newPassword] 新密码
class ChangePasswordRequest {
  final String phone;
  final String code;
  final String newPassword;

  ChangePasswordRequest({
    required this.phone,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
        'newPassword': newPassword,
      };
}

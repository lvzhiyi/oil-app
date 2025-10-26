/// 登录请求参数
class LoginRequest {
  final String phone;
  final String password;

  const LoginRequest({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        phone: json['phone'],
        password: json['password'],
      );
}

/// 登录响应数据
///
/// 实际API响应格式（直接返回token数据）：
/// {
///   "access_token": "用户的access_token",
///   "refresh_token": "用户的refresh_token",
///   "tenantUuid": "代理商ID",
///   "userName": "用户名",
///   "phone": "手机号"
/// }
class LoginResponse {
  final int? code;
  final String? message;
  final LoginData? data;

  const LoginResponse({
    this.code,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json['code'],
        message: json['message'],
        data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      );
}

/// 登录数据详情
class LoginData {
  final String? accessToken;
  final String? refreshToken;
  final String? tenantUuid;

  const LoginData({
    this.accessToken,
    this.refreshToken,
    this.tenantUuid,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        tenantUuid: json['tenantUuid'],
      );
}

/// Token刷新请求
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      RefreshTokenRequest(
        refreshToken: json['refresh_token'],
      );
}

/// Token刷新响应
///
/// 标准API响应格式：
/// {
///   "code": 200,
///   "message": "success",
///   "data": {
///     "access_token": "new_access_token",
///     "refresh_token": "new_refresh_token"
///   }
/// }
class RefreshTokenResponse {
  final int? code;
  final String? message;
  final RefreshTokenData? data;

  const RefreshTokenResponse({
    this.code,
    this.message,
    this.data,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        code: json['code'],
        message: json['message'],
        data: json['data'] != null
            ? RefreshTokenData.fromJson(json['data'])
            : null,
      );
}

/// Token刷新数据详情
class RefreshTokenData {
  final String? accessToken;
  final String? refreshToken;

  const RefreshTokenData({
    this.accessToken,
    this.refreshToken,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      RefreshTokenData(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );
}

/// 退出登录响应
///
/// 标准API响应格式：
/// {
///   "code": 200,
///   "message": "success",
///   "data": null
/// }
class LogoutResponse {
  final int? code;
  final String? message;

  const LogoutResponse({
    this.code,
    this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
        code: json['code'],
        message: json['message'],
      );
}

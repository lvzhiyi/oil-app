# 认证API

<cite>
**本文档引用的文件**  
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart)
- [auth_rep_type.dart](file://lib/global/model/auth_rep_type.dart)
- [auth_service.dart](file://lib/global/service/auth_service.dart)
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart)
- [login.dart](file://lib/pages/login/controller.dart)
- [register.dart](file://lib/pages/register/controller.dart)
- [forgot_password.dart](file://lib/pages/forgot_password/controller.dart)
- [otp.dart](file://lib/pages/otp/controller.dart)
- [net_manager.dart](file://lib/net/net_manager.dart)
</cite>

## 目录
1. [简介](#简介)
2. [认证端点](#认证端点)
3. [请求模型](#请求模型)
4. [响应模型](#响应模型)
5. [认证服务调用](#认证服务调用)
6. [错误处理](#错误处理)
7. [使用示例](#使用示例)

## 简介
本文档详细描述了油品业务应用中的认证API，涵盖了用户登录、注册、密码重置和OTP验证等核心功能。文档基于`auth_req_type.dart`和`auth_rep_type.dart`中的模型定义，详细说明了每个接口的HTTP方法、请求头要求、认证机制、请求参数和响应数据结构。同时，文档提供了使用Retrofit生成的AuthService调用示例代码，并解释了错误处理流程。

**Section sources**
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart)
- [auth_rep_type.dart](file://lib/global/model/auth_rep_type.dart)

## 认证端点
认证API提供了多个端点来处理用户认证相关的操作。所有端点都使用POST方法，并通过JSON格式传输数据。

### 登录端点
- **HTTP方法**: POST
- **路径**: `/auth/login`
- **认证机制**: JWT Bearer Token（在后续请求中通过Authorization头传递）
- **请求头要求**:
  - `Content-Type: application/json`
  - `Accept: application/json`

### 注册端点
- **HTTP方法**: POST
- **路径**: `/auth/register`
- **认证机制**: 无（注册成功后返回JWT Token）
- **请求头要求**:
  - `Content-Type: application/json`
  - `Accept: application/json`

### 发送验证码端点
- **HTTP方法**: POST
- **路径**: `/auth/send-verification`
- **认证机制**: 无
- **请求头要求**:
  - `Content-Type: application/json`
  - `Accept: application/json`

### 修改密码端点
- **HTTP方法**: POST
- **路径**: `/auth/change-password`
- **认证机制**: 无（通过手机号和验证码验证身份）
- **请求头要求**:
  - `Content-Type: application/json`
  - `Accept: application/json`

### 刷新Token端点
- **HTTP方法**: POST
- **路径**: `/auth/refresh-token`
- **认证机制**: 使用刷新令牌
- **请求头要求**:
  - `Content-Type: application/json`
  - `Accept: application/json`

**Section sources**
- [auth_service.dart](file://lib/global/service/auth_service.dart#L15-L32)

## 请求模型
请求模型定义了客户端向服务器发送数据的结构。所有请求模型都实现了`toJson()`方法，用于序列化为JSON格式。

### 注册请求 (RegisterRequest)
| 字段 | 类型 | 约束 | 示例值 |
|------|------|------|--------|
| phone | String | 必填，11位手机号 | "13800138000" |
| password | String | 必填，8-20位，包含字母和数字 | "Password123" |
| code | String | 必填，4位验证码 | "1234" |
| name | String | 必填，用户姓名 | "张三" |
| referralCode | String? | 可选，推荐码 | "REF123" |

### 发送验证码请求 (SendCodeRequest)
| 字段 | 类型 | 约束 | 示例值 |
|------|------|------|--------|
| phone | String | 必填，11位手机号 | "13800138000" |
| type | String | 必填，验证码类型 | "login" 或 "password_change" |

### 登录请求 (LoginRequest)
| 字段 | 类型 | 约束 | 示例值 |
|------|------|------|--------|
| phone | String | 必填，11位手机号 | "13800138000" |
| password | String? | 可选，密码登录时必填 | "Password123" |
| code | String? | 可选，验证码登录时必填 | "1234" |

### 刷新Token请求 (RefreshTokenRequest)
| 字段 | 类型 | 约束 | 示例值 |
|------|------|------|--------|
| refreshToken | String | 必填，刷新令牌 | "refresh_token_value" |

### 修改密码请求 (ChangePasswordRequest)
| 字段 | 类型 | 约束 | 示例值 |
|------|------|------|--------|
| phone | String | 必填，11位手机号 | "13800138000" |
| code | String | 必填，4位验证码 | "1234" |
| newPassword | String | 必填，8-20位，包含字母和数字 | "NewPassword456" |

**Section sources**
- [auth_req_type.dart](file://lib/global/model/auth_req_type.dart#L6-L93)

## 响应模型
响应模型定义了服务器向客户端返回数据的结构。所有响应模型都实现了`fromJson()`和`toJson()`方法，用于反序列化和序列化。

### 认证响应 (AuthResponse)
```dart
class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final Account? account;
}
```

| 字段 | 类型 | 说明 | 示例值 |
|------|------|------|--------|
| accessToken | String? | 访问令牌，用于后续请求的认证 | "access_token_value" |
| refreshToken | String? | 刷新令牌，用于获取新的访问令牌 | "refresh_token_value" |
| account | Account? | 用户账户信息 | Account对象 |

### 账户信息 (Account)
```dart
class Account {
  final int id;
  final String phone;
  final String name;
  final int status;
}
```

| 字段 | 类型 | 说明 | 示例值 |
|------|------|------|--------|
| id | int | 用户ID | 12345 |
| phone | String | 手机号 | "13800138000" |
| name | String | 用户姓名 | "张三" |
| status | int | 账户状态 | 1 |

**Section sources**
- [auth_rep_type.dart](file://lib/global/model/auth_rep_type.dart#L6-L45)

## 认证服务调用
认证服务使用Retrofit库生成，提供了类型安全的API调用方法。

### AuthService接口
```dart
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
  Future changePassword(@Body() ChangePasswordRequest request);
}
```

### 服务实例获取
```dart
/// 获取AuthService实例，确保网络管理器已初始化
AuthService get authService => AuthService(netManager.clientDio ?? Dio());
```

**Section sources**
- [auth_service.dart](file://lib/global/service/auth_service.dart#L10-L40)
- [auth_service.g.dart](file://lib/global/service/auth_service.g.dart#L11-L146)

## 错误处理
认证API的错误处理基于DioException和服务器返回的错误消息。以下是常见的错误状态码及其处理方式：

### HTTP状态码处理
| 状态码 | 含义 | 处理方式 |
|-------|------|---------|
| 400 | 无效请求 | 显示具体的错误消息，如"手机号格式不正确"或"密码不符合要求" |
| 401 | 未授权 | 清除本地认证信息，跳转到登录页面 |
| 403 | 禁止访问 | 显示"账号已被锁定，请联系您的业务员" |
| 429 | 请求过于频繁 | 显示"发送过于频繁，请稍后再试" |
| 500 | 服务器错误 | 显示"服务器错误，请稍后重试" |

### 网络错误处理
```dart
String _getErrorMessage(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '网络连接超时，请检查网络后重试';
      case DioExceptionType.badResponse:
        return '服务器错误，请稍后重试';
      case DioExceptionType.connectionError:
        return '网络连接失败，请检查网络设置';
      default:
        break;
    }
  }
  // 其他错误处理逻辑
}
```

### 业务逻辑错误处理
- **账号不存在**: 显示"账号不存在，请先注册"
- **密码错误**: 显示"手机号或密码错误"
- **验证码错误**: 显示"验证码错误或已过期"
- **验证码过期**: 显示"验证码已过期，请重新获取"

**Section sources**
- [login.dart](file://lib/pages/login/controller.dart#L73-L140)
- [forgot_password.dart](file://lib/pages/forgot_password/controller.dart#L148-L200)
- [api_exception.dart](file://lib/net/api_exception.dart#L2-L11)

## 使用示例
以下示例展示了如何在Flutter应用中使用认证API。

### 用户登录示例
```dart
// 密码登录
Future<void> _passwordLogin() async {
  final formData = formKey.currentState?.value ?? {};
  final phone = (formData['phone'] ?? '').toString();
  final password = formData['password'] ?? '';

  try {
    final response = await authService.login(
      LoginRequest(phone: phone, password: password)
    );
    // 处理登录成功逻辑
    BaseConfig.appContext?.read<AppController>().loginSucessProcess(response);
    await _saveLastPhone(phone);
    emit(state.copyWith(loginLoading: false, loginSuccess: true));
  } on DioException catch (e) {
    // 处理登录失败
    final errorMessage = _getErrorMessage(e);
    emit(state.copyWith(
      loginLoading: false,
      errorMessage: errorMessage,
    ));
  }
}
```

### 发送验证码示例
```dart
Future<void> sendVerificationCode(String phone) async {
  try {
    await authService.sendCode(
      SendCodeRequest(phone: phone, type: 'login')
    );
    emit(state.copyWith(verificationCodeSent: true));
    startCountdown(); // 启动60秒倒计时
  } on DioException catch (e) {
    final errorMessage = _getSmsErrorMessage(e);
    emit(state.copyWith(errorMessage: errorMessage));
  }
}
```

### 用户注册示例
```dart
Future<void> goToOtpPage() async {
  if (!registerPrecheck()) return;

  final formData = formKey.currentState?.value ?? {};
  final phone = formData['phone'] ?? '';
  final name = formData['name'] ?? '';
  final password = formData['password'] ?? '';
  final referralCode = formData['referralCode'] ?? '';

  // 跳转到OTP验证页面，传递表单数据
  BaseRouter.push(url: AppPage.otpPage.path, extra: {
    'type': 'register',
    'phone': phone,
    'name': name,
    'password': password,
    'referralCode': referralCode,
  });
}
```

### OTP验证示例
```dart
submit({required Map<String, dynamic> extra}) async {
  if (extra['type'] == "register") {
    final otpCode = codeController.map((e) => e.text).join('');
    final reqParams = RegisterRequest(
      name: extra['name'] ?? '',
      phone: extra['phone'] ?? '',
      code: otpCode,
      password: extra['password'] ?? '',
      referralCode: extra['referralCode'] ?? '',
    );

    try {
      final response = await authService.register(reqParams);
      BaseConfig.appContext
          ?.read<AppController>()
          .loginSucessProcess(response, type: AuthReqType.register);
      emit(state.copyWith(loading: false));
    } on DioException catch (e) {
      emit(state.copyWith(loading: false));
      debugPrint('注册失败: $e');
    }
  }
}
```

**Section sources**
- [login.dart](file://lib/pages/login/controller.dart#L143-L176)
- [register.dart](file://lib/pages/register/controller.dart#L37-L55)
- [otp.dart](file://lib/pages/otp/controller.dart#L122-L165)
- [forgot_password.dart](file://lib/pages/forgot_password/controller.dart#L89-L117)
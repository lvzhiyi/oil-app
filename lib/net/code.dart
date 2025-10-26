///错误编码
///业务错误，非状态错误
class HttpCode {
  ///请求成功
  static const success = 0;

  /// 登陆失效
  static const logout = 401;

  /// token过期
  static const tokenExpired = 401;
}

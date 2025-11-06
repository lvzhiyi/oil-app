enum AuthReqType {
  /// 登录
  login,

  /// 注册
  register,

  /// 验证码登录
  otp,
}

enum StationStatus {
  /// 待审核
  pending_review,

  /// 审核通过
  active,

  /// 审核失败
  rejected,

  /// 禁用
  disabled,
}

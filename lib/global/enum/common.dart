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

/// 文件上传类型枚举
enum FileUploadTypeEnum {
  /// 图片
  Img('img'),

  /// 视频
  Video('video'),

  /// 音频
  Audio('audio'),

  /// 文档
  Bin('bin');

  const FileUploadTypeEnum(this.value);

  final String value;
}

/// 订单状态枚举
enum OrderStatus {
  PendingPayment('待支付', 10),
  PaymentUploaded('已支付', 20),
  Cancelled('已取消', 30),
  Completed('已完成', 40);

  const OrderStatus(this.displayName, this.value);

  final String displayName;
  final int value;

  static OrderStatus fromValue(int value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatus.PendingPayment,
    );
  }
}

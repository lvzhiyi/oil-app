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

enum OrderStatus {
  Pending('待支付', 'pending'),
  Canceled('已取消', 'canceled'),
  Success('支付成功', 'success'),
  Failed('支付失败', 'failed'),
  Submitted('已上传凭证', 'submitted');

  const OrderStatus(this.displayName, this.value);

  final String displayName;
  final String value;

  static OrderStatus fromValue(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatus.Pending,
    );
  }
}

/// 彩票状态枚举
enum LotteryStatus {
  expired(0, '已失效'),
  notWin(1, '未中奖'),
  claimed(2, '已兑奖'),
  pending(3, '待开奖'),
  generating(4, '生成中'),
  won(5, '已中奖'),
  claiming(6, '兑奖中');

  const LotteryStatus(this.code, this.displayName);

  final int code;
  final String displayName;

  /// 根据状态码获取状态
  static LotteryStatus fromCode(int code) {
    return LotteryStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => LotteryStatus.expired,
    );
  }
}

/// 充值类型
enum RechargeType {
  balance('余额充值', 'balance'),
  package('套餐购买', 'package'),
  all('全部', null);

  const RechargeType(this.displayName, this.value);

  final String displayName;
  final String? value;
}

/// 支付方式
enum PaymentMethod {
  Heepay('heepay', '汇付宝'),
  CorpToCorp('corpToCorp', '公对公');

  const PaymentMethod(this.value, this.displayName);
  final String value;
  final String displayName;
}

/// 彩票种类枚举
enum LotteryType {
  doubleColorBall('双色球', 'dcb', 1, 2.0, true),
  threeDimensional('3D', '3d', 2, 1.0, false),
  happyEight('快乐8', 'happy8', 3, 1.5, false),
  sevenHappyColor('七乐彩', '7lc', 4, 1.8, false);

  const LotteryType(
      this.displayName, this.code, this.value, this.price, this.enable);

  final String displayName;
  final String code;
  final int value;
  final double price; // 单价
  final bool enable;

  factory LotteryType.fromJson(Map<String, dynamic> json) {
    String code = json['code'] ?? '';
    return LotteryType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => LotteryType.doubleColorBall,
    );
  }

  /// 根据数值获取彩票类型
  static LotteryType fromValue(int value) {
    return LotteryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LotteryType.doubleColorBall,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'code': code,
      'value': value,
      'price': price,
      'enable': enable,
    };
  }
}

/// 排序类型
enum SortType {
  timeDesc('DESC', '时间倒序'),
  timeAsc('ASC', '时间正序');

  const SortType(this.value, this.displayName);

  final String value;
  final String displayName;
}

/// 二维码生成类型
enum QrCodeType {
  static('静态二维码', 'static'),
  dynamic('动态二维码', 'dynamic');

  const QrCodeType(this.displayName, this.code);

  final String displayName;
  final String code;

  static QrCodeType fromCode(String code) {
    return QrCodeType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => QrCodeType.static,
    );
  }
}

/// 二维码生成状态
enum QrCodeStatus {
  unredeemed('未核销', 'unredeemed'),
  redeemed('已核销', 'redeemed'),
  all('全部', null);

  const QrCodeStatus(this.displayName, this.code);

  final String displayName;
  final String? code;
}

/// 彩票临时券类型枚举
enum LotteryTempCouponTypeEnum {
  static('静态二维码', 'static'),
  dynamic('动态二维码', 'dynamic');

  const LotteryTempCouponTypeEnum(this.displayName, this.value);

  final String displayName;
  final String value;

  static LotteryTempCouponTypeEnum fromValue(String value) {
    return LotteryTempCouponTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LotteryTempCouponTypeEnum.static,
    );
  }
}

// 支付类型枚举值，包含套餐购买和余额充值
enum PaymentType {
  Balance('余额充值', 'balance'),
  Package('套餐购买', 'package');

  const PaymentType(this.displayName, this.value);

  final String displayName;
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

/// 文件上传方式枚举
enum FileUploadMethodEnum {
  /// 表单上传
  Put('put'),

  /// 分片上传
  MultipartUpload('multipartUpload');

  const FileUploadMethodEnum(this.value);

  final String value;
}

/// 员工状态枚举
enum EmployeeStatus {
  Active('正常', 'active'),
  Disabled('已禁用', 'disabled');

  const EmployeeStatus(this.displayName, this.value);

  final String displayName;
  final String value;
}

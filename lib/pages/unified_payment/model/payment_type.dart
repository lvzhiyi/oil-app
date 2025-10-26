import 'package:json_annotation/json_annotation.dart';

part 'payment_type.g.dart';

/// 创建支付订单请求
@JsonSerializable()
class CreatePackageOrderRequest {
  /// 支付类型
  final String type;

  /// 支付方式
  final String paymentMethod;

  /// 套餐ID（可选）
  final String? packageUuid;

  /// 备注
  final String? remark;

  const CreatePackageOrderRequest({
    required this.type,
    required this.paymentMethod,
    this.packageUuid,
    this.remark,
  });

  factory CreatePackageOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePackageOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePackageOrderRequestToJson(this);
}

@JsonSerializable()
class CreateBalanceOrderRequest {
  /// 订单金额（元）
  final int quota;

  /// 支付类型
  final String type;

  /// 支付方式
  final String paymentMethod;

  /// 备注
  final String? remark;

  const CreateBalanceOrderRequest({
    required this.type,
    required this.quota,
    required this.paymentMethod,
    this.remark,
  });

  factory CreateBalanceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBalanceOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBalanceOrderRequestToJson(this);
}

/// 创建支付订单数据
@JsonSerializable()
class CreatePaymentOrderData {
  int? id;
  int? createTime;
  int? updateTime;
  int? deleteTime;
  String? createdBy;
  String? updatedBy;
  String? deletedBy;
  String? uuid;
  String? type;
  String? quota;
  int? lotteryType;
  String? payAmount;
  String? remark;
  String? paymentMethod;
  String? origin;
  String? status;
  String? tenantUuid;
  String? pCreatedBy;
  String? pUpdatedBy;
  String? tCreatedBy;
  String? tUpdatedBy;

  CreatePaymentOrderData({
    this.id,
    this.createTime,
    this.updateTime,
    this.deleteTime,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.uuid,
    this.type,
    this.quota,
    this.lotteryType,
    this.payAmount,
    this.remark,
    this.paymentMethod,
    this.origin,
    this.status,
    this.tenantUuid,
    this.pCreatedBy,
    this.pUpdatedBy,
    this.tCreatedBy,
    this.tUpdatedBy,
  });

  factory CreatePaymentOrderData.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentOrderDataToJson(this);

  CreatePaymentOrderData copyWith({
    int? id,
    int? createTime,
    int? updateTime,
    int? deleteTime,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? uuid,
    String? type,
    String? quota,
    int? lotteryType,
    String? payAmount,
    String? remark,
    String? paymentMethod,
    String? origin,
    String? status,
    String? tenantUuid,
    String? pCreatedBy,
    String? pUpdatedBy,
    String? tCreatedBy,
    String? tUpdatedBy,
  }) {
    return CreatePaymentOrderData(
      id: id ?? this.id,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      deleteTime: deleteTime ?? this.deleteTime,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      quota: quota ?? this.quota,
      lotteryType: lotteryType ?? this.lotteryType,
      payAmount: payAmount ?? this.payAmount,
      remark: remark ?? this.remark,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      origin: origin ?? this.origin,
      status: status ?? this.status,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      pCreatedBy: pCreatedBy ?? this.pCreatedBy,
      pUpdatedBy: pUpdatedBy ?? this.pUpdatedBy,
      tCreatedBy: tCreatedBy ?? this.tCreatedBy,
      tUpdatedBy: tUpdatedBy ?? this.tUpdatedBy,
    );
  }
}

/// 创建支付订单响应
@JsonSerializable()
class CreatePaymentOrderResponse {
  final int code;
  final String message;
  final CreatePaymentOrderData data;

  const CreatePaymentOrderResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreatePaymentOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentOrderResponseToJson(this);
}

/// 套餐信息
@JsonSerializable()
class PackageInfo {
  /// 套餐UUID
  final String uuid;

  /// 彩票类型
  final int lotteryType;

  /// 最小数量
  final int minQuantity;

  /// 赠送数量
  final int bonusQuantity;

  /// 充值金额
  final String rechargeAmount;

  const PackageInfo({
    required this.uuid,
    required this.lotteryType,
    required this.minQuantity,
    required this.bonusQuantity,
    required this.rechargeAmount,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PackageInfoToJson(this);
}



@JsonSerializable()
class PackageInfoData {
  final List<PackageInfo> list;

  const PackageInfoData({
    required this.list,
  });

  factory PackageInfoData.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PackageInfoDataToJson(this);
}

/// 获取套餐列表响应
@JsonSerializable()
class GetPackagesResponse {
  final int code;
  final String message;
  final PackageInfoData data;

  const GetPackagesResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetPackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPackagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetPackagesResponseToJson(this);
}

/// 充值订单记录（用于/recharges 列表）
@JsonSerializable()
class RechargeRecord {
  /// 订单UUID
  final String uuid;

  /// 租户UUID
  final String tenantUuid;

  /// 类型
  final String type;

  /// 配额（金额，字符串）
  final String quota;

  /// 彩票类型
  final String lotteryType;

  /// 支付金额
  final String payAmount;

  /// 备注
  final String? remark;

  /// 支付方式
  final String paymentMethod;

  /// 状态：pending/cancelled/complete
  final String status;

  /// 创建时间（字符串）
  final String createTime;

  const RechargeRecord({
    required this.uuid,
    required this.tenantUuid,
    required this.type,
    required this.quota,
    required this.lotteryType,
    required this.payAmount,
    this.remark,
    required this.paymentMethod,
    required this.status,
    required this.createTime,
  });

  factory RechargeRecord.fromJson(Map<String, dynamic> json) =>
      _$RechargeRecordFromJson(json);

  Map<String, dynamic> toJson() => _$RechargeRecordToJson(this);
}

/// /recharges 列表响应
@JsonSerializable()
class GetRechargesResponse {
  final int code;
  final String message;
  final List<RechargeRecord> data;

  const GetRechargesResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetRechargesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRechargesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetRechargesResponseToJson(this);
}


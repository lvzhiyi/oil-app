import 'package:json_annotation/json_annotation.dart';

part 'withdraw_data.g.dart';

/// 提油订单列表响应
@JsonSerializable()
class WithdrawOrderListResponse {
  final List<WithdrawOrderModel>? list;
  final int? total;
  final int? page;
  final int? pageSize;

  WithdrawOrderListResponse({
    this.list,
    this.total,
    this.page,
    this.pageSize,
  });

  factory WithdrawOrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawOrderListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawOrderListResponseToJson(this);
}

/// 提油订单模型
@JsonSerializable()
class WithdrawOrderModel {
  /// 提油订单ID
  @JsonKey(name: 'withdrawId')
  final int? withdrawId;

  /// 提油订单编号
  @JsonKey(name: 'withdrawNo')
  final String? withdrawNo;

  /// 库存ID
  @JsonKey(name: 'inventoryId')
  final int? inventoryId;

  /// 订单ID（向后兼容字段，映射到withdrawId）
  final int? id;

  /// 油品订单ID
  final int? oilOrderId;

  /// 订单状态
  final String? status;

  /// 油库名称
  @JsonKey(name: 'depotName')
  final String? depotName;

  /// 加油站ID
  @JsonKey(name: 'stationId')
  final int? stationId;

  /// 加油站名称
  @JsonKey(name: 'stationName')
  final String? stationName;

  /// 提油吨数
  @JsonKey(name: 'withdrawTon')
  final double? withdrawTon;

  /// 车辆信息（JSON字符串）
  @JsonKey(name: 'vehicleInfo')
  final String? vehicleInfo;

  /// 创建时间
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  /// 更新时间
  final String? updatedAt;

  /// 省份名称
  @JsonKey(name: 'provinceName')
  final String? provinceName;

  /// 城市名称
  @JsonKey(name: 'cityName')
  final String? cityName;

  /// 区域名称
  @JsonKey(name: 'areaName')
  final String? areaName;

  /// 详细地址
  @JsonKey(name: 'addressDetail')
  final String? addressDetail;

  WithdrawOrderModel({
    this.withdrawId,
    this.withdrawNo,
    this.inventoryId,
    this.id,
    this.oilOrderId,
    this.status,
    this.stationId,
    this.stationName,
    this.withdrawTon,
    this.vehicleInfo,
    this.createdAt,
    this.updatedAt,
    this.provinceName,
    this.cityName,
    this.areaName,
    this.addressDetail,
    this.depotName,
  });

  factory WithdrawOrderModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawOrderModelToJson(this);
}

/// 提油请求
@JsonSerializable()
class WithdrawRequest {
  final double withdrawTon;
  final int stationId;
  final String vehicleInfo;

  WithdrawRequest({
    required this.withdrawTon,
    required this.stationId,
    required this.vehicleInfo,
  });

  factory WithdrawRequest.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawRequestToJson(this);
}

/// 提油响应
@JsonSerializable()
class WithdrawResponse {
  @JsonKey(name: 'withdrawId')
  final int? withdrawId;

  @JsonKey(name: 'withdrawNo')
  final String? withdrawNo;

  @JsonKey(name: 'remainingTon')
  final double? remainingTon;

  final String? status;

  final String? message;

  WithdrawResponse({
    this.withdrawId,
    this.withdrawNo,
    this.remainingTon,
    this.status,
    this.message,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawResponseToJson(this);
}

/// 库存油模型
@JsonSerializable()
class InventoryModel {
  @JsonKey(name: 'inventoryId')
  final int? inventoryId;

  @JsonKey(name: 'depotId')
  final int? depotId;

  @JsonKey(name: 'depotName')
  final String? depotName;

  @JsonKey(name: 'fuelType')
  final String? fuelType;

  @JsonKey(name: 'availableTon')
  final double? availableTon;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  InventoryModel({
    this.inventoryId,
    this.depotId,
    this.depotName,
    this.fuelType,
    this.availableTon,
    this.updatedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryModelToJson(this);
}

/// 库存油列表响应
@JsonSerializable()
class InventoryListResponse {
  final List<InventoryModel>? list;
  final int? total;
  final int? page;
  final int? pageSize;

  InventoryListResponse({
    this.list,
    this.total,
    this.page,
    this.pageSize,
  });

  factory InventoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryListResponseToJson(this);
}

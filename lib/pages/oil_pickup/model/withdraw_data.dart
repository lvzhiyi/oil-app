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

/// 加油站信息
@JsonSerializable()
class StationInfo {
  @JsonKey(name: 'stationId')
  final int? stationId;

  @JsonKey(name: 'stationName')
  final String? stationName;

  @JsonKey(name: 'provinceName')
  final String? provinceName;

  @JsonKey(name: 'cityName')
  final String? cityName;

  @JsonKey(name: 'areaName')
  final String? areaName;

  @JsonKey(name: 'addressDetail')
  final String? addressDetail;

  StationInfo({
    this.stationId,
    this.stationName,
    this.provinceName,
    this.cityName,
    this.areaName,
    this.addressDetail,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) =>
      _$StationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StationInfoToJson(this);
}

/// 油库信息
@JsonSerializable()
class DepotInfo {
  @JsonKey(name: 'depotId')
  final int? depotId;

  @JsonKey(name: 'depotName')
  final String? depotName;

  @JsonKey(name: 'addressDetail')
  final String? addressDetail;

  DepotInfo({
    this.depotId,
    this.depotName,
    this.addressDetail,
  });

  factory DepotInfo.fromJson(Map<String, dynamic> json) =>
      _$DepotInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DepotInfoToJson(this);
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

  /// 提油吨数
  @JsonKey(name: 'withdrawTon')
  final double? withdrawTon;

  /// 油品类型
  @JsonKey(name: 'fuelType')
  final String? fuelType;

  /// 车辆信息（JSON字符串）
  @JsonKey(name: 'vehicleInfo')
  final String? vehicleInfo;

  /// 订单状态
  final String? status;

  /// 创建时间
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  /// 更新时间
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  /// 加油站信息
  final StationInfo? station;

  /// 油库信息
  final DepotInfo? depot;

  WithdrawOrderModel({
    this.withdrawId,
    this.withdrawNo,
    this.withdrawTon,
    this.fuelType,
    this.vehicleInfo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.station,
    this.depot,
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

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
  final int? id;
  final int? oilOrderId;
  final String? status;
  final int? stationId;
  final String? stationName;
  final double? withdrawTon;
  final String? vehicleInfo;
  final String? createdAt;
  final String? updatedAt;

  WithdrawOrderModel({
    this.id,
    this.oilOrderId,
    this.status,
    this.stationId,
    this.stationName,
    this.withdrawTon,
    this.vehicleInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawOrderModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawOrderModelToJson(this);
}

/// 提油请求
@JsonSerializable()
class WithdrawRequest {
  final int withdrawTon;
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
  final int? id;
  final String? status;
  final String? message;

  WithdrawResponse({
    this.id,
    this.status,
    this.message,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawResponseToJson(this);
}

/// 库存油查询请求
@JsonSerializable()
class InventoryQueryRequest {
  final int page;
  final int pageSize;

  InventoryQueryRequest({
    required this.page,
    required this.pageSize,
  });

  factory InventoryQueryRequest.fromJson(Map<String, dynamic> json) =>
      _$InventoryQueryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryQueryRequestToJson(this);
}

/// 库存油模型
@JsonSerializable()
class InventoryModel {
  final int? id;
  final int? oilOrderId;
  final String? depotName;
  final String? fuelType;
  final double? purchaseTon;
  final String? createdAt;
  final String? updatedAt;

  InventoryModel({
    this.id,
    this.oilOrderId,
    this.depotName,
    this.fuelType,
    this.purchaseTon,
    this.createdAt,
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

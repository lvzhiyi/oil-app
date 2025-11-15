import 'package:json_annotation/json_annotation.dart';
import 'package:oil_business_app/global/enum/common.dart';

part 'orders_data.g.dart';

@JsonSerializable()
class OrderListResponse {
  final List<OrderModel>? list;
  final int? total;
  final int? page;
  final int? pageSize;

  OrderListResponse({
    this.list,
    this.total,
    this.page,
    this.pageSize,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListResponseToJson(this);
}

@JsonSerializable()
class OrderModel {
  final int? id;
  final String? orderNo;

  @JsonKey(fromJson: OrderStatus.fromValue)
  final OrderStatus? status;
  final int? depotId;
  final String? depotName;
  final String? fuelType;
  final double? fuelPriceCny;
  final double? purchaseTon;
  final double? totalAmount;
  final String? createdAt;
  final String? updatedAt;

  OrderModel({
    this.id,
    this.orderNo,
    this.status,
    this.depotId,
    this.depotName,
    this.fuelType,
    this.fuelPriceCny,
    this.purchaseTon,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

class ReasonOfCancellationData {
  final String reason;
  final bool? isSelected;

  ReasonOfCancellationData({
    required this.reason,
    this.isSelected,
  });
}

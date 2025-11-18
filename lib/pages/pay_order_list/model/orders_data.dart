import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oil_business_app/global/enum/common.dart';

part 'orders_data.g.dart';
part 'orders_data.freezed.dart';

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

@unfreezed
abstract class OrderModel with _$OrderModel {
  factory OrderModel({
    int? id,
    String? orderNo,
    @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
    int? depotId,
    String? depotName,
    String? fuelType,
    double? fuelPriceCny,
    double? purchaseTon,
    double? totalAmount,
    String? createdAt,
    String? updatedAt,
    String? accountName,
    String? bankAccount,
    String? bankName,
    String? bankBranchNumber,
    String? remark,
    double? availableInventory,
    List<String>? paymentProofUrls,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

class ReasonOfCancellationData {
  final String reason;
  final bool? isSelected;

  ReasonOfCancellationData({
    required this.reason,
    this.isSelected,
  });
}

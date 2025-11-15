// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListResponse _$OrderListResponseFromJson(Map<String, dynamic> json) =>
    OrderListResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderListResponseToJson(OrderListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['orderNo'] as String?,
      status: OrderStatus.fromValue((json['status'] as num).toInt()),
      depotId: (json['depotId'] as num?)?.toInt(),
      depotName: json['depotName'] as String?,
      fuelType: json['fuelType'] as String?,
      fuelPriceCny: (json['fuelPriceCny'] as num?)?.toDouble(),
      purchaseTon: (json['purchaseTon'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNo': instance.orderNo,
      'status': _$OrderStatusEnumMap[instance.status],
      'depotId': instance.depotId,
      'depotName': instance.depotName,
      'fuelType': instance.fuelType,
      'fuelPriceCny': instance.fuelPriceCny,
      'purchaseTon': instance.purchaseTon,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.PendingPayment: 'PendingPayment',
  OrderStatus.PaymentUploaded: 'PaymentUploaded',
  OrderStatus.Cancelled: 'Cancelled',
  OrderStatus.Completed: 'Completed',
};

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

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
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
      accountName: json['accountName'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankName: json['bankName'] as String?,
      bankBranchNumber: json['bankBranchNumber'] as String?,
      remark: json['remark'] as String?,
      availableInventory: (json['availableInventory'] as num?)?.toDouble(),
      paymentProofUrls: (json['paymentProofUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
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
      'accountName': instance.accountName,
      'bankAccount': instance.bankAccount,
      'bankName': instance.bankName,
      'bankBranchNumber': instance.bankBranchNumber,
      'remark': instance.remark,
      'availableInventory': instance.availableInventory,
      'paymentProofUrls': instance.paymentProofUrls,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.PendingPayment: 'PendingPayment',
  OrderStatus.PaymentUploaded: 'PaymentUploaded',
  OrderStatus.Cancelled: 'Cancelled',
  OrderStatus.Completed: 'Completed',
};

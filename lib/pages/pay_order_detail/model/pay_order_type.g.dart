// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_order_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailResponse _$OrderDetailResponseFromJson(Map<String, dynamic> json) =>
    OrderDetailResponse(
      data: json['data'] == null
          ? null
          : PayOrderDetailModel.fromJson(json['data'] as Map<String, dynamic>),
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$OrderDetailResponseToJson(
        OrderDetailResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'code': instance.code,
      'message': instance.message,
      'requestId': instance.requestId,
    };

PayOrderDetailModel _$PayOrderDetailModelFromJson(Map<String, dynamic> json) =>
    PayOrderDetailModel(
      id: (json['id'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      type: json['type'] as String?,
      quota: json['quota'] as String?,
      lotteryType: (json['lotteryType'] as num?)?.toInt(),
      payAmount: json['payAmount'] as String?,
      remark: json['remark'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      origin: json['origin'] as String?,
      status: json['status'] as String?,
      tenantUuid: json['tenantUuid'] as String?,
      pCreatedBy: json['pCreatedBy'] as String?,
      pUpdatedBy: json['pUpdatedBy'] as String?,
      tCreatedBy: json['tCreatedBy'] as String?,
      tUpdatedBy: json['tUpdatedBy'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => FileAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      accountName: json['accountName'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankName: json['bankName'] as String?,
      bankBranchNumber: json['bankBranchNumber'] as String?,
      voucherUrl: json['voucherUrl'] as String?,
      voucherPath: json['voucherPath'] as String?,
    );

Map<String, dynamic> _$PayOrderDetailModelToJson(
        PayOrderDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'uuid': instance.uuid,
      'type': instance.type,
      'quota': instance.quota,
      'lotteryType': instance.lotteryType,
      'payAmount': instance.payAmount,
      'remark': instance.remark,
      'paymentMethod': instance.paymentMethod,
      'origin': instance.origin,
      'status': instance.status,
      'tenantUuid': instance.tenantUuid,
      'pCreatedBy': instance.pCreatedBy,
      'pUpdatedBy': instance.pUpdatedBy,
      'tCreatedBy': instance.tCreatedBy,
      'tUpdatedBy': instance.tUpdatedBy,
      'attachments': instance.attachments,
      'accountName': instance.accountName,
      'bankAccount': instance.bankAccount,
      'bankName': instance.bankName,
      'bankBranchNumber': instance.bankBranchNumber,
      'voucherUrl': instance.voucherUrl,
      'voucherPath': instance.voucherPath,
    };

CancelRechargeRequest _$CancelRechargeRequestFromJson(
        Map<String, dynamic> json) =>
    CancelRechargeRequest(
      status: json['status'] as String,
    );

Map<String, dynamic> _$CancelRechargeRequestToJson(
        CancelRechargeRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

UpdateOrderVoucherRequest _$UpdateOrderVoucherRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateOrderVoucherRequest(
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => FileAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateOrderVoucherRequestToJson(
        UpdateOrderVoucherRequest instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'status': instance.status,
    };

FileAttachment _$FileAttachmentFromJson(Map<String, dynamic> json) =>
    FileAttachment(
      uuid: json['uuid'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$FileAttachmentToJson(FileAttachment instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'path': instance.path,
    };

FileUploadData _$FileUploadDataFromJson(Map<String, dynamic> json) =>
    FileUploadData(
      uuid: json['uuid'] as String?,
      path: json['path'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$FileUploadDataToJson(FileUploadData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'path': instance.path,
      'type': instance.type,
    };

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: FileUploadData.fromJson(json['data'] as Map<String, dynamic>),
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'requestId': instance.requestId,
    };

FileSignUrlResponse _$FileSignUrlResponseFromJson(Map<String, dynamic> json) =>
    FileSignUrlResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] as String?,
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$FileSignUrlResponseToJson(
        FileSignUrlResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'requestId': instance.requestId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceInfo _$InvoiceInfoFromJson(Map<String, dynamic> json) => InvoiceInfo(
      invoiceTitle: json['invoiceTitle'] as String?,
      taxNumber: json['taxNumber'] as String?,
      bankName: json['bankName'] as String?,
      bankAccount: json['bankAccount'] as String?,
      companyAddress: json['companyAddress'] as String?,
      companyPhone: json['companyPhone'] as String?,
      invoiceType: json['invoiceType'] as String?,
    );

Map<String, dynamic> _$InvoiceInfoToJson(InvoiceInfo instance) =>
    <String, dynamic>{
      'invoiceTitle': instance.invoiceTitle,
      'taxNumber': instance.taxNumber,
      'bankName': instance.bankName,
      'bankAccount': instance.bankAccount,
      'companyAddress': instance.companyAddress,
      'companyPhone': instance.companyPhone,
      'invoiceType': instance.invoiceType,
    };

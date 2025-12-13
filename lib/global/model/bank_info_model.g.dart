// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankInfoModel _$BankInfoModelFromJson(Map<String, dynamic> json) =>
    BankInfoModel(
      accountName: json['accountName'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankName: json['bankName'] as String?,
      bankCode: json['bankCode'] as String?,
    );

Map<String, dynamic> _$BankInfoModelToJson(BankInfoModel instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'bankAccount': instance.bankAccount,
      'bankName': instance.bankName,
      'bankCode': instance.bankCode,
    };

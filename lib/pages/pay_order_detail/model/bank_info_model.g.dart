// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankInfoModel _$BankInfoModelFromJson(Map<String, dynamic> json) =>
    BankInfoModel(
      accountName: json['AccountName'] as String?,
      bankAccount: json['BankAccount'] as String?,
      bankName: json['BankName'] as String?,
      bankCode: json['BankCode'] as String?,
    );

Map<String, dynamic> _$BankInfoModelToJson(BankInfoModel instance) =>
    <String, dynamic>{
      'AccountName': instance.accountName,
      'BankAccount': instance.bankAccount,
      'BankName': instance.bankName,
      'BankCode': instance.bankCode,
    };

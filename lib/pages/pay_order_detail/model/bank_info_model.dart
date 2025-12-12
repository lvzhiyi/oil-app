import 'package:json_annotation/json_annotation.dart';

part 'bank_info_model.g.dart';

/// 对公转账银行信息
@JsonSerializable(fieldRename: FieldRename.pascal)
class BankInfoModel {
  /// 收款户名
  @JsonKey(name: 'AccountName')
  final String? accountName;

  /// 银行账号
  @JsonKey(name: 'BankAccount')
  final String? bankAccount;

  /// 开户银行
  @JsonKey(name: 'BankName')
  final String? bankName;

  /// 联行号
  @JsonKey(name: 'BankCode')
  final String? bankCode;

  BankInfoModel({
    this.accountName,
    this.bankAccount,
    this.bankName,
    this.bankCode,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BankInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankInfoModelToJson(this);
}

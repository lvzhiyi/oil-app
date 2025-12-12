import 'package:json_annotation/json_annotation.dart';

part 'bank_info_model.g.dart';

/// 对公转账银行信息
@JsonSerializable()
class BankInfoModel {
  /// 收款户名
  @JsonKey(name: 'accountName')
  final String? accountName;

  /// 银行账号
  @JsonKey(name: 'bankAccount')
  final String? bankAccount;

  /// 开户银行
  @JsonKey(name: 'bankName')
  final String? bankName;

  /// 联行号
  @JsonKey(name: 'bankCode')
  final String? bankCode;

  const BankInfoModel({
    this.accountName,
    this.bankAccount,
    this.bankName,
    this.bankCode,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BankInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankInfoModelToJson(this);
}

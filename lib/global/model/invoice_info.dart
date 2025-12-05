import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_info.g.dart';

/// 发票类型枚举
enum InvoiceType {
  @JsonValue('special_vat')
  specialVat, // 增值税专用发票
  @JsonValue('general_vat')
  normalVat, // 增值税普通发票
}

/// 发票类型扩展
extension InvoiceTypeExtension on InvoiceType {
  String get displayName {
    switch (this) {
      case InvoiceType.specialVat:
        return '增值税专用发票';
      case InvoiceType.normalVat:
        return '增值税普通发票';
    }
  }

  String get value {
    switch (this) {
      case InvoiceType.specialVat:
        return 'special_vat';
      case InvoiceType.normalVat:
        return 'general_vat';
    }
  }

  static InvoiceType? fromValue(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'special_vat':
        return InvoiceType.specialVat;
      case 'general_vat':
        return InvoiceType.normalVat;
      default:
        return null;
    }
  }
}

/// 发票信息模型
@JsonSerializable()
class InvoiceInfo {
  final String? invoiceTitle;
  final String? taxNumber;
  final String? bankName;
  final String? bankAccount;
  final String? companyAddress;
  final String? companyPhone;
  final String? invoiceType;

  InvoiceInfo({
    this.invoiceTitle,
    this.taxNumber,
    this.bankName,
    this.bankAccount,
    this.companyAddress,
    this.companyPhone,
    this.invoiceType,
  });

  factory InvoiceInfo.fromJson(Map<String, dynamic> json) =>
      _$InvoiceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceInfoToJson(this);

  InvoiceInfo copyWith({
    String? invoiceTitle,
    String? taxNumber,
    String? bankName,
    String? bankAccount,
    String? companyAddress,
    String? companyPhone,
    String? invoiceType,
  }) {
    return InvoiceInfo(
      invoiceTitle: invoiceTitle ?? this.invoiceTitle,
      taxNumber: taxNumber ?? this.taxNumber,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone: companyPhone ?? this.companyPhone,
      invoiceType: invoiceType ?? this.invoiceType,
    );
  }
}

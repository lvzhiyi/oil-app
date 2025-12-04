/// 更新发票信息请求
class UpdateInvoiceRequest {
  final String invoiceTitle;
  final String taxNumber;
  final String bankName;
  final String bankAccount;
  final String companyAddress;
  final String companyPhone;
  final String invoiceType;

  UpdateInvoiceRequest({
    required this.invoiceTitle,
    required this.taxNumber,
    required this.bankName,
    required this.bankAccount,
    required this.companyAddress,
    required this.companyPhone,
    required this.invoiceType,
  });

  Map<String, dynamic> toJson() => {
        'invoiceTitle': invoiceTitle,
        'taxNumber': taxNumber,
        'bankName': bankName,
        'bankAccount': bankAccount,
        'companyAddress': companyAddress,
        'companyPhone': companyPhone,
        'invoiceType': invoiceType,
      };

  UpdateInvoiceRequest copyWith({
    String? invoiceTitle,
    String? taxNumber,
    String? bankName,
    String? bankAccount,
    String? companyAddress,
    String? companyPhone,
    String? invoiceType,
  }) =>
      UpdateInvoiceRequest(
        invoiceTitle: invoiceTitle ?? this.invoiceTitle,
        taxNumber: taxNumber ?? this.taxNumber,
        bankName: bankName ?? this.bankName,
        bankAccount: bankAccount ?? this.bankAccount,
        companyAddress: companyAddress ?? this.companyAddress,
        companyPhone: companyPhone ?? this.companyPhone,
        invoiceType: invoiceType ?? this.invoiceType,
      );
}

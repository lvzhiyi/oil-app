import 'package:oil_business_app/global/model/invoice_info.dart';

class InvoiceEditState {
  final int stationId;
  final String stationName;
  final String invoiceTitle;
  final String taxNumber;
  final String bankName;
  final String bankAccount;
  final String companyAddress;
  final String companyPhone;
  final String invoiceType;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final InvoiceInfo? originalInvoice;
  final String? invoiceTitleError;
  final String? taxNumberError;
  final String? bankNameError;
  final String? bankAccountError;
  final String? companyAddressError;
  final String? companyPhoneError;

  InvoiceEditState({
    required this.stationId,
    this.stationName = '',
    this.invoiceTitle = '',
    this.taxNumber = '',
    this.bankName = '',
    this.bankAccount = '',
    this.companyAddress = '',
    this.companyPhone = '',
    this.invoiceType = 'general_vat', // 默认选中增值税专用发票
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.originalInvoice,
    this.invoiceTitleError,
    this.taxNumberError,
    this.bankNameError,
    this.bankAccountError,
    this.companyAddressError,
    this.companyPhoneError,
  });

  InvoiceEditState copyWith({
    int? stationId,
    String? stationName,
    String? invoiceTitle,
    String? taxNumber,
    String? bankName,
    String? bankAccount,
    String? companyAddress,
    String? companyPhone,
    String? invoiceType,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    InvoiceInfo? originalInvoice,
    String? invoiceTitleError,
    String? taxNumberError,
    String? bankNameError,
    String? bankAccountError,
    String? companyAddressError,
    String? companyPhoneError,
  }) {
    return InvoiceEditState(
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      invoiceTitle: invoiceTitle ?? this.invoiceTitle,
      taxNumber: taxNumber ?? this.taxNumber,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone: companyPhone ?? this.companyPhone,
      invoiceType: invoiceType ?? this.invoiceType,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      originalInvoice: originalInvoice ?? this.originalInvoice,
      invoiceTitleError: invoiceTitleError,
      taxNumberError: taxNumberError,
      bankNameError: bankNameError,
      bankAccountError: bankAccountError,
      companyAddressError: companyAddressError,
      companyPhoneError: companyPhoneError,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/model/invoice_info.dart';
import 'package:oil_business_app/global/model/invoice_req_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/invoice_validator.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class InvoiceEditCtrl extends Cubit<InvoiceEditState> {
  InvoiceEditCtrl({required int stationId, InvoiceInfo? invoice})
      : super(InvoiceEditState(stationId: stationId)) {
    if (invoice != null) {
      _initFromInvoice(invoice);
    }
  }

  void _initFromInvoice(InvoiceInfo invoice) {
    emit(state.copyWith(
      invoiceTitle: invoice.invoiceTitle ?? '',
      taxNumber: invoice.taxNumber ?? '',
      bankName: invoice.bankName ?? '',
      bankAccount: invoice.bankAccount ?? '',
      companyAddress: invoice.companyAddress ?? '',
      companyPhone: invoice.companyPhone ?? '',
      invoiceType: invoice.invoiceType ?? '',
      originalInvoice: invoice,
    ));
  }

  void updateInvoiceTitle(String value) {
    emit(state.copyWith(
        invoiceTitle: value, hasError: false, errorMessage: null));
  }

  void updateTaxNumber(String value) {
    emit(state.copyWith(taxNumber: value, hasError: false, errorMessage: null));
  }

  void updateBankName(String value) {
    emit(state.copyWith(bankName: value, hasError: false, errorMessage: null));
  }

  void updateBankAccount(String value) {
    emit(state.copyWith(
        bankAccount: value, hasError: false, errorMessage: null));
  }

  void updateCompanyAddress(String value) {
    emit(state.copyWith(
        companyAddress: value, hasError: false, errorMessage: null));
  }

  void updateCompanyPhone(String value) {
    emit(state.copyWith(
        companyPhone: value, hasError: false, errorMessage: null));
  }

  void updateInvoiceType(String value) {
    emit(state.copyWith(
        invoiceType: value, hasError: false, errorMessage: null));
  }

  /// 验证表单
  String? validate() {
    String? error;

    error = InvoiceValidator.validateInvoiceTitle(state.invoiceTitle);
    if (error != null) return error;

    error = InvoiceValidator.validateTaxNumber(state.taxNumber);
    if (error != null) return error;

    error = InvoiceValidator.validateBankName(state.bankName);
    if (error != null) return error;

    error = InvoiceValidator.validateBankAccount(state.bankAccount);
    if (error != null) return error;

    error = InvoiceValidator.validateCompanyAddress(state.companyAddress);
    if (error != null) return error;

    error = InvoiceValidator.validateCompanyPhone(state.companyPhone);
    if (error != null) return error;

    error = InvoiceValidator.validateInvoiceType(state.invoiceType);
    if (error != null) return error;

    return null;
  }

  /// 保存发票信息
  Future<bool> save(BuildContext context) async {
    final error = validate();
    if (error != null) {
      emit(state.copyWith(hasError: true, errorMessage: error));
      return false;
    }

    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));

    try {
      final request = UpdateInvoiceRequest(
        invoiceTitle: state.invoiceTitle,
        taxNumber: state.taxNumber,
        bankName: state.bankName,
        bankAccount: state.bankAccount,
        companyAddress: state.companyAddress,
        companyPhone: state.companyPhone,
        invoiceType: state.invoiceType,
      );

      await stationService.updateStationInvoice(state.stationId, request);

      l.d('InvoiceEditCtrl', '保存发票信息成功: ${state.stationId}');

      emit(state.copyWith(isLoading: false, hasError: false));

      SportsToast.showSuccess('保存成功');
      BaseRouter.pop(result: {'refresh': true});
      return true;
    } catch (e) {
      l.e('InvoiceEditCtrl', '保存发票信息失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '保存失败，请稍后重试',
      ));
      SportsToast.showError('保存失败，请稍后重试');
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/model/invoice_req_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/invoice_validator.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class InvoiceEditCtrl extends Cubit<InvoiceEditState> {
  InvoiceEditCtrl({
    required int stationId,
    String? stationName,
  }) : super(InvoiceEditState(
          stationId: stationId,
          stationName: stationName ?? '',
        )) {
    // 始终从接口加载发票信息
    loadStationDetail(stationId);
  }

  /// 加载加油站详情（包含发票信息）
  Future<void> loadStationDetail(int stationId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await stationService.getStationDetail(stationId);

      emit(state.copyWith(
        stationName: response.stationName ?? '',
        invoiceTitle: response.invoiceTitle ?? '',
        taxNumber: response.taxNumber ?? '',
        bankName: response.bankName ?? '',
        bankAccount: response.bankAccount ?? '',
        companyAddress: response.companyAddress ?? '',
        companyPhone: response.companyPhone ?? '',
        invoiceType: response.invoiceType ?? 'general_vat', // 默认选中增值税普通发票
        isLoading: false,
      ));
    } catch (e) {
      l.e('InvoiceEditCtrl', '加载加油站详情失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: '加载失败，请稍后重试',
      ));
    }
  }

  void updateInvoiceTitle(String value) {
    emit(state.copyWith(
      invoiceTitle: value,
      hasError: false,
      errorMessage: null,
      invoiceTitleError: null,
    ));
  }

  void updateTaxNumber(String value) {
    emit(state.copyWith(
      taxNumber: value,
      hasError: false,
      errorMessage: null,
      taxNumberError: null,
    ));
  }

  void updateBankName(String value) {
    emit(state.copyWith(
      bankName: value,
      hasError: false,
      errorMessage: null,
      bankNameError: null,
    ));
  }

  void updateBankAccount(String value) {
    emit(state.copyWith(
      bankAccount: value,
      hasError: false,
      errorMessage: null,
      bankAccountError: null,
    ));
  }

  void updateCompanyAddress(String value) {
    emit(state.copyWith(
      companyAddress: value,
      hasError: false,
      errorMessage: null,
      companyAddressError: null,
    ));
  }

  void updateCompanyPhone(String value) {
    emit(state.copyWith(
      companyPhone: value,
      hasError: false,
      errorMessage: null,
      companyPhoneError: null,
    ));
  }

  void updateInvoiceType(String value) {
    emit(state.copyWith(
      invoiceType: value,
      hasError: false,
      errorMessage: null,
      bankNameError: null,
      bankAccountError: null,
      companyAddressError: null,
      companyPhoneError: null,
    ));
  }

  bool _validateAndMarkErrors() {
    final isSpecialVat = state.invoiceType == 'special_vat';

    final String? invoiceTitleError =
        InvoiceValidator.validateInvoiceTitle(state.invoiceTitle);
    final String? taxNumberError =
        InvoiceValidator.validateTaxNumber(state.taxNumber);
    final String? invoiceTypeError =
        InvoiceValidator.validateInvoiceType(state.invoiceType);

    String? bankNameError;
    String? bankAccountError;
    String? companyAddressError;
    String? companyPhoneError;

    if (isSpecialVat) {
      bankNameError = InvoiceValidator.validateBankName(state.bankName);
      bankAccountError = InvoiceValidator.validateBankAccount(state.bankAccount);
      companyAddressError =
          InvoiceValidator.validateCompanyAddress(state.companyAddress);
      companyPhoneError =
          InvoiceValidator.validateCompanyPhone(state.companyPhone);
    }

    String? firstError;
    for (final err in [
      invoiceTitleError,
      taxNumberError,
      invoiceTypeError,
      bankNameError,
      bankAccountError,
      companyAddressError,
      companyPhoneError,
    ]) {
      if (err != null) {
        firstError = err;
        break;
      }
    }

    final hasError = firstError != null;

    emit(state.copyWith(
      hasError: hasError,
      errorMessage: firstError,
      invoiceTitleError: invoiceTitleError,
      taxNumberError: taxNumberError,
      bankNameError: bankNameError,
      bankAccountError: bankAccountError,
      companyAddressError: companyAddressError,
      companyPhoneError: companyPhoneError,
    ));

    return !hasError;
  }

  /// 保存发票信息
  Future<bool> save(BuildContext context) async {
    final isValid = _validateAndMarkErrors();
    if (!isValid) return false;

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

      emit(state.copyWith(
        isLoading: false,
        hasError: false,
        errorMessage: null,
        invoiceTitleError: null,
        taxNumberError: null,
        bankNameError: null,
        bankAccountError: null,
        companyAddressError: null,
        companyPhoneError: null,
      ));

      // 显示成功提示
      if (context.mounted) {
        SportsToast.showSuccess('保存成功', duration: 2000);
        await Future.delayed(const Duration(milliseconds: 1000));
        BaseRouter.pop(result: {'refresh': true});
      }

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

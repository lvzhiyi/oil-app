import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/invoice_edit/controller.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';
import 'package:oil_business_app/pages/invoice_edit/widgets/station_relation_card.dart';
import 'package:oil_business_app/pages/invoice_edit/widgets/invoice_type_segmented_control.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class InvoiceEditForm extends StatefulWidget {
  final InvoiceEditState state;
  final InvoiceEditCtrl controller;

  const InvoiceEditForm({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<InvoiceEditForm> createState() => _InvoiceEditFormState();
}

class _InvoiceEditFormState extends State<InvoiceEditForm> {
  late TextEditingController _invoiceTitleController;
  late TextEditingController _taxNumberController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountController;
  late TextEditingController _companyAddressController;
  late TextEditingController _companyPhoneController;

  @override
  void initState() {
    super.initState();
    _invoiceTitleController =
        TextEditingController(text: widget.state.invoiceTitle);
    _taxNumberController = TextEditingController(text: widget.state.taxNumber);
    _bankNameController = TextEditingController(text: widget.state.bankName);
    _bankAccountController =
        TextEditingController(text: widget.state.bankAccount);
    _companyAddressController =
        TextEditingController(text: widget.state.companyAddress);
    _companyPhoneController =
        TextEditingController(text: widget.state.companyPhone);
  }

  @override
  void didUpdateWidget(InvoiceEditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.invoiceTitle != widget.state.invoiceTitle) {
      _invoiceTitleController.text = widget.state.invoiceTitle;
    }
    if (oldWidget.state.taxNumber != widget.state.taxNumber) {
      _taxNumberController.text = widget.state.taxNumber;
    }
    if (oldWidget.state.bankName != widget.state.bankName) {
      _bankNameController.text = widget.state.bankName;
    }
    if (oldWidget.state.bankAccount != widget.state.bankAccount) {
      _bankAccountController.text = widget.state.bankAccount;
    }
    if (oldWidget.state.companyAddress != widget.state.companyAddress) {
      _companyAddressController.text = widget.state.companyAddress;
    }
    if (oldWidget.state.companyPhone != widget.state.companyPhone) {
      _companyPhoneController.text = widget.state.companyPhone;
    }
  }

  @override
  void dispose() {
    _invoiceTitleController.dispose();
    _taxNumberController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _companyAddressController.dispose();
    _companyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomAppColor.of(context).txtBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CommonText(
          text: '发票信息',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.setHeight(16)),
                StationRelationCard(
                  stationName: widget.state.stationName,
                ),
                SizedBox(height: AppSizes.setHeight(16)),
                _buildFormCard(context),
                SizedBox(height: AppSizes.setHeight(16)),
                Center(
                  child: CommonText(
                    text: '请确保信息与营业执照一致，否则可能导致无法开票',
                    fontSize: AppSizes.setFontSize(12),
                    textColor: const Color(0xFF9CA3AF),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppSizes.setHeight(80)),
              ],
            ),
          ),
        ),
        _buildBottomButton(context),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('发票类型', isRequired: true),
          SizedBox(height: AppSizes.setHeight(8)),
          InvoiceTypeSegmentedControl(
            selectedType: widget.state.invoiceType.isEmpty
                ? null
                : widget.state.invoiceType,
            onTypeChanged: (value) {
              widget.controller.updateInvoiceType(value);
            },
          ),
          SizedBox(height: AppSizes.setHeight(24)),
          _buildField('发票抬头 (公司名称)', _invoiceTitleController, '请输入单位全称',
              (v) => widget.controller.updateInvoiceTitle(v ?? '')),
          _buildField('纳税人识别号', _taxNumberController, '15-20位统一社会信用代码',
              (v) => widget.controller.updateTaxNumber(v ?? ''),
              isMonospace: true),
          _buildDivider('银行及地址信息'),
          _buildField('开户银行', _bankNameController, '如：招商银行成都分行',
              (v) => widget.controller.updateBankName(v ?? '')),
          _buildField('银行账号', _bankAccountController, '请输入对公账户号码',
              (v) => widget.controller.updateBankAccount(v ?? ''),
              keyboardType: TextInputType.number, isMonospace: true),
          _buildField('公司地址', _companyAddressController, '请输入公司地址',
              (v) => widget.controller.updateCompanyAddress(v ?? ''),
              maxLines: 2),
          _buildField('公司电话', _companyPhoneController, '请输入预留固定电话或手机号',
              (v) => widget.controller.updateCompanyPhone(v ?? ''),
              keyboardType: TextInputType.phone,
              isMonospace: true,
              isLast: true),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint,
    Function(String?) onChanged, {
    TextInputType? keyboardType,
    bool isMonospace = false,
    int maxLines = 1,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.setHeight(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, isRequired: true),
          SizedBox(height: AppSizes.setHeight(8)),
          _buildTextField(controller, hint, onChanged,
              keyboardType: keyboardType,
              isMonospace: isMonospace,
              maxLines: maxLines),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    Function(String?) onChanged, {
    TextInputType? keyboardType,
    bool isMonospace = false,
    int maxLines = 1,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return Container(
            decoration: BoxDecoration(
              color: hasFocus ? Colors.white : const Color(0xFFF9FAFB),
              border: Border.all(
                color: hasFocus
                    ? const Color(0xFF7165E3)
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              boxShadow: hasFocus
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7165E3).withValues(alpha: 0.1),
                        blurRadius: 0,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: AppSizes.setFontSize(15),
                color: const Color(0xFF1F2937),
                fontFamily: isMonospace ? 'monospace' : null,
                letterSpacing: isMonospace ? 0.5 : null,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: AppSizes.setFontSize(15),
                  color: const Color(0xFF9CA3AF),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(12),
                  vertical: AppSizes.setHeight(12),
                ),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(12),
        bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.state.hasError && widget.state.errorMessage != null)
              Container(
                padding: EdgeInsets.all(AppSizes.setWidth(12)),
                margin: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context).red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppSizes.setWidth(16),
                      color: CustomAppColor.of(context).red,
                    ),
                    SizedBox(width: AppSizes.setWidth(8)),
                    Expanded(
                      child: CommonText(
                        text: widget.state.errorMessage!,
                        fontSize: AppSizes.setFontSize(13),
                        textColor: CustomAppColor.of(context).red,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            CommonButton(
              isLoading: widget.state.isLoading,
              btnText: '保存配置',
              radius: 28,
              pVertical: AppSizes.setHeight(14),
              fontSize: AppSizes.setFontSize(16),
              onTap: () {
                widget.controller.save(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: AppSizes.setFontSize(13),
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: text),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(String label) {
    return Container(
      margin: EdgeInsets.only(
        top: AppSizes.setHeight(4),
        bottom: AppSizes.setHeight(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 1,
                color: const Color(0xFFF3F4F6),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(right: AppSizes.setWidth(8)),
              color: Colors.white,
              child: CommonText(
                text: label,
                fontSize: AppSizes.setFontSize(12),
                fontWeight: FontWeight.w600,
                textColor: const Color(0xFF7165E3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

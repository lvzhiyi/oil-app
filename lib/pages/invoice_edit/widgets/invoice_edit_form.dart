import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/invoice_edit/controller.dart';
import 'package:oil_business_app/pages/invoice_edit/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

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
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.setHeight(16)),
              _buildFormSection(
                context: context,
                title: '发票信息',
                children: [
                  _buildInputWrapper(
                    context: context,
                    label: '发票抬头',
                    child: CommonTextFormField(
                      controller: _invoiceTitleController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入发票抬头',
                      onChanged: (value) =>
                          widget.controller.updateInvoiceTitle(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '税号',
                    child: CommonTextFormField(
                      controller: _taxNumberController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入税号',
                      onChanged: (value) =>
                          widget.controller.updateTaxNumber(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '开户银行',
                    child: CommonTextFormField(
                      controller: _bankNameController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入开户银行',
                      onChanged: (value) =>
                          widget.controller.updateBankName(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '银行账号',
                    child: CommonTextFormField(
                      controller: _bankAccountController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入银行账号',
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          widget.controller.updateBankAccount(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '公司地址',
                    child: CommonTextFormField(
                      controller: _companyAddressController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入公司地址',
                      onChanged: (value) =>
                          widget.controller.updateCompanyAddress(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '公司电话',
                    child: CommonTextFormField(
                      controller: _companyPhoneController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入公司电话',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) =>
                          widget.controller.updateCompanyPhone(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '发票类型',
                    child: _buildInvoiceTypeDropdown(context),
                  ),
                ],
              ),
              if (widget.state.hasError && widget.state.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(AppSizes.setWidth(12)),
                  margin: EdgeInsets.only(top: AppSizes.setHeight(16)),
                  decoration: BoxDecoration(
                    color:
                        CustomAppColor.of(context).red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                  ),
                  child: CommonText(
                    text: widget.state.errorMessage!,
                    fontSize: AppSizes.setFontSize(14),
                    textColor: CustomAppColor.of(context).red,
                    textAlign: TextAlign.left,
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
                child: CommonButton(
                  isLoading: widget.state.isLoading,
                  btnText: '保存',
                  radius: 28,
                  pVertical: AppSizes.setHeight(14),
                  fontSize: AppSizes.setFontSize(16),
                  onTap: () {
                    widget.controller.save(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceTypeDropdown(BuildContext context) {
    final invoiceTypes = [
      {'value': 'special_vat', 'label': '增值税专用发票'},
      {'value': 'normal_vat', 'label': '增值税普通发票'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CustomAppColor.of(context).textFieldBorder,
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue:
            widget.state.invoiceType.isEmpty ? null : widget.state.invoiceType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(16),
            vertical: AppSizes.setHeight(12),
          ),
          border: InputBorder.none,
          hintText: '请选择发票类型',
          hintStyle: TextStyle(
            color: const Color(0xFF9CA3AF),
            fontSize: AppSizes.setFontSize(14),
          ),
        ),
        items: invoiceTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type['value'],
            child: CommonText(
              text: type['label']!,
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtBlack,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            widget.controller.updateInvoiceType(value);
          }
        },
      ),
    );
  }

  Widget _buildFormSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final colors = CustomAppColor.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      decoration: BoxDecoration(
        color: colors.bgContainer,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(16)),
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
          Row(
            children: [
              Container(
                width: AppSizes.setWidth(4),
                height: AppSizes.setHeight(14),
                decoration: BoxDecoration(
                  color: colors.btnPurple,
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(2)),
                ),
              ),
              SizedBox(width: AppSizes.setWidth(6)),
              CommonText(
                text: title,
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w700,
                textColor: colors.txtBlack,
              ),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputWrapper({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.setHeight(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: label,
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w500,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          child,
        ],
      ),
    );
  }
}

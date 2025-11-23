import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class VehicleInfoForm extends StatelessWidget {
  final TextEditingController driverNameController;
  final TextEditingController plateNumberController;
  final TextEditingController idCardController;
  final TextEditingController phoneController;
  final TextEditingController oilAmountController; // Optional, for "parsed" amount display/edit

  const VehicleInfoForm({
    Key? key,
    required this.driverNameController,
    required this.plateNumberController,
    required this.idCardController,
    required this.phoneController,
    required this.oilAmountController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '车辆及司机信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildTextField(
            context,
            label: '车牌号码',
            controller: plateNumberController,
            hint: '请输入车牌号',
            isRequired: true,
            validator: (v) => v == null || v.isEmpty ? '请输入车牌号' : null,
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          _buildTextField(
            context,
            label: '司机姓名',
            controller: driverNameController,
            hint: '请输入司机姓名',
            isRequired: true,
            validator: (v) => v == null || v.isEmpty ? '请输入司机姓名' : null,
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          _buildTextField(
            context,
            label: '身份证号',
            controller: idCardController,
            hint: '请输入司机身份证号',
            isRequired: true,
            validator: (v) => v == null || v.isEmpty ? '请输入司机身份证号' : null,
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          _buildTextField(
            context,
            label: '联系电话',
            controller: phoneController,
            hint: '请输入司机电话',
            isRequired: true,
            inputType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return '请输入司机电话';
              }
              // Simple China mobile phone regex
              if (!RegExp(r'^1[1-9]\d{9}$').hasMatch(v)) {
                return '请输入正确的手机号';
              }
              return null;
            },
          ),
           // Optional: Display parsed oil amount if useful, or keep hidden if it confuses with the main input
           // Decided to omit for now to avoid conflict with the main "Withdraw Amount" input at the top of the screen.
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRequired = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtGrey,
            ),
            if (isRequired)
              CommonText(
                text: '*',
                fontSize: AppSizes.setFontSize(14),
                textColor: CustomAppColor.of(context).red,
              ),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: AppSizes.setFontSize(14),
            color: CustomAppColor.of(context).txtBlack,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppSizes.setFontSize(14),
              color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.4),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.setWidth(12),
              vertical: AppSizes.setHeight(12),
            ),
            filled: true,
            fillColor: CustomAppColor.of(context).bgScaffold,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              borderSide: BorderSide(
                color: CustomAppColor.of(context).txtBlue,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              borderSide: BorderSide(
                color: CustomAppColor.of(context).red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
              borderSide: BorderSide(
                color: CustomAppColor.of(context).red,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

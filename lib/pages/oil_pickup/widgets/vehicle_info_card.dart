import 'package:flutter/material.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

class VehicleInfoCard extends StatelessWidget {
  final VehicleModel? vehicleModel;
  final String vehicleInfo;
  final List<String> missingFields;
  final bool parseSuccess;
  final String? errorMessage;
  final TextEditingController controller;
  final Function(String) onChanged;

  const VehicleInfoCard({
    Key? key,
    this.vehicleModel,
    this.vehicleInfo = '',
    this.missingFields = const [],
    this.parseSuccess = false,
    this.errorMessage,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '粘贴车辆信息',
          fontSize: AppSizes.setFontSize(16),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        CommonTextFormField(
          controller: controller,
          hintText: '请粘贴车辆信息文本...',
          maxLines: 8,
          onChanged: (value) {
            if (value != null && value.isNotEmpty) {
              onChanged(value);
            }
          },
        ),
        if (parseSuccess && vehicleModel != null) ...[
          SizedBox(height: AppSizes.setHeight(16)),
          _buildParsedInfo(context),
        ],
        if (missingFields.isNotEmpty) ...[
          SizedBox(height: AppSizes.setHeight(12)),
          Container(
            padding: EdgeInsets.all(AppSizes.setWidth(12)),
            decoration: BoxDecoration(
              color:
                  CustomAppColor.of(context).txtOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
            ),
            child: CommonText(
              text: '缺少必填字段: ${missingFields.join(', ')}',
              fontSize: AppSizes.setFontSize(12),
              textColor: CustomAppColor.of(context).txtOrange,
              textAlign: TextAlign.left,
            ),
          ),
        ],
        if (errorMessage != null && !parseSuccess) ...[
          SizedBox(height: AppSizes.setHeight(12)),
          Container(
            padding: EdgeInsets.all(AppSizes.setWidth(12)),
            decoration: BoxDecoration(
              color: CustomAppColor.of(context).red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
            ),
            child: CommonText(
              text: errorMessage!,
              fontSize: AppSizes.setFontSize(12),
              textColor: CustomAppColor.of(context).red,
              textAlign: TextAlign.left,
            ),
          ),
        ],
        // if (vehicleInfo.isNotEmpty && parseSuccess) ...[
        //   SizedBox(height: AppSizes.setHeight(16)),
        //   ExpansionTile(
        //     title: CommonText(
        //       text: '查看完整 JSON',
        //       fontSize: AppSizes.setFontSize(14),
        //       fontWeight: FontWeight.w500,
        //       textColor: CustomAppColor.of(context).txtPurple,
        //       textAlign: TextAlign.left,
        //     ),
        //     children: [
        //       Container(
        //         padding: EdgeInsets.all(AppSizes.setWidth(12)),
        //         decoration: BoxDecoration(
        //           color: CustomAppColor.of(context).bgContainer,
        //           borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
        //         ),
        //         child: SelectableText(
        //           vehicleInfo,
        //           style: TextStyle(
        //             fontFamily: 'monospace',
        //             fontSize: AppSizes.setFontSize(12),
        //             color: CustomAppColor.of(context).txtBlack,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      ],
    );
  }

  Widget _buildParsedInfo(BuildContext context) {
    final model = vehicleModel!;
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).bgContainer,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '识别结果',
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w600,
            textColor: CustomAppColor.of(context).txtBlack,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          if (model.driverName != null)
            _buildInfoRow(context, '驾驶员姓名', model.driverName!),
          if (model.plateNumber != null)
            _buildInfoRow(context, '车号', model.plateNumber!),
          if (model.oilAmount != null)
            _buildInfoRow(context, '提油吨位', '${model.oilAmount}吨'),
          if (model.driverPhone != null)
            _buildInfoRow(context, '驾驶员电话', model.driverPhone!),
          if (model.driverIdCard != null)
            _buildInfoRow(context, '身份证号', model.driverIdCard!),
          if (model.date != null) _buildInfoRow(context, '日期', model.date!),
          if (model.oilType != null)
            _buildInfoRow(context, '油品', model.oilType!),
          if (model.oilSource != null)
            _buildInfoRow(context, '油库', model.oilSource!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(80),
            child: CommonText(
              text: '$label:',
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtGrey,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: CommonText(
              text: value,
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/pages/bind_station/controller.dart';
import 'package:oil_business_app/pages/bind_station/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class BindStationScreen extends StatelessWidget {
  const BindStationScreen({super.key, required this.extra});
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BindStationCtrl, BindStationState>(
      builder: (context, state) {
        final ctrl = context.read<BindStationCtrl>();
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.setHeight(20)),
                    // 返回按钮
                    if (extra?['isFromLogin'] == true)
                      InkWell(
                        onTap: () => BaseRouter.pop(),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: AppSizes.setWidth(20),
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ),
                    // 品牌头部
                    Column(
                      children: [
                        // Logo 盒子
                        Container(
                          width: AppSizes.setWidth(64),
                          height: AppSizes.setHeight(64),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B)
                                    .withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              AssetsImg.LOGO,
                              width: AppSizes.setWidth(32),
                              height: AppSizes.setHeight(32),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.setHeight(16)),
                        CommonText(
                          text: '绑定加油站',
                          fontWeight: FontWeight.w700,
                          fontSize: AppSizes.setFontSize(24),
                          textColor: const Color(0xFF1F2937),
                        ),
                        SizedBox(height: AppSizes.setHeight(8)),
                        CommonText(
                          text: '请完善加油站信息以完成企业入驻',
                          fontWeight: FontWeight.w400,
                          fontSize: AppSizes.setFontSize(14),
                          textColor: const Color(0xFF6B7280),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.setHeight(32)),
                    FormBuilder(
                      key: ctrl.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonTextFormField(
                            name: 'stationName',
                            validators: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: '请输入加油站名称'),
                              FormBuilderValidators.minLength(2,
                                  errorText: '加油站名称至少2个字符'),
                            ]),
                            borderColor: const Color(0xFFE5E7EB),
                            fillColor: const Color(0xFFF9FAFB),
                            leadingIcon: Image.asset(
                              AssetsIcon.IC_PROFILE,
                              width: AppSizes.setHeight(20),
                              height: AppSizes.setHeight(20),
                            ),
                            hintText: '加油站名称',
                            radius: 12,
                          ),
                          SizedBox(height: AppSizes.setHeight(16)),
                          CommonCityPickerFormField(
                            name: 'city',
                            hintText: '选择省/市/区',
                            controller: ctrl.cityController,
                            onChanged: (value) {
                              ctrl.provinceName = value[0];
                              ctrl.cityName = value[1];
                              ctrl.areaName = value[2];
                              ctrl.provinceCode = value[3];
                              ctrl.cityCode = value[4];
                              ctrl.areaCode = value[5];
                            },
                            borderColor: const Color(0xFFE5E7EB),
                            fillColor: const Color(0xFFF9FAFB),
                            radius: 12,
                          ),
                          SizedBox(height: AppSizes.setHeight(16)),
                          CommonTextFormField(
                            name: 'addressDetail',
                            borderColor: const Color(0xFFE5E7EB),
                            fillColor: const Color(0xFFF9FAFB),
                            leadingIcon: Image.asset(
                              AssetsIcon.IC_BANK,
                              width: AppSizes.setHeight(20),
                              height: AppSizes.setHeight(20),
                            ),
                            hintText: '详细地址 (街道/门牌号)',
                            radius: 12,
                          ),
                          SizedBox(height: AppSizes.setHeight(16)),
                          // 上传营业执照卡片
                          _buildUploadCard(
                            context: context,
                            title: '上传营业执照',
                            hint: '支持 JPG, PNG 格式，最大 5MB',
                            icon: Icons.image_outlined,
                            imageUrl: state.businessLicenseUrl,
                            onImageChanged: (value) {
                              ctrl.updateBusinessLicense(value ?? '');
                              // 同步更新表单字段
                              final formState = ctrl.formKey.currentState;
                              if (formState != null && value != null) {
                                formState.fields['businessLicenseUrl']
                                    ?.didChange(value);
                              }
                            },
                          ),
                          SizedBox(height: AppSizes.setHeight(16)),
                          // 上传成品油零售许可卡片
                          _buildUploadCard(
                            context: context,
                            title: '上传成品油零售许可',
                            hint: '请确保文字清晰可见',
                            icon: Icons.description_outlined,
                            imageUrl: state.fuelRetailPermitUrl,
                            onImageChanged: (value) {
                              ctrl.updateFuelRetailPermit(value ?? '');
                              // 同步更新表单字段
                              final formState = ctrl.formKey.currentState;
                              if (formState != null && value != null) {
                                formState.fields['fuelRetailPermitUrl']
                                    ?.didChange(value);
                              }
                            },
                          ),
                          SizedBox(height: AppSizes.setHeight(32)),
                          CommonButton(
                            isLoading: state.loading,
                            btnText: '提交审核',
                            radius: 26,
                            onTap: () {
                              ctrl.submit();
                            },
                          ),
                          SizedBox(height: AppSizes.setHeight(20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadCard({
    required BuildContext context,
    required String title,
    required String hint,
    required IconData icon,
    required String imageUrl,
    required ValueChanged<String?> onImageChanged,
  }) {
    final hasImage = imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () async {
        // 直接调用图片选择器
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          onImageChanged(image.path);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: hasImage ? const Color(0xFF7165E3) : const Color(0xFFD1D5DB),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          color: hasImage ? const Color(0xFFF0FDF4) : const Color(0xFFF9FAFB),
        ),
        padding: EdgeInsets.all(AppSizes.setWidth(24)),
        child: hasImage
            ? Row(
                children: [
                  // 图片预览
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageUrl),
                      width: AppSizes.setWidth(80),
                      height: AppSizes.setHeight(80),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: AppSizes.setWidth(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: title,
                          fontSize: AppSizes.setFontSize(14),
                          fontWeight: FontWeight.w600,
                          textColor: const Color(0xFF1F2937),
                        ),
                        SizedBox(height: AppSizes.setHeight(4)),
                        CommonText(
                          text: '已上传',
                          fontSize: AppSizes.setFontSize(12),
                          textColor: const Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                  ),
                  // 重新上传按钮
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920,
                        maxHeight: 1080,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        onImageChanged(image.path);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.setWidth(12),
                        vertical: AppSizes.setHeight(6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.txtPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: CommonText(
                        text: '重新上传',
                        fontSize: AppSizes.setFontSize(12),
                        fontWeight: FontWeight.w600,
                        textColor: AppColor.txtPurple,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: AppSizes.setWidth(48),
                        height: AppSizes.setHeight(48),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: AppColor.txtPurple,
                          size: AppSizes.setWidth(24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.setHeight(12)),
                  CommonText(
                    text: title,
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xFF1F2937),
                  ),
                  SizedBox(height: AppSizes.setHeight(4)),
                  CommonText(
                    text: hint,
                    fontSize: AppSizes.setFontSize(12),
                    textColor: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/bind_station/controller.dart';
import 'package:oil_business_app/pages/bind_station/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';

import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';
import '../../../widgets/common/qualification_image_upload.dart';

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
                            Icons.arrow_back,
                            size: AppSizes.setWidth(20),
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ),
                  // 品牌头部
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Logo 盒子
                          Center(
                            child: Image.asset(
                              AssetsImg.LOGO,
                              width: AppSizes.setWidth(132),
                              height: AppSizes.setHeight(132),
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
                                // 上传营业执照
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: '营业执照',
                                      fontSize: AppSizes.setFontSize(14),
                                      fontWeight: FontWeight.w500,
                                      textColor: const Color(0xFF1F2937),
                                    ),
                                    SizedBox(height: AppSizes.setHeight(8)),
                                    QualificationImageUpload(
                                      imageUrl: state.businessLicenseUrl,
                                      hintText: '点击上传照片',
                                      onChanged: (value) {
                                        ctrl.updateBusinessLicense(value ?? '');
                                        // 同步更新表单字段
                                        final formState = ctrl.formKey.currentState;
                                        if (formState != null && value != null) {
                                          formState.fields['businessLicenseUrl']
                                              ?.didChange(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.setHeight(16)),
                                // 上传成品油零售许可
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: '成品油零售许可',
                                      fontSize: AppSizes.setFontSize(14),
                                      fontWeight: FontWeight.w500,
                                      textColor: const Color(0xFF1F2937),
                                    ),
                                    SizedBox(height: AppSizes.setHeight(8)),
                                    QualificationImageUpload(
                                      imageUrl: state.fuelRetailPermitUrl,
                                      hintText: '点击上传照片',
                                      onChanged: (value) {
                                        ctrl.updateFuelRetailPermit(value ?? '');
                                        // 同步更新表单字段
                                        final formState = ctrl.formKey.currentState;
                                        if (formState != null && value != null) {
                                          formState.fields['fuelRetailPermitUrl']
                                              ?.didChange(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.setHeight(32)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
          ),
        );
      },
    );
  }

}

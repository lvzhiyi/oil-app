import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/bind_station/controller.dart';
import 'package:oil_business_app/pages/bind_station/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';
import 'package:oil_business_app/widgets/common/qualification_image_upload.dart';

class BindStationScreen extends StatelessWidget {
  const BindStationScreen({super.key, required this.extra});
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BindStationCtrl, BindStationState>(
      builder: (context, state) {
        final ctrl = context.read<BindStationCtrl>();
        final colors = CustomAppColor.of(context);

        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),
          appBar: AppBar(
            backgroundColor: colors.bgScaffold,
            elevation: 0,
            leading: extra?['isFromLogin'] == true
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: colors.txtBlack,
                    ),
                    onPressed: () => BaseRouter.pop(),
                  )
                : null,
            title: CommonText(
              text: '绑定加油站',
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w600,
              textColor: colors.txtBlack,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                  child: FormBuilder(
                    key: ctrl.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSizes.setHeight(16)),
                        _buildFormSection(
                          context: context,
                          title: '基础信息',
                          children: [
                            _buildInputWrapper(
                              context: context,
                              label: '加油站名称',
                              child: CommonTextFormField(
                                name: 'stationName',
                                validators: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: '请输入加油站名称'),
                                  FormBuilderValidators.minLength(2,
                                      errorText: '加油站名称至少2个字符'),
                                ]),
                                borderColor: colors.textFieldBorder,
                                fillColor: const Color(0xFFF9FAFB),
                                radius: 10,
                                hintText: '请输入加油站名称',
                              ),
                            ),
                            _buildInputWrapper(
                              context: context,
                              label: '所在区域',
                              child: CommonCityPickerFormField(
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
                                borderColor: colors.textFieldBorder,
                                fillColor: Colors.white,
                                radius: 10,
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: AppSizes.setFontSize(20),
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                            _buildInputWrapper(
                              context: context,
                              label: '详细地址',
                              child: CommonTextFormField(
                                name: 'addressDetail',
                                borderColor: colors.textFieldBorder,
                                fillColor: const Color(0xFFF9FAFB),
                                radius: 10,
                                hintText: '请输入详细地址（不含省市区）',
                              ),
                            ),
                          ],
                        ),
                        _buildFormSection(
                          context: context,
                          title: '资质证照',
                          children: [
                            _buildInputWrapper(
                              context: context,
                              label: '营业执照',
                              child: QualificationImageUpload(
                                imageUrl: state.businessLicenseUrl,
                                hintText: '点击上传照片',
                                onChanged: (value) {
                                  ctrl.updateBusinessLicense(value ?? '');
                                  final formState = ctrl.formKey.currentState;
                                  if (formState != null && value != null) {
                                    formState.fields['businessLicenseUrl']
                                        ?.didChange(value);
                                  }
                                },
                              ),
                            ),
                            _buildInputWrapper(
                              context: context,
                              label: '成品油零售许可证',
                              child: QualificationImageUpload(
                                imageUrl: state.fuelRetailPermitUrl,
                                hintText: '点击上传照片',
                                onChanged: (value) {
                                  ctrl.updateFuelRetailPermit(value ?? '');
                                  final formState = ctrl.formKey.currentState;
                                  if (formState != null && value != null) {
                                    formState.fields['fuelRetailPermitUrl']
                                        ?.didChange(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSizes.setWidth(16)),
                decoration: BoxDecoration(
                  color: colors.bgContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: CommonButton(
                    isLoading: state.loading,
                    btnText: '提交审核',
                    radius: 28,
                    pVertical: AppSizes.setHeight(14),
                    fontSize: AppSizes.setFontSize(16),
                    onTap: () {
                      ctrl.submit();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

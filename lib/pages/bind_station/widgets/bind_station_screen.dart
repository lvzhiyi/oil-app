import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/bind_station/controller.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';
import 'package:oil_business_app/widgets/base/textfield/common_img_upload.dart';

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
    final ctrl = context.read<BindStationCtrl>();
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
        child: SingleChildScrollView(
          child: Column(children: [
            InkWell(
              onTap: () => {
                BaseRouter.pop(),
              },
              child: Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(61)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: extra?['isFromLogin'] == true
                      ? Image.asset(
                          AssetsIcon.IC_LEFT_ARROW,
                          width: AppSizes.setWidth(20),
                          height: AppSizes.setHeight(20),
                        )
                      : null,
                ),
              ),
            ),
            Image.asset(
              AssetsImg.LOGO,
              width: AppSizes.setWidth(80),
              height: AppSizes.setHeight(80),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(15)),
              child: CommonText(
                text: '绑定您的加油站',
                fontWeight: FontWeight.w700,
                fontSize: AppSizes.setFontSize(24),
              ),
            ),
            FormBuilder(
              key: ctrl.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
                    child: CommonTextFormField(
                      name: 'stationName',
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入加油站名称'),
                        FormBuilderValidators.minLength(2,
                            errorText: '加油站名称至少2个字符'),
                      ]),
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PROFILE,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '加油站名称',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                    child: CommonCityPickerFormField(
                      name: 'city',
                      hintText: '选择城市 省/市/区',
                      controller: ctrl.cityController,
                      onChanged: (value) {
                        ctrl.provinceName = value[0];
                        ctrl.cityName = value[1];
                        ctrl.areaName = value[2];
                        ctrl.provinceCode = value[3];
                        ctrl.cityCode = value[4];
                        ctrl.areaCode = value[5];
                      },
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PASSWORD,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                    child: CommonTextFormField(
                      name: 'addressDetail',
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_BANK,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '详细地址',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                    child: CommonImgUpload(
                      name: 'businessLicenseUrl',
                      hintText: '上传营业执照',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      radius: 6,
                      onChanged: (value) {
                        ctrl.businessLicenseUrl = value ?? '';
                      },
                      hintStyle: TextStyle(
                        height: AppSizes.setHeight(6),
                        color: CustomAppColor.of(context).txtGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CommonImgUpload(
                    name: 'fuelRetailPermitUrl',
                    hintText: '上传成品油零售许可',
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (value) {
                      ctrl.fuelRetailPermitUrl = value ?? '';
                    },
                    hintStyle: TextStyle(
                      height: AppSizes.setHeight(6),
                      color: CustomAppColor.of(context).txtGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
                    child: CommonButton(
                      isLoading: ctrl.state.loading,
                      btnText: '绑定',
                      onTap: () {
                        ctrl.submit();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

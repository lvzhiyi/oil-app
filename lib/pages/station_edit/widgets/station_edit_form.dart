import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/station_edit/controller.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';
import 'package:oil_business_app/widgets/base/textfield/common_img_upload.dart';

class StationEditForm extends StatefulWidget {
  final StationEditState state;
  final StationEditCtrl controller;

  const StationEditForm({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<StationEditForm> createState() => _StationEditFormState();
}

class _StationEditFormState extends State<StationEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _addressDetailController;
  late TextEditingController _businessLicenseController;
  late TextEditingController _fuelRetailPermitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.name);
    _cityController = TextEditingController(
      text: _buildCityText(),
    );
    _addressDetailController = TextEditingController(text: widget.state.addressDetail);
    _businessLicenseController = TextEditingController(text: widget.state.businessLicenseUrl);
    _fuelRetailPermitController = TextEditingController(text: widget.state.fuelRetailPermitUrl);
  }

  @override
  void didUpdateWidget(StationEditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.name != widget.state.name) {
      _nameController.text = widget.state.name;
    }
    if (oldWidget.state.provinceName != widget.state.provinceName ||
        oldWidget.state.cityName != widget.state.cityName ||
        oldWidget.state.areaName != widget.state.areaName) {
      _cityController.text = _buildCityText();
    }
    if (oldWidget.state.addressDetail != widget.state.addressDetail) {
      _addressDetailController.text = widget.state.addressDetail;
    }
    if (oldWidget.state.businessLicenseUrl != widget.state.businessLicenseUrl) {
      _businessLicenseController.text = widget.state.businessLicenseUrl;
    }
    if (oldWidget.state.fuelRetailPermitUrl != widget.state.fuelRetailPermitUrl) {
      _fuelRetailPermitController.text = widget.state.fuelRetailPermitUrl;
    }
  }

  /// 构建省市区显示文本
  /// 遵循 DRY 原则，统一地址格式化逻辑
  String _buildCityText() {
    final parts = [
      widget.state.provinceName,
      widget.state.cityName,
      widget.state.areaName,
    ].where((part) => part.isNotEmpty);

    return parts.isEmpty ? '' : parts.join(' ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressDetailController.dispose();
    _businessLicenseController.dispose();
    _fuelRetailPermitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
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
          text: widget.state.station == null ? '新增加油站' : '修改加油站',
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
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(16)),
                child: CommonTextFormField(
                  controller: _nameController,
                  borderColor: CustomAppColor.of(context).textFieldBorder,
                  leadingIcon: Image.asset(
                    AssetsIcon.IC_PROFILE,
                    width: AppSizes.setHeight(20),
                    height: AppSizes.setHeight(20),
                  ),
                  hintText: '加油站名称',
                  onChanged: (value) => widget.controller.updateName(value ?? ''),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                child: CommonCityPickerFormField(
                  controller: _cityController,
                  name: 'city',
                  hintText: '选择城市 省/市/区',
                  initialCityData: widget.state.provinceCode.isNotEmpty
                      ? [
                          widget.state.provinceCode,
                          widget.state.cityCode,
                          widget.state.areaCode,
                        ]
                      : null,
                  onChanged: (cityData) {
                    widget.controller.updateCityData(cityData);
                    setState(() {
                      _cityController.text = _buildCityText();
                    });
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
                  controller: _addressDetailController,
                  borderColor: CustomAppColor.of(context).textFieldBorder,
                  leadingIcon: Image.asset(
                    AssetsIcon.IC_BANK,
                    width: AppSizes.setHeight(20),
                    height: AppSizes.setHeight(20),
                  ),
                  hintText: '详细地址',
                  onChanged: (value) => widget.controller.updateAddressDetail(value ?? ''),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
                child: CommonImgUpload(
                  name: 'businessLicenseUrl',
                  controller: _businessLicenseController,
                  hintText: '上传营业执照',
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  radius: 6,
                  onChanged: (value) {
                    widget.controller.updateBusinessLicenseUrl(value ?? '');
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
                controller: _fuelRetailPermitController,
                hintText: '上传成品油零售许可',
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (value) {
                  widget.controller.updateFuelRetailPermitUrl(value ?? '');
                },
                hintStyle: TextStyle(
                  height: AppSizes.setHeight(6),
                  color: CustomAppColor.of(context).txtGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.state.hasError && widget.state.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(AppSizes.setWidth(12)),
                  margin: EdgeInsets.only(top: AppSizes.setHeight(16)),
                  decoration: BoxDecoration(
                    color: CustomAppColor.of(context).red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                  ),
                  child: CommonText(
                    text: widget.state.errorMessage!,
                    fontSize: AppSizes.setFontSize(14),
                    textColor: CustomAppColor.of(context).red,
                    textAlign: TextAlign.left,
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(20)),
                child: CommonButton(
                  isLoading: widget.state.isLoading,
                  btnText: '保存',
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

}


import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/station_edit/controller.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/base/textfield/common_city_picker.dart';
import 'package:oil_business_app/widgets/common/qualification_image_upload.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.name);
    _cityController = TextEditingController(
      text: _buildCityText(),
    );
    _addressDetailController =
        TextEditingController(text: widget.state.addressDetail);
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
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
        child: SingleChildScrollView(
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
                      controller: _nameController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入加油站名称',
                      onChanged: (value) =>
                          widget.controller.updateName(value ?? ''),
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '所在区域',
                    child: CommonCityPickerFormField(
                      controller: _cityController,
                      name: 'city',
                      hintText: '选择省/市/区',
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
                      fillColor: const Color(0xFFF9FAFB),
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
                      controller: _addressDetailController,
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      fillColor: const Color(0xFFF9FAFB),
                      radius: 10,
                      hintText: '请输入详细地址（不含省市区）',
                      onChanged: (value) =>
                          widget.controller.updateAddressDetail(value ?? ''),
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
                      imageUrl: widget.state.businessLicenseUrl,
                      hintText: '点击上传照片',
                      onChanged: (value) {
                        widget.controller.updateBusinessLicenseUrl(value ?? '');
                      },
                    ),
                  ),
                  _buildInputWrapper(
                    context: context,
                    label: '成品油零售许可',
                    child: QualificationImageUpload(
                      imageUrl: widget.state.fuelRetailPermitUrl,
                      hintText: '点击上传照片',
                      onChanged: (value) {
                        widget.controller
                            .updateFuelRetailPermitUrl(value ?? '');
                      },
                    ),
                  ),
                ],
              ),
              if (widget.state.station != null) _buildInvoiceEntry(context),
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
                  isLoading: widget.controller.state.isLoading,
                  btnText: '保存提交',
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

  Widget _buildInvoiceEntry(BuildContext context) {
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
      child: GestureDetector(
        onTap: () {
          BaseRouter.push(
            url: AppPage.invoiceEditPage.path,
            extra: {
              'stationId': widget.state.station?.id,
              'stationName': widget.state.station?.stationName,
            },
          );
        },
        child: Row(
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
            Expanded(
              child: CommonText(
                text: '发票信息',
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w700,
                textColor: colors.txtBlack,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: AppSizes.setFontSize(20),
              color: colors.txtGrey,
            ),
          ],
        ),
      ),
    );
  }
}

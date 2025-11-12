import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/station_edit/controller.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

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
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.name);
    _addressController = TextEditingController(text: widget.state.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '加油站名称',
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w500,
            textColor: CustomAppColor.of(context).txtBlack,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          CommonTextFormField(
            controller: _nameController,
            hintText: '请输入加油站名称',
            onChanged: (value) => widget.controller.updateName(value ?? ''),
          ),
          SizedBox(height: AppSizes.setHeight(20)),
          CommonText(
            text: '加油站地址',
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w500,
            textColor: CustomAppColor.of(context).txtBlack,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          CommonTextFormField(
            controller: _addressController,
            hintText: '请输入加油站地址',
            maxLines: 3,
            onChanged: (value) => widget.controller.updateAddress(value ?? ''),
          ),
          SizedBox(height: AppSizes.setHeight(32)),
          if (widget.state.hasError && widget.state.errorMessage != null)
            Container(
              padding: EdgeInsets.all(AppSizes.setWidth(12)),
              margin: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
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
          CommonButton(
            btnText: '保存',
            height: AppSizes.setHeight(52),
            fontSize: AppSizes.setFontSize(15),
            isLoading: widget.state.isLoading,
            onTap: () => widget.controller.save(context),
          ),
        ],
      ),
    );
  }
}


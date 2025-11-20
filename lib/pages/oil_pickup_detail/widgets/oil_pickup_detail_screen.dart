import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/station_selector_button.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/controller.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';

class OilPickupDetailScreen extends StatefulWidget {
  final OilPickupDetailState state;
  final OilPickupDetailCtrl controller;

  const OilPickupDetailScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<OilPickupDetailScreen> createState() => _OilPickupDetailScreenState();
}

class _OilPickupDetailScreenState extends State<OilPickupDetailScreen> {
  late TextEditingController _oilAmountController;
  late TextEditingController _vehicleInfoController;

  @override
  void initState() {
    super.initState();
    _oilAmountController = TextEditingController(text: widget.state.oilAmount);
    _vehicleInfoController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _oilAmountController.dispose();
    _vehicleInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalUpdateUi(
      builder: (context, appCtrl) {
        final selectedStation = appCtrl.state.selectedStation;
        final currentState = widget.state.copyWith(selectedStation: selectedStation);

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
              text: '提油详情',
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w600,
              textColor: CustomAppColor.of(context).txtBlack,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentState.inventory != null) ...[
                        _buildInventoryInfoCard(context, currentState.inventory!),
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppSizes.setHeight(16)),
                            _buildOilAmountInput(context),
                            SizedBox(height: AppSizes.setHeight(12)),
                            _buildArrowDown(context),
                            SizedBox(height: AppSizes.setHeight(12)),
                            StationSelectorButton(
                              station: currentState.selectedStation,
                              onTap: () => widget.controller.selectStation(context),
                            ),
                            SizedBox(height: AppSizes.setHeight(24)),
                            _buildVehicleInfoInput(context, currentState),
                            SizedBox(height: AppSizes.setHeight(20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: AppSizes.setWidth(16),
                  right: AppSizes.setWidth(16),
                  top: AppSizes.setHeight(12),
                  bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context).bgScaffold,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentState.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.setWidth(12)),
                          margin: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                          decoration: BoxDecoration(
                            color: CustomAppColor.of(context).red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                          ),
                          child: CommonText(
                            text: currentState.errorMessage!,
                            fontSize: AppSizes.setFontSize(14),
                            textColor: CustomAppColor.of(context).red,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      CommonButton(
                        btnText: '生成提油凭证',
                        height: AppSizes.setHeight(52),
                        fontSize: AppSizes.setFontSize(15),
                        isLoading: currentState.isLoading,
                        onTap: () {
                          final currentOilAmount = _oilAmountController.text.trim();
                          widget.controller.generateCertificate(context, currentOilAmount: currentOilAmount);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInventoryInfoCard(BuildContext context, InventoryModel inventory) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
      padding: EdgeInsets.only(
        top: AppSizes.setHeight(16),
        bottom: AppSizes.setHeight(24),
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
      ),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -AppSizes.setWidth(16),
            bottom: -AppSizes.setHeight(16),
            child: Icon(
              Icons.warehouse,
              size: AppSizes.setWidth(144),
              color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: inventory.depotName ?? '',
                          fontSize: AppSizes.setFontSize(20),
                          fontWeight: FontWeight.w700,
                          textColor: CustomAppColor.of(context).txtBlack,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: AppSizes.setHeight(4)),
                        // CommonText(
                        //   text: '四川省广安市前锋区xxxxx',
                        //   fontSize: AppSizes.setFontSize(12),
                        //   textColor: CustomAppColor.of(context).txtGrey,
                        //   textAlign: TextAlign.left,
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(12),
                      vertical: AppSizes.setHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: CustomAppColor.of(context).txtBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
                    ),
                    child: CommonText(
                      text: FuelTypeHelper.getDisplayName(inventory.fuelType),
                      fontSize: AppSizes.setFontSize(14),
                      fontWeight: FontWeight.w700,
                      textColor: CustomAppColor.of(context).txtBlue,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.setHeight(16)),
              CommonText(
                text: '当前剩余库存',
                fontSize: AppSizes.setFontSize(14),
                textColor: CustomAppColor.of(context).txtGrey,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: AppSizes.setHeight(4)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommonText(
                    text: '${(inventory.availableTon ?? 0).toInt()}',
                    fontSize: AppSizes.setFontSize(36),
                    fontWeight: FontWeight.w700,
                    textColor: CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSizes.setWidth(4),
                      bottom: AppSizes.setHeight(4),
                    ),
                    child: CommonText(
                      text: '吨',
                      fontSize: AppSizes.setFontSize(14),
                      fontWeight: FontWeight.w400,
                      textColor: CustomAppColor.of(context).txtGrey,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOilAmountInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(24)),
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
        children: [
          CommonText(
            text: '请输入本次提油量',
            fontSize: AppSizes.setFontSize(12),
            textColor: CustomAppColor.of(context).txtGrey,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _oilAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(30),
                    fontWeight: FontWeight.w700,
                    color: CustomAppColor.of(context).txtBlack,
                    fontFamily: 'Arial',
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: AppSizes.setFontSize(30),
                      fontWeight: FontWeight.w700,
                      color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.3),
                      fontFamily: 'Arial',
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => widget.controller.updateOilAmount(value),
                ),
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: '吨',
                fontSize: AppSizes.setFontSize(18),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrowDown(BuildContext context) {
    return Center(
      child: Icon(
        Icons.arrow_downward,
        size: AppSizes.setWidth(24),
        color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildVehicleInfoInput(BuildContext context, OilPickupDetailState state) {
    final showInput = !state.parseSuccess || state.vehicleModel == null;
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: '车辆及司机信息',
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
              if (showInput)
                Row(
                  children: [
                    Icon(
                      Icons.copy_all,
                      size: AppSizes.setWidth(14),
                      color: CustomAppColor.of(context).txtGrey,
                    ),
                    SizedBox(width: AppSizes.setWidth(4)),
                    CommonText(
                      text: '支持智能识别',
                      fontSize: AppSizes.setFontSize(12),
                      textColor: CustomAppColor.of(context).txtGrey,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
            ],
          ),
          if (showInput) ...[
            SizedBox(height: AppSizes.setHeight(12)),
            Container(
              padding: EdgeInsets.all(AppSizes.setWidth(16)),
              decoration: BoxDecoration(
                color: CustomAppColor.of(context).bgScaffold,
                borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                border: Border.all(
                  color: CustomAppColor.of(context).containerBorder,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _vehicleInfoController,
                      maxLines: 8,
                      style: TextStyle(
                        fontSize: AppSizes.setFontSize(16),
                        color: CustomAppColor.of(context).txtBlack,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: '2025年8月23日\n油品：XXX油库：92与95\n重型罐式挂车\n驾驶员姓名：张三\n驾驶员身份证：510123199001011234。\n驾驶员电话：13800138000。\n\n驾驶证编码：510100123456\n车型：重型罐式挂车\n车号：川X88888\n核定载重（公斤）：33.400\n行驶证编号：A00000000001\n单双仓：双仓\n一仓：16.5吨。\n二仓：16.5吨。\n是否带泵：否\n提油吨位：33吨。',
                        hintStyle: TextStyle(
                          fontSize: AppSizes.setFontSize(14),
                          color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (text) => widget.controller.onVehicleInfoPasted(text),
                    ),
                  ),
                  SizedBox(width: AppSizes.setWidth(8)),
                  GestureDetector(
                    onTap: () async {
                      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                      if (clipboardData != null && clipboardData.text != null) {
                        _vehicleInfoController.text = clipboardData.text!;
                        widget.controller.onVehicleInfoPasted(clipboardData.text!);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.setWidth(8)),
                      child: Icon(
                        Icons.paste,
                        size: AppSizes.setWidth(20),
                        color: CustomAppColor.of(context).txtBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!showInput && state.parseSuccess && state.vehicleModel != null) ...[
            SizedBox(height: AppSizes.setHeight(16)),
            _buildParsedVehicleInfo(context, state.vehicleModel!, state.missingFields),
            if (state.missingFields.isNotEmpty) ...[
              SizedBox(height: AppSizes.setHeight(12)),
              Container(
                padding: EdgeInsets.all(AppSizes.setWidth(12)),
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context).txtOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                ),
                child: CommonText(
                  text: '缺少必填字段: ${state.missingFields.join(', ')}',
                  fontSize: AppSizes.setFontSize(12),
                  textColor: CustomAppColor.of(context).txtOrange,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildParsedVehicleInfo(BuildContext context, VehicleModel model, List<String> missingFields) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: '识别结果',
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w600,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
              GestureDetector(
                onTap: () {
                  _vehicleInfoController.clear();
                  widget.controller.resetVehicleInfo();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(12),
                    vertical: AppSizes.setHeight(6),
                  ),
                  decoration: BoxDecoration(
                    color: CustomAppColor.of(context).txtBlue,
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
                  ),
                  child: CommonText(
                    text: '重新输入识别',
                    fontSize: AppSizes.setFontSize(12),
                    textColor: CustomAppColor.of(context).white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
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
          if (model.date != null)
            _buildInfoRow(context, '日期', model.date!),
          if (model.oilType != null)
            _buildInfoRow(
              context,
              '油品',
              FuelTypeHelper.getDisplayName(model.oilType),
            ),
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

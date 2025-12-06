import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/station_selector_button.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/controller.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/widgets/smart_parse_card.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

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

  @override
  void initState() {
    super.initState();
    _oilAmountController = TextEditingController(text: widget.state.oilAmount);
  }

  @override
  void dispose() {
    _oilAmountController.dispose();
    super.dispose();
  }

  void _handleGenerateCertificate() {
    final currentOilAmount = _oilAmountController.text.trim();

    if (widget.state.vehicleInfo.isEmpty) {
      SportsToast.showWarning('请输入车辆及司机信息');
      return;
    }

    final vehicleModel = widget.state.vehicleModel ?? VehicleModel();

    widget.controller.generateCertificate(
      context,
      currentOilAmount: currentOilAmount,
      vehicleModel: vehicleModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalUpdateUi(
      builder: (context, appCtrl) {
        final selectedStation = appCtrl.state.selectedStation;
        final currentState =
            widget.state.copyWith(selectedStation: selectedStation);

        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),
          appBar: AppBar(
             backgroundColor: CustomAppColor(context).white,
            elevation: 0,
            shadowColor: const Color(0xffF5F7FA),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CustomAppColor.of(context).txtBlack,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: CommonText(
              text: '提油',
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
                        _buildInventoryInfoCard(
                            context, currentState.inventory!),
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.setWidth(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOilAmountInput(context, currentState),
                            SizedBox(height: AppSizes.setHeight(12)),
                            StationSelectorButton(
                              station: currentState.selectedStation,
                              onTap: () =>
                                  widget.controller.selectStation(context),
                            ),
                            SizedBox(height: AppSizes.setHeight(12)),
                            SmartParseCard(
                              onParse: (text) =>
                                  widget.controller.onVehicleInfoPasted(text),
                            ),
                            SizedBox(height: AppSizes.setHeight(24)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(16),
                  vertical: AppSizes.setHeight(12),
                ),
                decoration: BoxDecoration(
                  color: CustomAppColor(context).white,
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
                      CommonButton(
                        btnText: '生成提油凭证',
                        height: AppSizes.setHeight(52),
                        fontSize: AppSizes.setFontSize(15),
                        isLoading: currentState.isLoading,
                        onTap: _handleGenerateCertificate,
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

  Widget _buildInventoryInfoCard(
    BuildContext context,
    InventoryModel inventory,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          left: AppSizes.setWidth(16),
          right: AppSizes.setWidth(16),
          top: AppSizes.setHeight(12),
          bottom: 0),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.setHeight(24),
      ),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.setWidth(12)),
            topRight: Radius.circular(AppSizes.setWidth(12))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(
            text: inventory.depotName ?? '',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.setHeight(6)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.setWidth(10),
              vertical: AppSizes.setHeight(4),
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
            ),
            child: CommonText(
              text: '可用库存: ${(inventory.availableTon ?? 0).toInt()} 吨',
              fontSize: AppSizes.setFontSize(12),
              fontWeight: FontWeight.w400,
              textColor: const Color(0xff6B7280),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOilAmountInput(
      BuildContext context, OilPickupDetailState currentState) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.setHeight(24),
        horizontal: AppSizes.setWidth(20),
      ),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppSizes.setWidth(12)),
            bottomRight: Radius.circular(AppSizes.setWidth(12))),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: TextField(
                  controller: _oilAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(48),
                    fontWeight: FontWeight.w700,
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      fontSize: AppSizes.setFontSize(48),
                      fontWeight: FontWeight.w700,
                      color: CustomAppColor.of(context)
                          .txtGrey
                          .withValues(alpha: 0.3),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: AppSizes.setWidth(140),
                    ),
                  ),
                  onChanged: (value) =>
                      widget.controller.updateOilAmount(value),
                ),
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: '吨',
                fontSize: AppSizes.setFontSize(16),
                fontWeight: FontWeight.w500,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          Container(
            width: double.infinity,
            height: 1,
            color: CustomAppColor.of(context).containerBorder,
            margin: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(30)),
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          CommonText(
            text: currentState.errorMessage ?? '请输入本次提油数量',
            fontSize: AppSizes.setFontSize(12),
            textColor: currentState.errorMessage != null
                ? CustomAppColor.of(context).red
                : CustomAppColor.of(context).txtGrey.withValues(alpha: 0.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

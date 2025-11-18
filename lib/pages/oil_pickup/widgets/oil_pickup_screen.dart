import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/pages/oil_pickup/controller.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';

import 'order_info_card.dart';
import 'station_selector_button.dart';
import 'vehicle_info_card.dart';

class OilPickupScreen extends StatefulWidget {
  final OilPickupState state;
  final OilPickupCtrl controller;

  const OilPickupScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<OilPickupScreen> createState() => _OilPickupScreenState();
}

class _OilPickupScreenState extends State<OilPickupScreen> {
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
          body: _buildBody(context, currentState),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OilPickupState currentState) {
    // 加载中状态
    if (currentState.isLoadingOrder) {
      return Center(
        child: CircularProgressIndicator(
          color: CustomAppColor.of(context).btnPurple,
        ),
      );
    }

    // 无订单状态：仅显示空态标志
    if (currentState.pendingOilOrder == null) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _buildEmptyState(context),
      );
    }

    final order = currentState.pendingOilOrder!;
    final availableInventory = order.availableInventory ?? 0.0;
    final hasInventory = availableInventory > 0;

    // 有订单但无库存：显示订单信息卡片 + 空态标志
    if (!hasInventory) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.setWidth(20)),
        child: Column(
          children: [
            SizedBox(height: AppSizes.setHeight(20)),
            OrderInfoCard(order: order),
            SizedBox(height: AppSizes.setHeight(20)),
            _buildEmptyState(context),
          ],
        ),
      );
    }

    // 有订单且有库存：显示订单信息卡片 + 正常提油表单
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.setHeight(20)),
          OrderInfoCard(order: order),
          SizedBox(height: AppSizes.setHeight(24)),
          _buildOilAmountInput(context),
          SizedBox(height: AppSizes.setHeight(24)),
          StationSelectorButton(
            station: currentState.selectedStation,
            onTap: () => widget.controller.selectStation(context),
          ),
          SizedBox(height: AppSizes.setHeight(24)),
          VehicleInfoCard(
            vehicleModel: currentState.vehicleModel,
            vehicleInfo: currentState.vehicleInfo,
            missingFields: currentState.missingFields,
            parseSuccess: currentState.parseSuccess,
            errorMessage: currentState.errorMessage,
            controller: _vehicleInfoController,
            onChanged: (text) => widget.controller.onVehicleInfoPasted(text),
          ),
          SizedBox(height: AppSizes.setHeight(32)),
          if (currentState.errorMessage != null)
            Container(
              padding: EdgeInsets.all(AppSizes.setWidth(12)),
              margin: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
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
            onTap: () => widget.controller.generateCertificate(context),
          ),
          SizedBox(height: AppSizes.setHeight(20)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsImg.PAGE_EMPTY,
            width: AppSizes.setWidth(180),
            height: AppSizes.setHeight(180),
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSizes.setHeight(20)),
          CommonText(
            text: '您还没有库存油哦~',
            fontSize: AppSizes.setFontSize(14),
            fontWeight: FontWeight.w400,
            textColor: CustomAppColor.of(context).txtGrey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOilAmountInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '提油量',
          fontSize: AppSizes.setFontSize(16),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        CommonTextFormField(
          controller: _oilAmountController,
          hintText: '请输入本次提油量/吨',
          keyboardType: TextInputType.number,
          inputFormatter: FilteringTextInputFormatter.digitsOnly,
          onChanged: (value) => widget.controller.updateOilAmount(value ?? ''),
        ),
      ],
    );
  }
}


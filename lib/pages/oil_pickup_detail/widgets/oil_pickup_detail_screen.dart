import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/order_info_card.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/station_selector_button.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/vehicle_info_card.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/controller.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
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

  OrderModel _convertInventoryToOrder(InventoryModel inventory) {
    return OrderModel(
      id: inventory.inventoryId,
      depotName: inventory.depotName,
      fuelType: inventory.fuelType,
      purchaseTon: inventory.availableTon,
      createdAt: null,
      updatedAt: inventory.updatedAt,
    );
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
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.setWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentState.inventory != null) ...[
                  OrderInfoCard(order: _convertInventoryToOrder(currentState.inventory!)),
                ],
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
          ),
        );
      },
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

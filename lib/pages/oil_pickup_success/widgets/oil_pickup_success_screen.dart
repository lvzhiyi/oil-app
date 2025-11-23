import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class OilPickupSuccessScreen extends StatelessWidget {
  final WithdrawResponse response;
  final InventoryModel inventory;
  final Station station;
  final String oilAmount;
  final VehicleModel vehicleModel;

  const OilPickupSuccessScreen({
    Key? key,
    required this.response,
    required this.inventory,
    required this.station,
    required this.oilAmount,
    required this.vehicleModel,
  }) : super(key: key);

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
          onPressed: () => _handleBack(context),
        ),
        title: CommonText(
          text: '提油成功',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.setHeight(32)),
                    _buildSuccessIcon(context),
                    SizedBox(height: AppSizes.setHeight(24)),
                    _buildSuccessTitle(context),
                    SizedBox(height: AppSizes.setHeight(32)),
                    _buildPickupInfoCard(context),
                    SizedBox(height: AppSizes.setHeight(16)),
                    _buildStationInfoCard(context),
                    SizedBox(height: AppSizes.setHeight(16)),
                    _buildVehicleInfoCard(context),
                    SizedBox(height: AppSizes.setHeight(20)),
                  ],
                ),
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
              child: CommonButton(
                btnText: '返回',
                height: AppSizes.setHeight(52),
                fontSize: AppSizes.setFontSize(15),
                onTap: () => _handleBack(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context) {
    BaseRouter.pop(context: context, result: true);
    BaseRouter.pop(context: context, result: true);
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return Center(
      child: Container(
        width: AppSizes.setWidth(80),
        height: AppSizes.setWidth(80),
        decoration: BoxDecoration(
          color: CustomAppColor.of(context).green.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_circle,
          size: AppSizes.setWidth(48),
          color: CustomAppColor.of(context).green,
        ),
      ),
    );
  }

  Widget _buildSuccessTitle(BuildContext context) {
    return Center(
      child: CommonText(
        text: '提油凭证生成成功',
        fontSize: AppSizes.setFontSize(20),
        fontWeight: FontWeight.w700,
        textColor: CustomAppColor.of(context).txtBlack,
      ),
    );
  }

  Widget _buildPickupInfoCard(BuildContext context) {
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
          CommonText(
            text: '提油信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          if (response.withdrawNo != null)
            _buildInfoRow(context, '提油单号', response.withdrawNo!),
          _buildInfoRow(context, '提油量', '$oilAmount 吨'),
          if (response.remainingTon != null)
            _buildInfoRow(context, '剩余库存', '${response.remainingTon!.toInt()} 吨'),
          if (inventory.depotName != null)
            _buildInfoRow(context, '油库', inventory.depotName!),
          if (inventory.fuelType != null)
            _buildInfoRow(
              context,
              '油品',
              FuelTypeHelper.getDisplayName(inventory.fuelType),
            ),
          if (response.status != null)
            _buildInfoRow(
              context,
              '状态',
              WithdrawStatus.fromString(response.status)?.displayName ?? response.status!,
            ),
        ],
      ),
    );
  }

  Widget _buildStationInfoCard(BuildContext context) {
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
          CommonText(
            text: '加油站信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildInfoRow(context, '加油站名称', station.displayName),
          _buildInfoRow(context, '地址', station.fullAddress),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(BuildContext context) {
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
          CommonText(
            text: '车辆及司机信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          if (vehicleModel.driverName != null)
            _buildInfoRow(context, '驾驶员姓名', vehicleModel.driverName!),
          if (vehicleModel.plateNumber != null)
            _buildInfoRow(context, '车号', vehicleModel.plateNumber!),
          if (vehicleModel.driverPhone != null)
            _buildInfoRow(context, '驾驶员电话', vehicleModel.driverPhone!),
          if (vehicleModel.driverIdCard != null)
            _buildInfoRow(context, '身份证号', vehicleModel.driverIdCard!),
          if (vehicleModel.vehicleType != null)
            _buildInfoRow(context, '车型', vehicleModel.vehicleType!),
          if (vehicleModel.loadCapacity != null)
            _buildInfoRow(context, '核定载重', vehicleModel.loadCapacity!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(100),
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


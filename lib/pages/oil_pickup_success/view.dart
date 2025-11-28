import 'package:flutter/material.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_success/widgets/oil_pickup_success_screen.dart';

class OilPickupSuccessView extends StatelessWidget {
  final WithdrawResponse response;
  final InventoryModel inventory;
  final Station station;
  final String oilAmount;
  final VehicleModel vehicleModel;
  final String dispatchInfo;

  const OilPickupSuccessView({
    Key? key,
    required this.response,
    required this.inventory,
    required this.station,
    required this.oilAmount,
    required this.vehicleModel,
    required this.dispatchInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OilPickupSuccessScreen(
      response: response,
      inventory: inventory,
      station: station,
      oilAmount: oilAmount,
      vehicleModel: vehicleModel,
      dispatchInfo: dispatchInfo,
    );
  }
}

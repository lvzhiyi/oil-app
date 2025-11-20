import 'package:flutter/material.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup_success/view.dart';
import 'package:oil_business_app/widgets/common/base_page.dart';

class OilPickupSuccessPage extends BasePage {
  final WithdrawResponse response;
  final InventoryModel inventory;
  final StationModel station;
  final String oilAmount;
  final VehicleModel vehicleModel;

  const OilPickupSuccessPage({
    Key? key,
    required this.response,
    required this.inventory,
    required this.station,
    required this.oilAmount,
    required this.vehicleModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OilPickupSuccessPage();
}

class _OilPickupSuccessPage extends BaseState<OilPickupSuccessPage> with BasicInitPage {
  @override
  Widget body(context) {
    return OilPickupSuccessView(
      response: widget.response,
      inventory: widget.inventory,
      station: widget.station,
      oilAmount: widget.oilAmount,
      vehicleModel: widget.vehicleModel,
    );
  }
  
  String get title => '提油成功';
}


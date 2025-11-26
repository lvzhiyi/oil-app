import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

const _kNoChange = Object();

class OilPickupDetailState {
  final InventoryModel? inventory;
  final Station? selectedStation;
  final String oilAmount;
  final String vehicleInfo;
  final VehicleModel? vehicleModel;
  final List<String> missingFields;
  final bool parseSuccess;
  final String? errorMessage;
  final bool isLoading;

  OilPickupDetailState({
    this.inventory,
    this.selectedStation,
    this.oilAmount = '',
    this.vehicleInfo = '',
    this.vehicleModel,
    this.missingFields = const [],
    this.parseSuccess = false,
    this.errorMessage,
    this.isLoading = false,
  });

  OilPickupDetailState copyWith({
    InventoryModel? inventory,
    Station? selectedStation,
    String? oilAmount,
    String? vehicleInfo,
    VehicleModel? vehicleModel,
    List<String>? missingFields,
    bool? parseSuccess,
    Object? errorMessage = _kNoChange,
    bool? isLoading,
  }) {
    return OilPickupDetailState(
      inventory: inventory ?? this.inventory,
      selectedStation: selectedStation ?? this.selectedStation,
      oilAmount: oilAmount ?? this.oilAmount,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      missingFields: missingFields ?? this.missingFields,
      parseSuccess: parseSuccess ?? this.parseSuccess,
      errorMessage: identical(errorMessage, _kNoChange)
          ? this.errorMessage
          : errorMessage as String?,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

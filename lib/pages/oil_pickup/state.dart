import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/models/vehicle_model.dart';

class OilPickupState {
  final StationModel? selectedStation;
  final String oilAmount;
  final String vehicleInfo;
  final VehicleModel? vehicleModel;
  final List<String> missingFields;
  final bool parseSuccess;
  final String? errorMessage;
  final bool isLoading;

  OilPickupState({
    this.selectedStation,
    this.oilAmount = '',
    this.vehicleInfo = '',
    this.vehicleModel,
    this.missingFields = const [],
    this.parseSuccess = false,
    this.errorMessage,
    this.isLoading = false,
  });

  OilPickupState copyWith({
    StationModel? selectedStation,
    String? oilAmount,
    String? vehicleInfo,
    VehicleModel? vehicleModel,
    List<String>? missingFields,
    bool? parseSuccess,
    String? errorMessage,
    bool? isLoading,
  }) {
    return OilPickupState(
      selectedStation: selectedStation ?? this.selectedStation,
      oilAmount: oilAmount ?? this.oilAmount,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      missingFields: missingFields ?? this.missingFields,
      parseSuccess: parseSuccess ?? this.parseSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


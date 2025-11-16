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

  // 订单相关字段
  final int? pendingOilOrderId; // 待完成的买油订单ID
  final bool isLoadingOrder; // 是否正在加载订单
  final String? orderError; // 订单加载错误信息

  OilPickupState({
    this.selectedStation,
    this.oilAmount = '',
    this.vehicleInfo = '',
    this.vehicleModel,
    this.missingFields = const [],
    this.parseSuccess = false,
    this.errorMessage,
    this.isLoading = false,
    this.pendingOilOrderId,
    this.isLoadingOrder = false,
    this.orderError,
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
    int? pendingOilOrderId,
    bool? isLoadingOrder,
    String? orderError,
  }) {
    return OilPickupState(
      selectedStation: selectedStation ?? this.selectedStation,
      oilAmount: oilAmount ?? this.oilAmount,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      missingFields: missingFields ?? this.missingFields,
      parseSuccess: parseSuccess ?? this.parseSuccess,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
      pendingOilOrderId: pendingOilOrderId ?? this.pendingOilOrderId,
      isLoadingOrder: isLoadingOrder ?? this.isLoadingOrder,
      orderError: orderError,
    );
  }
}


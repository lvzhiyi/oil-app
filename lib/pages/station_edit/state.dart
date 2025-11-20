import 'package:oil_business_app/models/station_model.dart';

class StationEditState {
  final StationModel? station;
  final String name;
  final String provinceName;
  final String cityName;
  final String areaName;
  final String provinceCode;
  final String cityCode;
  final String areaCode;
  final String addressDetail;
  final String businessLicenseUrl;
  final String fuelRetailPermitUrl;
  final String originalBusinessLicenseUrl;
  final String originalFuelRetailPermitUrl;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  StationEditState({
    this.station,
    this.name = '',
    this.provinceName = '',
    this.cityName = '',
    this.areaName = '',
    this.provinceCode = '',
    this.cityCode = '',
    this.areaCode = '',
    this.addressDetail = '',
    this.businessLicenseUrl = '',
    this.fuelRetailPermitUrl = '',
    this.originalBusinessLicenseUrl = '',
    this.originalFuelRetailPermitUrl = '',
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  StationEditState copyWith({
    StationModel? station,
    String? name,
    String? provinceName,
    String? cityName,
    String? areaName,
    String? provinceCode,
    String? cityCode,
    String? areaCode,
    String? addressDetail,
    String? businessLicenseUrl,
    String? fuelRetailPermitUrl,
    String? originalBusinessLicenseUrl,
    String? originalFuelRetailPermitUrl,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return StationEditState(
      station: station ?? this.station,
      name: name ?? this.name,
      provinceName: provinceName ?? this.provinceName,
      cityName: cityName ?? this.cityName,
      areaName: areaName ?? this.areaName,
      provinceCode: provinceCode ?? this.provinceCode,
      cityCode: cityCode ?? this.cityCode,
      areaCode: areaCode ?? this.areaCode,
      addressDetail: addressDetail ?? this.addressDetail,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      fuelRetailPermitUrl: fuelRetailPermitUrl ?? this.fuelRetailPermitUrl,
      originalBusinessLicenseUrl: originalBusinessLicenseUrl ?? this.originalBusinessLicenseUrl,
      originalFuelRetailPermitUrl: originalFuelRetailPermitUrl ?? this.originalFuelRetailPermitUrl,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


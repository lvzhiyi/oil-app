import 'package:oil_business_app/global/enum/common.dart';

/// 获取加油站列表请求
class GetStationRequest {
  final int page;
  final int pageSize;
  final List<StationStatus> statuses;

  GetStationRequest(
      {required this.page, required this.pageSize, required this.statuses});

  Map<String, dynamic> toJson() => {
        'page': page,
        'pageSize': pageSize,
        'statuses': statuses.map((e) => e.name).toList(),
      };
}

/// 绑定加油站请求
class BindStationRequest {
  final String stationName;
  final String provinceCode;
  final String provinceName;
  final String cityCode;
  final String cityName;
  final String areaCode;
  final String areaName;
  final String addressDetail;
  final String businessLicenseUrl;
  final String fuelRetailPermitUrl;

  BindStationRequest({
    required this.stationName,
    required this.provinceCode,
    required this.provinceName,
    required this.cityCode,
    required this.cityName,
    required this.areaCode,
    required this.areaName,
    required this.addressDetail,
    required this.businessLicenseUrl,
    required this.fuelRetailPermitUrl,
  });

  Map<String, dynamic> toJson() => {
        'stationName': stationName,
        'provinceCode': provinceCode,
        'provinceName': provinceName,
        'cityCode': cityCode,
        'cityName': cityName,
        'areaCode': areaCode,
        'areaName': areaName,
        'addressDetail': addressDetail,
        'businessLicenseUrl': businessLicenseUrl,
        'fuelRetailPermitUrl': fuelRetailPermitUrl,
      };

  BindStationRequest copyWith({
    String? stationName,
    String? provinceCode,
    String? provinceName,
    String? cityCode,
    String? cityName,
    String? areaCode,
    String? areaName,
    String? addressDetail,
    String? businessLicenseUrl,
    String? fuelRetailPermitUrl,
  }) =>
      BindStationRequest(
        stationName: stationName ?? this.stationName,
        provinceCode: provinceCode ?? this.provinceCode,
        provinceName: provinceName ?? this.provinceName,
        cityCode: cityCode ?? this.cityCode,
        cityName: cityName ?? this.cityName,
        areaCode: areaCode ?? this.areaCode,
        areaName: areaName ?? this.areaName,
        addressDetail: addressDetail ?? this.addressDetail,
        businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
        fuelRetailPermitUrl: fuelRetailPermitUrl ?? this.fuelRetailPermitUrl,
      );
}

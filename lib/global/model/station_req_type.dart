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
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oil_business_app/global/enum/common.dart';

part 'station_res_type.g.dart';

@JsonSerializable()
class GetStationResponse {
  final int? page;
  final int? pageSize;
  final int? total;
  final List<Station>? list;

  GetStationResponse({
    this.page,
    this.pageSize,
    this.total,
    this.list,
  });

  factory GetStationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetStationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetStationResponseToJson(this);
}

@JsonSerializable()
class Station {
  final int? id;
  final String? stationName;
  final String? provinceCode;
  final String? provinceName;
  final String? cityCode;
  final String? cityName;
  final String? areaCode;
  final String? areaName;
  final String? addressDetail;
  final String? businessLicenseUrl;
  final String? fuelRetailPermitUrl;
  final StationStatus? status;
  final String? rejectReason;
  final String? createdAt;
  final String? updatedAt;

  Station(
      {this.id,
      this.stationName,
      this.provinceCode,
      this.provinceName,
      this.cityCode,
      this.cityName,
      this.areaCode,
      this.areaName,
      this.addressDetail,
      this.businessLicenseUrl,
      this.fuelRetailPermitUrl,
      this.status,
      this.rejectReason,
      this.createdAt,
      this.updatedAt});

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}

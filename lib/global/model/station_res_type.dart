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
  final String? rejectionReason;

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
      this.updatedAt,
      this.rejectionReason});

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);

  Station copyWith({
    String? rejectionReason,
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
    StationStatus? status,
    String? rejectReason,
    String? createdAt,
    String? updatedAt,
  }) {
    return Station(
      id: id,
      stationName: stationName ?? this.stationName,
      provinceCode: provinceCode ?? this.provinceCode,
      provinceName: provinceName ?? this.provinceName,
      cityCode: cityCode ?? this.cityCode,
      cityName: cityName ?? this.cityName,
      areaCode: areaCode ?? this.areaCode,
      areaName: areaName ?? this.areaName,
      addressDetail: addressDetail ?? this.addressDetail,
      businessLicenseUrl: businessLicenseUrl,
      fuelRetailPermitUrl: fuelRetailPermitUrl ?? this.fuelRetailPermitUrl,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class StationDetailResponse {
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
  final String? invoiceTitle;
  final String? taxNumber;
  final String? bankName;
  final String? bankAccount;
  final String? companyAddress;
  final String? companyPhone;
  final String? invoiceType;
  final StationStatus? status;
  final String? statusRemark;
  final int? reviewedBy;
  final String? reviewedAt;
  final String? createdAt;
  final String? updatedAt;

  StationDetailResponse({
    this.id,
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
    this.invoiceTitle,
    this.taxNumber,
    this.bankName,
    this.bankAccount,
    this.companyAddress,
    this.companyPhone,
    this.invoiceType,
    this.status,
    this.statusRemark,
    this.reviewedBy,
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StationDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StationDetailResponseToJson(this);
}

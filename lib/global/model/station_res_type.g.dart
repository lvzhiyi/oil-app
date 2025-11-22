// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_res_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStationResponse _$GetStationResponseFromJson(Map<String, dynamic> json) =>
    GetStationResponse(
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetStationResponseToJson(GetStationResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'total': instance.total,
      'list': instance.list,
    };

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      id: (json['id'] as num?)?.toInt(),
      stationName: json['stationName'] as String?,
      provinceCode: json['provinceCode'] as String?,
      provinceName: json['provinceName'] as String?,
      cityCode: json['cityCode'] as String?,
      cityName: json['cityName'] as String?,
      areaCode: json['areaCode'] as String?,
      areaName: json['areaName'] as String?,
      addressDetail: json['addressDetail'] as String?,
      businessLicenseUrl: json['businessLicenseUrl'] as String?,
      fuelRetailPermitUrl: json['fuelRetailPermitUrl'] as String?,
      status: $enumDecodeNullable(_$StationStatusEnumMap, json['status']),
      rejectReason: json['rejectReason'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.id,
      'stationName': instance.stationName,
      'provinceCode': instance.provinceCode,
      'provinceName': instance.provinceName,
      'cityCode': instance.cityCode,
      'cityName': instance.cityName,
      'areaCode': instance.areaCode,
      'areaName': instance.areaName,
      'addressDetail': instance.addressDetail,
      'businessLicenseUrl': instance.businessLicenseUrl,
      'fuelRetailPermitUrl': instance.fuelRetailPermitUrl,
      'status': _$StationStatusEnumMap[instance.status],
      'rejectReason': instance.rejectReason,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'rejectionReason': instance.rejectionReason,
    };

const _$StationStatusEnumMap = {
  StationStatus.pending_review: 'pending_review',
  StationStatus.active: 'active',
  StationStatus.rejected: 'rejected',
  StationStatus.disabled: 'disabled',
};

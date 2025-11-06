// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_res_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStationResponse _$GetStationResponseFromJson(Map<String, dynamic> json) =>
    GetStationResponse(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => Station.fromJson(e as Map<String, dynamic>))
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
      id: (json['id'] as num).toInt(),
      phone: json['phone'] as String,
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'status': instance.status,
    };

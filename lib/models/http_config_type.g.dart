// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_config_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HttpConfigType _$HttpConfigTypeFromJson(Map<String, dynamic> json) =>
    _HttpConfigType(
      canVisit: (json['canVisit'] as num?)?.toInt(),
      endTime: json['endTime'] as String?,
      startTime: json['startTime'] as String?,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$HttpConfigTypeToJson(_HttpConfigType instance) =>
    <String, dynamic>{
      'canVisit': instance.canVisit,
      'endTime': instance.endTime,
      'startTime': instance.startTime,
      'tip': instance.tip,
    };

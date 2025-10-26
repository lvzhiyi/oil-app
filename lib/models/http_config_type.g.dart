// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_config_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HttpConfigTypeImpl _$$HttpConfigTypeImplFromJson(Map<String, dynamic> json) =>
    _$HttpConfigTypeImpl(
      canVisit: (json['canVisit'] as num?)?.toInt(),
      endTime: json['endTime'] as String?,
      startTime: json['startTime'] as String?,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$$HttpConfigTypeImplToJson(
        _$HttpConfigTypeImpl instance) =>
    <String, dynamic>{
      'canVisit': instance.canVisit,
      'endTime': instance.endTime,
      'startTime': instance.startTime,
      'tip': instance.tip,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_loginout_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotifyLoginoutModelImpl _$$NotifyLoginoutModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotifyLoginoutModelImpl(
      playerId: json['playerId'] as String?,
      playerObjId: json['playerObjId'] as String?,
      serviceName: json['serviceName'] as String?,
      messageType: json['messageType'] as String?,
      isBlacklisted: json['isBlacklisted'] as bool?,
    );

Map<String, dynamic> _$$NotifyLoginoutModelImplToJson(
        _$NotifyLoginoutModelImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerObjId': instance.playerObjId,
      'serviceName': instance.serviceName,
      'messageType': instance.messageType,
      'isBlacklisted': instance.isBlacklisted,
    };

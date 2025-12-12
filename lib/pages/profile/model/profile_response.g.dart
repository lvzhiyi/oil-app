// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      status: (json['status'] as num?)?.toInt(),
      lastLoginAt: json['lastLoginAt'] as String?,
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'status': instance.status,
      'lastLoginAt': instance.lastLoginAt,
      'inventories': instance.inventories,
    };

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      fuelType: json['fuelType'] as String?,
      availableTon: (json['availableTon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'fuelType': instance.fuelType,
      'availableTon': instance.availableTon,
    };

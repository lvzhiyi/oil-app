// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oil_order_res.type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOilStoreResponse _$GetOilStoreResponseFromJson(Map<String, dynamic> json) =>
    GetOilStoreResponse(
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => Depot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetOilStoreResponseToJson(
        GetOilStoreResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'total': instance.total,
      'list': instance.list,
    };

Depot _$DepotFromJson(Map<String, dynamic> json) => Depot(
      depotId: (json['depotId'] as num?)?.toInt(),
      depotName: json['depotName'] as String?,
      provinceCode: json['provinceCode'] as String?,
      provinceName: json['provinceName'] as String?,
      cityCode: json['cityCode'] as String?,
      cityName: json['cityName'] as String?,
      areaCode: json['areaCode'] as String?,
      areaName: json['areaName'] as String?,
      addressDetail: json['addressDetail'] as String?,
      fuels: (json['fuels'] as List<dynamic>?)
          ?.map((e) => Fuel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepotToJson(Depot instance) => <String, dynamic>{
      'depotId': instance.depotId,
      'depotName': instance.depotName,
      'provinceCode': instance.provinceCode,
      'provinceName': instance.provinceName,
      'cityCode': instance.cityCode,
      'cityName': instance.cityName,
      'areaCode': instance.areaCode,
      'areaName': instance.areaName,
      'addressDetail': instance.addressDetail,
      'fuels': instance.fuels,
    };

Fuel _$FuelFromJson(Map<String, dynamic> json) => Fuel(
      fuelType: json['fuelType'] as String?,
      priceCny: (json['priceCny'] as num?)?.toDouble(),
      density: (json['density'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FuelToJson(Fuel instance) => <String, dynamic>{
      'fuelType': instance.fuelType,
      'priceCny': instance.priceCny,
      'density': instance.density,
    };

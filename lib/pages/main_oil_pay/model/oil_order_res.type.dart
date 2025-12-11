import 'package:json_annotation/json_annotation.dart';

part 'oil_order_res.type.g.dart';

@JsonSerializable()
class GetOilStoreResponse {
  final int? page;
  final int? pageSize;
  final int? total;
  final List<Depot>? list;

  GetOilStoreResponse({this.page, this.pageSize, this.total, this.list});

  factory GetOilStoreResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOilStoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOilStoreResponseToJson(this);
}

@JsonSerializable()
class Depot {
  final int? depotId;

  /// 油库名称
  final String? depotName;

  /// 省份编码
  final String? provinceCode;

  /// 省份名称
  final String? provinceName;

  /// 城市编码
  final String? cityCode;

  /// 城市名称
  final String? cityName;

  /// 区县编码
  final String? areaCode;

  /// 区县名称
  final String? areaName;

  /// 详细地址
  final String? addressDetail;

  /// 油品列表
  final List<Fuel>? fuels;

  Depot(
      {this.depotId,
      this.depotName,
      this.provinceCode,
      this.provinceName,
      this.cityCode,
      this.cityName,
      this.areaCode,
      this.areaName,
      this.addressDetail,
      this.fuels});

  factory Depot.fromJson(Map<String, dynamic> json) => _$DepotFromJson(json);

  Map<String, dynamic> toJson() => _$DepotToJson(this);
}

@JsonSerializable()
class Fuel {
  /// 油品类型
  final String? fuelType;

  /// 价格
  final double? priceCny;

  /// 密度
  final double? density;

  Fuel({this.fuelType, this.priceCny, this.density});

  factory Fuel.fromJson(Map<String, dynamic> json) => _$FuelFromJson(json);

  Map<String, dynamic> toJson() => _$FuelToJson(this);
}

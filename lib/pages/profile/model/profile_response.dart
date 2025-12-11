import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

/// 用户个人资料响应
@JsonSerializable()
class ProfileResponse {
  /// 手机号
  @JsonKey(name: 'phone')
  final String? phone;

  /// 用户名
  @JsonKey(name: 'name')
  final String? name;

  /// 状态
  @JsonKey(name: 'status')
  final int? status;

  /// 最后登录时间
  @JsonKey(name: 'lastLoginAt')
  final String? lastLoginAt;

  /// 用户库存列表
  @JsonKey(name: 'inventories')
  final List<InventoryItem>? inventories;

  ProfileResponse({
    this.phone,
    this.name,
    this.status,
    this.lastLoginAt,
    this.inventories,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

/// 库存项
@JsonSerializable()
class InventoryItem {
  /// 油品类型
  @JsonKey(name: 'fuelType')
  final String? fuelType;

  /// 可用吨数
  @JsonKey(name: 'availableTon')
  final double? availableTon;

  InventoryItem({
    this.fuelType,
    this.availableTon,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
}

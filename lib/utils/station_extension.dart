import 'package:oil_business_app/global/model/station_res_type.dart';

/// Station 扩展方法
/// 提供常用工具方法
extension StationExtension on Station {
  /// 构建完整地址
  /// 将省市区和详细地址拼接成完整地址
  String get fullAddress {
    final parts = [
      provinceName,
      cityName,
      areaName,
      addressDetail,
    ].where((part) => part != null && part.isNotEmpty);
    return parts.join('');
  }

  /// 获取加油站名称
  String get displayName => stationName ?? '';

  /// 获取加油站ID字符串
  String get idString => id?.toString() ?? '';
}


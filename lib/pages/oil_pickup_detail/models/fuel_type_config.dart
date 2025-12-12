import 'package:flutter/material.dart';

/// 油品类型配置
class FuelTypeConfig {
  final String type;
  final String label;
  final Color dotColor;
  final Color valueColor;

  const FuelTypeConfig({
    required this.type,
    required this.label,
    required this.dotColor,
    required this.valueColor,
  });
}

/// 预定义的油品类型配置
const List<FuelTypeConfig> fuelTypeConfigs = [
  FuelTypeConfig(
    type: '0',
    label: '0#柴油',
    dotColor: Color(0xFF6366F1), // 紫色/靛蓝色
    valueColor: Color(0xFF6366F1),
  ),
  FuelTypeConfig(
    type: '92',
    label: '92#汽油',
    dotColor: Color(0xFFF97316), // 橙色
    valueColor: Color(0xFFF97316),
  ),
  FuelTypeConfig(
    type: '95',
    label: '95#汽油',
    dotColor: Color(0xFFEF4444), // 红色
    valueColor: Color(0xFFEF4444),
  ),
];

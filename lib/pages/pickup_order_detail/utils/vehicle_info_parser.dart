import 'dart:convert';
import 'package:oil_business_app/models/vehicle_model.dart';

/// 车辆信息解析工具类
class VehicleInfoParser {
  /// 从 vehicleInfo 字符串解析 VehicleModel
  ///
  /// 支持两种格式:
  /// 1. 直接 JSON 字符串
  /// 2. 原始字符串|||JSON字符串 (新格式)
  static VehicleModel? parse(String? vehicleInfo) {
    if (vehicleInfo == null || vehicleInfo.isEmpty) {
      return null;
    }

    try {
      String jsonStr = vehicleInfo;

      // 兼容新的格式：原始字符串|||JSON字符串
      if (jsonStr.contains('|||')) {
        final parts = jsonStr.split('|||');
        if (parts.length > 1) {
          jsonStr = parts[1];
        }
      }

      final jsonMap = jsonDecode(jsonStr);
      return VehicleModel.fromJson(jsonMap);
    } catch (e) {
      // 解析失败，返回 null
      return null;
    }
  }

  /// 生成调度信息文本内容
  ///
  /// 用于生成凭证图片时的调度信息展示
  static String getDispatchContent(VehicleModel? vehicleModel) {
    if (vehicleModel == null) return '暂无调度信息';

    final List<String> lines = [];

    void addLine(String label, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        lines.add('$label: $value');
      }
    }

    addLine('提油日期', vehicleModel.date);
    addLine('驾驶员', vehicleModel.driverName);
    addLine('电话', vehicleModel.driverPhone);
    addLine('身份证', vehicleModel.driverIdCard);
    addLine('车号', vehicleModel.plateNumber);
    addLine('车型', vehicleModel.vehicleType);
    addLine('载重', vehicleModel.loadCapacity);

    return lines.isEmpty ? '暂无调度信息' : lines.join('\n');
  }
}

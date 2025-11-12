import 'dart:convert';
import 'package:oil_business_app/models/vehicle_model.dart';

class VehicleInfoParser {
  static const Map<String, List<String>> fieldKeywords = {
    'date': ['日期', '时间'],
    'oilType': ['油品', '油号'],
    'oilSource': ['油库'],
    'vehicleType': ['车型'],
    'driverName': ['驾驶员姓名', '驾驶员', '司机姓名'],
    'driverIdCard': ['驾驶员身份证', '身份证', '身份证号'],
    'driverPhone': ['驾驶员电话', '电话', '手机', '联系方式'],
    'driverLicense': ['驾驶证编码', '驾驶证号'],
    'plateNumber': ['车号', '车牌', '车牌号'],
    'loadCapacity': ['核定载重', '载重'],
    'vehicleLicense': ['行驶证编号', '行驶证号'],
    'tankType': ['单双仓', '仓型'],
    'tank1Capacity': ['一仓', '1仓'],
    'tank2Capacity': ['二仓', '2仓'],
    'hasPump': ['是否带泵', '带泵'],
    'oilAmount': ['提油吨位', '提油量', '吨位'],
  };

  static VehicleModel parse(String text) {
    final Map<String, String> result = {};

    text = text
        .replaceAll('：', ':')
        .replaceAll('=', ':')
        .trim();

    final lines = text.split('\n').where((line) => line.trim().isNotEmpty);

    for (final line in lines) {
      _parseLine(line, result);
    }

    return VehicleModel(
      date: result['date'],
      oilType: result['oilType'],
      oilSource: result['oilSource'],
      vehicleType: result['vehicleType'],
      driverName: result['driverName'],
      driverIdCard: result['driverIdCard'],
      driverPhone: result['driverPhone'],
      driverLicense: result['driverLicense'],
      plateNumber: result['plateNumber'],
      loadCapacity: result['loadCapacity'],
      vehicleLicense: result['vehicleLicense'],
      tankType: result['tankType'],
      tank1Capacity: result['tank1Capacity'],
      tank2Capacity: result['tank2Capacity'],
      hasPump: result['hasPump'],
      oilAmount: result['oilAmount'],
    );
  }

  static void _parseLine(String line, Map<String, String> result) {
    line = line.trim();

    for (final entry in fieldKeywords.entries) {
      final fieldName = entry.key;
      final keywords = entry.value;

      if (result.containsKey(fieldName)) continue;

      for (final keyword in keywords) {
        if (line.contains(keyword)) {
          final value = _extractValue(line, keyword);
          if (value != null && value.isNotEmpty) {
            result[fieldName] = value;
            break;
          }
        }
      }
    }
  }

  static String? _extractValue(String line, String keyword) {
    final keywordIndex = line.indexOf(keyword);
    if (keywordIndex == -1) return null;

    String value = line.substring(keywordIndex + keyword.length).trim();

    if (value.startsWith(':') ||
        value.startsWith('=') ||
        value.startsWith('：')) {
      value = value.substring(1).trim();
    }

    final separators = ['\n', ',', ';', '。', ' '];
    int endIndex = value.length;

    for (final sep in separators) {
      final index = value.indexOf(sep);
      if (index != -1 && index < endIndex) {
        endIndex = index;
      }
    }

    value = value.substring(0, endIndex).trim();

    value = _removeUnits(value);

    return value.isEmpty ? null : value;
  }

  static String _removeUnits(String value) {
    final unitsToRemove = ['吨', '公斤', 'kg', 't'];
    for (final unit in unitsToRemove) {
      if (value.endsWith(unit)) {
        return value.substring(0, value.length - unit.length).trim();
      }
    }
    return value;
  }

  static String toJson(VehicleModel model) {
    return jsonEncode(model.toJson());
  }

  static List<String> validateRequired(VehicleModel model) {
    final missing = <String>[];

    if (model.driverName == null || model.driverName!.isEmpty) {
      missing.add('驾驶员姓名');
    }
    if (model.plateNumber == null || model.plateNumber!.isEmpty) {
      missing.add('车号');
    }
    if (model.oilAmount == null || model.oilAmount!.isEmpty) {
      missing.add('提油吨位');
    }

    return missing;
  }
}


import 'dart:convert';
import 'package:oil_business_app/models/vehicle_model.dart';

class VehicleInfoParser {
  // --- 正则表达式定义 ---
  
  // 手机号: 1开头，第二位3-9，后面9位数字
  static final RegExp _phoneRegExp = RegExp(r'1[3-9]\d{9}');
  
  // 身份证: 15位或18位 (这里只匹配18位常见格式，17位数字+1位数字或X)
  static final RegExp _idCardRegExp = RegExp(r'\d{17}[\dXx]');
  
  // 车牌号: 简单匹配常用格式 (省份简写+字母+5或6位字符)
  static final RegExp _plateRegExp = RegExp(
    r'[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-Z0-9]{5,6}',
  );

  // 纯数字提取 (用于吨位)
  static final RegExp _numberRegExp = RegExp(r'(\d+(\.\d+)?)');

  // --- 关键词定义 ---
  static const Map<String, List<String>> fieldKeywords = {
    'date': ['日期', '时间'],
    'oilType': ['油品', '油号'],
    'oilSource': ['油库'],
    'vehicleType': ['车型'],
    'driverName': ['驾驶员姓名', '驾驶员', '司机姓名', '司机', '姓名'],
    'driverIdCard': ['驾驶员身份证', '身份证号', '身份证'],
    'driverPhone': ['驾驶员电话', '联系方式', '电话', '手机'],
    'driverLicense': ['驾驶证编码', '驾驶证号', '驾驶证'],
    'plateNumber': ['车牌号', '车牌', '车号'],
    'loadCapacity': ['核定载重', '载重'],
    'vehicleLicense': ['行驶证编号', '行驶证号', '行驶证'],
    'tankType': ['单双仓', '仓型'],
    'tank1Capacity': ['一仓', '1仓'],
    'tank2Capacity': ['二仓', '2仓'],
    'hasPump': ['是否带泵', '带泵'],
    'oilAmount': ['提油吨位', '提油量', '吨位', '数量'],
  };

  static VehicleModel parse(String text) {
    // 1. 预处理
    // 将全角冒号、等号替换为半角冒号，方便后续处理，但保留空格和换行
    String processedText = text
        .replaceAll('：', ':')
        .replaceAll('=', ':')
        .trim();

    // 2. 提取策略
    // 优先使用 "特征正则" 提取强特征字段 (车牌、手机、身份证)
    // 如果有明确的 Key: Value 格式，Key: Value 优先级更高 (避免误判)
    
    String? plateNumber = _extract(processedText, fieldKeywords['plateNumber']!) ?? 
                          _extractByPattern(processedText, _plateRegExp);
                          
    String? driverPhone = _extract(processedText, fieldKeywords['driverPhone']!) ?? 
                          _extractByPattern(processedText, _phoneRegExp);
                          
    String? driverIdCard = _extract(processedText, fieldKeywords['driverIdCard']!) ?? 
                           _extractByPattern(processedText, _idCardRegExp);

    // 3. 提取其他字段 (主要依赖关键词)
    String? driverName = _extract(processedText, fieldKeywords['driverName']!);
    String? oilAmount = _extract(processedText, fieldKeywords['oilAmount']!);
    
    // 针对吨位做特殊处理：提取后只保留数字部分
    if (oilAmount != null) {
      final match = _numberRegExp.firstMatch(oilAmount);
      if (match != null) {
        oilAmount = match.group(1);
      }
    }

    // 4. 组装结果
    // 其他字段保持原有的关键词提取逻辑
    return VehicleModel(
      date: _extract(processedText, fieldKeywords['date']!),
      oilType: _extract(processedText, fieldKeywords['oilType']!),
      oilSource: _extract(processedText, fieldKeywords['oilSource']!),
      vehicleType: _extract(processedText, fieldKeywords['vehicleType']!),
      driverName: driverName,
      driverIdCard: driverIdCard,
      driverPhone: driverPhone,
      driverLicense: _extract(processedText, fieldKeywords['driverLicense']!),
      plateNumber: plateNumber,
      loadCapacity: _extract(processedText, fieldKeywords['loadCapacity']!),
      vehicleLicense: _extract(processedText, fieldKeywords['vehicleLicense']!),
      tankType: _extract(processedText, fieldKeywords['tankType']!),
      tank1Capacity: _extract(processedText, fieldKeywords['tank1Capacity']!),
      tank2Capacity: _extract(processedText, fieldKeywords['tank2Capacity']!),
      hasPump: _extract(processedText, fieldKeywords['hasPump']!),
      oilAmount: oilAmount,
    );
  }

  /// 根据关键词提取值
  /// 支持格式：Key: Value, Key Value
  /// 解决旧算法遇空格截断的问题：现在的逻辑是提取到行尾或下一个分隔符(逗号/分号)
  static String? _extract(String text, List<String> keys) {
    for (final key in keys) {
      // 正则解释：
      // (?:Key)        -> 匹配关键词
      // \s*[:：]?\s*   -> 匹配可选的冒号和周围的空白
      // ([^,，;；\n]+) -> 捕获组1：匹配除了逗号、分号、换行符之外的任意字符 (贪婪匹配)
      // 这样 "张 三" 会被完整匹配，直到遇到逗号或换行
      final pattern = RegExp('(?:$key)\s*[:：]?\s*([^,，;；\n]+)', caseSensitive: false);
      final match = pattern.firstMatch(text);
      if (match != null) {
        String val = match.group(1)!.trim();
        return _cleanValue(val);
      }
    }
    return null;
  }

  /// 直接根据正则特征提取 (全篇搜索)
  static String? _extractByPattern(String text, RegExp pattern) {
    final match = pattern.firstMatch(text);
    return match?.group(0);
  }

  /// 清理提取到的值 (移除单位等)
  static String _cleanValue(String value) {
    if (value.isEmpty) return value;
    
    // 移除常见的尾部单位
    final unitsToRemove = ['吨', '公斤', 'kg', 't', 'L', '升'];
    String result = value;
    for (final unit in unitsToRemove) {
      // 大小写不敏感检查
      if (result.toLowerCase().endsWith(unit.toLowerCase())) {
        result = result.substring(0, result.length - unit.length).trim();
      }
    }
    return result;
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
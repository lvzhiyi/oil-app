import 'dart:convert';
import 'package:oil_business_app/models/vehicle_model.dart';

class VehicleInfoParser {
  // --- 正则表达式定义 ---
  
  // 手机号: 1开头，第二位3-9，后面9位数字
  static final RegExp _phoneRegExp = RegExp(r'1[3-9]\d{9}');

  // 日期: 匹配常见日期格式 (YYYY年MM月DD日, YYYY-MM-DD, YYYY/MM/DD, YYYY.MM.DD)
  static final RegExp _dateRegExp = RegExp(r'\d{4}[年\-\./]\d{1,2}[月\-\./]\d{1,2}[日]?');
  
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
    'loadCapacity': ['核定载重（公斤）', '核定载重(公斤)', '核定载重', '载重'],
    'vehicleLicense': ['行驶证编号', '行驶证号', '行驶证'],
    'tankType': ['单双仓', '仓型'],
    'tank1Capacity': ['一仓', '1仓'],
    'tank2Capacity': ['二仓', '2仓'],
    'hasPump': ['是否带泵', '带泵'],
    'oilAmount': ['提油吨位', '提油量', '吨位', '数量'],
  };

  static VehicleModel parse(String text) {
    // 1. 预处理
    // 策略：在所有已知关键词前面强制加换行符，解决"姓名:张三电话:123"这种无分隔符连字的问题
    String processedText = text;
    
    // 收集所有关键词并按长度降序排列（防止短词误替换长词的一部分）
    final allKeywords = fieldKeywords.values.expand((e) => e).toSet().toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final keyword in allKeywords) {
      // 简单替换，在关键词前加换行。注意：为了避免破坏本来就有的换行，可以先不加，
      // 但统一加一个换行符 \n 是最稳妥的，多余的空白会被 trim 掉。
      // 使用 replaceAll 替换所有出现的关键词
      processedText = processedText.replaceAll(keyword, '\n$keyword');
    }

    // 再次做基础清理
    processedText = processedText
        .replaceAll('：', ':')
        .replaceAll('=', ':')
        .trim();

    // 2. 提取策略
    // 优先使用 "特征正则" 提取强特征字段 (车牌、手机、身份证)
    // 如果有明确的 Key: Value 格式，Key: Value 优先级更高 (避免误判)
    // 对于这些格式固定的字段，开启 isStrict: true，遇到空格即停止，防止读取到后续字段
    
    String? plateNumber = _extract(processedText, fieldKeywords['plateNumber']!, isStrict: true) ?? 
                          _extractByPattern(processedText, _plateRegExp);
    
    // 特殊处理：车牌号中不应该包含冒号（针对用户输入 "车号：川A：DT581" 的情况）
    if (plateNumber != null) {
      plateNumber = plateNumber.replaceAll(':', '').replaceAll('：', '');
    }
                          
    String? driverPhone = _extract(processedText, fieldKeywords['driverPhone']!, isStrict: true) ?? 
                          _extractByPattern(processedText, _phoneRegExp);
                          
    String? driverIdCard = _extract(processedText, fieldKeywords['driverIdCard']!, isStrict: true) ?? 
                           _extractByPattern(processedText, _idCardRegExp);

    // 3. 提取其他字段 (主要依赖关键词)
    // 姓名等字段保持 isStrict: false，允许中间有空格 (如 "张 三")
    String? driverName = _extract(processedText, fieldKeywords['driverName']!);
    
    // 吨位通常是数字，也建议严格模式
    String? oilAmount = _extract(processedText, fieldKeywords['oilAmount']!, isStrict: true);
    
    // 针对吨位做特殊处理：提取后只保留数字部分
    if (oilAmount != null) {
      final match = _numberRegExp.firstMatch(oilAmount);
      if (match != null) {
        oilAmount = match.group(1);
      }
    }

    // 4. 组装结果
    return VehicleModel(
      date: _extract(processedText, fieldKeywords['date']!) ?? _extractByPattern(processedText, _dateRegExp),
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
  /// [isStrict] 为 true 时，遇到空格也会停止提取（适用于车牌、电话等无空格字段）
  /// [isStrict] 为 false 时，允许空格，直到遇到逗号、分号或换行（适用于姓名等可能含空格字段）
  static String? _extract(String text, List<String> keys, {bool isStrict = false}) {
    for (final key in keys) {
      // 正则解释：
      // (?:Key)        -> 匹配关键词
      // \s*[:：]?\s*   -> 匹配可选的冒号和周围的空白
      // stopChars      -> 决定匹配到哪里停止
      // 更新：加入句号(。.)作为停止符
      final stopChars = isStrict ? r'[^,，;；.。\n\s]+' : r'[^,，;；.。\n]+';
      final pattern = RegExp('(?:$key)\s*[:：]?\s*($stopChars)', caseSensitive: false);
      
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

  /// 清理提取到的值 (移除单位、首尾标点等)
  static String _cleanValue(String value) {
    if (value.isEmpty) return value;
    
    String result = value;

    // 1. 移除常见的尾部单位
    final unitsToRemove = ['吨', '公斤', 'kg', 't', 'L', '升'];
    for (final unit in unitsToRemove) {
      if (result.toLowerCase().endsWith(unit.toLowerCase())) {
        result = result.substring(0, result.length - unit.length).trim();
      }
    }

    // 2. 移除首尾的标点符号
    // 包含：句号(。.)、逗号(，,)、分号(；;)、冒号(：:)、顿号(、)、感叹号(!！)、问号(?？)以及空白字符
    // 注意：正则匹配末尾的 '.' 会被移除，这符合预期 (例如 "10.5." -> "10.5")
    final startPunctuation = RegExp(r'^[。.,，;；:：!！?？、\s]+');
    final endPunctuation = RegExp(r'[。.,，;；:：!！?？、\s]+$');

    result = result.replaceAll(startPunctuation, '');
    result = result.replaceAll(endPunctuation, '');

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
# 车辆信息智能识别解析器使用示例

## 功能概述
车辆信息智能识别解析器 (`VehicleInfoParser`) 能够从粘贴的文本中自动提取结构化数据,支持灵活的字段顺序和多种分隔符格式。

## 核心特性

### 1. 支持的字段

| 字段名 | 关键词 | 示例 |
|-------|-------|------|
| 日期 | 日期, 时间 | 2025年8月23日 |
| 油品 | 油品, 油号 | 92与95 |
| 油库 | 油库 | 新恒阳油库 |
| 车型 | 车型 | 重型罐式挂车 |
| 驾驶员姓名 | 驾驶员姓名, 驾驶员, 司机姓名 | 张三 |
| 驾驶员身份证 | 驾驶员身份证, 身份证, 身份证号 | 510184198011271101 |
| 驾驶员电话 | 驾驶员电话, 电话, 手机, 联系方式 | 13800000000 |
| 驾驶证编码 | 驾驶证编码, 驾驶证号 | 513100150000 |
| 车号 | 车号, 车牌, 车牌号 | 川A:DT1234 |
| 核定载重 | 核定载重, 载重 | 33.400 |
| 行驶证编号 | 行驶证编号, 行驶证号 | A00010046612 |
| 单双仓 | 单双仓, 仓型 | 双仓 |
| 一仓容量 | 一仓, 1仓 | 16.5吨 |
| 二仓容量 | 二仓, 2仓 | 16.5吨 |
| 是否带泵 | 是否带泵, 带泵 | 否 |
| 提油吨位 | 提油吨位, 提油量, 吨位 | 33吨 |

### 2. 支持的分隔符
- 中文冒号 `:`
- 英文冒号 `:`
- 等号 `=`
- 空格 ` `

### 3. 单位自动处理
自动移除以下单位:
- 吨 (t)
- 公斤 (kg)

## 使用示例

### 示例 1: 标准格式

**输入文本**:
```
2025年8月23日
油品：新恒阳油库：92与95
重型罐式挂车
驾驶员姓名：张三
驾驶员身份证：510184198011271101
驾驶员电话：13800000000
驾驶证编码：513100150000
车型：重型罐式挂车
车号：川A:DT1234
核定载重（公斤）：33.400
行驶证编号：A00010046612
单双仓：双仓
一仓：16.5吨
二仓：16.5吨
是否带泵：否
提油吨位：33吨
```

**Dart 代码**:
```dart
final text = '''
2025年8月23日
油品：新恒阳油库：92与95
重型罐式挂车
驾驶员姓名：张三
驾驶员身份证：510184198011271101
驾驶员电话：13800000000
驾驶证编码：513100150000
车型：重型罐式挂车
车号：川A:DT1234
核定载重（公斤）：33.400
行驶证编号：A00010046612
单双仓：双仓
一仓：16.5吨
二仓：16.5吨
是否带泵：否
提油吨位：33吨
''';

final vehicleModel = VehicleInfoParser.parse(text);
final jsonString = VehicleInfoParser.toJson(vehicleModel);

print(jsonString);
```

**输出 JSON**:
```json
{
  "date": "2025年8月23日",
  "oilType": "92与95",
  "oilSource": "新恒阳油库",
  "vehicleType": "重型罐式挂车",
  "driverName": "张三",
  "driverIdCard": "510184198011271101",
  "driverPhone": "13800000000",
  "driverLicense": "513100150000",
  "plateNumber": "川A:DT1234",
  "loadCapacity": "33.400",
  "vehicleLicense": "A00010046612",
  "tankType": "双仓",
  "tank1Capacity": "16.5",
  "tank2Capacity": "16.5",
  "hasPump": "否",
  "oilAmount": "33"
}
```

### 示例 2: 乱序输入

**输入文本** (字段顺序打乱):
```
车号：川A:DT1234
提油吨位：33吨
驾驶员姓名：张三
2025年8月23日
驾驶员电话：13800000000
油品：92与95
```

**输出 JSON**:
```json
{
  "date": "2025年8月23日",
  "oilType": "92与95",
  "driverName": "张三",
  "driverPhone": "13800000000",
  "plateNumber": "川A:DT1234",
  "oilAmount": "33"
}
```

### 示例 3: 不同分隔符

**输入文本** (使用等号和空格):
```
驾驶员姓名=张三
车号 川A:DT1234
电话:13800000000
提油量=33吨
```

**输出 JSON**:
```json
{
  "driverName": "张三",
  "driverPhone": "13800000000",
  "plateNumber": "川A:DT1234",
  "oilAmount": "33"
}
```

### 示例 4: 不完整数据

**输入文本**:
```
驾驶员姓名：张三
车号：川A:DT1234
```

**输出 JSON**:
```json
{
  "driverName": "张三",
  "plateNumber": "川A:DT1234"
}
```

**验证必填字段**:
```dart
final vehicleModel = VehicleInfoParser.parse(text);
final missing = VehicleInfoParser.validateRequired(vehicleModel);

if (missing.isNotEmpty) {
  print('缺少必填字段: ${missing.join(', ')}');
  // 输出: 缺少必填字段: 提油吨位
}
```

## 在页面中集成

### Controller 集成

```dart
// oil_pickup/controller.dart
class OilPickupCtrl extends Cubit<OilPickupState> {
  OilPickupCtrl() : super(OilPickupState());
  
  /// 处理粘贴的车辆信息
  void onVehicleInfoPasted(String text) {
    try {
      // 解析文本
      final vehicleModel = VehicleInfoParser.parse(text);
      
      // 生成 JSON
      final jsonString = VehicleInfoParser.toJson(vehicleModel);
      
      // 验证必填字段
      final missing = VehicleInfoParser.validateRequired(vehicleModel);
      
      // 更新状态
      emit(state.copyWith(
        vehicleInfo: jsonString,
        vehicleModel: vehicleModel,
        missingFields: missing,
        parseSuccess: true,
      ));
      
      // 如果有缺失字段,显示提示
      if (missing.isNotEmpty) {
        // 显示 Toast 或 SnackBar
        l.w('OilPickup', '缺少必填字段: ${missing.join(', ')}');
      } else {
        l.i('OilPickup', '车辆信息解析成功');
      }
    } catch (e) {
      l.e('OilPickup', '车辆信息解析失败: $e');
      emit(state.copyWith(
        parseSuccess: false,
        errorMessage: '解析失败,请检查格式',
      ));
    }
  }
}
```

### Widget 集成

```dart
// oil_pickup/widgets/vehicle_info_input.dart
class VehicleInfoInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onPasted;
  
  const VehicleInfoInput({
    required this.controller,
    required this.onPasted,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '粘贴车辆信息',
          fontSize: AppSizes.setFontSize(16),
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        TextField(
          controller: controller,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: '请粘贴车辆信息...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (text) {
            if (text.isNotEmpty) {
              onPasted(text);
            }
          },
        ),
      ],
    );
  }
}
```

### 显示解析结果

```dart
// 显示识别到的字段
BlocBuilder<OilPickupCtrl, OilPickupState>(
  builder: (context, state) {
    if (state.vehicleModel == null) {
      return CommonText(
        text: '暂无车辆信息',
        textColor: CustomAppColor.of(context).txtGrey,
      );
    }
    
    final model = state.vehicleModel!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.driverName != null)
          _buildInfoRow('驾驶员', model.driverName!),
        if (model.plateNumber != null)
          _buildInfoRow('车号', model.plateNumber!),
        if (model.oilAmount != null)
          _buildInfoRow('提油吨位', '${model.oilAmount}吨'),
        // ... 其他字段
        
        SizedBox(height: AppSizes.setHeight(16)),
        
        // 显示完整 JSON
        ExpansionTile(
          title: CommonText(text: '查看完整 JSON'),
          children: [
            SelectableText(
              state.vehicleInfo ?? '',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: AppSizes.setFontSize(12),
              ),
            ),
          ],
        ),
      ],
    );
  },
)
```

## 测试用例

### 单元测试

```dart
// test/utils/vehicle_info_parser_test.dart
void main() {
  group('VehicleInfoParser', () {
    test('解析标准格式', () {
      final text = '''
驾驶员姓名：张三
车号：川A:DT1234
提油吨位：33吨
''';
      
      final model = VehicleInfoParser.parse(text);
      
      expect(model.driverName, '张三');
      expect(model.plateNumber, '川A:DT1234');
      expect(model.oilAmount, '33');
    });
    
    test('处理乱序输入', () {
      final text = '''
车号：川A:DT1234
驾驶员姓名：张三
''';
      
      final model = VehicleInfoParser.parse(text);
      
      expect(model.driverName, '张三');
      expect(model.plateNumber, '川A:DT1234');
    });
    
    test('自动移除单位', () {
      final text = '提油吨位：33吨';
      final model = VehicleInfoParser.parse(text);
      
      expect(model.oilAmount, '33');
    });
    
    test('验证必填字段', () {
      final model = VehicleModel(driverName: '张三');
      final missing = VehicleInfoParser.validateRequired(model);
      
      expect(missing, contains('车号'));
      expect(missing, contains('提油吨位'));
    });
  });
}
```

## 扩展性

### 添加新字段

如需添加新字段,只需修改 `fieldKeywords` 映射表:

```dart
static const Map<String, List<String>> fieldKeywords = {
  // ... 现有字段
  'newField': ['新字段', '别名1', '别名2'],
};
```

### 添加新的关键词别名

```dart
'driverName': [
  '驾驶员姓名', 
  '驾驶员', 
  '司机姓名',
  '司机',        // 新增别名
  '驾驶人',      // 新增别名
],
```

### 自定义单位处理

修改 `_removeUnits` 方法:

```dart
static String _removeUnits(String value) {
  final unitsToRemove = [
    '吨', '公斤', 'kg', 't',
    '升', 'L', 'l',  // 新增单位
  ];
  // ...
}
```

## 性能考虑

- **时间复杂度**: O(n*m),其中 n 是文本行数,m 是字段数量 (通常 < 100ms)
- **空间复杂度**: O(n),需要存储解析结果
- **适用场景**: 适合处理几百行以内的文本

## 注意事项

1. **关键词优先级**: 先匹配到的关键词优先,后续相同字段忽略
2. **空值处理**: 未识别的字段返回 null
3. **单位处理**: 只移除末尾单位,中间的单位保留
4. **特殊字符**: 自动处理中英文标点符号
5. **性能优化**: 对于大量文本,建议分批处理

## 常见问题

### Q: 如何处理一行包含多个字段?
A: 当前算法按关键词匹配,如果一行包含多个关键词,只会识别第一个。建议每行一个字段。

### Q: 如何处理相似关键词冲突?
A: 使用更具体的关键词放在前面,如 "驾驶员姓名" 优先于 "姓名"。

### Q: 解析失败怎么办?
A: 检查文本格式,确保包含关键词和分隔符。可以开启日志查看详细信息。

---

完整的实现代码请参考: `lib/utils/vehicle_info_parser.dart`


# 提油页面功能设计文档

## Context
提油是买油呗应用的核心业务流程之一。用户需要在选择加油站后,输入提油量、粘贴车辆信息,最终生成提油凭证。此功能涉及多个页面交互和数据流转,需要清晰的架构设计。

当前阶段使用 Mock 数据进行开发,后续将接入真实 API。

## Goals / Non-Goals

### Goals
- 实现完整的提油页面用户流程
- 建立加油站选择和管理的标准模式
- 使用 Mock 数据验证交互逻辑
- 遵循项目的四层架构模式(page/controller/state/view)
- 确保响应式布局和主题适配
- 为后续 API 接入预留扩展点

### Non-Goals
- 不实现真实的后端 API 调用(使用 Mock)
- 不实现新增加油站的完整逻辑(仅预留 UI)
- 不实现提油凭证的生成逻辑(预留接口)
- 不涉及支付和订单流程

## Decisions

### 1. 页面架构设计

**决策**: 采用标准的四层架构模式

```
oil_pickup/
├── page.dart              # 路由入口,继承 BasePage
├── controller.dart        # Cubit 控制器
├── state.dart             # 状态类(包含 copyWith)
├── view.dart              # 视图组装层
└── widgets/
    └── oil_pickup_screen.dart  # 实际 UI 实现

station_list/
├── page.dart
├── controller.dart
├── state.dart
├── view.dart
└── widgets/
    ├── station_list_screen.dart
    └── station_item.dart

station_edit/
├── page.dart
├── controller.dart
├── state.dart
├── view.dart
└── widgets/
    └── station_edit_form.dart
```

**理由**:
- 符合项目现有架构规范
- 清晰的职责分离
- 便于状态管理和测试

**替代方案**:
- 单文件实现: 不符合项目规范,难以维护
- 使用 Bloc 替代 Cubit: 过度设计,页面逻辑较简单

### 2. 数据模型设计

**决策**: 创建独立的数据模型类

```dart
// lib/models/station_model.dart
class Station {
  final String id;
  final String name;
  final String address;
  final double? latitude;   // 可选,预留地图功能
  final double? longitude;
  final bool isActive;

  Station({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.isActive = true,
  });

  // copyWith, toJson, fromJson
}

// lib/models/vehicle_model.dart
class VehicleModel {
  final String? date;              // 日期: 2025年8月23日
  final String? oilType;           // 油品: 92与95
  final String? oilSource;         // 油库: 新恒阳油库
  final String? vehicleType;       // 车型: 重型罐式挂车
  final String? driverName;        // 驾驶员姓名
  final String? driverIdCard;      // 驾驶员身份证
  final String? driverPhone;       // 驾驶员电话
  final String? driverLicense;     // 驾驶证编码
  final String? plateNumber;       // 车号: 川A:DT1234
  final String? loadCapacity;      // 核定载重(公斤)
  final String? vehicleLicense;    // 行驶证编号
  final String? tankType;          // 单双仓
  final String? tank1Capacity;     // 一仓容量
  final String? tank2Capacity;     // 二仓容量
  final String? hasPump;           // 是否带泵
  final String? oilAmount;         // 提油吨位

  VehicleModel({
    this.date,
    this.oilType,
    this.oilSource,
    this.vehicleType,
    this.driverName,
    this.driverIdCard,
    this.driverPhone,
    this.driverLicense,
    this.plateNumber,
    this.loadCapacity,
    this.vehicleLicense,
    this.tankType,
    this.tank1Capacity,
    this.tank2Capacity,
    this.hasPump,
    this.oilAmount,
  });

  // toJson, fromJson, copyWith
}
```

**理由**:
- 类型安全,避免使用 Map
- 便于序列化和反序列化
- 为后续 API 集成做准备
- 字段使用 nullable,支持不完整识别

### 3. Mock 数据管理

**决策**: 在 Controller 中管理 Mock 数据

```dart
// station_list/controller.dart
class StationListCtrl extends Cubit<StationListState> {
  StationListCtrl() : super(StationListState(
    stations: _mockStations,
  ));

  static final List<Station> _mockStations = [
    Station(
      id: '1',
      name: 'xxx加油站',
      address: '北京市朝阳区xxx路xxx号',
    ),
    // ... 更多 mock 数据
  ];

  void selectStation(String stationId) {
    // 保存到全局状态或本地存储
  }

  void updateStation(Station station) {
    final updated = state.stations.map((s) =>
      s.id == station.id ? station : s
    ).toList();
    emit(state.copyWith(stations: updated));
  }
}
```

**理由**:
- 简单直接,不需要额外的 Mock 服务层
- 便于快速开发和调试
- 后续可轻松替换为真实 API 调用

**替代方案**:
- 创建独立的 MockService: 当前阶段过度设计
- 使用 Hive 本地存储: 增加不必要的复杂度

### 3.5. 车辆信息智能识别算法

**决策**: 实现基于关键词匹配的灵活解析器

```dart
// lib/utils/vehicle_info_parser.dart
class VehicleInfoParser {
  /// 字段关键词映射表
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

  /// 解析车辆信息文本
  static VehicleModel parse(String text) {
    final Map<String, String> result = {};

    // 1. 预处理: 统一分隔符
    text = text
        .replaceAll(':', ':')  // 中文冒号 -> 英文冒号
        .replaceAll('=', ':')  // 等号 -> 冒号
        .trim();

    // 2. 按行分割
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty);

    // 3. 逐行解析
    for (final line in lines) {
      _parseLine(line, result);
    }

    // 4. 生成 VehicleModel
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

  /// 解析单行文本
  static void _parseLine(String line, Map<String, String> result) {
    line = line.trim();

    // 尝试匹配每个字段
    for (final entry in fieldKeywords.entries) {
      final fieldName = entry.key;
      final keywords = entry.value;

      // 跳过已识别的字段
      if (result.containsKey(fieldName)) continue;

      // 尝试匹配关键词
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

  /// 提取字段值
  static String? _extractValue(String line, String keyword) {
    // 查找关键词位置
    final keywordIndex = line.indexOf(keyword);
    if (keywordIndex == -1) return null;

    // 提取关键词后的内容
    String value = line.substring(keywordIndex + keyword.length).trim();

    // 移除前导分隔符
    if (value.startsWith(':') ||
        value.startsWith('=') ||
        value.startsWith('：')) {
      value = value.substring(1).trim();
    }

    // 提取到下一个分隔符或行尾
    final separators = ['\n', ',', ';', '。', ' '];
    int endIndex = value.length;

    for (final sep in separators) {
      final index = value.indexOf(sep);
      if (index != -1 && index < endIndex) {
        endIndex = index;
      }
    }

    value = value.substring(0, endIndex).trim();

    // 特殊处理: 移除单位
    value = _removeUnits(value);

    return value.isEmpty ? null : value;
  }

  /// 移除单位
  static String _removeUnits(String value) {
    // 移除常见单位,保留数字和文字
    final unitsToRemove = ['吨', '公斤', 'kg', 't'];
    for (final unit in unitsToRemove) {
      if (value.endsWith(unit)) {
        return value.substring(0, value.length - unit.length).trim();
      }
    }
    return value;
  }

  /// 生成 JSON 字符串
  static String toJson(VehicleModel model) {
    return jsonEncode(model.toJson());
  }

  /// 验证必填字段
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
```

**示例输入**:
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

**算法特点**:
1. **关键词匹配**: 支持多个关键词别名
2. **灵活分隔符**: 支持冒号、等号、空格等
3. **顺序无关**: 不依赖固定顺序
4. **单位处理**: 自动移除吨、公斤等单位
5. **容错性强**: 部分字段缺失不影响其他字段识别
6. **可扩展**: 易于添加新字段和关键词

**理由**:
- 简单直接,易于理解和维护
- 适应不同格式的输入
- 性能足够(文本处理在毫秒级)
- 不依赖第三方 NLP 库

**替代方案**:
- 正则表达式: 难以维护,不够灵活
- AI/ML 模型: 过度设计,增加复杂度
- 固定格式解析: 不满足"灵活顺序"需求

### 4. 状态管理策略

**决策**:
- 页面级状态: 使用 Cubit
- 选中的加油站: 保存到全局 AppController

```dart
// oil_pickup/state.dart
class OilPickupState {
  final Station? selectedStation;  // 当前选中的加油站
  final String oilAmount;               // 油量输入
  final String vehicleInfo;             // 粘贴的车辆信息
  final bool loading;

  OilPickupState({
    this.selectedStation,
    this.oilAmount = '',
    this.vehicleInfo = '',
    this.loading = false,
  });

  OilPickupState copyWith({...}) => ...;
}

// global/app_controller.dart
class AppController extends HydratedCubit<AppState> {
  void setSelectedStation(Station station) {
    emit(state.copyWith(selectedStation: station));
  }
}
```

**理由**:
- 选中的加油站需要跨页面持久化
- 页面内的临时状态使用 Cubit 管理
- 利用 HydratedCubit 自动持久化

### 5. 页面导航策略

**决策**: 使用 BaseRouter 进行页面导航,传递参数使用 extra

```dart
// 提油页面 -> 加油站列表
BaseRouter.push(
  url: AppPage.stationListPage.path,
  extra: {'from': 'oil_pickup'},
);

// 加油站列表 -> 加油站编辑
BaseRouter.push(
  url: AppPage.stationEditPage.path,
  extra: {'stationId': station.id},
);

// 选择加油站后返回
BaseRouter.pop(result: selectedStation);
```

**理由**:
- 符合项目路由规范
- extra 参数灵活传递数据
- pop 支持返回结果

### 6. UI 组件复用

**决策**: 使用项目现有的通用组件

- `TopBar`: 页面顶部导航栏
- `CommonButton`: 主要操作按钮
- `CommonTextFormField`: 表单输入
- `CommonContainer`: 容器组件
- `CommonText`: 文本组件

**自定义组件**:
- `StationSelectorButton`: 加油站选择/切换按钮
- `StationItem`: 加油站列表项
- `OilAmountInput`: 油量输入组件
- `VehicleInfoCard`: 车辆信息展示卡片

**理由**:
- 保持 UI 一致性
- 减少重复代码
- 自动支持主题切换

## Risks / Trade-offs

### Risk 1: Mock 数据与真实 API 的差异
**风险**: Mock 数据结构可能与后端 API 不一致

**缓解措施**:
- 参考后端 API 文档设计数据模型
- 使用标准的 JSON 序列化
- 预留扩展字段
- 设计时考虑 API 错误处理

### Risk 2: 加油站选择状态管理复杂度
**风险**: 多个页面共享加油站选择状态可能导致状态不一致

**缓解措施**:
- 使用全局 AppController 统一管理
- 利用 HydratedCubit 自动持久化
- 明确状态更新的唯一入口

### Risk 3: 响应式布局适配
**风险**: 不同设备尺寸可能导致布局问题

**缓解措施**:
- 严格使用 AppSizes 工具类
- 使用 CustomAppColor 动态主题
- 在平板和手机上充分测试

### Trade-off 1: Mock vs 真实 API
**权衡**: 使用 Mock 数据快速开发 vs 等待后端 API 完成

**选择**: Mock 优先

**理由**:
- 前后端并行开发
- 快速验证交互逻辑
- 便于 UI 调试和测试

### Trade-off 2: 页面复杂度
**权衡**: 单页面实现所有功能 vs 拆分多个子页面

**选择**: 拆分页面

**理由**:
- 清晰的用户流程
- 便于代码维护
- 符合移动端交互习惯

## Migration Plan

### 阶段 1: 基础页面实现(当前)
1. 创建页面结构和路由
2. 实现 Mock 数据模型
3. 实现加油站选择流程
4. 实现加油站信息修改

### 阶段 2: API 集成(后续)
1. 替换 Mock 数据为 API 调用
2. 添加网络请求错误处理
3. 实现数据缓存策略
4. 添加加载状态和骨架屏

### 阶段 3: 完整功能(后续)
1. 实现新增加油站功能
2. 实现提油凭证生成
3. 集成车辆信息管理
4. 添加数据验证和提示

### Rollback Plan
如果遇到问题:
- Mock 数据独立于其他模块,可以安全回滚
- 新增的路由可以注释掉
- Tab 导航可以暂时隐藏提油入口

## Open Questions

1. **提油凭证生成逻辑**
   - 问题: 生成凭证的具体业务规则是什么?
   - 影响: 影响表单验证和提交逻辑
   - 决策方: 产品/后端
   - 暂定方案: 预留按钮,后续实现

2. **车辆信息粘贴格式**
   - 问题: 用户粘贴的车辆信息格式如何解析?
   - 影响: 影响数据处理逻辑
   - 决策方: 产品/后端
   - 暂定方案: 显示纯文本区域

3. **加油站数据来源**
   - 问题: 加油站数据从哪个 API 获取?是否需要搜索功能?
   - 影响: 影响列表实现和性能
   - 决策方: 后端
   - 暂定方案: 使用 Mock 静态列表

4. **新增加油站审核流程**
   - 问题: 用户新增的加油站是否需要审核?
   - 影响: 影响新增功能的实现
   - 决策方: 产品/后端
   - 暂定方案: 预留 UI,逻辑后续开发

## Implementation Notes

### 代码规范遵守
- ✅ 使用 AppSizes 进行尺寸适配
- ✅ 使用 CustomAppColor 进行主题适配
- ✅ 使用单引号定义字符串
- ✅ 所有异步操作添加 loading 状态
- ✅ 表单使用 FormBuilder 和验证器
- ✅ 日志使用 l.d/l.i/l.e
- ✅ 错误处理使用 try-catch

### 测试要点
- 加油站选择流程完整性
- 状态在页面切换时的持久化
- Mock 数据的增删改查
- 响应式布局在不同设备上的表现
- 深色模式的颜色适配
- 表单验证的正确性

### 性能考虑
- 使用 ListView.builder 渲染加油站列表
- 使用 const 构造函数
- 避免不必要的 Widget 重建
- 图标使用 WebP 格式


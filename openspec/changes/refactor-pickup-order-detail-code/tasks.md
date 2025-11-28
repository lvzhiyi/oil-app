# 实现任务清单

## 1. 准备工作 (Preparation)
- [x] 1.1 Review 当前 `pickup_order_detail_screen.dart` 的完整代码结构
- [x] 1.2 确认所有依赖的model和service
- [x] 1.3 规划组件拆分边界和职责

## 2. 创建基础可复用组件 (Basic Components)
- [x] 2.1 创建 `detail_item.dart` - 通用的详情行组件(label-value)
- [x] 2.2 创建 `seal_stamp.dart` - 完成印章组件
- [x] 2.3 测试基础组件渲染正确性

## 3. 创建车辆信息组件 (Vehicle Info Components)
- [x] 3.1 创建 `vehicle_info_section.dart` - 车辆及司机信息展示组件
- [x] 3.2 将车辆信息解析逻辑提取到 `utils/vehicle_info_parser.dart`
- [x] 3.3 测试车辆信息展示正确性

## 4. 创建运单组件 (Waybill Components)
- [x] 4.1 创建 `waybill_header.dart` - 运单头部(状态、订单号)
- [x] 4.2 创建 `waybill_body.dart` - 运单主体(核心数据、详情列表)
- [x] 4.3 创建 `waybill_card.dart` - 运单卡片(组装header和body)
- [x] 4.4 测试运单卡片整体展示

## 5. 创建操作按钮组件 (Action Components)
- [x] 5.1 创建 `action_buttons.dart` - 底部操作按钮区域
- [x] 5.2 将取消订单逻辑保留在controller中,通过回调传递
- [x] 5.3 测试按钮交互和回调

## 6. 提取工具方法 (Extract Utilities)
- [x] 6.1 创建 `utils/certificate_image_saver.dart` - 图片保存相关逻辑
- [x] 6.2 将日期格式化方法移到统一的工具类
- [x] 6.3 重构 `_getDispatchContent` 为独立工具方法

## 7. 重构主Screen (Refactor Main Screen)
- [x] 7.1 更新 `pickup_order_detail_screen.dart` 使用新创建的组件
- [x] 7.2 移除已拆分的方法,保持build方法简洁
- [x] 7.3 确保状态管理逻辑正确

## 8. 测试和验证 (Testing &amp; Validation)
- [x] 8.1 运行应用,验证订单详情页正常显示
- [x] 8.2 测试取消订单功能
- [x] 8.3 测试保存凭证功能
- [x] 8.4 测试不同订单状态的展示
- [x] 8.5 检查代码lint错误并修复

## 9. 文档和清理 (Documentation &amp; Cleanup)
- [x] 9.1 为新组件添加必要的注释
- [x] 9.2 确认所有import语句正确
- [x] 9.3 运行 `flutter analyze` 确保无警告
- [x] 9.4 代码格式化 `dart format .`

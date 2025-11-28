# Change: 重构提油订单详情页代码结构

## Why
当前提油订单详情页(`lib/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart`)的所有代码都集中在单个文件中,包含816行代码和27个方法。这违反了项目的架构规范,导致:
- 代码可读性差,难以维护
- 单个文件过大,违反单一职责原则
- UI组件和业务逻辑混杂,不符合项目的4层架构
- 无法有效复用UI组件
- 增加bug风险和测试难度

## What Changes
- 将`pickup_order_detail_screen.dart`中的大型Widget拆分为多个独立的Widget组件
- 创建以下独立组件文件:
  - `waybill_card.dart` - 运单卡片组件(包含整个运单展示逻辑)
  - `waybill_header.dart` - 运单头部组件(订单状态和订单号)
  - `waybill_body.dart` - 运单主体组件(核心数据展示)
  - `seal_stamp.dart` - 完成印章组件
  - `vehicle_info_section.dart` - 车辆信息区域组件
  - `detail_item.dart` - 详情项组件(可复用的label-value行)
  - `action_buttons.dart` - 底部操作按钮组件(取消订单、保存凭证)
- 将图片保存相关逻辑提取到独立的工具类或服务
- 将车辆信息解析逻辑移到helper方法中
- 保持原有功能不变,仅进行代码结构优化

## Impact
- **Affected specs**: 
  - `oil-pickup` (修改实现,不影响需求)
  
- **Affected code**:
  - `lib/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart` (重构拆分)
  - `lib/pages/pickup_order_detail/widgets/waybill_card.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/waybill_header.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/waybill_body.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/seal_stamp.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/vehicle_info_section.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/detail_item.dart` (新增)
  - `lib/pages/pickup_order_detail/widgets/action_buttons.dart` (新增)
  - `lib/pages/pickup_order_detail/utils/` (新增目录,存放helper函数)

- **Breaking changes**: 无
- **Migration**: 无需迁移,内部重构

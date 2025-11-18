# Change: 优化提油页面空态显示

## Why
当前提油页面在无买油订单或无可用库存时缺少友好的空态提示。用户需要清楚地了解当前状态：是否有买油订单、订单的基本信息（油库名称、油品类型、剩余库存）以及是否可以进行提油操作。

## What Changes
- 当没有买油订单时，显示空态标志（仅显示空态，不显示其他内容）
- 当有买油订单时，在页面上方显示订单信息卡片，包含：
  - 油库名称
  - 买油订单的油品类型
  - 剩余库存（吨）
- 当有买油订单但无可用库存时，在订单信息卡片下方显示空态标志
- 优化页面布局，确保空态显示符合设计规范

## Impact
- **Affected specs**: 
  - `oil-pickup` (修改，添加空态显示需求)
  
- **Affected code**:
  - `lib/pages/oil_pickup/controller.dart` (修改，获取订单详细信息包括库存)
  - `lib/pages/oil_pickup/state.dart` (修改，添加订单详情和库存字段)
  - `lib/pages/oil_pickup/widgets/oil_pickup_screen.dart` (修改，添加空态显示逻辑)
  - `lib/pages/oil_pickup/widgets/` (新增，订单信息卡片组件)
  - `lib/pages/pay_order_list/service/pay_order_list.dart` (可能需要添加订单详情接口)


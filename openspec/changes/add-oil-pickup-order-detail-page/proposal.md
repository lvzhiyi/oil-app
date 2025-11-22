# Change: 新增提油订单详情页

## Why
用户需要能够查看提油订单的详细信息。当前提油订单列表页点击列表项后跳转到了提油详情页（用于提油操作），而不是订单详情页。需要新增一个专门的提油订单详情页，让用户可以查看已创建的提油订单的完整信息。

## What Changes
- 创建提油订单详情页，使用与提油成功页面相同的布局结构和样式（但不包含底部返回按钮）
- 页面显示提油订单的详细信息，包括：
  - 提油信息（提油单号、提油量、状态等）
  - 加油站信息（加油站名称、地址）
  - 车辆及司机信息（从 vehicleInfo JSON 解析）
- 在提油订单列表页添加点击跳转逻辑，点击列表项跳转到订单详情页
- 添加路由配置，支持从列表页传递订单数据到详情页
- 页面使用 AppBar 的返回按钮进行导航，不包含底部固定按钮

## Impact
- **Affected specs**:
  - `oil-pickup-order-detail` (新增能力)

- **Affected code**:
  - `lib/pages/pickup_order_detail/` (新增页面目录)
  - `lib/pages/pickup_list/view.dart` (修改点击跳转逻辑)
  - `lib/router/routes.dart` (新增路由配置)


## 1. 创建提油订单详情页结构
- [ ] 1.1 创建 `lib/pages/pickup_order_detail/` 目录结构
- [ ] 1.2 创建 `page.dart`、`controller.dart`、`state.dart`、`view.dart`
- [ ] 1.3 创建 `widgets/pickup_order_detail_screen.dart`，复用提油成功页面的布局结构

## 2. 实现页面UI
- [ ] 2.1 实现页面布局（Scaffold + AppBar + Expanded + SingleChildScrollView结构）
- [ ] 2.2 实现可滚动内容区域（SingleChildScrollView）
- [ ] 2.3 实现提油信息卡片（显示提油单号、提油量、状态等）
- [ ] 2.4 实现加油站信息卡片（显示加油站名称、地址）
- [ ] 2.5 实现车辆及司机信息卡片（从 vehicleInfo JSON 解析并显示）

## 3. 实现数据解析和展示
- [ ] 3.1 在 controller 中实现从路由参数获取订单数据
- [ ] 3.2 实现 vehicleInfo JSON 字符串解析为 VehicleModel
- [ ] 3.3 实现订单状态文本和颜色显示
- [ ] 3.4 处理数据为空的情况（显示默认值或隐藏字段）

## 4. 更新路由配置
- [ ] 4.1 在 `routes.dart` 中新增 `pickupOrderDetailPage` 路由枚举
- [ ] 4.2 在 `PageRoute` extension 中添加路由构建器
- [ ] 4.3 实现路由参数传递逻辑（传递 WithdrawOrderModel）

## 5. 更新提油订单列表页
- [ ] 5.1 修改 `lib/pages/pickup_list/view.dart` 中的点击跳转逻辑
- [ ] 5.2 将跳转目标从 `oilPickupDetailPage` 改为 `pickupOrderDetailPage`
- [ ] 5.3 传递完整的订单数据（WithdrawOrderModel）到详情页

## 6. 测试验证
- [ ] 6.1 测试从提油订单列表页点击列表项跳转到详情页
- [ ] 6.2 测试详情页正确显示订单信息
- [ ] 6.3 测试 vehicleInfo JSON 解析和显示
- [ ] 6.4 测试数据为空时的显示处理
- [ ] 6.5 测试 AppBar 返回按钮功能


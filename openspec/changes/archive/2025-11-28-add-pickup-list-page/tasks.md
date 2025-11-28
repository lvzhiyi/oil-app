# 实现任务清单

## 1. 页面基础结构
- [x] 1.1 创建提油列表页面目录 `lib/pages/pickup_list/` 及基础文件 (page.dart, controller.dart, state.dart, view.dart)
- [x] 1.2 在 `lib/router/routes.dart` 中注册提油列表页面路由
- [x] 1.3 在 `lib/pages/profile/widgets/account_screen.dart` 中添加"提油管理"菜单项并实现跳转

## 2. 业务逻辑实现 (Controller & State)
- [x] 2.1 定义 `PickupListState`，包含当前选中的标签索引、列表数据、加载状态等
- [x] 2.2 实现 `PickupListCtrl.getPickupList` 方法，调用 `OilPickupService.getWithdrawOrderList` 接口
- [x] 2.3 实现下拉刷新和上拉加载更多逻辑

## 3. UI 实现 (View & Widgets)
- [x] 3.1 实现页面顶部标签栏 (TabBar)，包含"待提油"和"已完成"
- [x] 3.2 实现列表视图 (ListView)，展示提油订单信息
- [x] 3.3 实现列表项组件 (PickupListItem)，展示订单详情 (单号、油库、吨数、状态等)
- [x] 3.4 处理空数据和错误状态显示

## 4. 测试与验证
- [x] 4.1 验证从"我的"页面能否正确跳转
- [x] 4.2 验证"待提油"列表数据加载和展示
- [x] 4.3 验证"已完成"列表数据加载和展示
- [x] 4.4 验证分页加载和下拉刷新功能

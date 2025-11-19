## 1. 创建库存详情提油页面
- [ ] 1.1 创建 `lib/pages/oil_pickup_detail/` 目录结构
- [ ] 1.2 创建 `page.dart`、`controller.dart`、`state.dart`、`view.dart`
- [ ] 1.3 创建 `widgets/oil_pickup_detail_screen.dart`，复用现有提油表单逻辑
- [ ] 1.4 实现从路由参数获取库存信息的逻辑
- [ ] 1.5 实现提油表单提交功能（复用现有逻辑）

## 2. 重构现有提油页面为库存列表页面
- [ ] 2.1 修改 `state.dart`，将 `pendingOilOrder` 改为 `inventories` 列表，添加分页相关状态（currentPage、hasMore、isLoadingMore 等）
- [ ] 2.2 修改 `controller.dart`，将 `_loadPendingOilOrder` 改为 `_loadInventories`，实现初始加载（page: 1, pageSize: 10）
- [ ] 2.3 在 `controller.dart` 中实现 `loadMoreInventories` 方法，支持加载下一页
- [ ] 2.4 创建 `widgets/inventory_list_screen.dart`，使用 ListView.builder 实现列表展示
- [ ] 2.5 在 `inventory_list_screen.dart` 中实现滚动监听，当滚动到底部时触发加载更多
- [ ] 2.6 创建 `widgets/inventory_item.dart`，实现库存列表项组件
- [ ] 2.7 实现加载状态显示（加载中、加载完成、加载失败）
- [ ] 2.8 修改 `oil_pickup_screen.dart`，移除提油表单，改为显示库存列表
- [ ] 2.9 实现点击库存项跳转到详情页面的逻辑

## 3. 更新路由配置
- [ ] 3.1 在 `routes.dart` 中新增 `oilPickupDetailPage` 路由枚举
- [ ] 3.2 在 `PageRoute` extension 中添加路由构建器
- [ ] 3.3 实现路由参数传递逻辑

## 4. 测试验证
- [ ] 4.1 测试无库存时的空态显示
- [ ] 4.2 测试有单个库存时的列表显示和跳转
- [ ] 4.3 测试有多个库存（≤10个）时的列表显示和跳转
- [ ] 4.4 测试有多个库存（>10个）时的分页加载功能
- [ ] 4.5 测试滚动到底部自动加载下一页
- [ ] 4.6 测试加载状态显示（加载中、加载完成、加载失败）
- [ ] 4.7 测试加载全部数据后的提示显示
- [ ] 4.8 测试库存详情页面的提油表单功能
- [ ] 4.9 测试提油提交功能

## 5. 代码清理
- [ ] 5.1 移除废弃的代码和注释
- [ ] 5.2 更新相关注释和文档


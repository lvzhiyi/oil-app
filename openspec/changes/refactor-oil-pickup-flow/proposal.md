# Change: 重构提油页面流程

## Why
当前提油页面在初始化时只获取第一个库存油，无法处理多个库存的情况。用户需要能够查看所有可用库存列表，并选择特定的库存进行提油操作。

## What Changes
- **BREAKING**: 提油页面流程重构，从直接显示提油表单改为先显示库存列表
- 修改提油页面初始化逻辑，使用分页查询（pageSize: 10）获取库存列表
- 实现上滑加载更多功能，支持瀑布流形式的分页加载
- 新增库存列表展示页面，显示可用库存列表
- 新增库存详情提油页面，用于输入提油信息并提交
- 保持空态显示逻辑不变（无库存时显示空态）

## Impact
- Affected specs: `oil-pickup` capability
- Affected code:
  - `lib/pages/oil_pickup/` - 重构现有页面为库存列表页面
  - 新增 `lib/pages/oil_pickup_detail/` - 库存详情提油页面
  - `lib/router/routes.dart` - 新增路由配置
  - `lib/pages/oil_pickup/service/oil_pickup_service.dart` - 修改查询逻辑（pageSize）


# Design: 重构提油页面流程

## Context
当前提油页面在初始化时调用 `getInventories` 接口，但只获取第一个库存（pageSize: 1）。如果有库存，直接显示提油表单；如果没有，显示空态。

用户需求是将流程拆分为两个页面：
1. 库存列表页面：显示所有可用库存
2. 库存详情提油页面：选择特定库存后，输入提油信息并提交

## Goals / Non-Goals
- Goals:
  - 支持多个库存的展示和选择
  - 保持现有空态显示逻辑
  - 保持现有提油表单功能不变
  - 保持现有 API 接口调用逻辑

- Non-Goals:
  - 不修改库存查询 API 接口
  - 不修改提油提交 API 接口
  - 不修改车辆信息解析逻辑

## Decisions

### Decision: 页面拆分策略
将现有 `oil_pickup` 页面重构为库存列表页面，新增 `oil_pickup_detail` 页面用于提油表单。

**Rationale**:
- 符合单一职责原则
- 库存列表和提油表单是不同层级的操作
- 便于后续扩展（如库存筛选、搜索等）

**Alternatives considered**:
- 在同一个页面内切换视图：会增加状态管理复杂度
- 使用 BottomSheet：不适合复杂的表单交互

### Decision: 路由设计
- `/oilPickup` - 库存列表页面（重构现有页面）
- `/oilPickupDetail` - 库存详情提油页面（新增）

**Rationale**:
- 保持现有路由路径不变，减少影响范围
- 新增详情页面路由，清晰表达页面层级关系

### Decision: 数据传递方式
通过路由参数传递选中的库存信息（InventoryModel）。

**Rationale**:
- 使用路由 extra 参数传递数据
- 避免全局状态污染
- 符合 Flutter 路由最佳实践

**Alternatives considered**:
- 使用全局状态：会增加状态管理复杂度
- 使用数据库缓存：过度设计

### Decision: 库存查询参数和分页加载
修改 `getInventories` 调用，使用 pageSize: 10 进行分页查询，并实现上滑加载更多功能。

**Rationale**:
- 保持 API 接口不变
- 使用分页加载减少初始加载时间
- 支持大量库存数据的展示
- 符合移动端列表加载最佳实践

**实现方式**:
- 初始加载第一页（page: 1, pageSize: 10）
- 使用 ListView 或类似组件实现滚动加载
- 当用户滚动到底部时自动加载下一页
- 显示加载状态和加载完成提示

**Alternatives considered**:
- 一次性加载所有库存：数据量大时影响性能
- 手动点击加载更多：用户体验不如自动加载流畅

## Risks / Trade-offs
- **风险**: 分页加载可能增加状态管理复杂度
  - **缓解**: 使用成熟的分页加载模式，在 state 中维护 page、hasMore、isLoadingMore 等状态

- **风险**: 页面重构可能影响现有功能
  - **缓解**: 保持现有 API 调用和业务逻辑不变，只改变页面展示方式

- **风险**: 滚动加载可能影响性能
  - **缓解**: 使用 ListView.builder 按需构建列表项，避免一次性渲染所有项目

## Migration Plan
1. 创建新的库存详情提油页面
2. 重构现有提油页面为库存列表页面
3. 更新路由配置
4. 测试验证功能完整性
5. 清理废弃代码

## Open Questions
- 是否需要支持库存筛选或搜索功能？（当前阶段不考虑）


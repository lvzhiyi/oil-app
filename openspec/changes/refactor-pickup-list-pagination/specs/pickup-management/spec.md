## ADDED Requirements
### Requirement: 提油列表标准分页
提油列表 SHALL 使用标准的下拉刷新和滚动加载机制，替代原有的 EasyRefresh 实现。

#### Scenario: 滚动加载
- **WHEN** 用户滚动提油列表到底部
- **AND** 存在下一页数据
- **THEN** 系统自动加载下一页数据
- **AND** 显示底部加载指示器

#### Scenario: 状态切换重置
- **WHEN** 用户切换"待提油"或"已完成"标签
- **THEN** 列表重置为第一页
- **AND** 自动刷新数据

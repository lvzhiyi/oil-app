## ADDED Requirements
### Requirement: 买油订单列表标准分页
买油订单列表 SHALL 使用标准的下拉刷新和滚动加载机制。

#### Scenario: 滚动加载
- **WHEN** 用户滚动订单列表到底部
- **AND** 存在下一页数据
- **THEN** 系统自动加载下一页数据
- **AND** 新数据追加到列表底部
- **AND** 修复原有的数据重复 Bug

#### Scenario: 状态筛选
- **WHEN** 用户切换订单状态标签（如待支付、已支付）
- **THEN** 列表重置为第一页
- **AND** 重新加载对应状态的数据

# Main Navigation Capability - Delta Changes

## MODIFIED Requirements

### Requirement: Tab 导航结构
主应用 SHALL 提供底部 Tab 导航栏,包含多个主要功能入口。

#### Scenario: 显示所有 Tab
- **WHEN** 用户登录成功进入主页
- **THEN** 系统应在底部显示 Tab 导航栏
- **AND** 应包含首页、提油、订单等主要功能入口
- **AND** 第二个 Tab 应为提油页面

#### Scenario: 切换到提油 Tab
- **WHEN** 用户点击第二个 Tab(提油)
- **THEN** 系统应导航到提油页面
- **AND** Tab 图标应高亮显示当前选中状态
- **AND** 页面内容应切换到提油页面

#### Scenario: Tab 状态持久化
- **WHEN** 用户在不同 Tab 间切换
- **THEN** 系统应记住每个 Tab 的浏览状态
- **AND** 返回已访问的 Tab 时应恢复之前的状态

#### Scenario: Tab 图标和文字
- **WHEN** 用户查看 Tab 导航栏
- **THEN** 每个 Tab 应显示对应的图标和文字标签
- **AND** 图标应支持亮色/暗色主题切换
- **AND** 选中 Tab 应使用紫色主题色高亮


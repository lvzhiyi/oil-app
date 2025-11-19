## ADDED Requirements

### Requirement: 加油站管理列表页
系统 SHALL 提供专门的加油站管理列表页面，用于用户查看和管理所有加油站信息。

#### Scenario: 从个人中心进入管理列表页
- **WHEN** 用户在个人中心页面点击"加油站管理"按钮
- **THEN** 系统跳转到加油站管理列表页面
- **AND** 页面标题显示为"加油站管理"

#### Scenario: 加载加油站列表
- **WHEN** 用户进入加油站管理列表页面
- **THEN** 系统调用 getStationStatus 接口获取加油站列表
- **AND** 接口参数为 page=1, pageSize=1, statuses=[active, pending_review]
- **AND** 显示加载状态指示器

#### Scenario: 显示加油站列表
- **WHEN** 接口返回加油站数据
- **THEN** 系统在列表中展示所有加油站信息
- **AND** 每个列表项显示加油站名称和地址
- **AND** 每个列表项提供编辑按钮

#### Scenario: 编辑加油站
- **WHEN** 用户点击某个加油站的编辑按钮
- **THEN** 系统跳转到加油站编辑页面
- **AND** 传递加油站ID作为参数

#### Scenario: 新增加油站
- **WHEN** 用户在管理列表页点击"新增加油站"按钮
- **THEN** 系统跳转到加油站编辑页面（新增模式）
- **AND** 不传递加油站ID参数

#### Scenario: 加载失败处理
- **WHEN** 接口请求失败
- **THEN** 系统显示错误提示信息
- **AND** 提供重试按钮允许用户重新加载

#### Scenario: 空状态处理
- **WHEN** 接口返回空列表
- **THEN** 系统显示空状态提示
- **AND** 提供"新增加油站"按钮引导用户添加


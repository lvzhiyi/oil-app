# Main Navigation Capability - Delta Changes

## MODIFIED Requirements

### Requirement: 底部导航栏
系统 SHALL 提供底部标签栏导航，支持主要功能模块的快速切换，包括提油页面入口。

#### Scenario: 显示底部导航栏
- **WHEN** 用户进入主界面
- **THEN** 系统在屏幕底部显示导航栏
- **AND** 导航栏包含多个标签项（买油、提油、我的等）
- **AND** 第二个标签为"提油"页面
- **AND** 当前选中的标签高亮显示

#### Scenario: 切换标签页
- **WHEN** 用户点击底部导航栏的标签
- **THEN** 系统切换到对应的页面
- **AND** 标签的选中状态更新
- **AND** 顶部栏标题和按钮随之更新
- **AND** 触发全局标签切换事件

#### Scenario: 标签页状态保持
- **WHEN** 用户在标签页之间切换
- **THEN** 每个标签页保持其之前的状态
- **AND** 滚动位置被保留
- **AND** 输入的数据不会丢失

#### Scenario: 默认选中首页
- **WHEN** 应用首次进入主界面
- **THEN** 默认选中第一个标签（索引0，买油）
- **AND** 显示对应的页面内容


# Capability: Main Navigation (主界面导航)

## Purpose

主界面导航能力提供应用的核心导航结构，包括底部标签栏、顶部栏和页面切换管理。支持多个功能模块的快速切换，动态顶部栏配置，标签页状态保持，以及全局事件通信机制。

## Requirements

### Requirement: 底部导航栏
系统 SHALL 提供底部标签栏导航，支持主要功能模块的快速切换。

#### Scenario: 显示底部导航栏
- **WHEN** 用户进入主界面
- **THEN** 系统在屏幕底部显示导航栏
- **AND** 导航栏包含多个标签项（买油、提油、我的等）
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

### Requirement: 顶部栏
系统 SHALL 根据当前选中的标签动态显示顶部栏内容。

#### Scenario: 买油页面顶部栏
- **WHEN** 用户在"买油"标签页
- **THEN** 顶部栏显示标题"买油"
- **AND** 显示用户头像按钮
- **AND** 显示通知铃铛按钮
- **AND** 显示点赞/收藏按钮
- **AND** 显示购物车按钮及数量徽章
- **AND** 顶部栏背景色使用特定的主题色

#### Scenario: 提油页面顶部栏
- **WHEN** 用户在"提油"标签页
- **THEN** 顶部栏显示标题"提油"
- **AND** 显示搜索输入框
- **AND** 显示点赞/收藏按钮
- **AND** 显示购物车按钮
- **AND** 顶部栏背景色使用脚手架背景色

#### Scenario: 我的页面顶部栏
- **WHEN** 用户在"我的"标签页
- **THEN** 顶部栏显示标题"我的"
- **AND** 不显示其他操作按钮
- **AND** 顶部栏显示阴影效果
- **AND** 文字颜色使用黑色

#### Scenario: 顶部栏高度
- **WHEN** 顶部栏显示时
- **THEN** 高度固定为120个逻辑像素
- **AND** 在不同设备上保持一致的视觉效果

### Requirement: TabController管理
系统 SHALL 使用TabController管理标签页的状态和切换。

#### Scenario: 初始化TabController
- **WHEN** 主界面组件初始化
- **THEN** 创建TabController并设置标签数量
- **AND** 绑定当前组件为vsync提供者
- **AND** 添加索引变化监听器

#### Scenario: 监听标签切换
- **WHEN** TabController的索引发生变化
- **THEN** 系统更新选中的底部导航索引
- **AND** 触发状态更新重建顶部栏
- **AND** 仅在索引变化完成后触发（非changing状态）

#### Scenario: 销毁TabController
- **WHEN** 主界面组件被销毁
- **THEN** 系统正确释放TabController资源
- **AND** 移除所有监听器
- **AND** 避免内存泄漏

### Requirement: 页面状态管理
系统 SHALL 管理主界面的全局状态。

#### Scenario: 当前选中索引
- **WHEN** 用户切换标签页
- **THEN** 系统在MainLayoutState中更新selectedIndex
- **AND** 通过Cubit的emit方法触发UI更新
- **AND** 所有依赖该状态的组件自动重建

#### Scenario: 底部导航栏可见性
- **WHEN** 某些场景需要隐藏底部导航栏
- **THEN** 系统通过toggleBottomNavigation方法控制显示/隐藏
- **AND** showBottomNavigation状态被更新
- **AND** UI根据状态调整布局

#### Scenario: 状态持久化
- **WHEN** 应用在主界面被最小化或暂停
- **THEN** 当前选中的标签索引被保持
- **AND** 用户返回时恢复到相同的标签页
- **AND** 页面内容状态被保留

### Requirement: 全局事件通信
系统 SHALL 提供全局事件总线用于标签切换通知。

#### Scenario: 触发标签切换事件
- **WHEN** 用户通过底部导航切换标签
- **THEN** 系统通过globalTabChangeEventBus广播切换事件
- **AND** 事件包含新的标签索引
- **AND** 订阅者可以接收并响应该事件

#### Scenario: 页面响应标签事件
- **WHEN** 某个标签页组件监听标签切换事件
- **THEN** 该组件在被切换到时收到通知
- **AND** 可以执行数据刷新或状态更新逻辑
- **AND** 可以处理页面激活/非激活的生命周期

### Requirement: 导航栏配置
系统 SHALL 提供灵活的导航栏配置。

#### Scenario: 导航项配置
- **WHEN** 系统初始化底部导航栏
- **THEN** 从bottomNavigationBarList读取配置
- **AND** 每个配置项包含图标、标题、页面组件
- **AND** 支持动态增减导航项

#### Scenario: 条件显示导航项
- **WHEN** 某些导航项需要权限或条件才能显示
- **THEN** 系统根据用户角色或状态过滤导航项
- **AND** 动态调整TabController的长度
- **AND** 保持索引映射的一致性

### Requirement: 响应式布局
系统 SHALL 适配不同尺寸的设备。

#### Scenario: 手机端布局
- **WHEN** 设备屏幕宽度 ≤ 600像素
- **THEN** 使用标准的底部导航栏布局
- **AND** 导航栏始终显示在底部
- **AND** 顶部栏使用移动端高度

#### Scenario: 平板端布局
- **WHEN** 设备屏幕宽度 > 600像素
- **THEN** 系统检测为平板设备
- **AND** 可以使用侧边栏导航（如果实现）
- **AND** 顶部栏宽度和间距适配大屏

### Requirement: 导航动画
系统 SHALL 提供流畅的页面切换动画。

#### Scenario: 标签切换动画
- **WHEN** 用户切换标签页
- **THEN** 页面内容平滑过渡
- **AND** 使用系统默认的TabBarView切换动画
- **AND** 动画时长适中，不影响用户体验

#### Scenario: 顶部栏元素动画
- **WHEN** 顶部栏内容因标签切换而改变
- **THEN** 按钮的显示/隐藏有淡入淡出效果
- **AND** 标题文字平滑切换
- **AND** 背景色渐变过渡

## Technical Notes

### State Management
- 使用 Cubit 管理主界面状态（MainLayoutCtrl）
- 状态类: MainLayoutState { selectedIndex, showBottomNavigation }
- 通过 BlocBuilder 响应状态变化

### Component Structure
```
MainLayoutPage (BasePage)
  └─ MainLayoutView (StatefulWidget)
      ├─ TopBar (自定义顶部栏组件)
      └─ TabBarView
          ├─ 买油页面
          ├─ 提油页面
          └─ 我的页面
```

### Event Bus
- 使用 event_bus 包
- 全局实例: globalTabChangeEventBus
- 事件类型: int (标签索引)

### TopBar Configuration
- 动态配置属性:
  - title: 标题文字
  - isShowProfile: 是否显示用户头像
  - isShowNotification: 是否显示通知按钮
  - isShowLike: 是否显示点赞按钮
  - isShowSearchField: 是否显示搜索框
  - isShowCart: 是否显示购物车
  - isShowCartCount: 是否显示购物车数量
  - topBarColor: 背景颜色
  - textColor: 文字颜色
  - isShowShadow: 是否显示阴影
  - height: 高度

### TabController
- 使用 SingleTickerProviderStateMixin
- length: 根据 bottomNavigationBarList.length 动态设置
- 监听 indexIsChanging 事件
- 在 dispose 时正确释放资源

### Navigation Data Source
- bottomNavigationBarList: 配置数组
- 每项包含: { icon, label, widget, ... }
- 中央化配置便于维护

### Performance Considerations
- 使用 AutomaticKeepAliveClientMixin 保持页面状态
- 避免不必要的重建
- 使用 const 构造函数
- 合理使用 RepaintBoundary

### Accessibility
- 底部导航项支持语义标签
- 顶部栏按钮有合适的点击区域
- 支持键盘导航（Web平台）


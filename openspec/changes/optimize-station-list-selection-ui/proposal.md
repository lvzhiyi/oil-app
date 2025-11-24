# Change: 优化加油站选择页面UI样式

## Why
当前加油站选择页面的UI样式需要根据HTML设计稿进行优化，以提供更现代化和一致的用户体验。需要优化列表项的卡片样式、选中状态的视觉反馈，以及底部确认按钮的样式。

## What Changes
- 优化列表项卡片样式：按照HTML设计实现卡片式布局，包括圆角、阴影、间距等
- 优化选中状态视觉反馈：选中时显示紫色边框、浅紫色背景和阴影效果
- 优化选中图标样式：右侧显示圆形选中图标，选中时显示紫色背景和白色勾选标记
- 优化地址显示：地址文字使用12px字体，添加位置图标
- 优化底部确认按钮：固定在底部，使用28px圆角，16px字体
- 保持头部导航栏不变：按照要求不修改AppBar部分

## Impact
- **Affected specs**:
  - `station-management` (修改，优化加油站选择页面的UI样式需求)

- **Affected code**:
  - `lib/pages/station_list/widgets/station_list_screen.dart` (添加底部确认按钮)
  - `lib/pages/station_list/widgets/station_item.dart` (优化卡片样式和选中状态)
  - `lib/pages/station_list/controller.dart` (可能需要添加确认选择的方法)


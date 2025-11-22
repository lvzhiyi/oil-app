# Change: 优化加油站管理列表页UI和功能

## Why
当前加油站管理列表页的UI设计需要优化，以提供更好的用户体验。同时需要支持按状态筛选加油站，显示状态标签和驳回原因，并修复筛选功能的bug。

## What Changes
- 优化UI布局：按照HTML设计实现顶部固定区域（导航栏+筛选栏）和卡片式列表布局
- 添加状态筛选功能：支持按全部、正常、待审核、已驳回、禁用状态筛选
- 显示状态标签：每个加油站卡片显示对应的状态标签（正常/待审核/已驳回/禁用）
- 显示驳回原因：已驳回状态的加油站显示驳回原因提示框
- 数据模型扩展：在Station和Station中添加status和rejectReason字段
- 主题色适配：将所有硬编码颜色替换为应用主题色系统
- Bug修复：修复"全部"筛选标签无法选中的问题

## Impact
- **Affected specs**:
  - `station-management` (修改，优化加油站管理列表页的UI和功能需求)

- **Affected code**:
  - `lib/pages/station_management_list/widgets/station_management_list_screen.dart` (UI优化)
  - `lib/pages/station_management_list/widgets/station_management_item.dart` (卡片组件优化)
  - `lib/pages/station_management_list/controller.dart` (筛选逻辑优化)
  - `lib/pages/station_management_list/state.dart` (状态管理优化)
  - `lib/models/station_model.dart` (添加status和rejectReason字段)
  - `lib/global/model/station_res_type.dart` (添加rejectReason字段)


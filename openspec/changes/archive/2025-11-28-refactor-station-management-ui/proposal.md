# Change: 重构加油站管理页面UI

## Why
当前加油站管理页面的UI设计与HTML设计稿存在较大差异，需要按照HTML设计稿重构列表页和表单页的UI样式，以提供更现代化、一致的用户体验。主要改进包括：更紧凑的导航栏、优化的筛选Tabs样式、改进的卡片布局、独立的驳回原因提示框、以及更清晰的表单分组和上传组件样式。

## What Changes
- **列表页UI重构**：
  - 优化顶部导航栏样式（44px高度，白色背景，带阴影和底部边框）
  - 重构筛选Tabs样式（横向滚动，无背景色，左对齐，左边距16px与列表对齐，使用IntrinsicWidth让下划线宽度与文字一致，下划线居中显示）
  - 优化卡片样式（圆角12px，阴影效果，地址区域灰色背景#F9FAFB）
  - 重构驳回原因提示框（独立的红色提示框，带图标和标题）
  - 优化操作按钮区域（顶部虚线分隔，使用DashedLinePainter绘制）
  - 优化按钮样式（"去修改并重新提交"按钮特殊样式，紫色边框和浅紫色背景）

- **表单页UI重构**：
  - 添加表单分组（基础信息、资质证照）
  - 优化分组标题样式（左侧紫色竖条指示器）
  - 优化输入框样式（圆角10px，聚焦效果，背景色变化）
  - 优化上传组件样式（140px高度，预览图覆盖层，编辑提示）

- **样式系统统一**：
  - 统一使用项目主题色系统（CustomAppColor）
  - 统一使用响应式尺寸工具（AppSizes）
  - 遵循项目设计规范（间距、圆角、阴影）
  - 页面背景色使用#F5F7FA

## Impact
- **Affected specs**:
  - `station-management` (修改，更新UI样式和交互规范)

- **Affected code**:
  - `lib/pages/station_management_list/widgets/station_management_list_screen.dart` (列表页UI重构)
  - `lib/pages/station_management_list/widgets/station_management_item.dart` (卡片组件UI重构)
  - `lib/pages/station_edit/widgets/station_edit_form.dart` (表单页UI重构)
  - 可能需要创建新的widget组件用于表单分组和上传组件样式


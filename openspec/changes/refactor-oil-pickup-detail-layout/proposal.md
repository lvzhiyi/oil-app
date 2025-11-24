# Change: 重构提油详情页面布局和样式

## Why
根据新的设计规范，需要重构提油详情页面的UI布局和样式，使其更符合现代化商业应用的设计标准，提升用户体验。新的设计采用更简洁的居中布局，优化了信息层级和视觉焦点。

## What Changes
- 重构库存信息卡片布局，改为居中显示，优化信息层级
- 调整提油量输入框样式，使用更大的字体和居中布局
- 优化文本粘贴区的样式和交互体验
- 统一页面间距和圆角规范
- 优化底部按钮区域的固定定位和样式

## Impact
- Affected specs: 需要创建新的 `oil-pickup-detail` capability spec
- Affected code: 
  - `lib/pages/oil_pickup_detail/widgets/oil_pickup_detail_screen.dart`
  - `lib/pages/oil_pickup_detail/widgets/smart_parse_card.dart`
  - 可能需要调整 `lib/pages/oil_pickup/widgets/station_selector_button.dart` 的样式


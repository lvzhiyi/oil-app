# Change: 优化提油首页库存列表样式

## Why
当前库存列表的UI设计较为传统，缺乏现代化的扁平设计风格。根据提供的HTML设计稿，需要优化库存卡片的视觉呈现，提升用户体验：
- 采用更扁平的设计风格，减少视觉噪音
- 优化信息层级，突出核心数据（库存量）
- 增强油品类型的视觉识别（柴油/汽油不同颜色主题）
- 添加库存状态标签，直观显示库存充足/紧张状态
- 优化卡片布局，提升信息可读性

## What Changes
- **MODIFIED**: 库存列表项组件样式优化
  - 卡片头部：油库信息（图标+名称）和位置信息，使用虚线分割
  - 卡片主体：左侧油品徽章（52x52，柴油/汽油不同颜色）、中间库存量（大号字体26px）、库存状态标签、右侧操作按钮
  - 油品视觉系统：柴油（紫色主题 #EEECFC/#7165E3）、汽油（橙色主题 #FFF7ED/#F59E0B）
  - 库存状态标签：库存充足（绿色）、库存紧张（橙色）
  - 卡片样式：16px圆角、弱阴影、虚线分割线
- **ADDED**: 位置信息显示（如果API提供位置数据）
- **MODIFIED**: 库存状态判断逻辑（库存紧张阈值：< 5吨）

## Impact
- Affected specs: `oil-pickup` (库存列表展示相关需求)
- Affected code: 
  - `lib/pages/oil_pickup/widgets/inventory_item.dart` - 主要样式优化
  - `lib/pages/oil_pickup/model/withdraw_data.dart` - 可能需要添加位置字段（如果API支持）
- Breaking changes: 无


# Change: 更新品牌主题色为琥珀金

## Why
现有按钮与 Logo 色存在饱和度/亮度差异，品牌一致性和文字可读性需要提升。

## What Changes
- 采用琥珀金色阶：主色 #D97706 用于主按钮/选中态，高亮色 #F59E0B 呼应 Logo，辅色 #FFFBEB 用于浅色背景。
- 规范主/辅/呼应色的使用场景与对比度要求，覆盖浅色/深色主题。
- 更新主题配置和通用组件以使用新的品牌色 token（按钮、选中、高亮、背景）。

## Impact
- Affected specs: app-theme
- Affected code: resources/colors.dart, resources/theme.dart, widgets/base/CommonButton 及依赖 CustomAppColor 的组件

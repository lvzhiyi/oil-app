# Requirements Document

## Introduction

本规范定义了"买油呗"应用的琥珀金主题色彩系统重构需求。目标是将应用的颜色配置统一化，与Logo颜色搭配协调，并建立一套易于维护和修改的主题色系统。设计理念取自Logo的主色调，通过加深饱和度和亮度来确保按钮等交互元素上的文字清晰可见。

## Glossary

- **Primary Color (主色)**: #D97706 - 深琥珀色，用于按钮、选中态等主要交互元素
- **Secondary Color (辅色)**: #FFFBEB - 极浅黄色，用于背景底色
- **Logo Accent Color (Logo呼应色)**: #F59E0B - 明亮琥珀色，用于图标、高亮文本
- **Theme System (主题系统)**: 应用中统一管理颜色的配置系统
- **AppColor**: 静态颜色常量类，定义所有基础颜色值
- **CustomAppColor**: 支持明暗主题切换的颜色适配类

## Requirements

### Requirement 1

**User Story:** As a developer, I want a centralized amber-gold color palette definition, so that I can easily maintain and modify theme colors across the application.

#### Acceptance Criteria

1. WHEN the application initializes THEN the Theme System SHALL provide a primary color constant with value #D97706
2. WHEN the application initializes THEN the Theme System SHALL provide a secondary color constant with value #FFFBEB
3. WHEN the application initializes THEN the Theme System SHALL provide a logo accent color constant with value #F59E0B
4. WHEN a developer references a theme color THEN the Theme System SHALL return the color from a single source of truth in AppColor class

### Requirement 2

**User Story:** As a user, I want buttons and interactive elements to use the amber-gold primary color, so that the app feels consistent with the brand identity.

#### Acceptance Criteria

1. WHEN a primary button is rendered THEN the Button Component SHALL use #D97706 as the background color
2. WHEN a primary button displays text THEN the Button Component SHALL use white (#FFFFFF) as the text color for contrast
3. WHEN a button is in disabled state THEN the Button Component SHALL use a lighter variant of the primary color with reduced opacity
4. WHEN a button is in pressed state THEN the Button Component SHALL use a darker variant of the primary color

### Requirement 3

**User Story:** As a user, I want the app background to use the warm secondary color, so that the interface feels cohesive with the amber-gold theme.

#### Acceptance Criteria

1. WHEN a scaffold background is rendered in light mode THEN the Scaffold Component SHALL use #FFFBEB as the background color
2. WHEN a container background is rendered THEN the Container Component SHALL use white (#FFFFFF) or the secondary color based on context
3. WHEN the app bar is rendered THEN the AppBar Component SHALL use a color that harmonizes with the amber-gold palette

### Requirement 4

**User Story:** As a user, I want icons and highlighted text to use the logo accent color, so that important elements stand out while maintaining brand consistency.

#### Acceptance Criteria

1. WHEN an accent icon is rendered THEN the Icon Component SHALL use #F59E0B as the icon color
2. WHEN highlighted or emphasized text is rendered THEN the Text Component SHALL use #F59E0B as the text color
3. WHEN a selected state indicator is rendered THEN the Indicator Component SHALL use #F59E0B to show selection

### Requirement 5

**User Story:** As a developer, I want to replace all hardcoded purple theme colors with the new amber-gold palette, so that the application has a unified visual appearance.

#### Acceptance Criteria

1. WHEN the btnPurple color is referenced THEN the Theme System SHALL return the primary amber color #D97706 instead
2. WHEN the txtPurple color is referenced THEN the Theme System SHALL return the logo accent color #F59E0B instead
3. WHEN the borderPurple color is referenced THEN the Theme System SHALL return the primary amber color #D97706 instead
4. WHEN the icPurple color is referenced THEN the Theme System SHALL return the logo accent color #F59E0B instead

### Requirement 6

**User Story:** As a developer, I want semantic color naming that reflects purpose rather than specific hue, so that future theme changes require minimal code modifications.

#### Acceptance Criteria

1. WHEN defining primary action colors THEN the AppColor class SHALL use semantic names like primaryColor, primaryLight, primaryDark
2. WHEN defining secondary colors THEN the AppColor class SHALL use semantic names like secondaryColor, secondaryLight
3. WHEN defining accent colors THEN the AppColor class SHALL use semantic names like accentColor for logo-related highlights
4. WHEN legacy color names are used THEN the AppColor class SHALL maintain backward compatibility by aliasing old names to new semantic colors

### Requirement 7

**User Story:** As a user, I want the fuel type indicators to harmonize with the new amber-gold theme, so that the oil/gas categorization remains visually distinct while fitting the overall design.

#### Acceptance Criteria

1. WHEN diesel fuel type is displayed THEN the Fuel Indicator SHALL use colors that complement the amber-gold palette
2. WHEN gasoline fuel type is displayed THEN the Fuel Indicator SHALL use the logo accent color #F59E0B for consistency
3. WHEN fuel type backgrounds are rendered THEN the Background Component SHALL use appropriately tinted versions of the theme colors

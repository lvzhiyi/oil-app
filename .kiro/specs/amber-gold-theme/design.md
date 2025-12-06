# Design Document: Amber-Gold Theme System

## Overview

本设计文档描述了"买油呗"应用的琥珀金主题色彩系统重构方案。目标是建立一套统一、可维护的颜色系统，将现有的紫色主题替换为与Logo协调的琥珀金色系。

### 设计理念
- **主色 (Primary)**: #D97706 - 深琥珀色，比Logo色更深以确保白色文字清晰可见
- **辅色 (Secondary)**: #FFFBEB - 极浅黄色，用于背景营造温暖氛围
- **Logo呼应色 (Accent)**: #F59E0B - 明亮琥珀色，与Logo一致，用于高亮元素

## Architecture

### 颜色系统架构

```
┌─────────────────────────────────────────────────────────┐
│                    Theme System                          │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────────────────┐ │
│  │   AppColor      │    │   CustomAppColor            │ │
│  │   (Static)      │───▶│   (Context-aware)           │ │
│  │                 │    │                             │ │
│  │ - primaryColor  │    │ - Adapts to light/dark mode │ │
│  │ - secondaryColor│    │ - Returns appropriate color │ │
│  │ - accentColor   │    │   based on theme brightness │ │
│  │ - Legacy aliases│    │                             │ │
│  └─────────────────┘    └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                    UI Components                         │
├─────────────────────────────────────────────────────────┤
│  Buttons │ TextFields │ Icons │ Backgrounds │ Indicators│
└─────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. AppColor 类 (静态颜色常量)

```dart
class AppColor {
  // ===== 新的语义化颜色定义 =====
  // 主色系 - 琥珀金
  static const primaryColor = Color(0xFFD97706);      // 深琥珀色
  static const primaryLight = Color(0xFFF59E0B);      // 明亮琥珀色
  static const primaryDark = Color(0xFFB45309);       // 更深琥珀色
  static const primaryDisabled = Color(0xFFD9770640); // 带透明度
  
  // 辅色系 - 暖黄
  static const secondaryColor = Color(0xFFFFFBEB);    // 极浅黄
  static const secondaryLight = Color(0xFFFEF3C7);    // 浅黄
  
  // 强调色 - Logo呼应
  static const accentColor = Color(0xFFF59E0B);       // Logo色
  
  // ===== 向后兼容的别名 =====
  static const btnPurple = primaryColor;    // 原紫色按钮 → 琥珀金
  static const txtPurple = accentColor;     // 原紫色文字 → Logo色
  static const borderPurple = primaryColor; // 原紫色边框 → 琥珀金
  static const icPurple = accentColor;      // 原紫色图标 → Logo色
}
```

### 2. CustomAppColor 类 (主题感知颜色)

```dart
class CustomAppColor {
  // 主色 - 按钮、选中态
  Color get primaryColor => AppColor.primaryColor;
  
  // 辅色 - 背景
  Color get secondaryColor => AppColor.secondaryColor;
  
  // 强调色 - 图标、高亮文本
  Color get accentColor => AppColor.accentColor;
  
  // 向后兼容
  Color get btnPurple => primaryColor;
  Color get txtPurple => accentColor;
  Color get borderPurple => primaryColor;
  Color get icPurple => accentColor;
}
```

### 3. 组件颜色映射

| 组件类型 | 颜色属性 | 新颜色值 |
|---------|---------|---------|
| 主按钮背景 | buttonColor | primaryColor (#D97706) |
| 主按钮文字 | textColor | white (#FFFFFF) |
| 禁用按钮 | disabledColor | primaryColor.withOpacity(0.4) |
| 输入框焦点边框 | focusBorderColor | primaryColor (#D97706) |
| 强调图标 | iconColor | accentColor (#F59E0B) |
| 高亮文本 | highlightTextColor | accentColor (#F59E0B) |
| 选中指示器 | indicatorColor | accentColor (#F59E0B) |
| 页面背景 | scaffoldBgColor | secondaryColor (#FFFBEB) |

## Data Models

### 颜色常量定义

```dart
// 琥珀金主题色板
const amberGoldPalette = {
  'primary': 0xFFD97706,      // 深琥珀 - 按钮、选中态
  'primaryLight': 0xFFF59E0B, // 明亮琥珀 - Logo色
  'primaryDark': 0xFFB45309,  // 深琥珀 - 按下态
  'secondary': 0xFFFFFBEB,    // 极浅黄 - 背景
  'secondaryLight': 0xFFFEF3C7, // 浅黄 - 容器背景
  'accent': 0xFFF59E0B,       // Logo呼应色
};
```

### 油品颜色适配

```dart
// 油品颜色 - 与琥珀金主题协调
const fuelColors = {
  'dieselBg': 0xFFFEF3C7,     // 柴油背景 - 浅黄
  'dieselText': 0xFFB45309,   // 柴油文字 - 深琥珀
  'gasBg': 0xFFFFF7ED,        // 汽油背景 - 保持原色
  'gasText': 0xFFF59E0B,      // 汽油文字 - Logo色
};
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Legacy color alias consistency
*For any* legacy color name (btnPurple, txtPurple, borderPurple, icPurple), the returned color value SHALL equal the corresponding new semantic color (primaryColor or accentColor).

**Validates: Requirements 5.1, 5.2, 5.3, 5.4, 6.4**

### Property 2: Primary button color consistency
*For any* primary button widget rendered in the application, the background color SHALL equal AppColor.primaryColor (#D97706).

**Validates: Requirements 2.1**

### Property 3: Theme color value correctness
*For any* theme color constant in AppColor, the hex value SHALL match the specified design values:
- primaryColor = #D97706
- secondaryColor = #FFFBEB
- accentColor = #F59E0B

**Validates: Requirements 1.1, 1.2, 1.3**

## Additional Components Color Mapping

### 1. 图片上传组件 (CommonImgUpload)

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 焦点状态标签 | borderPurple | primaryColor (#D97706) |
| 编辑图标 | borderPurple | primaryColor (#D97706) |
| 编辑文字 | borderPurple | primaryColor (#D97706) |
| 焦点边框 | borderPurple | primaryColor (#D97706) |
| Loading动画 | 默认蓝色 | primaryColor (#D97706) |

### 2. 地址选择器 (CommonCityPicker)

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 焦点边框 | borderPurple | primaryColor (#D97706) |
| 确认按钮文字 | txtBlue | primaryColor (#D97706) |

### 3. 登录页面Tab组件

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 选中Tab背景 | btnPurple | primaryColor (#D97706) |
| 未选中Tab文字 | txtPurple | accentColor (#F59E0B) |
| Tab容器背景 | btnPurple.withOpacity(0.1) | primaryColor.withOpacity(0.1) |

### 4. 验证码登录表单

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 获取验证码按钮文字 | txtPurple | accentColor (#F59E0B) |

### 5. HTML协议文件 (privacy_policy.html, service_agreement.html)

```css
:root {
    --primary-color: #D97706; /* 从 #7165E3 改为琥珀金 */
}
```

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 标题左边框 | #7165E3 | #D97706 |

### 6. 忘记密码页面

该页面主要使用 CommonButton 和 CommonTextFormField 组件，颜色会随组件统一更新。

### 7. 购油首页列表 (DepotsItemWidget)

| 元素 | 当前颜色 | 新颜色 |
|-----|---------|-------|
| 去购油按钮背景 | #EEECFC (浅紫) | secondaryLight (#FEF3C7) |
| 去购油按钮文字 | txtPurple | accentColor (#F59E0B) |
| 去购油按钮箭头 | txtPurple | accentColor (#F59E0B) |
| 卡片选中边框 | txtPurple | primaryColor (#D97706) |
| 价格数字 | txtPurple | accentColor (#F59E0B) |

### 8. 其他通用组件

| 组件 | 元素 | 新颜色 |
|-----|------|-------|
| CommonDialog | Loading动画 | primaryColor (#D97706) |
| HtmlWebviewContainer | Loading动画 | primaryColor (#D97706) |
| PullRefresh | 刷新文字 | primaryColor (#D97706) |
| FilterOptionChip | 选中边框/文字 | primaryColor (#D97706) |
| CommonRichText | 链接文字 | accentColor (#F59E0B) |
| Heading | 查看更多文字 | accentColor (#F59E0B) |

## Error Handling

### 颜色访问错误处理

1. **空上下文处理**: CustomAppColor 在无法获取 BuildContext 时，应返回默认的 light mode 颜色
2. **主题切换**: 确保在主题切换时颜色能正确更新，避免缓存旧值
3. **向后兼容**: 保留所有旧的颜色名称作为别名，避免编译错误

## Testing Strategy

### 单元测试

1. **颜色常量测试**: 验证 AppColor 中所有颜色常量的十六进制值正确
2. **别名映射测试**: 验证旧颜色名称正确映射到新的语义化颜色
3. **CustomAppColor 测试**: 验证在不同主题模式下返回正确的颜色

### 属性测试 (Property-Based Testing)

使用 `test` 包进行属性测试：

1. **Property 1 测试**: 生成所有 legacy 颜色名称，验证它们都映射到正确的新颜色
2. **Property 2 测试**: 创建多个 CommonButton 实例，验证背景色一致性
3. **Property 3 测试**: 验证所有主题颜色常量值的正确性

### 视觉回归测试

1. 截图对比关键页面（登录、主页、订单列表）
2. 验证颜色变更后的视觉一致性

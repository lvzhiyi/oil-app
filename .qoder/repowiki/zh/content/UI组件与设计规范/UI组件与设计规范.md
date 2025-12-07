# UI组件与设计规范

<cite>
**本文档引用文件**  
- [common_button.dart](file://lib/widgets/base/button/common_button.dart)
- [common_text.dart](file://lib/widgets/base/text/common_text.dart)
- [common_textformfield.dart](file://lib/widgets/base/textfield/common_textformfield.dart)
- [topbar.dart](file://lib/widgets/base/topbar/topbar.dart)
- [common_container.dart](file://lib/widgets/base/container/common_container.dart)
- [colors.dart](file://lib/resources/colors.dart)
- [theme.dart](file://lib/resources/theme.dart)
- [style.dart](file://lib/resources/style.dart)
- [size.dart](file://lib/resources/size.dart)
- [fonts.dart](file://lib/static/fonts.dart)
</cite>

## 目录
1. [简介](#简介)
2. [基础UI组件](#基础ui组件)
   1. [CommonButton](#commonbutton)
   2. [CommonText](#commontext)
   3. [CommonTextFormField](#commontextformfield)
   4. [TopBar](#topbar)
   5. [CommonContainer](#commoncontainer)
3. [设计系统](#设计系统)
   1. [颜色规范](#颜色规范)
   2. [字体系统](#字体系统)
   3. [间距系统](#间距系统)
4. [主题系统](#主题系统)
5. [交互规范](#交互规范)

## 简介
本文档旨在为油品业务应用提供完整的UI组件与设计规范，作为前端开发的权威指南。文档系统化地记录了所有基础UI组件、设计系统规范以及交互准则，确保应用界面的一致性和可维护性。

## 基础UI组件

### CommonButton
CommonButton是应用中的标准按钮组件，用于各种操作场景。

**属性表**
- `buttonColor`: 按钮背景颜色
- `borderColor`: 边框颜色
- `height`: 按钮高度
- `width`: 按钮宽度
- `radius`: 圆角半径（默认8）
- `pVertical`: 垂直内边距
- `pHorizontal`: 水平内边距
- `onTap`: 点击回调函数
- `btnText`: 按钮文本
- `child`: 自定义子组件
- `fontSize`: 文本大小
- `isButtonShadow`: 是否显示阴影（默认true）
- `isLoading`: 是否显示加载状态
- `textColor`: 文本颜色

**状态表现**
- **正常状态**: 显示标准背景色和文本
- **聚焦状态**: 通过阴影效果提供视觉反馈
- **禁用状态**: 通过透明度变化表示不可用

**使用示例**
```dart
CommonButton(
  btnText: "提交",
  onTap: () {
    // 处理点击事件
  },
)
```

**Section sources**
- [common_button.dart](file://lib/widgets/base/button/common_button.dart#L6-L92)

### CommonText
CommonText是应用中的标准文本组件，用于显示各种文本内容。

**属性表**
- `text`: 显示的文本内容
- `textColor`: 文本颜色
- `fontSize`: 字体大小
- `letterSpacing`: 字符间距
- `fontFamily`: 字体家族（默认Urbanist）
- `fontWeight`: 字重
- `fontStyle`: 字体样式
- `textAlign`: 文本对齐方式
- `textDecoration`: 文本装饰
- `maxLines`: 最大行数
- `isAutoSize`: 是否自动调整大小
- `overflow`: 溢出处理方式

**状态表现**
- **正常状态**: 显示标准文本样式
- **聚焦状态**: 无特殊表现
- **禁用状态**: 通过颜色变化表示

**使用示例**
```dart
CommonText(
  text: "欢迎使用油品业务应用",
  fontSize: 16,
  fontWeight: FontWeight.w600,
  textColor: CustomAppColor.of(context).txtBlack,
)
```

**Section sources**
- [common_text.dart](file://lib/widgets/base/text/common_text.dart#L6-L55)

### CommonTextFormField
CommonTextFormField是应用中的标准文本输入框组件，支持多种输入类型。

**属性表**
- `hintText`: 占位符文本
- `leadingIcon`: 前置图标
- `suffixIcon`: 后置图标
- `isPasswordField`: 是否为密码字段
- `controller`: 文本控制器
- `onChanged`: 文本变化回调
- `isPhoneNumberField`: 是否为电话号码字段
- `fillColor`: 填充颜色
- `borderColor`: 边框颜色
- `hintStyle`: 占位符样式
- `focusNode`: 焦点节点
- `maxLines`: 最大行数
- `radius`: 圆角半径
- `labelText`: 标签文本
- `onSubmitField`: 提交回调
- `maxLength`: 最大长度
- `isRequiredLabel`: 标签是否必填
- `isRequiredHint`: 占位符是否必填
- `textAlign`: 文本对齐
- `textAlignVertical`: 垂直对齐
- `isCountryLabelVisible`: 国家标签是否可见
- `name`: 字段名称
- `validators`: 验证器
- `keyboardType`: 键盘类型
- `inputFormatter`: 输入格式化器
- `enabled`: 是否启用
- `showHint`: 是否显示占位符

**状态表现**
- **正常状态**: 显示标准边框和占位符
- **聚焦状态**: 边框颜色变为紫色，显示阴影效果
- **禁用状态**: 灰色边框，不可编辑

**使用示例**
```dart
CommonTextFormField(
  hintText: "请输入邮箱",
  isPasswordField: false,
  keyboardType: TextInputType.emailAddress,
  validators: FormBuilderValidators.email(),
)
```

**Section sources**
- [common_textformfield.dart](file://lib/widgets/base/textfield/common_textformfield.dart#L11-L360)

### TopBar
TopBar是应用中的顶部导航栏组件，提供导航和操作功能。

**属性表**
- `clickListener`: 点击监听器
- `title`: 标题文本
- `alignment`: 对齐方式
- `isShowTitle`: 是否显示标题
- `subTitle`: 子标题
- `isShowNotification`: 是否显示通知图标
- `isShowSearch`: 是否显示搜索图标
- `isShowSearchField`: 是否显示搜索字段
- `isShowBack`: 是否显示返回按钮
- `isShowShadow`: 是否显示阴影
- `topBarColor`: 导航栏颜色
- `textColor`: 文本颜色
- `height`: 高度
- `isShowCart`: 是否显示购物车
- `isShowLike`: 是否显示收藏
- `isShowProfile`: 是否显示个人资料
- `isShowCartCount`: 是否显示购物车数量
- `isShowEditProfile`: 是否显示编辑个人资料
- `isBackIconWhite`: 返回图标是否为白色

**状态表现**
- **正常状态**: 显示标准导航栏样式
- **聚焦状态**: 无特殊表现
- **禁用状态**: 无特殊表现

**使用示例**
```dart
TopBar(
  clickListener: this,
  title: "油品管理",
  isShowBack: true,
  isShowNotification: true,
  isShowCart: true,
)
```

**Section sources**
- [topbar.dart](file://lib/widgets/base/topbar/topbar.dart#L9-L252)

### CommonContainer
CommonContainer是应用中的标准容器组件，用于包裹其他组件。

**属性表**
- `width`: 容器宽度
- `height`: 容器高度
- `borderColor`: 边框颜色
- `borderWidth`: 边框宽度
- `borderRadius`: 圆角半径
- `child`: 子组件

**状态表现**
- **正常状态**: 显示标准容器样式
- **聚焦状态**: 无特殊表现
- **禁用状态**: 无特殊表现

**使用示例**
```dart
CommonContainer(
  width: 200,
  height: 100,
  borderRadius: 15,
  child: CommonText(text: "容器内容"),
)
```

**Section sources**
- [common_container.dart](file://lib/widgets/base/container/common_container.dart#L4-L40)

## 设计系统

### 颜色规范
应用采用琥珀金主题，包含品牌色、中性色和功能色。

**品牌色**
- 主色: `#D97706` (深琥珀色)
- 辅色: `#F59E0B` (暖黄色)
- 强调色: `#F59E0B` (Logo呼应色)

**中性色**
- 白色: `#FFFFFF`
- 黑色: `#000000`
- 浅灰: `#9EA6BE`
- 深灰: `#1F222A`

**功能色**
- 成功: `#10B981` (绿色)
- 警告: `#F59E0B` (橙色)
- 错误: `#FF4141` (红色)
- 信息: `#383EAF` (蓝色)

**主题适配**
所有颜色必须通过`CustomAppColor.of(context)`获取，以确保浅色/深色主题的正确适配。

```dart
Color color = CustomAppColor.of(context).primaryColor;
```

**Section sources**
- [colors.dart](file://lib/resources/colors.dart#L3-L287)

### 字体系统
应用采用Urbanist字体家族，提供多种字重和字号。

**字体家族**
- Urbanist Regular
- Urbanist Medium
- Urbanist Semibold
- Urbanist Bold

**字号规范**
- 标题大: 20pt
- 标题中: 18pt
- 标题小: 16pt
- 正文大: 16pt
- 正文中: 14pt
- 正文小: 12pt

**字重规范**
- 轻: 300
- 正常: 400
- 中等: 500
- 半粗: 600
- 粗: 700

**Section sources**
- [fonts.dart](file://lib/static/fonts.dart#L3-L11)
- [style.dart](file://lib/resources/style.dart#L5-L40)

### 间距系统
应用采用基于`AppSizes`的响应式布局系统。

**间距规范**
- 微小: 4pt
- 小: 8pt
- 中: 12pt
- 大: 16pt
- 超大: 24pt

**布局原则**
- 页面内边距: 水平12pt
- 组件间距: 8-16pt
- 圆角半径: 12pt

**Section sources**
- [size.dart](file://lib/resources/size.dart#L4-L16)

## 主题系统
应用支持浅色和深色主题切换，通过`CustomAppColor`类实现。

**实现机制**
- 使用`CustomAppColor.of(context)`获取主题颜色
- 根据`Theme.of(context).brightness`判断当前主题
- 动态返回对应主题的颜色值

**使用要求**
所有组件必须使用`CustomAppColor.of(context)`获取颜色，禁止直接使用硬编码颜色值。

```dart
// 正确做法
Color textColor = CustomAppColor.of(context).txtBlack;

// 错误做法
Color textColor = Color(0xFF000000);
```

**Section sources**
- [colors.dart](file://lib/resources/colors.dart#L3-L287)

## 交互规范

### 点击反馈
- 按钮点击时提供视觉反馈
- 使用阴影和颜色变化表示点击状态
- 点击区域至少44pt×44pt

### 页面导航
- 使用标准返回按钮
- 导航栏高度统一
- 页面切换使用淡入淡出动画

### 弹窗使用
- 使用标准对话框样式
- 确认按钮在右侧
- 取消按钮在左侧
- 提供清晰的关闭方式

**Section sources**
- [topbar.dart](file://lib/widgets/base/topbar/topbar.dart#L9-L252)
- [common_dialog.dart](file://lib/widgets/base/alert/common_dialog.dart)
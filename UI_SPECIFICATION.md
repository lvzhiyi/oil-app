# Goozzy E-Commerce App UI 规范文档

## 1. 设计系统概述

### 1.1 设计原则
- 现代化电商应用界面设计
- 支持浅色/深色主题切换
- 响应式布局，支持手机、平板、折叠屏
- Material Design 3 设计语言
- 高内聚、低耦合的组件化设计

---

## 2. 颜色系统

### 2.1 主色调定义

#### 品牌色
```dart
AppColor.btnPurple = #7165E3      // 主品牌色，用于按钮、强调元素
AppColor.txtPurple = #7165E3      // 文本强调色
AppColor.icPurple = #7165E3       // 图标强调色
```

#### 中性色
```dart
AppColor.white = #FFFFFF          // 纯白
AppColor.black = #000000          // 纯黑
AppColor.txtBlack = #000000       // 黑色文本
AppColor.txtWhite = #FFFFFF       // 白色文本
AppColor.txtGrey = #9EA6BE        // 灰色文本
AppColor.hintGrey = #AFB0B6       // 提示文本灰色
AppColor.borderGrey = #9EA6BE     // 边框灰色
AppColor.grey = #95969D           // 通用灰色
```

#### 背景色
```dart
// 浅色主题背景
AppColor.white = #FFFFFF          // 主背景
AppColor.bgTopBar = #F9F9FB       // TopBar背景

// 深色主题背景
AppColor.bgScaffold = #181A20     // 深色主背景
AppColor.containerGrey = #1F222A  // 深色容器背景
```

#### 功能色
```dart
AppColor.green = #2AB126          // 成功/评分
AppColor.darkGreen = #128C7E      // WhatsApp绿色
AppColor.txtRed = #FF4141         // 错误/危险
AppColor.red = #EF3A10            // 红色警告
AppColor.txtOrange = #FF9B00      // 橙色提示
AppColor.orange = #F7A521         // 橙色
AppColor.txtBlue = #383EAF        // 蓝色链接
AppColor.txtDarkBlue = #006DF0    // 深蓝色
AppColor.yellow = #F7E632         // 黄色
```

#### 容器色
```dart
AppColor.containerGreen = #CAFFCA     // 绿色容器
AppColor.containerBlue = #C2F1FF      // 蓝色容器
AppColor.containerPink = #FFCDDB      // 粉色容器
AppColor.containerOrange = #FFC0BE    // 橙色容器
AppColor.containerRed = #FF2762       // 红色容器
AppColor.containerLightBlue = #65C5E3 // 浅蓝色容器
```

#### 卡片色
```dart
AppColor.cardBlue = #DFF7FC       // 蓝色卡片
AppColor.cardPink = #FBE9F1       // 粉色卡片
AppColor.cardYellow = #FDF4E6     // 黄色卡片
```

#### 边框色
```dart
AppColor.borderPurple = #7165E3   // 强调边框
AppColor.borderGrey = #9EA6BE     // 默认边框
AppColor.containerBorder = #EEEEEE // 容器边框
AppColor.textFieldBorder = #EEEEEE // 输入框边框
AppColor.icGrey = #EEEEEE         // 灰色图标
```

#### 其他
```dart
AppColor.indicator = #ABBFFF      // 指示器颜色
AppColor.transparent = #00FFFFFF  // 透明色
```

### 2.2 主题适配规则

使用 `CustomAppColor.of(context)` 进行主题自适应：

#### 文本颜色适配
- `txtBlack`: 浅色主题显示黑色，深色主题显示白色
- `txtWhite`: 浅色主题显示白色，深色主题显示黑色
- `txtBlackGrey`: 浅色主题黑色，深色主题灰色
- `txtBlackPurple`: 浅色主题黑色，深色主题紫色
- `txtAppBar`: 浅色主题黑色，深色主题紫色

#### 背景颜色适配
- `bgScaffold`: 浅色白色，深色 #181A20
- `bgBlackWhiteScaffold`: 浅色白色，深色黑色
- `bgContainer`: 浅色白色，深色 #1F222A
- `bgTopBar`: 浅色 #F9F9FB，深色黑色
- `bgNavBar`: 浅色白色，深色黑色
- `bgPurpleBlack`: 浅色紫色20%透明，深色 #181A20

#### 图标颜色适配
- `icBlack`: 浅色黑色，深色白色
- `icWhite`: 浅色白色，深色黑色
- `icBlackPurple`: 浅色黑色，深色紫色
- `icGrey`: 浅色 #EEEEEE，深色 #EEEEEE

#### 按钮颜色适配
- `btnPurple`: 固定 #7165E3
- `btnWhite`: 浅色白色，深色 #181A20

#### 边框颜色适配
- `containerBorder`: 浅色 #EEEEEE，深色白色5%透明
- `textFieldBorder`: 浅色 #EEEEEE，深色 #1F222A
- `dividerGrey`: 浅色 #EEEEEE，深色 #1F222A

---

## 3. 字体系统

### 3.1 字体家族
```dart
Constant.fontFamilyUrbanist = 'Urbanist'              // 主字体
Constant.fontFamilyMontserratSemiBold = 'Montserrat-SemiBold'  // 辅助字体
```

### 3.2 字重定义
```yaml
Urbanist:
  - Light: 300
  - Regular: 400
  - Medium: 500
  - SemiBold: 600
  - Bold: 700

Montserrat-SemiBold:
  - SemiBold: 600
```

### 3.3 字号规范

使用 `AppSizes.setFontSize(size)` 进行字号设置，自动适配不同设备：

| 用途 | 字号 | 字重 | 使用场景 |
|-----|------|------|---------|
| 大标题 | 24 | 700 | 页面主标题 |
| 标题 | 20 | 600 | TopBar标题、重要标题 |
| 二级标题 | 18 | 800/700 | 分类标题、Heading组件 |
| 价格大号 | 18 | 700 | 商品价格显示 |
| 按钮文字 | 15 | 500/600 | 主要按钮、次要按钮 |
| 正文 | 14 | 400/600/700 | 普通文本、输入框文本 |
| 副标题 | 12 | 500/600 | 辅助信息、标签 |
| 小号文字 | 10 | 500/700 | 折扣信息、小标签 |
| 极小文字 | 8 | 600 | Badge、角标 |

### 3.4 行高规范
- 所有文本统一行高: `height: 1.2`

### 3.5 响应式字体缩放

#### 设备类型判断
- **手机**: 默认缩放 1.0
- **平板**: 缩放 0.6
- **折叠屏**: 缩放 0.6

#### 用户文字缩放限制
- 最大文字缩放系数: 1.2

---

## 4. 尺寸与间距系统

### 4.1 设计基准
- 设计基于 `flutter_screenutil` 实现响应式布局
- 使用 `AppSizes` 统一管理尺寸

### 4.2 标准组件高度
```dart
AppSizes.buttonHeight = 52      // 标准按钮高度
AppSizes.topBarHeight = 60      // 顶部栏高度
```

### 4.3 间距规范

#### 水平间距
| 间距值 | 使用场景 |
|-------|---------|
| 8 | 极小间距，选项卡内边距 |
| 10 | 小间距，列表项间距 |
| 12 | 图标间距 |
| 14 | 标准小间距 |
| 15 | 标准间距 |
| 18 | 页面左右边距 |
| 20 | 标准页面边距 |
| 24 | 大间距 |

#### 垂直间距
| 间距值 | 使用场景 |
|-------|---------|
| 4 | 极小间距 |
| 5 | 列表项间距 |
| 8 | 小间距 |
| 10 | 标准小间距 |
| 15 | 标准间距 |
| 16 | 表单项间距 |
| 18 | 容器内边距 |
| 20 | 大间距、分组间距 |
| 22 | 商品详情间距 |
| 32 | 表单提交按钮上边距 |
| 61 | 登录页顶部间距 |

### 4.4 圆角规范
| 圆角值 | 使用场景 |
|-------|---------|
| 2 | 极小圆角，小标签 |
| 3 | 小按钮圆角 |
| 5 | 商品卡片圆角 |
| 8 | 标准圆角，输入框、容器 |
| 12 | 标准容器圆角 |
| 15 | 大圆角 |
| 20 | BottomSheet圆角 |
| 25 | 圆形按钮、Toggle按钮 |

---

## 5. 核心组件规范

### 5.1 CommonText 文本组件

#### 基本用法
```dart
CommonText(
  text: '文本内容',
  fontSize: AppSizes.setFontSize(14),
  fontWeight: FontWeight.w400,
  textColor: CustomAppColor.of(context).txtBlack,
  textAlign: TextAlign.center,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| text | String | 必填 | 文本内容 |
| fontSize | double | 14 | 字体大小 |
| fontWeight | FontWeight | w400 | 字重 |
| textColor | Color | txtBlack | 文字颜色 |
| textAlign | TextAlign | center | 对齐方式 |
| fontFamily | String | Urbanist | 字体家族 |
| maxLines | int? | null | 最大行数 |
| overflow | TextOverflow? | null | 溢出处理 |
| letterSpacing | double? | null | 字间距 |
| textDecoration | TextDecoration | none | 文本装饰 |
| fontStyle | FontStyle | normal | 字体样式 |

#### 使用规范
- 必须使用 `AppSizes.setFontSize()` 设置字号
- 必须使用 `CustomAppColor.of(context)` 获取颜色
- 固定行高 1.2
- 必须指定 `package: 'goozzy_e_commerce_screens_app_package'`

---

### 5.2 CommonButton 按钮组件

#### 基本用法
```dart
CommonButton(
  btnText: '按钮文字',
  onTap: () {},
  height: AppSizes.buttonHeight,
  radius: 8,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| btnText | String? | null | 按钮文字 |
| child | Widget? | null | 自定义子组件 |
| onTap | Function()? | null | 点击回调 |
| buttonColor | Color? | btnPurple | 按钮背景色 |
| borderColor | Color? | transparent | 边框颜色 |
| height | double? | buttonHeight(52) | 按钮高度 |
| width | double? | fullWidth | 按钮宽度 |
| radius | double | 8 | 圆角半径 |
| fontSize | double? | 15 | 文字大小 |
| isButtonShadow | bool? | true | 是否显示阴影 |
| pVertical | double | 0 | 垂直内边距 |
| pHorizontal | double | 0 | 水平内边距 |

#### 按钮类型

##### 主要按钮（Primary Button）
```dart
CommonButton(
  btnText: '主要操作',
  buttonColor: CustomAppColor.of(context).btnPurple,
  height: AppSizes.buttonHeight,  // 52
  radius: 8,
  isButtonShadow: true,
)
```
- 背景色: `btnPurple (#7165E3)`
- 文字颜色: 白色
- 阴影: 紫色40%透明，偏移(0, 2)，模糊4，扩散1
- 高度: 52
- 圆角: 8

##### 次要按钮（Secondary Button）
```dart
CommonButton(
  btnText: '次要操作',
  buttonColor: CustomAppColor.of(context).btnWhite,
  borderColor: CustomAppColor.of(context).bgContainerGrey,
  isButtonShadow: false,
)
```
- 背景色: 浅色白色/深色 bgScaffold
- 边框: 1px 灰色
- 无阴影

##### 小按钮（Small Button）
```dart
CommonButton(
  btnText: '小按钮',
  height: AppSizes.setHeight(34),
  width: AppSizes.setWidth(93),
  radius: 3,
)
```
- 高度: 34
- 宽度: 根据内容自适应或固定
- 圆角: 3

##### 图标按钮（Icon Button）
```dart
CommonButton(
  height: AppSizes.setHeight(34),
  width: AppSizes.setWidth(34),
  radius: 3,
  child: Image.asset(AppAssets.icWhatsapp, ...),
)
```
- 正方形
- 可自定义背景色
- 圆角: 3

#### 按钮状态
- **正常状态**: 默认样式
- **禁用状态**: 使用 `IgnorePointer(ignoring: true)` 包裹

---

### 5.3 CommonTextFormField 输入框组件

#### 基本用法
```dart
CommonTextFormField(
  hintText: '请输入内容',
  borderColor: CustomAppColor.of(context).textFieldBorder,
  leadingIcon: Image.asset(...),
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| hintText | String? | null | 占位文字 |
| labelText | String? | null | 标签文字 |
| controller | TextEditingController? | null | 输入控制器 |
| focusNode | FocusNode? | null | 焦点节点 |
| leadingIcon | Widget? | null | 前置图标 |
| suffixIcon | Widget? | null | 后置图标 |
| fillColor | Color? | bgContainer | 填充颜色 |
| borderColor | Color? | borderGrey | 边框颜色 |
| hintStyle | TextStyle? | null | 占位文字样式 |
| radius | double? | 12 | 圆角半径 |
| maxLines | int? | 1 | 最大行数 |
| maxLength | int? | null | 最大长度 |
| isPasswordField | bool | false | 是否密码框 |
| isPhoneNumberField | bool | false | 是否手机号码框 |
| isRequiredLabel | bool? | null | 标签是否必填标记 |
| isRequiredHint | bool? | null | 占位是否必填标记 |
| textAlign | TextAlign? | start | 文本对齐 |
| textAlignVertical | TextAlignVertical? | top | 垂直对齐 |
| onChanged | ValueChanged<String>? | null | 内容变化回调 |
| onSubmitField | Function(String)? | null | 提交回调 |

#### 输入框状态样式

##### 默认状态
- 填充颜色: 浅色白色/深色 #1F222A
- 边框: 1px 灰色 (#9EA6BE)
- 圆角: 12
- 文字大小: 14，字重 700

##### 聚焦状态
- 边框: 2px 紫色 (#7165E3)
- 标签颜色: 紫色
- 标签浮动显示

##### 密码输入框
- 后置图标: 显示/隐藏密码切换图标
- 初始状态: 密码隐藏

##### 手机号输入框
- 使用 `IntlPhoneField` 组件
- 默认国家代码: 'IN'
- 显示国家选择器
- 可选显示 'Country' 标签

#### 输入框尺寸规范
- 高度: 单行根据内容自适应
- 最小高度: 约 52
- 多行: 根据 `maxLines` 自适应
- 内边距: 垂直 12

---

### 5.4 TopBar 顶部导航栏组件

#### 基本用法
```dart
TopBar(
  clickListener,
  title: '页面标题',
  isShowBack: true,
  isShowSearch: true,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| clickListener | TopBarClickListener | 必填 | 点击事件监听器 |
| title | String? | null | 标题文字 |
| isShowTitle | bool | true | 是否显示标题 |
| isShowBack | bool | false | 是否显示返回按钮 |
| isShowProfile | bool | false | 是否显示头像 |
| isShowNotification | bool | false | 是否显示通知图标 |
| isShowSearch | bool | false | 是否显示搜索图标 |
| isShowSearchField | bool | false | 是否显示搜索框 |
| isShowCart | bool | false | 是否显示购物车 |
| isShowCartCount | bool? | null | 是否显示购物车数量 |
| isShowLike | bool | false | 是否显示收藏图标 |
| isShowEditProfile | bool? | false | 是否显示编辑图标 |
| isShowShadow | bool | true | 是否显示阴影 |
| isBackIconWhite | bool? | false | 返回图标是否白色 |
| topBarColor | Color? | white | 背景颜色 |
| textColor | Color | txtSecondary | 文字颜色 |
| height | double | 100 | 高度 |
| alignment | AlignmentGeometry | centerLeft | 对齐方式 |
| subTitle | String | '' | 副标题 |

#### TopBar 布局规范
- 固定高度: 100 (包含 SafeArea)
- 水平内边距: 18
- 阴影: 黑色1%透明，模糊3，扩散2，偏移(0, 4)
- 图标大小: 24x24
- 头像大小: 35x35

#### TopBar 元素顺序
从左到右:
1. 返回按钮 (可选)
2. 头像 (可选)
3. 标题 (可选)
4. Spacer
5. 搜索图标 (可选)
6. 收藏图标 (可选)
7. 通知图标 (可选)
8. 购物车图标 (可选)
9. 编辑图标 (可选)

#### 图标规范
- 图标尺寸: 24x24
- 图标颜色: 根据主题自适应 (icBlack/白色)
- 图标间距: 左右各 12
- 图标使用 `Image.asset` 加载
- 支持 `color` 属性着色

#### 角标规范
##### 通知角标
- 尺寸: 8x8
- 位置: 右上角 (top: 3, right: 3)
- 样式: 圆形，红色，白色边框

##### 购物车数量角标
- 尺寸: 16x16
- 位置: 右上角 (top: -5, right: -3)
- 样式: 圆角5，紫色背景，白色文字
- 字号: 8，字重 600
- 边框: 白色

---

### 5.5 CustomContainer 容器组件

#### 基本用法
```dart
CustomContainer(
  width: AppSizes.setWidth(100),
  height: AppSizes.setHeight(100),
  borderRadius: 15,
  child: ...,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| width | double | 必填 | 容器宽度 |
| height | double | 必填 | 容器高度 |
| child | Widget | 必填 | 子组件 |
| borderColor | Color? | containerBorder | 边框颜色 |
| borderWidth | double? | 1 | 边框宽度 |
| borderRadius | double? | 15 | 圆角半径 |

#### 容器样式
- 背景颜色: 根据主题自适应 (bgScaffold)
- 边框: 1px 实线
- 圆角: 15
- 内容居中对齐

---

### 5.6 Heading 标题组件

#### 基本用法
```dart
Heading(
  title: '主标题',
  navigationTitle: '查看更多',
  onTap: () {},
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| title | String | 必填 | 主标题文字 |
| navigationTitle | String | 必填 | 导航文字 |
| onTap | Function()? | null | 点击回调 |

#### 样式规范
- 主标题: 字号 18，字重 800
- 导航文字: 字号 14，字重 700，紫色
- 水平内边距: 20
- 布局: Row，两端对齐

---

### 5.7 ProductsDetail 商品卡片组件

#### 基本用法
```dart
ProductsDetail(
  productsList: productsList,
  btnText: '添加到购物车',
  onTap: () {},
  isShowMrp: false,
  isRatingShown: true,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| productsList | List<Products> | 必填 | 商品列表 |
| btnText | String | 必填 | 按钮文字 |
| onTap | Function()? | null | 点击回调 |
| isShowMrp | bool? | false | 是否显示市场价 |
| isShowTrusted | bool? | false | 是否显示信任标签 |
| isRatingShown | bool? | true | 是否显示评分 |
| isDownloadVisible | bool? | false | 是否显示下载选项 |
| isFavouriteVisible | bool? | false | 是否显示收藏图标 |
| isFilledFavouriteVisible | bool? | false | 是否显示已收藏图标 |
| isImageBorderVisible | bool? | false | 是否显示图片边框 |
| imageWidth | double? | null | 图片宽度 |

#### 布局结构
1. 商品名称区域 (顶部)
   - 商品名称: 字号 15，字重 700，灰色
   - 收藏图标: 24x24，右侧
   
2. 商品详情区域
   - 左侧: 商品图片 (124x89)
     - 有边框: 白色背景，灰色边框，圆角5
     - 无边框: 圆角12
   - 右侧: 详情信息
     - 价格: 字号 18，字重 700，黑色
     - 免费配送标签: 字号 12，字重 500，灰色
     - 折扣信息: 图标 11x10 + 文字 10
     - 市场价 (可选): 字号 10，字重 700
     - 信任标签 (可选): 图标 14x14 + 标签背景
     - 评分 (可选): 绿色背景，白色文字
     - 按钮组: 主按钮 + WhatsApp按钮

3. 商品图片列表区域 (底部)
   - 高度: 70
   - 图片尺寸: 69x78
   - 横向滚动
   - 间距: 左右各10

#### 按钮规范
- 主按钮: 高度 34，宽度 173，圆角 3
- WhatsApp按钮: 34x34，圆角 3，深绿色背景

#### 评分标签规范
- 容器: 41x20，绿色背景，圆角3
- 文字: 字号 12，字重 600，白色
- 星标图标: 10x10

---

### 5.8 FilterOptionChip 筛选标签组件

#### 基本用法
```dart
FilterOptionChip(
  label: '筛选项',
  isSelected: false,
  onTap: () {},
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| label | String | 必填 | 标签文字 |
| isSelected | bool | 必填 | 是否选中 |
| onTap | Function()? | 必填 | 点击回调 |

#### 样式规范
- 未选中: 灰色边框，灰色文字
- 选中: 紫色边框，紫色文字
- 圆角: 20
- 内边距: 水平 8，垂直 3
- 字号: 12，字重 500

---

### 5.9 ToggleButtonWidget 切换按钮组件

#### 基本用法
```dart
ToggleButtonWidget()
```

#### 样式规范
- 容器尺寸: 281x48
- 容器背景: 紫色10%透明
- 容器圆角: 25
- 内边距: 水平 8

#### 按钮项规范
- 单项尺寸: 134x36
- 圆角: 25
- 选中背景: 紫色
- 选中文字: 白色
- 未选中背景: 透明
- 未选中文字: 紫色
- 字重: 500

---

### 5.10 BottomSheet 底部弹窗组件

#### 基本用法
```dart
customBottomSheet(
  context: context,
  title: '标题',
  content: ...,
  onDone: () {},
  isDone: true,
  isClearVisible: false,
)
```

#### 属性规范
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| context | BuildContext | 必填 | 上下文 |
| title | String | 必填 | 标题 |
| content | Widget | 必填 | 内容组件 |
| onDone | Function()? | null | 完成回调 |
| maxHeightRatio | double? | 0.8 | 最大高度比例 |
| isDone | bool? | true | 是否显示底部按钮 |
| isClearVisible | bool? | false | 是否显示清除按钮 |
| isPaddingRequired | bool? | true | 是否需要内边距 |
| catalogCount | String? | null | 目录数量文字 |

#### 布局规范
- 顶部圆角: 20
- 背景颜色: 根据主题自适应
- 不可手势关闭: `isDismissible: false`
- 不可拖动: `enableDrag: false`

#### 头部区域
- 垂直内边距: 18
- 水平内边距: 24
- 标题: 大写，字号 18，字重 700
- 关闭图标: 灰色，24

#### 分割线
- 颜色: 灰色30%透明
- 宽度: 1

#### 内容区域
- 垂直内边距: 4
- 水平内边距: 有内边距时 14，无内边距时 0

#### 底部按钮区域 (可选)
- 顶部边框: 灰色50%透明
- 垂直内边距: 20
- 水平内边距: 18
- 布局: Row，两端对齐
- 左侧文字: 字号 15，字重 600，灰色
- 清除按钮 (可选): 93x34，圆角 3，白色背景，灰色边框
- 完成按钮: 93x34，圆角 3，紫色背景

---

## 6. 图标资源规范

### 6.1 图标格式
- 格式: WebP
- 支持暗色主题切换

### 6.2 图标尺寸规范
| 使用场景 | 尺寸 | 说明 |
|---------|------|------|
| TopBar图标 | 24x24 | 导航栏图标 |
| 按钮图标 | 18-22 | 按钮内图标 |
| 列表图标 | 20x20 | 列表项图标 |
| 输入框图标 | 20x20 | 表单图标 |
| 小图标 | 10-14 | 标签、角标图标 |
| 头像 | 35x35 | 用户头像 |
| 商品缩略图 | 89x124 | 商品卡片图片 |
| 商品详情图 | 69x78 | 商品详情小图 |

### 6.3 图标路径管理
使用 `AppAssets` 类统一管理图标路径：

```dart
// 图标目录
_pIcons = 'packages/goozzy_e_commerce_screens_app_package/assets/icons/'
_pDarkIcons = 'packages/goozzy_e_commerce_screens_app_package/assets/dark_icons/'
_pImages = 'packages/goozzy_e_commerce_screens_app_package/assets/images/'
_pDarkImages = 'packages/goozzy_e_commerce_screens_app_package/assets/dark_images/'
```

### 6.4 主题切换图标
支持自动切换主题的图标：
- `icFacebook`
- `icApple`
- `icBuy`
- `icNotification`
- `icHeart`

使用 `AppAssets.refreshAssets()` 方法更新主题图标路径。

### 6.5 图标使用规范
```dart
Image.asset(
  AppAssets.icSearch,
  width: AppSizes.setWidth(24),
  height: AppSizes.setHeight(24),
  color: CustomAppColor.of(context).icBlack,
  gaplessPlayback: true,  // 推荐使用，避免图片闪烁
)
```

---

## 7. 页面布局规范

### 7.1 基本页面结构
```dart
SafeArea(
  bottom: true,
  top: false,
  child: Scaffold(
    backgroundColor: CustomAppColor.of(context).bgScaffold,
    body: ...,
  ),
)
```

### 7.2 页面类型

#### 7.2.1 标准页面布局
- TopBar (可选)
- 主内容区域
- 底部导航栏 (可选)

#### 7.2.2 滚动页面布局
```dart
SingleChildScrollView(
  child: Column(
    children: [
      // 页面内容
    ],
  ),
)
```

#### 7.2.3 列表页面布局
```dart
ListView.builder(
  padding: EdgeInsets.symmetric(...),
  itemCount: ...,
  itemBuilder: (context, index) => ...,
)
```

### 7.3 页面边距规范
- 标准页面左右边距: 20
- TopBar左右边距: 18
- 列表项左右边距: 18-20
- 卡片内边距: 15-18

### 7.4 安全区域处理
- 顶部: 通常 `top: false`，由 TopBar 处理
- 底部: 通常 `bottom: true`

---

## 8. 阴影规范

### 8.1 按钮阴影
```dart
BoxShadow(
  color: AppColor.btnPurple.withOpacityPercent(0.4),
  spreadRadius: 1,
  blurRadius: 4,
  offset: Offset(0, 2),
)
```

### 8.2 TopBar阴影
```dart
BoxShadow(
  color: CustomAppColor.of(context).txtBlack.withOpacityPercent(0.01),
  blurRadius: 3,
  spreadRadius: 2,
  offset: Offset(0, 4),
)
```

### 8.3 卡片阴影
```dart
BoxShadow(
  color: Color(0xff000000).withOpacityPercent(0.10),  // 浅色主题
  blurRadius: ...,
  spreadRadius: ...,
)
```

---

## 9. 交互规范

### 9.1 点击反馈
- 使用 `InkWell` 或 `GestureDetector`
- 禁用状态使用 `IgnorePointer(ignoring: true)`

### 9.2 页面导航
```dart
Navigator.push(context, ScreenName.route())
```

### 9.3 弹窗交互
- BottomSheet: `showModalBottomSheet`
- Dialog: `showDialog`

### 9.4 输入框焦点管理
- 使用 `FocusNode` 管理焦点
- 聚焦时显示标签，修改边框颜色

---

## 10. 响应式设计

### 10.1 设备适配
使用 `flutter_screenutil` 实现响应式：
- 字体: `AppSizes.setFontSize(size)`
- 宽度: `AppSizes.setWidth(width)`
- 高度: `AppSizes.setHeight(height)`

### 10.2 设备类型判断
```dart
AppSizes.isTablet(context)         // 平板判断
AppSizes.isFoldablePhone(size)     // 折叠屏判断
```

### 10.3 缩放系数
- 手机: 1.0
- 平板: 0.6
- 折叠屏: 0.6

### 10.4 屏幕方向
- 主要支持竖屏
- 部分页面支持横屏

---

## 11. 主题切换

### 11.1 主题配置
```dart
ThemeData(
  brightness: isLightTheme ? Brightness.light : Brightness.dark,
  fontFamily: Constant.fontFamilyUrbanist,
  useMaterial3: true,
  scaffoldBackgroundColor: isLightTheme ? AppColor.white : AppColor.bgScaffold,
  appBarTheme: AppBarTheme(
    backgroundColor: isLightTheme ? Colors.white : Colors.black,
    surfaceTintColor: Colors.transparent,
  ),
)
```

### 11.2 主题状态管理
使用 `ThemeProvider` 管理主题状态：
```dart
Constant.isLightThemeGlobal = true/false
```

### 11.3 颜色自适应
必须使用 `CustomAppColor.of(context)` 获取颜色，自动适配主题。

### 11.4 图标自适应
支持主题切换的图标需要调用 `AppAssets.refreshAssets()`。

---

## 12. 动画规范

### 12.1 页面转场
使用 `MaterialPageRoute` 默认转场动画。

### 12.2 BottomSheet动画
系统默认从底部滑入动画。

### 12.3 Loading动画
使用 `flutter_spinkit` 包提供的加载动画。

---

## 13. 可访问性

### 13.1 文字缩放
- 最大文字缩放系数限制: 1.2
- 使用 `MediaQuery.textScaler` 获取用户设置

### 13.2 颜色对比度
- 主要文本对比度: ≥ 4.5:1
- 大号文本对比度: ≥ 3:1
- 品牌色紫色 (#7165E3) 在白色背景上对比度: 4.79:1

---

## 14. 性能优化

### 14.1 图片加载
- 使用 `gaplessPlayback: true` 避免图片闪烁
- WebP 格式优化文件大小

### 14.2 列表优化
- 使用 `ListView.builder` 按需构建
- `physics: NeverScrollableScrollPhysics()` 当嵌套在滚动容器中
- `shrinkWrap: true` 当需要自适应高度

### 14.3 状态管理
- 使用 `setState` 管理局部状态
- 使用 `Provider` 管理全局主题状态

---

## 15. 编码规范

### 15.1 命名规范
- 类名: 大驼峰 (PascalCase)
- 变量/方法名: 小驼峰 (camelCase)
- 常量: 大驼峰
- 私有成员: 下划线前缀 `_`

### 15.2 文件组织
```
lib/
  ├── ui/                   # 页面
  │   ├── page_name/
  │   │   ├── datamodel/   # 数据模型
  │   │   └── view/        # 视图
  ├── widgets/             # 公共组件
  ├── utils/               # 工具类
  ├── themes/              # 主题
  ├── localization/        # 国际化
  └── interfaces/          # 接口定义
```

### 15.3 注释规范
- 使用 `///` 文档注释
- 属性注释使用 `/** 注释文案 */` 放在属性上方
- 清晰、简洁、易维护
- 不包含优化方向或无关注释

### 15.4 字符串规范
- 统一使用单引号 `'`
- 多语言文本使用 `Languages.of(context)`
- 常量文本定义在 `AppStrings` 或 `StringConstant`

### 15.5 导入规范
```dart
import 'package:flutter/material.dart';
import 'package:goozzy_e_commerce_screens_app_package/utils/utils.dart';

import '../../utils/app_color.dart';
import '../../utils/sizer_utils.dart';
```

### 15.6 代码质量
- 遵循 Dart 编码规范
- 单一职责原则
- 高内聚、低耦合
- 组件可复用、可扩展

---

## 16. 国际化

### 16.1 语言支持
- 当前支持: 英语 (en)
- 扩展性: 预留多语言支持

### 16.2 文本获取
```dart
Languages.of(context).textKey
```

### 16.3 本地化组件
使用 `flutter_localizations` 和自定义 `LocalizationsDelegate`。

---

## 17. 第三方库规范

### 17.1 核心依赖
```yaml
flutter_screenutil: ^5.9.3        # 响应式布局
get_it: ^8.0.3                   # 依赖注入
shared_preferences: ^2.3.1       # 本地存储
```

### 17.2 UI组件库
```yaml
carousel_slider: ^5.0.0          # 轮播图
smooth_page_indicator: ^1.2.0+3  # 页面指示器
flutter_switch: ^0.3.2           # 开关组件
intl_phone_field: ^3.2.0         # 手机号输入框
```

### 17.3 功能库
```yaml
image_picker: ^1.1.2             # 图片选择
flutter_holo_date_picker: ^2.0.0 # 日期选择
showcaseview: ^4.0.0             # 引导页
super_tooltip: ^2.0.9            # 提示框
readmore: ^3.0.0                 # 展开/收起文本
```

---

## 18. 特殊组件规范

### 18.1 CommonRichText 富文本组件
用于显示多样式文本，如"已有账号？立即登录"。

### 18.2 FilterAction 筛选操作组件
用于列表筛选操作，支持排序、筛选等。

### 18.3 ProductRatings 商品评分组件
展示商品评分分布和统计信息。

### 18.4 ProductReviews 商品评论组件
展示用户评论列表。

### 18.5 ProductServices 商品服务组件
展示商品服务信息，如退货政策、配送信息等。

---

## 19. 验证与测试

### 19.1 UI一致性检查
- 所有颜色必须通过 `CustomAppColor.of(context)` 获取
- 所有字号必须通过 `AppSizes.setFontSize()` 设置
- 所有尺寸必须通过 `AppSizes.setWidth/setHeight()` 设置

### 19.2 主题测试
- 浅色主题完整测试
- 深色主题完整测试
- 主题切换流畅性测试

### 19.3 响应式测试
- 手机端测试 (不同屏幕尺寸)
- 平板端测试
- 折叠屏测试
- 横竖屏切换测试

### 19.4 交互测试
- 点击反馈测试
- 输入框交互测试
- 页面导航测试
- 弹窗交互测试

---

## 20. 维护与更新

### 20.1 新增组件
1. 在 `widgets/` 目录下创建组件文件
2. 遵循现有组件命名和代码规范
3. 使用统一的颜色和尺寸系统
4. 添加完整的属性文档注释
5. 更新本规范文档

### 20.2 修改现有组件
1. 确保向后兼容
2. 更新相关文档
3. 全面测试影响范围

### 20.3 新增主题色
1. 在 `AppColor` 类中定义静态常量
2. 在 `CustomAppColor` 类中添加主题适配方法
3. 更新本规范文档

### 20.4 版本管理
- 当前版本: 0.0.1
- 遵循语义化版本规范

---

## 21. 常见问题

### 21.1 颜色不跟随主题变化
**原因**: 直接使用 `AppColor.xxx` 而不是 `CustomAppColor.of(context).xxx`
**解决**: 使用 `CustomAppColor.of(context)` 获取颜色

### 21.2 字体在不同设备显示大小不一致
**原因**: 未使用 `AppSizes.setFontSize()`
**解决**: 统一使用 `AppSizes.setFontSize()` 设置字号

### 21.3 图标在深色主题下不清晰
**原因**: 未使用支持主题的图标路径
**解决**: 使用 `AppAssets` 管理的图标，并在切换主题时调用 `refreshAssets()`

### 21.4 输入框边框在聚焦时未变色
**原因**: 未使用 `FocusNode` 或未正确配置边框颜色
**解决**: 使用 `CommonTextFormField` 组件，自动处理焦点状态

---

## 22. 附录

### 22.1 颜色对照表
详见第2章颜色系统。

### 22.2 字号对照表
详见第3.3章字号规范。

### 22.3 间距对照表
详见第4.3章间距规范。

### 22.4 圆角对照表
详见第4.4章圆角规范。

### 22.5 组件清单
- CommonText
- CommonButton
- CommonTextFormField
- CommonDigitTextFormField
- TopBar
- CustomContainer
- Heading
- ProductsDetail
- ProductCard
- ProductRatings
- ProductReviews
- ProductServices
- FilterOptionChip
- FilterAction
- ToggleButtonWidget
- CommonRichText
- CommonDialog
- customBottomSheet

---

## 23. 更新日志

### v0.0.1 (2025-11-11)
- 初始版本发布
- 完成核心组件UI规范
- 完成颜色、字体、尺寸系统规范
- 完成主题切换规范

---

**文档维护者**: Goozzy E-Commerce Team  
**最后更新**: 2025-11-11  
**文档版本**: v1.0.0


# Project Context

## Purpose
Oil Business App 是一个油品业务管理应用，帮助加油站管理人员进行油品采购、提货、订单管理等业务操作。支持 Android 和 iOS 双平台。

## Tech Stack
- **框架**: Flutter 3.4+ (跨平台移动应用开发)
- **语言**: Dart 3.4+
- **状态管理**: BLOC Pattern (bloc ^9.0.0 + flutter_bloc ^9.1.1 + hydrated_bloc ^10.1.1)
- **网络请求**: Dio ^5.2.1 + Retrofit (代码生成)
- **路由导航**: Go Router ^16.0.0
- **国际化**: Easy Localization (支持中英文切换)
- **代码生成**: Freezed ^3.2.3 + JSON Serializable ^6.9.0 + Build Runner ^2.5.4
- **本地存储**: Hive ^2.2.3 + Shared Preferences ^2.5.3
- **依赖注入**: Get It ^8.2.0
- **UI组件库**: TDesign Flutter ^0.1.5
- **包管理器**: Flutter Pub (Dart/Flutter 官方包管理器)
- **脚本工具**: rps (Run Pub Scripts ^0.8.0，在 pubspec.yaml 中定义脚本命令)

## Project Conventions

### Code Style
- **代码风格**: 遵循 Flutter/Dart 官方编码规范和最佳实践
- **最大行宽**: 120字符（在 analysis_options.yaml 中配置）
- **缩进**: 2个空格
- **字符串**: 优先使用单引号 'string'
- **命名约定**:
  - 类名: PascalCase (首字母大写)
  - 变量、方法、参数: camelCase (驼峰式)
  - 常量: UPPER_SNAKE_CASE (全大写下划线)
  - 文件名、包名: lowercase_with_underscores (小写下划线)
- **不可变对象**: 尽可能使用 const 构造函数
- **变量声明**: 尽可能使用 final 变量
- **Widget**: 将独立 createState 方法提取为单独 children 组件或静态方法
- **注释规范**: 使用 /// 添加文档注释，用 // 添加行内注释

### Architecture Patterns

#### 目录结构
**Feature-first 组织结构**，按功能模块组织代码：
```
lib/
├── pages/              # 页面模块（feature-first），每个 feature 包含：
│   ├── [feature]/
│   │   ├── page.dart         # 路由定义文件（继承 BasePage）
│   │   ├── controller.dart   # Cubit/Bloc 控制器
│   │   ├── state.dart        # 状态定义（包含 copyWith）
│   │   ├── view.dart         # 视图实现文件
│   │   ├── model/            # 页面特有的数据模型和请求类
│   │   └── widgets/          # 页面特有组件
│   │       └── [feature]_screen.dart  # 具体 UI 布局
├── widgets/            # 公共组件（可复用）
│   ├── base/          # 基础组件（CommonButton、CommonText 等）
│   ├── common/        # 通用组件
│   └── popup/         # 弹窗组件
├── global/            # 全局状态
│   ├── app_controller.dart   # 全局状态 HydratedCubit
│   ├── app_state.dart        # 全局状态定义
│   ├── service/              # 全局 API 接口（Retrofit）
│   ├── model/                # 全局数据模型
│   ├── storage.dart          # 本地存储管理
│   └── events.dart           # 全局事件总线
├── net/               # 网络层
│   ├── net_manager.dart             # Dio 管理器
│   ├── base_interceptor.dart        # 基础拦截器
│   ├── http_header_interceptor.dart # 请求头拦截器
│   ├── http_resp_interceptor.dart   # 响应拦截器
│   ├── http_log_interceptor.dart    # 日志拦截器
│   └── response.dart                # 响应模型
├── router/            # 路由配置
│   ├── router.dart           # GoRouter 配置
│   ├── routes.dart           # 路由枚举和路径定义
│   └── pageTransition/       # 页面过渡动画
├── config/            # 配置文件
│   ├── config.dart           # 基础配置（设备信息、版本号等）
│   ├── env.dart              # 环境变量
│   ├── channel.dart          # 渠道配置
│   └── address.dart          # 接口配置
├── resources/         # 资源文件
│   ├── colors.dart           # 颜色定义（浅色/深色主题）
│   ├── size.dart             # 尺寸常量
│   ├── style.dart            # 样式定义
│   └── theme.dart            # 主题配置
├── static/            # 静态资源引用（代码生成文件）
│   ├── img.dart              # 图片路径常量
│   ├── icon.dart             # 图标路径常量
│   └── svg.dart              # SVG 资源路径
├── utils/             # 工具类（纯函数）
│   ├── sizer_utils.dart      # 响应式布局工具（AppSizes）
│   ├── log.dart              # 日志工具
│   ├── validators.dart       # 表单验证器
│   └── ...                   # 其他工具
└── models/            # 非全局、跨页面共享的数据模型
```

#### 页面结构标准（每个功能模块包含以下文件）

**必须包含的文件**：
1. **page.dart** - 路由配置文件
   - 继承 `BasePage`
   - 实现 `BasicInitPage` 初始化生命周期
   - 使用 `BlocProvider` 注册 Controller
   - 使用 `BlocBuilder` 响应状态变化

2. **controller.dart** - 业务逻辑控制器
   - 继承 `Cubit<State>` 或 `Bloc<Event, State>`
   - 页面局部状态使用 Cubit（简单场景）
   - 全局状态或持久化使用 HydratedCubit（复用存储）
   - 命名格式 Key 命名必须以 _storage 为后缀

3. **state.dart** - 状态定义类
   - 不可变数据类
   - 必须包含 `copyWith` 方法
   - 使用不可变集合（如 List 用 UnmodifiableListView）
   - 推荐使用 Freezed 生成

4. **view.dart** - 视图实现文件
   - `StatefulWidget` 或 `StatelessWidget`
   - 使用 `BlocListener` 监听副作用（如显示 Toast）
   - 调用 widgets/ 下的具体 UI 组件
   - 保持简洁，只负责组装和传递数据

5. **widgets/[feature]_screen.dart** - 具体 UI 布局
   - 布局和样式实现的主要位置
   - 使用公共组件构建 UI
   - 通过 `context.read<Ctrl>()` 调用方法

#### 状态管理模式

**1. 页面局部状态 - Cubit**
```dart
// 适用于简单场景，如表单页面的状态管理
class LoginCtrl extends Cubit<LoginState> {
  LoginCtrl() : super(LoginState(loginLoading: false));
  
  submit() async {
    emit(state.copyWith(loginLoading: true));
    // 业务逻辑
  }
}
```

**2. 全局持久化状态 - HydratedCubit**
```dart
// 适用于需要持久化存储的状态，如用户信息、应用配置
class AppController extends HydratedCubit<AppState> {
  AppController() : super(AppState());
  
  @override
  AppState? fromJson(Map<String, dynamic> json) {
    // 反序列化
  }
  
  @override
  Map<String, dynamic>? toJson(AppState state) {
    // 序列化
  }
}
```

**3. 全局事件通信 - EventBus**
```dart
// 非全局、跨页面事件通信
globalTabChangeEventBus.fire(index);
globalTabChangeEventBus.on<int>().listen((index) {
  // 监听事件
});
```

#### 网络请求架构

**拦截器链路**：
1. `HttpHeaderInterceptor` - 添加公共请求头（如 Token、User-Agent）
2. `BaseInterceptor` - Token 过期刷新和重试逻辑
3. `HttpLogInterceptor` - 请求/响应日志打印
4. `HttpRespInterceptor` - 统一错误处理和状态码处理

**API 接口定义**：使用 Retrofit 生成
```dart
@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;
  
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
}
```

### UI Component Standards

#### 设计规范
- 现代化电商应用界面设计
- 支持浅色/深色主题切换
- 响应式布局，支持手机、平板、折叠屏
- Material Design 3 设计语言
- 高内聚、低耦合的组件化设计

#### 公共组件库（`widgets/base/`）

##### **CommonText** - 统一文本组件

**属性参数**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| text | String | 必填 | 文本内容 |
| fontSize | double? | 14 | 字体大小（需通过 setFontSize） |
| fontWeight | FontWeight | w400 | 字体粗细 |
| textColor | Color? | txtBlack | 文本颜色 |
| textAlign | TextAlign | center | 对齐方式 |
| fontFamily | String | Urbanist | 字体家族 |
| maxLines | int? | null | 最大行数 |
| overflow | TextOverflow? | null | 溢出处理 |
| letterSpacing | double? | null | 字符间距 |

**使用示例**：
```dart
CommonText(
  text: '文本内容',
  fontSize: AppSizes.setFontSize(14),
  fontWeight: FontWeight.w600,
  textColor: CustomAppColor.of(context).txtBlack,
)
```

- ✅ 必须使用 `AppSizes.setFontSize()` 设置尺寸
- ✅ 必须使用 `CustomAppColor.of(context)` 获取颜色
- ✅ 默认行高 1.2
- ✅ 默认字体家族 Urbanist

##### **CommonButton** - 统一按钮组件

**属性参数**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| btnText | String? | null | 按钮文字 |
| child | Widget? | null | 自定义内容组件 |
| onTap | Function()? | null | 点击回调 |
| buttonColor | Color? | btnPurple | 按钮背景色 |
| borderColor | Color? | transparent | 边框颜色 |
| height | double? | 52 | 按钮高度 |
| width | double? | fullWidth | 按钮宽度 |
| radius | double | 8 | 圆角半径 |
| fontSize | double? | 15 | 文字大小 |
| isButtonShadow | bool? | true | 是否显示阴影 |
| isLoading | bool? | false | 是否显示加载 |

**按钮样式类型**：

*主要按钮（Primary）：*
```dart
CommonButton(
  btnText: '提交表单',
  buttonColor: CustomAppColor.of(context).btnPurple,
  height: AppSizes.buttonHeight,  // 52
  radius: 8,
  isButtonShadow: true,
  isLoading: state.loading,
)
```
- 背景色为品牌紫色 #7165E3
- 文本颜色为白色
- 阴影透明度 40% 向下偏移
- 高度固定 52，圆角 8

*次要按钮（Secondary）：*
```dart
CommonButton(
  btnText: '次要操作',
  buttonColor: CustomAppColor.of(context).btnWhite,
  borderColor: CustomAppColor.of(context).borderGrey,
  isButtonShadow: false,
)
```
- 背景色为白色/浅色背景
- 边框 1px 灰色
- 无阴影

*小按钮：*
```dart
CommonButton(
  btnText: '小按钮',
  height: AppSizes.setHeight(34),
  width: AppSizes.setWidth(93),
  radius: 3,
)
```
- 高度 34，圆角 3

##### **CommonTextFormField** - 表单输入组件

**属性参数**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| name | String? | null | 字段名称（FormBuilder 用）|
| hintText | String? | null | 占位文字 |
| labelText | String? | null | 标签文字 |
| controller | TextEditingController? | null | 控制器 |
| leadingIcon | Widget? | null | 前置图标 |
| suffixIcon | Widget? | null | 后置图标 |
| borderColor | Color? | borderGrey | 边框颜色 |
| radius | double? | 12 | 圆角半径 |
| isPasswordField | bool | false | 是否为密码框 |
| isPhoneNumberField | bool | false | 是否为手机号框 |
| validators | Function? | null | 表单验证器 |

**控制器特性**：
- 默认情况下边框灰色 1px，圆角 12
- 聚焦时边框变为紫色 2px，标签上浮显示
- 密码框右侧显示密码切换图标
- 手机号框使用专用的手机号输入格式（IntlPhoneField）

**使用示例**：
```dart
CommonTextFormField(
  name: 'phone',
  hintText: '请输入手机号',
  leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
  borderColor: CustomAppColor.of(context).textFieldBorder,
  validators: FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: '请输入手机号'),
  ]),
)
```

##### **TopBar** - 页面顶部栏组件

**属性参数**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| clickListener | TopBarClickListener | 必填 | 点击事件监听器 |
| title | String? | null | 标题文字 |
| isShowBack | bool | false | 是否显示返回按钮 |
| isShowProfile | bool | false | 是否显示头像 |
| isShowNotification | bool | false | 是否显示通知图标 |
| isShowSearch | bool | false | 是否显示搜索图标 |
| isShowCart | bool | false | 是否显示购物车 |
| topBarColor | Color? | white | 背景颜色 |
| textColor | Color | txtBlack | 文本颜色 |
| height | double | 100 | 高度 |

**样式说明**：
- 默认高度为 100（包含 SafeArea）
- 内部内容间距 18
- 图标大小 24x24
- 从左到右排列：返回 → 头像 → 标题 → Spacer → 操作图标

##### **CommonContainer** - 容器组件

**属性参数**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| width | double | 必填 | 容器宽度 |
| height | double | 必填 | 容器高度 |
| child | Widget | 必填 | 子组件 |
| borderColor | Color? | containerBorder | 边框颜色 |
| borderWidth | double? | 1 | 边框宽度 |
| borderRadius | double? | 15 | 圆角半径 |

##### **Heading** - 标题组件

**使用示例**：
```dart
Heading(
  title: '左侧标题',
  navigationTitle: '查看更多',
  onTap: () {},
)
```

**样式说明**：
- 左侧标题字体大小 18，粗细 800
- 导航文字右侧字号 14，粗细 700 带箭头
- 内部内容间距 0

#### 颜色规范

**品牌色**：
```dart
AppColor.btnPurple = #7165E3      // 主按钮、强调色、品牌标识
AppColor.txtPurple = #7165E3      // 文本强调色
AppColor.icPurple = #7165E3       // 图标强调色
AppColor.borderPurple = #7165E3   // 边框颜色
```

**中性色**：
```dart
AppColor.white = #FFFFFF          // 纯白
AppColor.black = #000000          // 纯黑
AppColor.txtBlack = #000000       // 黑色文本
AppColor.txtGrey = #9EA6BE        // 灰色文本
AppColor.hintGrey = #AFB0B6       // 提示文本灰色
AppColor.borderGrey = #9EA6BE     // 边框灰色
```

**状态色**：
```dart
AppColor.green = #2AB126          // 成功状态
AppColor.txtRed = #FF4141         // 错误/警告
AppColor.txtOrange = #FF9B00      // 橙色提示
AppColor.txtBlue = #383EAF        // 蓝色链接
```

**背景色**：
```dart
// 浅色主题
AppColor.white = #FFFFFF          // 主背景
AppColor.bgTopBar = #F9F9FB       // TopBar背景

// 深色主题
AppColor.bgScaffold = #181A20     // 深色主背景
AppColor.containerGrey = #1F222A  // 深色容器背景
```

**主题适配（重要！必须遵守）**：
```dart
// ✅ 正确：使用主题适配自动切换浅色/深色
backgroundColor: CustomAppColor.of(context).bgScaffold       // 页面背景
textColor: CustomAppColor.of(context).txtBlack         // 文本颜色（自动反色）
buttonColor: CustomAppColor.of(context).btnPurple        // 品牌色按钮
borderColor: CustomAppColor.of(context).borderGrey       // 边框
textFieldBorder: CustomAppColor.of(context).textFieldBorder  // 输入框边框

// ❌ 错误：直接硬编码颜色
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

#### 字体规范

**字体家族**：
```dart
Constant.fontFamilyUrbanist = 'Urbanist'    // 主字体
```

**字体粗细**：
- Light: 300
- Regular: 400
- Medium: 500
- SemiBold: 600
- Bold: 700

**字体使用场景**：
| 场景 | 字体大小 | 字体粗细 | 使用场景 |
|-----|------|------|---------|
| 大标题 | 35 | 800 | 页面主标题、欢迎页、启动页等 |
| 标题 | 24 | 700 | 页面标题、区块标题、对话框标题等 |
| 小标题 | 18 | 800 | 卡片标题、Heading组件 |
| 按钮文字 | 15 | 500 | 主按钮文本 |
| 正文 | 14 | 400-700 | 主内容、列表项、表单输入等 |
| 辅助文字 | 12 | 500 | 提示信息、副标题 |
| 小文字 | 10 | 500 | 占位提示 |

**行高规范**：
- 所有文本默认行高为 `height: 1.2`

**响应式透明度使用规范**：
- 禁用状态文本透明度 1.0
- 次要文本使用透明度 0.6
- 占位文字使用透明度 0.6
- 辅助信息文字使用透明度更高 1.2

#### 响应式布局工具（避免硬编码尺寸）

**尺寸适配 - AppSizes**：
```dart
// ✅ 正确：使用工具方法
width: AppSizes.setWidth(80)
height: AppSizes.setHeight(60)
fontSize: AppSizes.setFontSize(14)
padding: EdgeInsets.symmetric(
  horizontal: AppSizes.setWidth(20),
  vertical: AppSizes.setHeight(16),
)

// 常用固定尺寸
AppSizes.fullWidth        // 全屏宽度
AppSizes.fullHeight       // 全屏高度
AppSizes.buttonHeight     // 标准按钮高度 52
AppSizes.topBarHeight     // 顶部栏高度 60

// ❌ 错误：直接硬编码尺寸
width: 80
height: 60
fontSize: 14
```

**间距规范**：

*水平间距*：
| 间距值 | 使用场景 |
|-------|---------|
| 8 | 最小间距 |
| 10 | 小间距 |
| 12 | 图标间距 |
| 15 | 标准间距 |
| 18-20 | 页面左右边距 |
| 22 | 大间距 |
| 24 | 块间距 |

*垂直间距*：
| 间距值 | 使用场景 |
|-------|---------|
| 5 | 最小间距 |
| 10 | 小间距 |
| 12 | 标签与内容间距 |
| 15 | 标准间距 |
| 16 | 表单元素间距 |
| 20 | 大间距、组块间距 |
| 25 | 提示文本上方间距 |
| 32 | 表单与输入框顶部间距 |
| 58 | 页面顶部间距 |
| 61 | 对话框内容间距 |
| 88 | 大块间距 |

**圆角规范**：
| 圆角值 | 使用场景 |
|-------|---------|
| 3 | 小按钮圆角 |
| 5 | 标签圆角 |
| 8 | 标准卡片、容器、主按钮圆角 |
| 12 | 标准容器、输入框圆角 |
| 15 | 大圆角 |
| 20 | BottomSheet圆角 |

**颜色主题 - CustomAppColor**：
```dart
// ✅ 正确：使用主题适配自动切换 浅色/深色
backgroundColor: CustomAppColor.of(context).bgScaffold
textColor: CustomAppColor.of(context).txtBlack
borderColor: CustomAppColor.of(context).borderPurple

// 常用颜色
.bgScaffold          // 页面背景（自动适配）
.txtBlack / .txtWhite // 文本颜色（自动反色）
.txtGrey / .txtPurple // 灰色/紫色文字
.btnPurple           // 按钮颜色（固定色值 #7165E3）
.borderGrey / .borderPurple // 边框颜色
.textFieldBorder     // 输入框边框

// ❌ 错误：直接硬编码颜色
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

**设备类型判断**：
```dart
AppSizes.isTablet(context)         // 平板设备
AppSizes.isFoldablePhone(size)     // 折叠屏设备
```

**静态资源引用**：
```dart
// ✅ 正确：使用代码生成的资源常量
Image.asset(AssetsImg.LOGO)
Image.asset(AssetsIcon.IC_PROFILE)
SvgAsset(assetName: AssetsSvg.IC_HOME)

// ❌ 错误：直接硬编码路径
Image.asset('assets/img/logo.webp')
```

#### 页面框架模板

**顶层结构**：
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

**页面类型**：

*1. 标准静态页面*：
- TopBar（可选）
- 主内容
- 底部操作栏（可选）

*2. 滚动内容页面*：
```dart
SingleChildScrollView(
  padding: EdgeInsets.symmetric(
    horizontal: AppSizes.setWidth(20),
  ),
  child: Column(
    children: [
      // 页面内容
    ],
  ),
)
```

*3. 列表页面*：
```dart
ListView.builder(
  padding: EdgeInsets.symmetric(
    horizontal: AppSizes.setWidth(20),
    vertical: AppSizes.setHeight(16),
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ...,
)
```

**页面边距约束**：
- 标准静态页面左右边距：20
- TopBar 左右间距：18
- 列表页面顶部间距：18-20
- 块之间垂直间距：15-18

**SafeArea 管理**：
- 顶部导航栏设置 `top: false`，由 TopBar 自行管理
- 底部操作栏设置 `bottom: true`

#### 图标规范

**图标格式**：
- 主要格式：webp
- 支持浅色/深色主题切换

**图标大小约束**：
| 使用场景 | 尺寸 | 说明 |
|---------|------|------|
| TopBar 图标 | 24x24 | 导航栏图标 |
| 按钮图标 | 18-22 | 按钮内图标 |
| 列表图标 | 20x20 | 列表项图标 |
| 输入框前缀图标 | 20x20 | 表单图标 |
| 小标识 | 10-14 | 标签、徽章图标 |
| 头像 | 35x35 | 用户头像 |

**图标使用约束**：
```dart
// ✅ 正确：使用主题自适应和缓存优化
Image.asset(
  AssetsIcon.IC_SEARCH,
  width: AppSizes.setWidth(24),
  height: AppSizes.setHeight(24),
  color: CustomAppColor.of(context).icBlack,
  gaplessPlayback: true,  // 使用无缝切换避免闪烁
)

// ❌ 错误：直接硬编码路径
Image.asset('assets/icon/ic_search.webp')
```

#### 阴影规范

**按钮阴影**：
```dart
BoxShadow(
  color: AppColor.btnPurple.withOpacity(0.4),
  spreadRadius: 1,
  blurRadius: 4,
  offset: Offset(0, 2),
)
```

**TopBar 阴影**：
```dart
BoxShadow(
  color: CustomAppColor.of(context).txtBlack.withOpacity(0.01),
  blurRadius: 3,
  spreadRadius: 2,
  offset: Offset(0, 4),
)
```

**卡片阴影**：
```dart
BoxShadow(
  color: Color(0xff000000).withOpacity(0.10),
  blurRadius: 8,
  spreadRadius: 2,
  offset: Offset(0, 2),
)
```

#### 交互规范

**点击反馈**：
- 使用 `InkWell` 或 `GestureDetector`
- 禁用状态使用 `IgnorePointer(ignoring: true)`

**页面导航**：
```dart
BaseRouter.push(context, AppPage.home)
BaseRouter.pop(context)
```

**弹窗交互**：
- BottomSheet：`showModalBottomSheet`
- Dialog：`showDialog`
- Alert：TDesign Flutter 组件

**输入框焦点管理**：
- 使用 `FocusNode` 管理焦点
- 聚焦时显示标签，修改边框颜色

### 页面拆分与组件化规范
- 大型或内容丰富的页面必须拆分为职责明确的 Widgets；主页面文件只保留状态持有、导航、Toast/弹窗、截图/保存等业务流程，不内联大块 UI。
- UI 区块放入 `widgets/` 目录的独立组件（如 header、card、actions、sheet 等），组件仅负责展示和触发回调，不直接持有业务状态。
- 弹窗/BottomSheet/保存分享类组件通过参数传入的回调执行业务 IO 或导航，避免在组件内部管理状态或依赖全局单例。
- 命名建议：`xxx_header.dart`、`xxx_card.dart`、`xxx_actions.dart`、`xxx_sheet.dart`，职责清晰。
- 需截图/保存的页面使用 `RepaintBoundary` 包裹目标组件，主页面负责图片生成与存储逻辑，子组件保持纯 UI。

#### 主题切换

**主题配置**：
```dart
ThemeData(
  brightness: isLightTheme ? Brightness.light : Brightness.dark,
  fontFamily: Constant.fontFamilyUrbanist,
  useMaterial3: true,
  scaffoldBackgroundColor: isLightTheme 
    ? AppColor.white 
    : AppColor.bgScaffold,
)
```

**主题切换实现**：
```dart
// 使用全局状态切换主题
Constant.isLightThemeGlobal = true/false
```

**颜色适配方案**：
- ✅ 必须使用 `CustomAppColor.of(context)` 获取颜色
- ✅ 自动适配浅色/深色主题

#### 性能优化规范

**图片优化**：
- 使用 `gaplessPlayback: true` 避免图片闪烁
- WebP 格式优先，体积更小
- 使用 `CachedNetworkImage` 缓存网络图片

**列表优化**：
- 使用 `ListView.builder` 懒加载
- `physics: NeverScrollableScrollPhysics()` 禁用嵌套滚动
- `shrinkWrap: true` 禁用自动高度

**状态管理**：
- 使用 `setState` 管理局部轻量状态
- 使用 Cubit 管理静态复杂状态
- 使用 HydratedCubit 管理全局需存储状态

**常量优化**：
- 使用 `const` 构造函数
- 避免频繁创建 Widget 实例

**文本缩放**：
- 所有文本行高比率固定为 1.2
- 使用 `MediaQuery.textScaler` 获取系统缩放

**颜色对比度**：
- 主按钮文字对比度至少 4.5:1
- 大字号内容对比度至少 3:1
- 品牌紫色 (#7165E3) 与白色背景对比度 4.79:1

### Form Handling Standards

#### FormBuilder 集成
```dart
FormBuilder(
  key: ctrl.formKey,
  child: Column(
    children: [
      CommonTextFormField(
        name: 'phone',              // 必须指定唯一字段名
        hintText: '请输入手机号',
        leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
        validators: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: '请输入手机号'),
          FormBuilderValidators.numeric(),
        ]),
      ),
    ],
  ),
)
```

#### 表单验证流程
```dart
// Controller 中定义预检查方法
bool formPrecheck() {
  if (state.loading) return false;
  return formKey.currentState?.saveAndValidate() ?? false;
}

submit() async {
  if (!formPrecheck()) return;
  
  emit(state.copyWith(loading: true));
  
  final formData = formKey.currentState?.value ?? {};
  final phone = formData['phone'] ?? '';
  // 处理表单提交
}
```

### Router Management

#### 路由定义（`router/routes.dart`）
```dart
enum AppPage {
  loginPage('/login'),
  registerPage('/register'),
  mainLayoutPage('/'),
  
  const AppPage(this.path);
  final String path;
  
  static final routes = AppPage.values
      .map((page) => BaseRoute(
            path: page.path,
            builder: page.builder,
          ))
      .toList();
}
```

#### 路由导航
```dart
// ✅ 推荐：使用工具方法
BaseRouter.push(url: AppPage.loginPage.path)
BaseRouter.push(url: AppPage.otpPage.path, extra: {'type': 'register'})
BaseRouter.replace(url: AppPage.mainLayoutPage.path)
BaseRouter.pop()

// 可用：直接使用 GoRouter
context.go('/login')
context.push('/register')
```

#### 页面过渡动画配置
```dart
extension PageRoute on AppPage {
  GoRouterPageBuilder? get pageBuilder {
    if (this == AppPage.loginPage) {
      return (context, state) => bottomToTopPageTransition(
        context: context, 
        state: state, 
        child: const LoginPage()
      );
    }
    return null;
  }
}
```

### Testing Strategy
- 业务逻辑单元测试（API 接口、数据模型）
- Widget 组件测试
- 端到端集成测试（关键业务流程）
- 使用 mockito 模拟依赖

### Git Workflow
- **分支策略**: Git Flow
  - `main/master`: 生产环境分支
  - `develop`: 开发集成分支
  - `feature/*`: 功能分支
- **提交规范**: 清晰描述变更内容
- **代码审查**: 所有代码必须经过审查
- **Pre-commit**: 执行 Lint 检查 (scripts/pre-commit.sh)

## Domain Context

### 业务场景
本项目是一个油品业务应用，主要包含以下功能模块：
1. **用户认证**: 基础的登录注册流程（手机号 + 验证码）
2. **管理系统**: 加油站管理 + 油品订单管理
3. **订单流程**: 支付订单、提货订单、证件管理

### 数据模型主要实体
- 用户信息、登录状态
- 加油站信息
- 油品订单
- 支付订单
- 提货证件（车牌号码、司机信息等）

### API 数据规范
- **请求格式**: 统一 JSON (Content-Type: application/json;charset=UTF-8)
- **响应格式**: 统一对象 `{ code: number, message: string, data: any }`
  - code=200 表示成功
- **鉴权机制**: 基于 Token 双令牌
  - `access_token`: 用于认证的短期 API 访问令牌
  - `refresh_token`: 用于刷新 access_token 的长期令牌
  - 自动过期刷新：当 access_token 过期时自动刷新
- **Base URL**: 
  - 开发环境（测试）: https://test.maiyoubei.com/api/app
  - 生产环境: 待配置

## Important Constraints
- **厂商兼容性**: 支持 oppo、vivo、xiaomi 等国产手机
- **性能优化**: 
  - 使用 const 构造函数减少重建
  - 列表使用 ListView.builder
  - 网络图片使用 CachedNetworkImage
  - 避免频繁创建 Widget 实例
- **字符编码**: 统一使用 UTF-8
- **环境配置**: 支持开发环境（qa）、生产环境（pro）环境切换
- **设备要求**: 支持手机号登录、平板设备，数据自动响应式适配
- **安全性要求**: 敏感信息加密存储，防止内存泄漏

## External Dependencies
- **API 接口**: 后端 REST API (测试域名: test.maiyoubei.com)
- **鉴权接口**: 
  - POST /auths/login - 用户登录
  - POST /auths/refresh - Token 刷新
  - POST /auths/logout - 用户退出
- **设备信息**: Device Info Plus (获取设备型号、系统版本)
- **OSS**: 阿里云 OSS (上传 APK 和日志文件，见 scripts/upload_oss.sh)
- **版本信息**: Package Info Plus (获取应用版本号信息)

### Code Generation

#### 数据模型生成（Freezed + JSON Serializable）
```bash
# 生成所有 .g.dart 和 .freezed.dart 文件
pnpm gen_model

# 或直接运行
flutter pub run build_runner build --delete-conflicting-outputs
```

**数据模型定义规范**：
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_req_type.freezed.dart';
part 'auth_req_type.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    String? password,
    String? code,
  }) = _LoginRequest;
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
```

#### 静态资源代码生成
```bash
# 生成 static/ 目录下的资源路径常量
pnpm gen_assets

# 或直接运行
dart ./scripts/gen_assets.dart
```

自动生成 `AssetsImg`、`AssetsIcon`、`AssetsSvg` 常量类

#### 页面模块快速生成
```bash
# 使用脚手架快速生成页面模板
pnpm gen_page

# 或直接运行
dart ./scripts/create_page.dart
```

生成包含 page、controller、state、view 的完整文件

### Logging Standards

#### 日志工具（`utils/log.dart`）
```dart
import 'package:oil_business_app/utils/log.dart';

// 调试日志
l.d('Login', '用户登录: 手机号 $phone');

// 普通信息日志
l.i('Init', '######################## 页面初始化 ########################');

// 错误日志
l.e('Register', '注册失败: $e');

// 警告日志
l.w('Network', '网络请求超时');
```

**日志规范**：
- 第一参数填写模块名/页面名
- 第二参数填写具体日志内容
- 避免打印敏感信息（如密码、Token）
- 关键业务节点必须添加日志

### Error Handling

#### 网络请求错误处理
```dart
try {
  final response = await authService.login(request);
  // 处理成功响应
} on DioException catch (e) {
  // Dio 网络错误
  l.e('Login', 'DioException: ${e.message}');
  emit(state.copyWith(loading: false, errorMessage: e.message));
} catch (e) {
  // 其他错误
  l.e('Login', '未知错误: $e');
  emit(state.copyWith(loading: false));
}
```

#### 统一错误处理（响应拦截器）
网络错误通过 `HttpRespInterceptor` 统一处理：
- 401: Token 过期，自动刷新重试
- 403: 权限不足
- 500: 接口服务器错误
- 网络超时/断网

### Performance Optimization

#### 必须遵守的性能规范

1. **使用 const 构造函数**
   ```dart
   // ✅ 正确
   const Text('Hello')
   const SizedBox(height: 10)
   
   // ❌ 错误
   Text('Hello')
   SizedBox(height: 10)
   ```

2. **列表使用 Builder**
   ```dart
   // ✅ 正确
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   
   // ❌ 错误（一次性创建所有 Widget）
   ListView(children: items.map((e) => ItemWidget(e)).toList())
   ```

3. **网络图片使用缓存**
   ```dart
   // ✅ 正确
   CachedNetworkImage(
     imageUrl: imageUrl,
     placeholder: (context, url) => CircularProgressIndicator(),
   )
   
   // ❌ 错误（每次重新下载）
   Image.network(imageUrl)
   ```

4. **避免频繁重建组件**
   - 使用 `const` 构造函数
   - 合理使用 `BlocBuilder` 的 `buildWhen`
   - 使用 `RepaintBoundary` 隔离不需要更新的组件

#### 设备适配
- 支持手机号登录、平板设备
- 屏幕宽度 > 600 时启用平板布局
- 字体大小根据系统缩放比例自动调整
- 所有文本行高比例固定 1.2

### Best Practices

#### 代码组织
1. **导入排序**：Dart SDK → Flutter → 第三方包 → 项目文件
2. **文件命名**：小写下划线格式（login_controller.dart）
3. **类命名**：大驼峰格式（LoginController）
4. **方法命名**：小驼峰格式（submitForm）
5. **常量命名**：大写下划线格式（MAX_LENGTH）

#### 组件设计
1. **单一职责**：每个组件只做一件事
2. **可复用性**：通用组件放入 `widgets/base/`
3. **参数清晰**：使用 `required` 标记必填参数，可选参数提供合理默认值
4. **生命周期**：正确管理 `initState` 和 `dispose`

#### 状态管理
1. **页面局部状态**：使用 Cubit（简单场景）
2. **全局持久状态**：使用 HydratedCubit（需存储）
3. **事件通信**：使用 EventBus（跨页面）
4. **状态不可变**：通过 `copyWith` 创建新状态

#### 代码质量
1. **Linter 检查**：遵循 `analysis_options.yaml` 配置
2. **类型安全**：避免使用 `dynamic`，显式声明类型
3. **空安全**：正确使用 `?` 和 `!`
4. **注释完整**：为公共 API 必须添加文档注释

## Build & Deployment

### 开发环境启动
```bash
# 依赖安装
flutter pub get

# 运行到连接的设备（根据渠道启用不同配置）
rps dev                       # 使用 rps 脚本命令（默认 oppo 渠道）
# 或直接使用 Flutter 命令
flutter run --flavor oppo
flutter run --flavor vivo
flutter run --flavor xiaomi
```

### 代码生成
```bash
# 使用 rps 脚本命令
rps gen_model    # 生成数据模型
rps gen_assets   # 生成静态资源引用
rps gen_page     # 生成静态页面模板

# 或直接使用原始命令
flutter pub run build_runner build --delete-conflicting-outputs  # 生成数据模型
dart ./scripts/gen_assets.dart   # 生成静态资源
dart ./scripts/create_page.dart  # 生成页面模板
```

### 打包构建
```bash
# 使用 rps 脚本命令
rps build_android   # 打包 Android APK
rps build_ios       # 打包 iOS IPA
rps upload_app      # 上传到 OSS

# 这些命令实际执行的是 scripts/ 目录下的 shell 脚本
```

### 清理重置
```bash
rps reset           # 使用 rps 脚本：flutter clean + flutter pub get
flutter clean       # 或直接清理构建缓存
```

### 环境变量
- `HTTP_ENV`: 环境切换（1=开发环境，2=生产环境）
- `BUILD_NUMBER`: 构建编号，CI/CD 自动注入

### Git Hooks
本项目配置了 pre-commit hook：
```bash
# 安装 Git hooks
rps install         # 使用 rps 脚本
# 或直接执行
sh ./scripts/install.sh
```

Hook 会在提交前自动执行：
- 运行 Linter 检查
- 格式化代码
- 禁止提交调试代码

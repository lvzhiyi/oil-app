# Project Context

## Purpose
买油呗（Oil Business App）是一款面向加油站的油气采购管理移动应用，主要功能是帮助加油站向油库采购石油。项目支持 Android 和 iOS 双平台。

## Tech Stack
- **框架**: Flutter 3.4+ (跨平台移动应用开发)
- **语言**: Dart 3.4+
- **状态管理**: BLOC Pattern (bloc ^9.0.0 + flutter_bloc ^9.1.1 + hydrated_bloc ^10.1.1)
- **网络请求**: Dio ^5.2.1 + Retrofit (代码生成)
- **路由管理**: Go Router ^16.0.0
- **国际化**: Easy Localization (支持中文和英文)
- **代码生成**: Freezed ^3.2.3 + JSON Serializable ^6.9.0 + Build Runner ^2.5.4
- **本地存储**: Hive ^2.2.3 + Shared Preferences ^2.5.3
- **依赖注入**: Get It ^8.2.0
- **UI组件库**: TDesign Flutter ^0.1.5
- **包管理器**: pnpm (通过 rps 工具 ^0.8.0)

## Project Conventions

### Code Style
- **代码格式**: 遵循 Flutter/Dart 官方代码风格指南
- **行长度限制**: 120个字符（已在 analysis_options.yaml 中配置）
- **缩进**: 2个空格
- **字符串**: 使用单引号（'string'）
- **命名规则**:
  - 类名: PascalCase (大驼峰)
  - 方法/变量/参数: camelCase (小驼峰)
  - 常量: UPPER_SNAKE_CASE (大写下划线)
  - 文件名/库名: lowercase_with_underscores (小写下划线)
- **构造函数**: 优先使用 const 构造函数
- **字段声明**: 优先使用 final 字段
- **Widget**: 避免在 createState 方法中编写逻辑，children 属性放在最后
- **注释规范**: 使用 /// 进行文档注释，使用 // 进行行内注释

### Architecture Patterns

#### 项目结构
**Feature-first 组织方式**，按功能模块划分：

```
lib/
├── pages/              # 页面模块（Feature-first）
│   └── [feature]/
│       ├── page.dart         # 路由入口（继承 BasePage）
│       ├── controller.dart   # Cubit/Bloc 控制器
│       ├── state.dart        # 状态类（包含 copyWith）
│       ├── view.dart         # 视图组装层
│       ├── model/            # 页面特定数据模型（可选）
│       └── widgets/          # 页面私有组件
│           └── [feature]_screen.dart  # 实际 UI 实现
├── widgets/            # 通用可复用组件
│   ├── base/          # 基础组件（CommonButton、CommonText 等）
│   ├── common/        # 业务通用组件
│   └── popup/         # 弹窗组件
├── global/            # 全局层
│   ├── app_controller.dart   # 全局 HydratedCubit
│   ├── app_state.dart        # 全局状态
│   ├── service/              # 全局 API 服务（Retrofit）
│   ├── model/                # 全局数据模型
│   ├── storage.dart          # 本地存储管理
│   └── events.dart           # 全局事件总线
├── net/               # 网络层
│   ├── net_manager.dart             # Dio 管理器
│   ├── base_interceptor.dart        # 基础拦截器
│   ├── http_header_interceptor.dart # 请求头拦截器
│   ├── http_resp_interceptor.dart   # 响应拦截器
│   ├── http_log_interceptor.dart    # 日志拦截器
│   └── response.dart                # 响应基类
├── router/            # 路由配置
│   ├── router.dart           # GoRouter 配置
│   ├── routes.dart           # 路由枚举和构建器
│   └── pageTransition/       # 页面转场动画
├── config/            # 应用配置
│   ├── config.dart           # 基础配置（环境、设备信息）
│   ├── env.dart              # 环境枚举
│   ├── channel.dart          # 渠道配置
│   └── address.dart          # 地址配置
├── resources/         # 资源管理
│   ├── colors.dart           # 颜色主题（支持亮/暗模式）
│   ├── size.dart             # 尺寸常量
│   ├── style.dart            # 样式定义
│   └── theme.dart            # 主题配置
├── static/            # 静态资源引用（自动生成）
│   ├── img.dart              # 图片资源常量
│   ├── icon.dart             # 图标资源常量
│   └── svg.dart              # SVG 资源常量
├── utils/             # 工具类
│   ├── sizer_utils.dart      # 响应式尺寸工具（AppSizes）
│   ├── log.dart              # 日志工具
│   ├── validators.dart       # 表单验证器
│   └── ...                   # 其他工具
└── models/            # 跨模块共享的数据模型
```

#### 页面架构模式（必须严格遵守）

**标准四层架构**：
1. **page.dart** - 路由配置入口
   - 继承 `BasePage`
   - 混入 `BasicInitPage` 处理初始化
   - 使用 `BlocProvider` 注入 Controller
   - 使用 `BlocBuilder` 响应状态变化

2. **controller.dart** - 业务逻辑控制器
   - 继承 `Cubit<State>` 或 `Bloc<Event, State>`
   - 页面级状态使用 Cubit（简单）
   - 全局状态使用 HydratedCubit（持久化）
   - 包含表单 Key、业务方法、状态更新

3. **state.dart** - 状态定义
   - 不可变状态类
   - 必须包含 `copyWith` 方法
   - 使用命名参数构造函数
   - 可选使用 Freezed 生成

4. **view.dart** - 视图组装层
   - `StatefulWidget` 或 `StatelessWidget`
   - 使用 `BlocListener` 处理副作用（导航、Toast）
   - 调用 widgets/ 下的实际 UI 组件
   - 保持轻量，不包含复杂逻辑

5. **widgets/[feature]_screen.dart** - 实际 UI 实现
   - 实现具体的页面布局
   - 使用通用组件构建 UI
   - 通过 `context.read<Ctrl>()` 调用业务方法

#### 状态管理策略

**1. 页面级状态 - Cubit**
```dart
// 适用于简单的页面状态管理
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
// 适用于需要持久化的全局状态（如用户信息）
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
// 用于跨页面/跨模块通信
globalTabChangeEventBus.fire(index);
globalTabChangeEventBus.on<int>().listen((index) {
  // 处理事件
});
```

#### 网络层架构

**拦截器链**：
1. `HttpHeaderInterceptor` - 添加通用请求头（Token、User-Agent）
2. `BaseInterceptor` - Token 自动刷新、错误重试
3. `HttpLogInterceptor` - 请求/响应日志记录
4. `HttpRespInterceptor` - 统一响应处理、错误处理

**API 服务定义**（Retrofit）：
```dart
@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;
  
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
}
```

### UI Component Standards

#### 设计原则
- 现代化商业应用界面设计
- 支持浅色/深色主题切换
- 响应式布局，支持手机、平板、折叠屏
- Material Design 3 设计语言
- 高内聚、低耦合的组件化设计

#### 通用组件库（`widgets/base/`）

##### **CommonText** - 统一文本组件

**属性规范**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| text | String | 必填 | 文本内容 |
| fontSize | double? | 14 | 字体大小（必须使用 setFontSize） |
| fontWeight | FontWeight | w400 | 字重 |
| textColor | Color? | txtBlack | 文字颜色 |
| textAlign | TextAlign | center | 对齐方式 |
| fontFamily | String | Urbanist | 字体家族 |
| maxLines | int? | null | 最大行数 |
| overflow | TextOverflow? | null | 溢出处理 |
| letterSpacing | double? | null | 字间距 |

**使用规范**：
```dart
CommonText(
  text: '文本内容',
  fontSize: AppSizes.setFontSize(14),
  fontWeight: FontWeight.w600,
  textColor: CustomAppColor.of(context).txtBlack,
)
```

- ✅ 必须使用 `AppSizes.setFontSize()` 设置字号
- ✅ 必须使用 `CustomAppColor.of(context)` 获取颜色
- ✅ 固定行高 1.2
- ✅ 默认字体：Urbanist

##### **CommonButton** - 统一按钮组件

**属性规范**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| btnText | String? | null | 按钮文字 |
| child | Widget? | null | 自定义子组件 |
| onTap | Function()? | null | 点击回调 |
| buttonColor | Color? | btnPurple | 按钮背景色 |
| borderColor | Color? | transparent | 边框颜色 |
| height | double? | 52 | 按钮高度 |
| width | double? | fullWidth | 按钮宽度 |
| radius | double | 8 | 圆角半径 |
| fontSize | double? | 15 | 文字大小 |
| isButtonShadow | bool? | true | 是否显示阴影 |
| isLoading | bool? | false | 是否显示加载 |

**按钮类型**：

*主要按钮（Primary）*：
```dart
CommonButton(
  btnText: '主要操作',
  buttonColor: CustomAppColor.of(context).btnPurple,
  height: AppSizes.buttonHeight,  // 52
  radius: 8,
  isButtonShadow: true,
  isLoading: state.loading,
)
```
- 背景色：紫色 #7165E3
- 文字颜色：白色
- 阴影：紫色 40% 透明
- 高度：52，圆角：8

*次要按钮（Secondary）*：
```dart
CommonButton(
  btnText: '次要操作',
  buttonColor: CustomAppColor.of(context).btnWhite,
  borderColor: CustomAppColor.of(context).borderGrey,
  isButtonShadow: false,
)
```
- 背景色：白色/深色背景
- 边框：1px 灰色
- 无阴影

*小按钮*：
```dart
CommonButton(
  btnText: '小按钮',
  height: AppSizes.setHeight(34),
  width: AppSizes.setWidth(93),
  radius: 3,
)
```
- 高度：34，圆角：3

##### **CommonTextFormField** - 表单输入组件

**属性规范**：
| 属性 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| name | String? | null | 字段名（FormBuilder） |
| hintText | String? | null | 占位文字 |
| labelText | String? | null | 标签文字 |
| controller | TextEditingController? | null | 输入控制器 |
| leadingIcon | Widget? | null | 前置图标 |
| suffixIcon | Widget? | null | 后置图标 |
| borderColor | Color? | borderGrey | 边框颜色 |
| radius | double? | 12 | 圆角半径 |
| isPasswordField | bool | false | 是否密码框 |
| isPhoneNumberField | bool | false | 是否手机号码框 |
| validators | Function? | null | 验证器 |

**输入框状态**：
- 默认状态：灰色边框 1px，圆角 12
- 聚焦状态：紫色边框 2px，标签浮动显示
- 密码框：自动显隐密码图标
- 手机号：国际电话号码输入（IntlPhoneField）

**使用示例**：
```dart
CommonTextFormField(
  name: 'phone',
  hintText: '手机号',
  leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
  borderColor: CustomAppColor.of(context).textFieldBorder,
  validators: FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: '手机号不能为空'),
  ]),
)
```

##### **TopBar** - 顶部导航栏组件

**属性规范**：
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
| textColor | Color | txtBlack | 文字颜色 |
| height | double | 100 | 高度 |

**布局规范**：
- 固定高度：100（包含 SafeArea）
- 水平内边距：18
- 图标尺寸：24x24
- 元素顺序：返回 → 头像 → 标题 → Spacer → 操作图标

##### **CommonContainer** - 容器组件

**属性规范**：
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
  title: '主标题',
  navigationTitle: '查看更多',
  onTap: () {},
)
```

**样式规范**：
- 主标题：字号 18，字重 800
- 导航文字：字号 14，字重 700，紫色
- 水平内边距：20

#### 颜色系统

**品牌色**：
```dart
AppColor.btnPurple = #7165E3      // 主品牌色（按钮、强调元素）
AppColor.txtPurple = #7165E3      // 文本强调色
AppColor.icPurple = #7165E3       // 图标强调色
AppColor.borderPurple = #7165E3   // 强调边框
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

**功能色**：
```dart
AppColor.green = #2AB126          // 成功状态
AppColor.txtRed = #FF4141         // 错误/危险
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

**主题适配（必须使用）**：
```dart
// ✅ 正确：使用 CustomAppColor 动态主题
CustomAppColor.of(context).bgScaffold       // 页面背景
CustomAppColor.of(context).txtBlack         // 黑色文字
CustomAppColor.of(context).txtPurple        // 紫色强调
CustomAppColor.of(context).btnPurple        // 紫色按钮
CustomAppColor.of(context).borderGrey       // 边框
CustomAppColor.of(context).textFieldBorder  // 输入框边框

// ❌ 错误：硬编码颜色
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

#### 字体系统

**字体家族**：
```dart
Constant.fontFamilyUrbanist = 'Urbanist'    // 主字体
```

**字重定义**：
- Light: 300
- Regular: 400
- Medium: 500
- SemiBold: 600
- Bold: 700

**字号规范**：
| 用途 | 字号 | 字重 | 使用场景 |
|-----|------|------|---------|
| 大标题 | 35 | 800 | 页面主标题（如"账户创建成功"） |
| 标题 | 24 | 700 | 页面标题（如"登录到您的账户"） |
| 二级标题 | 18 | 800 | 分类标题、Heading组件 |
| 按钮文字 | 15 | 500 | 主要按钮文字 |
| 正文 | 14 | 400-700 | 普通文本、输入框文本 |
| 副标题 | 12 | 500 | 辅助信息、标签 |
| 小号文字 | 10 | 500 | 提示信息 |

**行高规范**：
- 所有文本统一行高：`height: 1.2`

**响应式字体缩放**：
- 手机：默认缩放 1.0
- 平板：缩放 0.6
- 折叠屏：缩放 0.6
- 用户文字缩放限制：最大 1.2

#### 响应式设计规范（必须严格遵守）

**尺寸适配 - AppSizes**：
```dart
// ✅ 正确：使用 AppSizes 工具类
width: AppSizes.setWidth(80)
height: AppSizes.setHeight(60)
fontSize: AppSizes.setFontSize(14)
padding: EdgeInsets.symmetric(
  horizontal: AppSizes.setWidth(20),
  vertical: AppSizes.setHeight(16),
)

// 常用常量
AppSizes.fullWidth        // 屏幕宽度
AppSizes.fullHeight       // 屏幕高度
AppSizes.buttonHeight     // 标准按钮高度 52
AppSizes.topBarHeight     // 顶部栏高度 60

// ❌ 错误：硬编码尺寸
width: 80
height: 60
fontSize: 14
```

**间距规范**：

*水平间距*：
| 间距值 | 使用场景 |
|-------|---------|
| 8 | 极小间距 |
| 10 | 小间距 |
| 12 | 图标间距 |
| 15 | 标准间距 |
| 18-20 | 页面左右边距 |
| 22 | 大间距 |
| 24 | 特大间距 |

*垂直间距*：
| 间距值 | 使用场景 |
|-------|---------|
| 5 | 极小间距 |
| 10 | 小间距 |
| 12 | 标准小间距 |
| 15 | 标准间距 |
| 16 | 表单项间距 |
| 20 | 大间距、分组间距 |
| 25 | 提示文本上下间距 |
| 32 | 表单提交按钮上边距 |
| 58 | 页面标题间距 |
| 61 | 登录页顶部间距 |
| 88 | 大节间距 |

**圆角规范**：
| 圆角值 | 使用场景 |
|-------|---------|
| 3 | 小按钮圆角 |
| 5 | 商品卡片圆角 |
| 8 | 标准圆角（输入框、按钮、容器） |
| 12 | 标准容器圆角（输入框） |
| 15 | 大圆角 |
| 20 | BottomSheet圆角 |

**颜色主题 - CustomAppColor**：
```dart
// ✅ 正确：使用动态主题（支持亮/暗模式）
backgroundColor: CustomAppColor.of(context).bgScaffold
textColor: CustomAppColor.of(context).txtBlack
borderColor: CustomAppColor.of(context).borderPurple

// 常用颜色
.bgScaffold          // 页面背景（白色/深色）
.txtBlack / .txtWhite // 文字颜色（自动反转）
.txtGrey / .txtPurple // 灰色/紫色文字
.btnPurple           // 按钮紫色（主题色 #7165E3）
.borderGrey / .borderPurple // 边框颜色
.textFieldBorder     // 输入框边框

// ❌ 错误：硬编码颜色
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

**设备类型判断**：
```dart
AppSizes.isTablet(context)         // 平板判断
AppSizes.isFoldablePhone(size)     // 折叠屏判断
```

**静态资源引用**：
```dart
// ✅ 正确：通过静态常量类引用
Image.asset(AssetsImg.LOGO)
Image.asset(AssetsIcon.IC_PROFILE)
SvgAsset(assetName: AssetsSvg.IC_HOME)

// ❌ 错误：硬编码路径
Image.asset('assets/img/logo.webp')
```

#### 页面布局规范

**基本页面结构**：
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

*1. 标准页面布局*：
- TopBar（可选）
- 主内容区域
- 底部导航栏（可选）

*2. 滚动页面布局*：
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

*3. 列表页面布局*：
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

**页面边距规范**：
- 标准页面左右边距：20
- TopBar 左右边距：18
- 列表项左右边距：18-20
- 卡片内边距：15-18

**安全区域处理**：
- 顶部：通常 `top: false`（由 TopBar 处理）
- 底部：通常 `bottom: true`

#### 图标资源规范

**图标格式**：
- 格式：WebP
- 支持暗色主题切换

**图标尺寸规范**：
| 使用场景 | 尺寸 | 说明 |
|---------|------|------|
| TopBar 图标 | 24x24 | 导航栏图标 |
| 按钮图标 | 18-22 | 按钮内图标 |
| 列表图标 | 20x20 | 列表项图标 |
| 输入框图标 | 20x20 | 表单图标 |
| 小图标 | 10-14 | 标签、角标图标 |
| 头像 | 35x35 | 用户头像 |

**图标使用规范**：
```dart
// ✅ 正确：使用静态资源类
Image.asset(
  AssetsIcon.IC_SEARCH,
  width: AppSizes.setWidth(24),
  height: AppSizes.setHeight(24),
  color: CustomAppColor.of(context).icBlack,
  gaplessPlayback: true,  // 推荐使用，避免图片闪烁
)

// ❌ 错误：硬编码路径
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
// 使用 BaseRouter 导航
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

**主题状态管理**：
```dart
// 使用全局状态
Constant.isLightThemeGlobal = true/false
```

**颜色自适应**：
- ✅ 必须使用 `CustomAppColor.of(context)` 获取颜色
- ✅ 自动适配浅色/深色主题

#### 性能优化规范

**图片加载**：
- 使用 `gaplessPlayback: true` 避免图片闪烁
- WebP 格式优化文件大小
- 使用 `CachedNetworkImage` 加载网络图片

**列表优化**：
- 使用 `ListView.builder` 按需构建
- `physics: NeverScrollableScrollPhysics()` 当嵌套在滚动容器中
- `shrinkWrap: true` 当需要自适应高度

**状态管理**：
- 使用 `setState` 管理局部状态
- 使用 Cubit 管理页面级状态
- 使用 HydratedCubit 管理全局持久化状态

**常量优化**：
- 使用 `const` 构造函数
- 避免不必要的 Widget 重建

#### 可访问性

**文字缩放**：
- 最大文字缩放系数限制：1.2
- 使用 `MediaQuery.textScaler` 获取用户设置

**颜色对比度**：
- 主要文本对比度：≥ 4.5:1
- 大号文本对比度：≥ 3:1
- 品牌色紫色 (#7165E3) 在白色背景上对比度：4.79:1

### Form Handling Standards

#### FormBuilder 集成
```dart
FormBuilder(
  key: ctrl.formKey,
  child: Column(
    children: [
      CommonTextFormField(
        name: 'phone',              // 必须：字段名
        hintText: '手机号',
        leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
        validators: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: '手机号不能为空'),
          FormBuilderValidators.numeric(),
        ]),
      ),
    ],
  ),
)
```

#### 表单验证和提交
```dart
// Controller 中的标准模式
bool formPrecheck() {
  if (state.loading) return false;
  return formKey.currentState?.saveAndValidate() ?? false;
}

submit() async {
  if (!formPrecheck()) return;
  
  emit(state.copyWith(loading: true));
  
  final formData = formKey.currentState?.value ?? {};
  final phone = formData['phone'] ?? '';
  // 处理业务逻辑
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
// ✅ 推荐：使用 BaseRouter
BaseRouter.push(url: AppPage.loginPage.path)
BaseRouter.push(url: AppPage.otpPage.path, extra: {'type': 'register'})
BaseRouter.replace(url: AppPage.mainLayoutPage.path)
BaseRouter.pop()

// 或使用 GoRouter
context.go('/login')
context.push('/register')
```

#### 页面转场动画（可选）
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
- 为所有业务逻辑编写单元测试
- 为 Widget 编写组件测试
- 为重要流程编写集成测试
- 使用 mockito 进行模拟

### Git Workflow
- **分支策略**: Git Flow
  - `main/master`: 生产环境分支
  - `develop`: 开发主分支
  - `feature/*`: 功能分支
- **提交规范**: 清晰描述变更内容
- **代码审查**: 合并前必须进行代码审查
- **Pre-commit**: 已配置 pre-commit hook (scripts/pre-commit.sh)

## Domain Context

### 用户角色
项目支持三种用户角色，权限递增：
1. **普通员工**: 基础功能访问，不可充值和导出
2. **管理员**: 员工权限 + 禁用员工权限
3. **老板**: 完整权限，包括员工管理和系统配置

### 核心业务场景
- 用户认证（登录、注册、OTP验证）
- 加油站绑定
- 石油采购订单管理
- 账户管理
- 数据导出（需管理员/老板权限）

### API 数据规范
- **请求格式**: 标准 JSON (Content-Type: application/json;charset=UTF-8)
- **响应格式**: 统一结构 `{ code: number, message: string, data: any }`
  - code=200 表示成功
- **认证机制**: 双 Token 机制
  - `access_token`: 短期令牌，用于 API 访问
  - `refresh_token`: 长期令牌，用于刷新 access_token
  - 自动刷新机制在 access_token 过期时触发
- **Base URL**: 
  - 开发/测试: https://test.maiyoubei.com/api/app
  - 生产: 待配置

## Important Constraints
- **多渠道支持**: 支持 oppo、vivo、xiaomi 等多个渠道打包
- **性能要求**: 
  - 使用 const 构造函数减少重建
  - 长列表使用 ListView.builder
  - 网络图片使用 CachedNetworkImage
  - 避免不必要的 Widget 重建
- **字符编码**: 统一使用 UTF-8
- **环境切换**: 支持开发(qa)和生产(pro)环境切换
- **设备兼容**: 支持手机和平板（根据屏幕宽度判断）
- **离线支持**: 部分数据需要本地缓存

## External Dependencies
- **API 服务**: 后端 REST API (测试环境: test.maiyoubei.com)
- **认证服务**: 
  - POST /auths/login - 用户登录
  - POST /auths/refresh - Token 刷新
  - POST /auths/logout - 退出登录
- **设备信息**: Device Info Plus (获取设备标识)
- **OSS**: 阿里云 OSS (用于 APK 上传，参见 scripts/upload_oss.sh)
- **包信息**: Package Info Plus (获取应用版本信息)

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

#### 静态资源生成
```bash
# 生成 static/ 目录下的资源常量类
pnpm gen_assets

# 或直接运行
dart ./scripts/gen_assets.dart
```

自动生成 `AssetsImg`、`AssetsIcon`、`AssetsSvg` 等静态类。

#### 页面模板生成
```bash
# 使用脚手架生成完整页面结构
pnpm gen_page

# 或直接运行
dart ./scripts/create_page.dart
```

生成标准的 page、controller、state、view 四件套。

### Logging Standards

#### 日志工具（`utils/log.dart`）
```dart
import 'package:oil_business_app/utils/log.dart';

// 调试日志
l.d('Login', '开始登录: 手机号=$phone');

// 信息日志
l.i('Init', '######################## 页面初始化 ########################');

// 错误日志
l.e('Register', '注册失败: $e');

// 警告日志
l.w('Network', '网络请求超时');
```

**日志规范**：
- 第一个参数：模块/功能标识
- 第二个参数：具体日志内容
- 避免在生产环境打印敏感信息
- 关键业务流程必须记录日志

### Error Handling

#### 网络错误处理
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
  l.e('Login', '登录失败: $e');
  emit(state.copyWith(loading: false));
}
```

#### 统一错误处理（拦截器层）
网络错误通过 `HttpRespInterceptor` 统一处理：
- 401: Token 失效，自动刷新或跳转登录
- 403: 权限不足
- 500: 服务器错误
- 网络超时/无网络

### Performance Optimization

#### 必须遵守的优化原则
1. **使用 const 构造函数**
   ```dart
   // ✅ 正确
   const Text('Hello')
   const SizedBox(height: 10)
   
   // ❌ 错误
   Text('Hello')
   SizedBox(height: 10)
   ```

2. **长列表使用 Builder**
   ```dart
   // ✅ 正确
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   
   // ❌ 错误：一次性创建所有 Widget
   ListView(children: items.map((e) => ItemWidget(e)).toList())
   ```

3. **网络图片使用缓存**
   ```dart
   // ✅ 正确
   CachedNetworkImage(
     imageUrl: imageUrl,
     placeholder: (context, url) => CircularProgressIndicator(),
   )
   
   // ❌ 错误：每次重新下载
   Image.network(imageUrl)
   ```

4. **避免不必要的重建**
   - 使用 `const` 构造函数
   - 合理使用 `BlocBuilder` 的 `buildWhen`
   - 使用 `RepaintBoundary` 隔离复杂组件

#### 设备适配
- 支持手机和平板（屏幕宽度 > 600 为平板）
- 支持折叠屏设备检测
- 字体大小限制最大缩放 1.2 倍
- 横竖屏切换自动重新计算尺寸

### Best Practices

#### 代码组织
1. **导入顺序**：Dart SDK → Flutter → 第三方包 → 项目内部
2. **文件命名**：小写下划线分隔（`login_controller.dart`）
3. **类命名**：大驼峰（`LoginController`）
4. **方法/变量命名**：小驼峰（`submitForm`）
5. **常量命名**：大写下划线（`MAX_LENGTH`）

#### 组件设计
1. **单一职责**：每个组件只做一件事
2. **可复用性**：通用组件放 `widgets/base/`
3. **参数设计**：必需参数用 `required`，可选参数提供默认值
4. **生命周期**：正确处理 `initState`、`dispose`

#### 状态管理
1. **页面状态**：使用 Cubit，保持简单
2. **全局状态**：使用 HydratedCubit，自动持久化
3. **事件通信**：使用 EventBus，解耦模块
4. **状态不可变**：始终使用 `copyWith` 更新状态

#### 代码质量
1. **Linter 规则**：严格遵守 `analysis_options.yaml` 配置
2. **类型安全**：避免使用 `dynamic`，明确类型
3. **空安全**：正确使用 `?` 和 `!`
4. **注释文档**：公共 API 必须有文档注释

## Build & Deployment

### 开发环境
```bash
# 安装依赖
flutter pub get

# 启动开发服务（多渠道支持）
pnpm dev                      # 默认 oppo 渠道
flutter run --flavor oppo
flutter run --flavor vivo
flutter run --flavor xiaomi
```

### 代码生成
```bash
pnpm gen_model    # 生成数据模型
pnpm gen_assets   # 生成静态资源常量
pnpm gen_page     # 生成页面模板
```

### 构建打包
```bash
# Android APK
pnpm build_android

# iOS IPA
pnpm build_ios

# 上传到 OSS
pnpm upload_app
```

### 清理和重置
```bash
pnpm reset        # flutter clean + pub get
flutter clean     # 清理构建缓存
```

### 环境变量
- `HTTP_ENV`: 环境切换（1=开发，2=生产）
- `BUILD_NUMBER`: 构建号（CI/CD 注入）

### Git Hooks
项目配置了 pre-commit hook：
```bash
# 安装 hook
pnpm install
# 或
sh ./scripts/install.sh
```

Hook 会在提交前自动：
- 运行 Linter 检查
- 格式化代码
- 执行快速测试

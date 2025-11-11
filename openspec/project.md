# Project Context

## Purpose
买油呗（Oil Business App）是一款面向加油站的石油采购管理移动应用，主要功能是帮助加油站向油库采购石油。项目支持 Android 和 iOS 双平台。

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

#### 通用组件库（`widgets/base/`）

**必须使用的基础组件**：
- **CommonButton** - 统一按钮组件
  - 支持加载状态（`isLoading`）
  - 支持自定义颜色、边框、阴影
  - 默认紫色主题，圆角 8px
  
- **CommonText** - 统一文本组件
  - 默认字体：Urbanist
  - 支持自动缩放（`isAutoSize`）
  - 行高固定 1.2
  
- **CommonTextFormField** - 表单输入组件
  - 集成 FormBuilder
  - 支持密码字段（自动显隐）
  - 支持国际电话号码
  - 聚焦时显示浮动标签
  - 验证失败自动显示错误

- **CommonContainer** - 容器组件
- **TopBar** - 顶部栏组件（动态配置）

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

**标准页面结构**：
```dart
SafeArea(
  bottom: true,
  top: false,  // 顶部不留白（TopBar 处理）
  child: Scaffold(
    backgroundColor: CustomAppColor.of(context).bgScaffold,
    body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(20)
      ),
      child: SingleChildScrollView(  // 防止键盘遮挡
        child: Column(
          children: [
            // 页面内容
          ],
        ),
      ),
    ),
  ),
)
```

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

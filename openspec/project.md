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
- **项目结构**: Feature-first 组织方式
- **页面结构**: 每个功能模块包含 controller、model、page、state、view 和 widgets
  ```
  pages/
    [feature]/
      controller.dart  # BLOC controller
      state.dart       # BLOC state
      page.dart        # 页面路由配置
      view.dart        # 页面主视图
      model/           # 页面特定数据模型
      widgets/         # 页面特定组件
  ```
- **全局模块**: 
  - `global/`: 全局状态、服务、存储
  - `widgets/`: 通用可复用组件
  - `utils/`: 工具类
  - `net/`: 网络层封装
  - `router/`: 路由配置
  - `config/`: 应用配置
  - `resources/`: 主题、颜色、尺寸等资源
- **状态管理模式**: 
  - 简单状态使用 Cubit
  - 复杂状态使用 Bloc
  - 持久化状态使用 HydratedBloc
- **网络层**: Dio + Retrofit + Interceptors (统一请求/响应处理、Token 管理、日志)

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

## Build & Deployment
- **开发运行**: `pnpm dev` 或 `flutter run --flavor oppo`
- **Android 打包**: `pnpm build_android` (见 scripts/build_android.sh)
- **iOS 打包**: `pnpm build_ios` (见 scripts/build_ios.sh)
- **上传 OSS**: `pnpm upload_app` (见 scripts/upload_oss.sh)
- **代码生成**: 
  - Model: `pnpm gen_model` (build_runner)
  - Assets: `pnpm gen_assets`
  - Page: `pnpm gen_page`
- **清理重置**: `pnpm reset` (flutter clean + pub get)

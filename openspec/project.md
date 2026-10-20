# Project Context

## Purpose

Oil Business App 为加油站管理人员提供油品采购、提货、订单及站点管理，面向 Android / iOS。

## 技术基础

- Flutter / Dart；Dart SDK 声明、依赖版本以 [pubspec.yaml](../pubspec.yaml) 为准，锁定解析见 pubspec.lock。当前未单独声明固定 Flutter SDK 版本。
- 状态管理：Bloc / Cubit，部分全局状态使用 HydratedBloc。
- 网络：Dio + Retrofit；模型使用 JSON Serializable / Freezed 和手写实现。
- 导航：GoRouter，项目封装 AppPage 与 BaseRouter。
- 存储：Hive、SharedPreferences；GetIt 仅在部分依赖中使用。
- UI：现有公共组件、TDesign Flutter、ScreenUtil；当前品牌为琥珀色。

## 工程规范索引

工程细节集中维护，避免重复：

- [AI 开发工作流（Codex + OpenSpec + Superpowers + Context7）](../docs/development/ai-workflow.md)
- [代码基础规范](../docs/development/coding.md)
- [架构与模块规范](../docs/development/architecture.md)
- [UI 开发规范](../docs/development/ui.md)
- [接口联调与测试数据约定](../docs/development/api-integration.md)
- [验证与交付规范](../docs/development/testing.md)

AI 入口见 [根目录 AGENTS.md](../AGENTS.md)；脚本命令以 pubspec.yaml、scripts/ 及 .vscode/launch.json 为准。

## 业务规格与变更

- specs/ 保存业务需求与验收场景，changes/ 保存待实施变更，changes/archive/ 保存历史记录。
- 新功能、破坏性和架构变化按 [OpenSpec 指南](AGENTS.md) 先提案、校验、批准，再实施；归档按该指南执行。
- 业务枚举、金额计算、库存变化、权限和状态流转必须有明确需求依据，AI 不自行补造规则。
- 业务规则变化更新对应规格；实现与规格不一致时报告差异，不能只改文档掩盖问题。
- 本文只描述背景并索引规范，不重复维护组件参数和业务规则。

## Domain Context

- 主要模块：用户认证、加油站管理、油品订单管理、支付订单、提货订单与提货证件。
- 核心实体：用户和登录状态、加油站、油品订单、支付订单、车牌与司机信息。
- 请求和响应契约以具体 Retrofit Service、DTO 和 lib/net/ 拦截器为准；公共响应模型包含 code、message、data、requestId。
- API 地址以 lib/config/address.dart 的实际配置为准，不在本文复制环境地址。

## Important Constraints

- 保持 oppo、vivo、xiaomi 等既有渠道配置兼容，渠道构建以当前脚本和原生配置为准。
- 文本使用 UTF-8；移动端布局考虑手机、平板以及键盘等可用空间变化，设备支持必须以实际验证为依据。
- 长列表沿用项目已有按需构建和图片缓存方式；性能调整须有具体问题依据。
- 敏感信息不写入代码、日志或文档；涉及存储时明确其保护方式。

## 背景参考

[规范基线说明](../docs/development/audit.md)介绍首次建立规范的范围，按需查阅。

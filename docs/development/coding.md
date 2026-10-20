# 代码基础规范

适用于新增和修改的 Dart/Flutter 代码，不批量整改无关代码。

## 格式与命名

- 使用 Dart formatter；只格式化本次修改的文件，避免无关差异。
- 缩进、换行及行宽以项目 formatter 的实际配置和输出为准。
- 类型使用 PascalCase，成员及参数使用 lowerCamelCase，文件使用 snake_case。
- 新常量优先 lowerCamelCase，修改已有常量保持兼容，不批量重命名。
- 字符串优先单引号，按需使用 final、const；公共 Widget 接收 key。
- 以根目录 analysis_options.yaml 为实际分析规则，不为消除报错而添加全局 ignore 或降低检查级别。

## 类型、状态与异步

- 新增公共方法明确参数、返回值和可空语义；异步操作使用 Future<T>，避免无意丢弃 Future。
- 仅在确认类型及来源时使用强制转换、空断言；接口缺失、空列表和失败响应显式处理。
- 状态通过 copyWith 和 emit 更新，不直接修改共享 List/Map。现有 State 同时存在手写与生成实现，无须强制迁移到 Freezed。
- 可空字段的 copyWith 必须区分“保持旧值”和“清空”，可参考 lib/pages/login/state.dart 的哨兵设计；不要用 ?? 实现需要清空的字段。
- 请求结果返回后检查对象生命周期；使用 BuildContext 跨 await 时检查 mounted。Timer、订阅、文本及刷新控制器由拥有者释放。
- 防止重复提交、并发刷新覆盖、失败后 loading 未恢复；按真实需求确定重试和取消策略。

## 生成代码与资源

- 接口和模型修改源定义后运行 dart run build_runner build --delete-conflicting-outputs，不直接编辑 *.g.dart、*.freezed.dart 等生成产物。
- 资源常量由 dart scripts/gen_assets.dart 生成；先检查脚本实际扫描范围，再运行并审查 diff。
- 保持生成文件现有的 Git 跟踪策略，生成后审查差异，不统一忽略或删除。
- 新增页面可参考 scripts/pageTemplate/。生成器会写文件，运行 dart scripts/create_page.dart <page_name> 前确认目标不存在；多词名称生成结果需人工检查。

## 日志、依赖与配置

- 使用 lib/utils/log.dart 的现有日志入口；不输出 token、密码、验证码或完整敏感请求体。
- 依赖由 pubspec.yaml 管理，安装结果检查 pubspec.lock；本次功能不顺带升级无关依赖。
- 配置沿用 lib/config/ 和已有启动参数；不硬编码凭据，不凭记忆猜测环境值。
- 注释解释边界和原因，公共接口按需写 ///；不复制实现生成冗余说明。

## 第三方 API 使用

涉及第三方库的 API、配置、生成器或兼容性时，按 [Context7 文档查询流程](ai-workflow.md#context7-文档查询)核对项目实际版本后实现。示例必须适配本项目架构，并执行相关检查；不依据最新版示例擅自升级依赖。

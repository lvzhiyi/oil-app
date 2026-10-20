# 验证与交付规范

## 当前验证基础

- 存在 analysis_options.yaml、flutter_test，以及登录、忘记密码、主题和校验器测试。
- 存在 scripts/pre-commit.sh 与 install.sh，但脚本存在不等于每个开发环境已安装 Hook。
- GitHub Actions 配置见 `.github/workflows/check.yml`，复用统一检查入口；需推送后才能确认远端执行结果，合并拦截需仓库分支保护单独配置。
- 当前没有 integration_test 入口，CI 通过不代表端到端业务流程通过。
- 部分测试只测试文件内的模拟函数，未调用真实 Widget/Controller；测试通过不等于真实登录链路通过。

## 统一检查入口

前提：Python 3、Git；完整检查还需 Flutter/Dart 和已安装依赖（先单独运行 flutter pub get）。

```bash
python3 scripts/check.py docs  # 规范文档本地链接/标题锚点 + Git diff 空白检查
python3 scripts/check.py full  # 上述检查 + 手写 Dart 格式 + 静态分析 + 全量测试
```

入口不自动修复、stash、暂存、安装依赖或修改源文件；Flutter 工具会写入 SDK/构建缓存。任何检查失败均返回非零，完整检查继续收集分析与测试结果，不隐藏基线失败。

格式检查覆盖 lib/、test/、scripts/ 中 Git 跟踪及未忽略的新 Dart 文件，排除常见生成文件。文档检查覆盖 AGENTS.md、openspec/project.md 和 docs/development/*.md 的行内本地链接及标题锚点，不校验所有历史规格或远程网址；OpenSpec 格式仍由其 CLI 校验。

CI 使用当前本机确认的 Flutter 3.47.5 和 Python 3.12，拉取依赖后运行同一完整入口；新增配置尚不等于远端已通过。现有格式/分析/测试失败会让 CI 报红，需单独整改，不能关闭检查使其变绿。

## 当前检查基线

2026-10-20 在本地 Flutter 3.47.5 / Dart 3.13.4 上运行完整入口：

- 文档链接和 Git diff 检查通过。
- 检查 342 个 Dart 文件，22 个文件存在格式差异；`--output=none` 未写回源文件。
- 静态分析报告 90 项问题，退出码为 1。
- 测试执行 197 项，全部通过；这不扩大已有测试的覆盖范围。
- 完整入口按预期返回失败，CI 也不会自动忽略上述问题。本次仅补齐流程和检查配置，没有批量修改业务代码；后续任务以运行时结果重新建立基线。

## 按修改范围验证

| 修改 | 最低验证要求 |
| --- | --- |
| Markdown | diff 检查、相对链接和代码路径核对 |
| Dart 逻辑 | 修改文件格式检查、静态分析、直接调用真实实现的相关测试 |
| Widget/交互 | 相关测试，加运行设备上的交互确认 |
| Retrofit/模型 | 重新生成并审查产物，执行相关解析和请求契约测试 |
| 启动/路由/公共组件 | 验证启动及受影响的代表性页面 |
| OpenSpec 变更 | 按 openspec/AGENTS.md 执行相应严格校验 |

```bash
# 安装依赖（需要时运行，检查锁文件变更）
flutter pub get
# 只检查本次修改的 Dart 文件，替换为实际路径
dart format --output=none --set-exit-if-changed <changed_files>
flutter analyze
flutter test test/resources/colors_test.dart
# 完整测试适用于更广范围变更或交付检查
flutter test
# 与现有 oppo Debug 配置一致；连接设备后运行
flutter run --flavor oppo --dart-define=ANDROID_CHANNEL=oppo
```

环境参数见 .vscode/launch.json、lib/config/config.dart 和 env.dart；当前枚举是 pro(1)、qa(3)，HTTP_ENV 涉及名称读取与映射逻辑，运行前核对完整配置链并确认目标环境。

## 测试质量

- 优先覆盖真实实现、边界和失败路径；不要在测试中复制生产算法再测试副本。
- 时间、网络及平台依赖需隔离；当前没有已确认的统一 Mock 框架，不假定存在 Mockito 或 bloc_test。
- 不因测试失败删除断言、跳过用例或降低规则；区分历史失败、环境问题和本次回归。
- 运行会话存在时，Dart/Flutter 修改后热重载或重启，并确认结果；无设备时说明交互验证未执行。

## Hook 和 CI 边界

现有 pre-commit 会 stash、执行全仓格式化并 git add .；AI 不应为“验证”直接运行该脚本或安装 Hook，以免改变用户暂存区。单独运行必要的检查命令。CI 与 Hook 调整作为独立任务实施。

## 交付记录

Bug 修复与功能迭代的技能使用顺序见 [AI 开发工作流](ai-workflow.md)。Superpowers 的完成前验证不能替代本文要求的实际检查。

说明修改范围、实际执行命令及结果、未验证项与原因。既有问题单独报告；未执行不能写“通过”，新建规范也不能写成“自动门禁已落实”。

## 失败与完成状态

开工记录必要检查基线；失败分类、受阻交接和状态定义见 [AI 工作流](ai-workflow.md#验证失败和受阻交接)。未解决失败不得描述为“检查通过”或“可合并”。

### 检查输出与归因

- `PASS`：该命令成功，不扩大到命令未覆盖的场景。
- `CHECK_FAILED`：命令返回非零，原因尚未归类；需对照基线，区分回归、既有问题与运行环境问题。
- `BLOCKED`：已确认工具缺失、启动失败或无法枚举源文件，检查未正常执行。
- 任意失败或受阻使整个入口返回非零；结果不是自动豁免依据。失败证据、处理及恢复按 AI 工作流记录。

检查脚本自身的错误分支可运行 `python3 -m unittest discover -s scripts -p 'test_check.py'` 验证，不需要 Flutter 或网络。

### 中断后的验证

续做时按 [中断与恢复交接](ai-workflow.md#中断与恢复交接)比对工作区和快照，核实未完成命令的实际结果，再重跑最小相关检查。交接中的通过记录必须能对应代码状态，不能直接替代当前验证。

## 接口与数据验收

涉及后端的功能按 [接口联调与测试数据约定](api-integration.md)记录环境、契约、账号角色、场景和清理情况；分别报告 Mock 与真实联调结果。接口尚未就绪时标记“实施完成，待联调”，不以模拟测试代替真实接口验证。

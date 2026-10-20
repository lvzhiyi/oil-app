<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Codex 项目指南

## 按任务读取

- Bug 修复、功能迭代及 Superpowers 配合方式：[AI 开发工作流](docs/development/ai-workflow.md)。
- 暂停、换会话或续做任务时读取：[中断与恢复交接](docs/development/ai-workflow.md#中断与恢复交接)，查找对应 change 的 handoff.md 或 docs/development/handoffs/ 下对应任务记录。
- 项目背景和技术栈：[openspec/project.md](openspec/project.md)。
- 每次修改代码前读取：[代码规范](docs/development/coding.md)、[架构规范](docs/development/architecture.md)。
- 涉及第三方库、框架 API、生成器或配置时，按 [Context7 使用规则](docs/development/ai-workflow.md#context7-文档查询)主动查询匹配项目版本的文档，无须用户重复提醒。
- 涉及接口、DTO、鉴权或后端联调时读取：[接口联调与测试数据约定](docs/development/api-integration.md)。
- UI 任务再读取：[UI 规范](docs/development/ui.md)。
- 执行检查及交付前读取：[验证规范](docs/development/testing.md)。
- 涉及业务时读取 openspec/specs/ 对应规格和 openspec/changes/ 相关提案。

## 执行边界

- 先检查 Git 状态和相关实现，不覆盖用户未提交或未跟踪内容。
- 新能力、破坏性和架构变更按 openspec/AGENTS.md 先提案后实施；文档整理及配置清理可直接处理。
- 小步修改，不顺带重构无关模块，不手改生成产物，不自动提交、推送或发布。
- 规范与实现冲突时报告具体依据；现有代码是现状证据，不代表可以绕过已批准的业务规格。
- 以本文件列出的规范为入口，不以会话记忆或其他工具配置替代项目规范。
- 开工前检查范围、工作区、环境和验证基线；失败按 AI 工作流分类处理并保留证据。
- 明确区分待验证、可评审、可合并、已上线和受阻；仅报告实际执行的验证结果。

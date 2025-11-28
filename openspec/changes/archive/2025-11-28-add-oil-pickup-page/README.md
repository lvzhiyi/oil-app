# 提油页面功能开发提案

## 提案状态
✅ **已创建并通过验证** (已更新车辆信息智能识别功能)

- 提案 ID: `add-oil-pickup-page`
- 创建时间: 2025-11-11
- 最后更新: 2025-11-11 (添加车辆信息智能识别)
- 总任务数: 58 个
- 完成任务: 0/58
- 影响的规范: `oil-pickup` (新增), `main-navigation` (修改)
- Delta 数量: 12 个需求变更

## 快速链接
- [提案说明](./proposal.md) - 为什么需要这个变更
- [任务清单](./tasks.md) - 58 个实现任务
- [设计文档](./design.md) - 技术实现细节 (含智能识别算法)
- [解析器示例](./PARSER_EXAMPLE.md) - 车辆信息智能识别使用示例 ⭐
- [需求规范 - Oil Pickup](./specs/oil-pickup/spec.md) - 提油功能需求 (新增)
- [需求规范 - Main Navigation](./specs/main-navigation/spec.md) - 导航修改 (修改)

## 功能概述

### 核心功能
1. **提油页面** - 主导航第二个 Tab
   - 油量输入区域
   - 加油站选择/切换按钮
   - 粘贴车辆信息展示区域 + **智能识别算法** ⭐
   - 生成提油凭证按钮

2. **加油站列表页面**
   - 显示所有可用加油站
   - 支持选择加油站
   - 支持修改加油站信息
   - 预留新增加油站入口

3. **加油站编辑页面**
   - 修改加油站名称
   - 修改加油站地址
   - 表单验证
   - 保存/取消操作

### 技术特点
- ✅ 使用 Mock 数据进行开发
- ✅ 遵循四层架构 (page/controller/state/view)
- ✅ 使用 Cubit 进行状态管理
- ✅ **车辆信息智能识别算法** (关键词匹配, 灵活顺序, 多分隔符) ⭐
- ✅ 响应式布局和主题适配
- ✅ 为后续 API 集成预留扩展点

## 开始实现

### 前置检查
在开始实现前,请确认:
- [ ] 已阅读 [proposal.md](./proposal.md) 了解变更背景
- [ ] 已阅读 [design.md](./design.md) 了解技术决策
- [ ] 已阅读 [tasks.md](./tasks.md) 了解任务清单
- [ ] 已查看 [specs/](./specs/) 目录了解需求细节

### 实现步骤
按照 [tasks.md](./tasks.md) 中的顺序实施:

1. **阶段 1: 数据模型和 Mock 数据** (任务 1.1 - 1.5)
2. **阶段 2: 车辆信息智能识别算法** (任务 2.1 - 2.11) ⭐
3. **阶段 3: 加油站选择列表页面** (任务 3.1 - 3.9)
4. **阶段 4: 加油站信息修改页面** (任务 4.1 - 4.7)
5. **阶段 5: 提油主页面** (任务 5.1 - 5.12)
6. **阶段 6: 路由配置** (任务 6.1 - 6.4)
7. **阶段 7: 主导航集成** (任务 7.1 - 7.3)
8. **阶段 8: 测试和优化** (任务 8.1 - 8.11)

### 验证提案

```bash
# 验证提案格式
openspec validate add-oil-pickup-page --strict

# 查看提案摘要
openspec show add-oil-pickup-page

# 查看需求变更详情
openspec show add-oil-pickup-page --json --deltas-only
```

## 需求摘要

### 新增需求 (oil-pickup)
1. ✅ 提油页面导航入口 (1 个场景)
2. ✅ 加油站选择功能 (3 个场景)
3. ✅ 加油站列表展示 (2 个场景)
4. ✅ 加油站信息修改 (3 个场景)
5. ✅ 新增加油站入口 (2 个场景)
6. ✅ 提油油量输入 (2 个场景)
7. ✅ 粘贴车辆信息展示 (2 个场景)
8. ✅ **车辆信息智能识别** (5 个场景) ⭐ 
9. ✅ 生成提油凭证 (2 个场景)
10. ✅ Mock 数据支持 (3 个场景)
11. ✅ 响应式布局适配 (3 个场景)

### 修改需求 (main-navigation)
1. ✅ Tab 导航结构 (4 个场景)
   - 添加提油页面为第二个 Tab
   - 支持 Tab 切换
   - Tab 状态持久化
   - 图标和文字显示

## 文件结构

```
openspec/changes/add-oil-pickup-page/
├── README.md                      # 本文件
├── proposal.md                    # 提案说明
├── tasks.md                       # 46 个任务清单
├── design.md                      # 设计文档
└── specs/
    ├── oil-pickup/
    │   └── spec.md               # 提油功能需求 (10个需求, 23个场景)
    └── main-navigation/
        └── spec.md               # 导航修改 (1个需求, 4个场景)
```

## 实现后的代码结构

```
lib/
├── pages/
│   ├── oil_pickup/               # 提油页面
│   │   ├── page.dart
│   │   ├── controller.dart
│   │   ├── state.dart
│   │   ├── view.dart
│   │   └── widgets/
│   │       └── oil_pickup_screen.dart
│   ├── station_list/             # 加油站列表
│   │   ├── page.dart
│   │   ├── controller.dart
│   │   ├── state.dart
│   │   ├── view.dart
│   │   └── widgets/
│   │       ├── station_list_screen.dart
│   │       └── station_item.dart
│   └── station_edit/             # 加油站编辑
│       ├── page.dart
│       ├── controller.dart
│       ├── state.dart
│       ├── view.dart
│       └── widgets/
│           └── station_edit_form.dart
├── models/
│   ├── station_model.dart        # 加油站数据模型
│   └── vehicle_model.dart        # 车辆数据模型
└── router/
    └── routes.dart               # 新增路由定义
```

## 关键决策

### 1. Mock 数据策略
- 在 Controller 中直接管理 Mock 数据
- 不创建独立的 Mock 服务层
- 便于后续替换为真实 API

### 2. 状态管理
- 页面级状态: 使用 Cubit
- 选中的加油站: 保存到全局 AppController
- 利用 HydratedCubit 实现自动持久化

### 3. 页面导航
- 使用 BaseRouter 进行导航
- 参数通过 extra 传递
- 支持返回结果 (pop with result)

### 4. UI 组件
- 复用项目现有通用组件
- 创建页面特定的自定义组件
- 严格使用 AppSizes 和 CustomAppColor

## 开放问题

在 [design.md](./design.md#open-questions) 中记录了 4 个开放问题:
1. 提油凭证生成逻辑
2. 车辆信息粘贴格式
3. 加油站数据来源
4. 新增加油站审核流程

这些问题需要产品和后端团队确认后再完善实现。

## 后续步骤

### 当前阶段
✅ 提案已创建并通过验证
⏭️ 等待审批后开始实现

### API 集成阶段 (后续)
- 替换 Mock 数据为 API 调用
- 添加网络请求错误处理
- 实现数据缓存策略

### 完整功能阶段 (后续)
- 实现新增加油站功能
- 实现提油凭证生成
- 集成车辆信息管理

## 相关命令

```bash
# 查看所有变更
openspec list

# 查看所有规范
openspec list --specs

# 查看特定规范
openspec show oil-pickup --type spec
openspec show main-navigation --type spec

# 验证所有变更
openspec validate --strict
```

---

**注意**: 请在开始实现前获得提案审批。实现完成后,请更新 tasks.md 中的任务状态。


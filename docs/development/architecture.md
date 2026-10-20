# 架构与模块规范

## 现有结构及职责

| 位置 | 职责 |
| --- | --- |
| lib/main.dart、lib/sports_run.dart | 启动、存储、配置、网络和 Flutter 运行初始化 |
| lib/pages/<feature>/ | 按功能组织页面，局部模型和 Service 可放模块内 |
| page.dart | BasePage/BaseState、BasicInitPage、BlocProvider 等页面入口 |
| controller.dart | Cubit/Bloc，编排业务请求与交互 |
| state.dart | 页面状态和 copyWith |
| view.dart、widgets/ | 组装状态、回调和可复用布局 |
| lib/global/ | AppController、全局存储、跨模块模型与 Service |
| lib/net/ | Dio 初始化、公共 Header、响应和日志拦截器 |
| lib/router/ | GoRouter、AppPage、BaseRouter 封装 |
| lib/widgets/ | 基础、业务公共组件和弹层 |
| lib/utils/、lib/resources/、lib/static/ | 工具、主题尺寸、资源引用 |

参考完整入口链路：lib/pages/station_list/page.dart → view.dart → widgets/station_list_screen.dart；业务逻辑在 controller.dart。

## 修改边界

- 新增标准业务页面沿用邻近模块结构，不引入第二套路由或状态管理体系。
- 视图负责渲染和交互转发；请求、解析、状态转换放 Controller 或 Service。不要在 build 中发请求。
- 跨模块复用先查 global/service、global/model、widgets 和 utils；不要为单一需求建立过度抽象。
- 项目有直接访问 appController、Service getter 和局部 GetIt 注册的混合模式；它不是完整的依赖注入架构。沿用模块边界，需重构时先明确影响。
- Widget 局部展示状态可由组件自己管理；共享业务状态使用现有 Cubit/Bloc，持久化状态沿用 HydratedCubit 或已有存储。
- 定时器、订阅及控制器的创建和释放成对；路由退出后不得继续更新已关闭状态。

## 网络和模型

接口契约、Mock、真实联调和数据准备按 [接口联调与测试数据约定](api-integration.md)执行。

- 新增接口优先 Retrofit，使用已初始化的 netManager.clientDio；不在页面创建独立 Dio 绕过公共配置。
- 跨模块接口放 global/service；页面专属接口可放 pages/<feature>/service，现有例子是 pay_order_detail/service/pay_order_service.dart。
- DTO 位于关联 model 目录；保持后端字段、序列化及可空契约一致，不猜测业务默认值。
- 当前拦截器注册顺序以 net/net_manager.dart 为准：日志、Header、响应。新增鉴权能力需核对实际接口契约。
- 新增 Service 使用前确认网络已初始化，可参考 pay_order_detail/service/pay_order_service.dart 的检查方式。
- 异常按公共响应处理与页面交互需要分层处理，避免重复 Toast 或吞掉失败。

## 路由与业务规格

- 路由变更检查 lib/router/routes.dart 和 router.dart，沿用 AppPage、BaseRouter 及现有 extra 传参方式。
- 业务规则以 openspec/specs/ 中相关规格为依据，结合已批准变更；遇到代码与规格冲突先报告，不能静默改写规格。
- 新能力、破坏性或架构变化先读取 openspec/AGENTS.md，按其流程提出变更。普通文档整理不需要额外功能提案。

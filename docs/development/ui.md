# UI 开发规范

## 当前主题及依据

- 当前品牌为琥珀色，依据 lib/resources/colors.dart 和 test/resources/colors_test.dart：primaryColor 为 #D97706，accentColor 为 #F59E0B，secondaryColor 为 #FFFBEB。
- btnPurple 等兼容别名的实际值以 colors.dart 为准，不按属性名称推断颜色。
- 本文是 UI 工程规范入口；UI_SPECIFICATION.md 仅作补充参考，组件参数与颜色以当前实现为准，业务行为以 OpenSpec 为准。

## 组件与资源

- 优先复用 lib/widgets/base/ 中的 CommonText、CommonButton、CommonTextFormField 以及已有业务组件。
- 先读组件构造函数和附近调用点，再使用参数；文档默认值不保证与代码同步。
- 页面主题颜色优先 CustomAppColor.of(context)，需要固定语义色时使用既有 AppColor 定义，不复制十六进制品牌色到业务页面。
- 沿用 AppSizes.setWidth/setHeight/setFontSize 和已有尺寸常量；Expanded、Flexible、LayoutBuilder 用于自适应。不是所有数字都需要缩放，例如 flex、索引和透明度。
- 资源优先使用 lib/static/ 中对应生成常量，沿用现有字体配置，不另建字体或资源命名体系。

## 页面状态及验收

- 根据页面能力覆盖初始加载、正常内容、空数据、请求失败及重试。
- 分页区分首次加载、刷新、加载更多、无更多数据和加载更多失败；不能因分页失败清空已有数据。
- 提交操作明确 loading、禁用及重复点击处理；表单错误要让用户知道如何修正。
- 尺寸修改检查小屏、长文本、键盘弹出和主题切换；不得只凭代码声称平板、折叠屏已通过验收。
- 检查文字缩放、可点击范围和语义标签，按本次交互影响选择验证范围。
- 文案沿用当前项目方式；引入国际化框架或多语言能力需先确认需求和方案。

## 修改公共组件

公共组件变更先搜索调用范围，保持现有 API 兼容；确需改变行为时说明受影响页面，并验证代表性调用。

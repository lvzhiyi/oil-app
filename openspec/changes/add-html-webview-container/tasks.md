## 1. 准备工作
- [x] 1.1 在 `lib/static/html.dart` 中添加隐私协议和用户协议的 HTML 文件路径常量
- [x] 1.2 确认 `webview_flutter` 依赖已正确安装

## 2. 创建通用 WebView 容器组件（可选）
- [x] 2.1 创建 `lib/widgets/common/html_webview_container.dart` 通用组件
- [x] 2.2 实现 HTML 文件加载逻辑（支持本地 assets 文件）
- [x] 2.3 实现加载状态显示（loading indicator）
- [x] 2.4 实现错误处理（加载失败时的错误提示）

## 3. 更新隐私政策页面
- [x] 3.1 更新 `lib/pages/privacy_feedback/view.dart` 使用 WebView 加载 HTML
- [x] 3.2 更新 `lib/pages/privacy_feedback/controller.dart` 处理 HTML 加载逻辑
- [x] 3.3 更新 `lib/pages/privacy_feedback/state.dart` 添加加载状态字段
- [x] 3.4 测试隐私政策页面 HTML 加载功能

## 4. 创建用户协议页面
- [x] 4.1 使用页面模板创建 `lib/pages/service_agreement/` 目录结构
- [x] 4.2 实现 `page.dart`、`controller.dart`、`state.dart`、`view.dart`
- [x] 4.3 在 `view.dart` 中使用 WebView 加载用户协议 HTML 文件
- [x] 4.4 添加页面标题和导航栏

## 5. 更新路由配置
- [x] 5.1 在 `lib/router/routes.dart` 的 `AppPage` 枚举中添加 `serviceAgreementPage`
- [x] 5.2 在 `PageRoute` extension 中添加用户协议页面的路由构建器
- [x] 5.3 更新隐私政策页面路由，支持通过参数传递 HTML 文件路径（可选）

## 6. 测试和验证
- [x] 6.1 测试隐私政策页面 HTML 加载和显示
- [x] 6.2 测试用户协议页面 HTML 加载和显示
- [x] 6.3 测试页面导航和返回功能
- [x] 6.4 测试不同设备尺寸下的显示效果
- [x] 6.5 验证 HTML 文件中的样式和格式正确显示


# Change: Add HTML WebView Container

## Why
目前项目中已有隐私协议和用户协议两个 HTML 文件（`assets/html/privacy_policy.html` 和 `assets/html/service_agreement.html`），但缺少一个通用的 WebView 容器页面来加载和显示这些 HTML 文件。现有的隐私政策页面使用的是静态文本，无法充分利用 HTML 文件的格式和样式。

## What Changes
- **新增通用 WebView 容器页面**：创建一个可复用的 WebView 容器组件，用于加载本地 HTML 文件
- **更新隐私政策页面**：将现有的静态文本显示改为使用 WebView 加载 HTML 文件
- **新增用户协议页面**：创建用户协议页面，使用 WebView 加载用户协议 HTML 文件
- **更新路由配置**：添加用户协议页面路由，更新隐私政策页面路由以支持 HTML 文件路径参数
- **更新资源引用**：在 `AssetsHtml` 类中添加隐私协议和用户协议的 HTML 文件路径常量

## Impact
- **新增能力**: `html-viewer` - HTML 文件查看器能力
- **受影响代码**:
  - `lib/pages/privacy_feedback/` - 更新为使用 WebView
  - `lib/router/routes.dart` - 添加用户协议路由
  - `lib/static/html.dart` - 添加 HTML 文件路径常量
  - `lib/widgets/` - 新增通用 WebView 容器组件（可选）
- **新增页面**: 用户协议页面
- **依赖**: 项目已安装 `webview_flutter: ^4.10.0`


# html-viewer Specification

## Purpose
TBD - created by archiving change add-html-webview-container. Update Purpose after archive.
## Requirements
### Requirement: HTML File Viewer
系统 SHALL 提供一个通用的 HTML 文件查看器组件，用于在应用内加载和显示本地 HTML 文件。

#### Scenario: 加载隐私政策 HTML 文件
- **WHEN** 用户打开隐私政策页面
- **THEN** 页面使用 WebView 加载 `assets/html/privacy_policy.html` 文件
- **AND** HTML 内容正确显示，包括样式、格式和布局
- **AND** 页面显示加载状态指示器，直到 HTML 内容加载完成

#### Scenario: 加载用户协议 HTML 文件
- **WHEN** 用户打开用户协议页面
- **THEN** 页面使用 WebView 加载 `assets/html/service_agreement.html` 文件
- **AND** HTML 内容正确显示，包括样式、格式和布局
- **AND** 页面显示加载状态指示器，直到 HTML 内容加载完成

#### Scenario: HTML 文件加载失败处理
- **WHEN** HTML 文件加载失败（文件不存在或读取错误）
- **THEN** 页面显示错误提示信息
- **AND** 用户可以点击返回按钮返回上一页

#### Scenario: WebView 页面导航
- **WHEN** 用户在 WebView 中查看 HTML 内容
- **THEN** 页面顶部显示标题栏和返回按钮
- **AND** 点击返回按钮可以返回到上一页
- **AND** WebView 支持滚动查看长内容

#### Scenario: HTML 资源路径管理
- **WHEN** 应用需要加载 HTML 文件
- **THEN** HTML 文件路径通过 `AssetsHtml` 类中的常量定义
- **AND** 隐私政策 HTML 路径定义为 `AssetsHtml.PRIVACY_POLICY`
- **AND** 用户协议 HTML 路径定义为 `AssetsHtml.SERVICE_AGREEMENT`


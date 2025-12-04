# Requirements Document

## Introduction

本功能为加油站管理系统新增发票信息编辑页面。用户可以从加油站管理列表或加油站详情页进入发票编辑页面，补充或修改加油站的发票信息。发票信息包括发票抬头、税号、开户银行、银行账号、公司地址、公司电话和发票类型等字段。

## Glossary

- **Invoice（发票信息）**: 加油站的开票信息，包含发票抬头、税号、银行信息等
- **Station（加油站）**: 系统中的加油站实体，发票信息依赖于加油站ID
- **InvoiceType（发票类型）**: 发票的类型，如增值税专用发票（special_vat）等
- **InvoiceEditPage（发票编辑页面）**: 用于编辑和保存发票信息的页面

## Requirements

### Requirement 1

**User Story:** As a 加油站管理员, I want to 从加油站管理列表进入发票编辑页面, so that 我可以为加油站补充发票信息。

#### Acceptance Criteria

1. WHEN 用户在加油站管理列表点击某个加油站的"发票信息"入口 THEN InvoiceEditPage SHALL 显示该加油站的发票编辑页面
2. WHEN InvoiceEditPage 加载时 THEN InvoiceEditPage SHALL 接收并使用加油站ID作为必要参数
3. WHEN 加油站已有发票信息 THEN InvoiceEditPage SHALL 在表单中预填充已有的发票数据

### Requirement 2

**User Story:** As a 加油站管理员, I want to 从加油站详情页进入发票编辑页面, so that 我可以在查看加油站详情时补充发票信息。

#### Acceptance Criteria

1. WHEN 用户在加油站详情页点击"补充发票信息"入口 THEN InvoiceEditPage SHALL 显示该加油站的发票编辑页面
2. WHEN 从详情页导航到发票编辑页面 THEN InvoiceEditPage SHALL 正确传递加油站ID

### Requirement 3

**User Story:** As a 加油站管理员, I want to 填写完整的发票信息, so that 系统可以正确记录开票所需的全部信息。

#### Acceptance Criteria

1. WHEN InvoiceEditPage 显示时 THEN InvoiceEditPage SHALL 提供以下输入字段：发票抬头(invoiceTitle)、税号(taxNumber)、开户银行(bankName)、银行账号(bankAccount)、公司地址(companyAddress)、公司电话(companyPhone)、发票类型(invoiceType)
2. WHEN 用户输入发票抬头 THEN InvoiceEditPage SHALL 接受非空字符串作为有效输入
3. WHEN 用户输入税号 THEN InvoiceEditPage SHALL 验证税号格式的有效性
4. WHEN 用户输入银行账号 THEN InvoiceEditPage SHALL 验证银行账号为纯数字格式
5. WHEN 用户输入公司电话 THEN InvoiceEditPage SHALL 验证电话号码格式的有效性
6. WHEN 用户选择发票类型 THEN InvoiceEditPage SHALL 提供发票类型选项供用户选择

### Requirement 4

**User Story:** As a 加油站管理员, I want to 保存发票信息, so that 发票信息可以持久化到服务器。

#### Acceptance Criteria

1. WHEN 用户点击保存按钮且所有必填字段已填写 THEN InvoiceEditPage SHALL 调用PUT接口 /stations/{stationId}/invoice 提交发票数据
2. WHEN 接口调用成功 THEN InvoiceEditPage SHALL 显示保存成功提示并返回上一页
3. WHEN 接口调用失败 THEN InvoiceEditPage SHALL 显示错误提示信息
4. WHEN 保存请求正在进行中 THEN InvoiceEditPage SHALL 显示加载状态并禁用保存按钮

### Requirement 5

**User Story:** As a 加油站管理员, I want to 在提交前验证表单数据, so that 我可以避免提交无效数据。

#### Acceptance Criteria

1. WHEN 用户尝试保存空的发票抬头 THEN InvoiceEditPage SHALL 显示"请输入发票抬头"错误提示
2. WHEN 用户尝试保存空的税号 THEN InvoiceEditPage SHALL 显示"请输入税号"错误提示
3. WHEN 用户尝试保存无效格式的税号 THEN InvoiceEditPage SHALL 显示"税号格式不正确"错误提示
4. WHEN 用户尝试保存空的开户银行 THEN InvoiceEditPage SHALL 显示"请输入开户银行"错误提示
5. WHEN 用户尝试保存空的银行账号 THEN InvoiceEditPage SHALL 显示"请输入银行账号"错误提示
6. WHEN 用户尝试保存非数字的银行账号 THEN InvoiceEditPage SHALL 显示"银行账号格式不正确"错误提示

### Requirement 6

**User Story:** As a 加油站管理员, I want to 看到关联的加油站信息, so that 我可以确认正在为哪个加油站配置发票信息。

#### Acceptance Criteria

1. WHEN InvoiceEditPage 显示时 THEN InvoiceEditPage SHALL 在页面顶部显示关联加油站信息卡片
2. WHEN 关联加油站信息卡片显示时 THEN InvoiceEditPage SHALL 显示加油站名称
3. WHEN 关联加油站信息卡片显示时 THEN InvoiceEditPage SHALL 使用紫色主题色和链接图标突出显示

### Requirement 7

**User Story:** As a 加油站管理员, I want to 通过切换按钮选择发票类型, so that 我可以更直观地选择增值税专用发票或普通发票。

#### Acceptance Criteria

1. WHEN InvoiceEditPage 显示发票类型选择时 THEN InvoiceEditPage SHALL 使用分段控制器样式而非下拉菜单
2. WHEN 用户点击发票类型选项 THEN InvoiceEditPage SHALL 高亮选中的类型并更新状态
3. WHEN 发票类型切换时 THEN InvoiceEditPage SHALL 提供平滑的视觉过渡效果

### Requirement 8

**User Story:** As a 加油站管理员, I want to 看到现代化的表单设计, so that 我可以获得更好的填写体验。

#### Acceptance Criteria

1. WHEN InvoiceEditPage 显示表单时 THEN InvoiceEditPage SHALL 使用浅灰色背景(#F5F7FA)和白色卡片容器
2. WHEN 表单输入框获得焦点时 THEN InvoiceEditPage SHALL 显示紫色边框和浅紫色阴影效果
3. WHEN 显示税号和银行账号字段时 THEN InvoiceEditPage SHALL 使用等宽字体以提高可读性
4. WHEN 显示必填字段标签时 THEN InvoiceEditPage SHALL 在标签后显示红色星号标记
5. WHEN 显示银行及地址信息分组时 THEN InvoiceEditPage SHALL 使用分割线和标签进行视觉分组
6. WHEN 显示保存按钮时 THEN InvoiceEditPage SHALL 使用圆角按钮并固定在底部
7. WHEN 显示表单底部提示时 THEN InvoiceEditPage SHALL 显示"请确保信息与营业执照一致，否则可能导致无法开票"的灰色提示文字

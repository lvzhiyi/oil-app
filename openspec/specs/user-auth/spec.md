# Capability: User Authentication (用户认证)

## Purpose

用户认证能力提供完整的用户身份验证和授权机制，包括登录、注册、OTP验证和双Token管理。支持密码登录和验证码登录两种方式，采用双Token机制确保会话安全，并实现Token自动刷新和持久化存储。

## Requirements

### Requirement: 用户登录
系统 SHALL 支持用户通过手机号和密码进行登录。

#### Scenario: 密码登录成功
- **WHEN** 用户输入有效的手机号和正确的密码
- **THEN** 系统验证凭证并返回双Token（access_token 和 refresh_token）
- **AND** 系统将用户信息和Token保存到本地存储
- **AND** 系统根据用户的加油站绑定状态导航到相应页面

#### Scenario: 密码登录失败
- **WHEN** 用户输入无效的手机号或错误的密码
- **THEN** 系统返回错误信息
- **AND** 用户保持在登录页面
- **AND** 表单数据被保留以便用户修正

#### Scenario: 验证码登录成功
- **WHEN** 用户输入有效的手机号和正确的4位验证码
- **THEN** 系统验证凭证并返回双Token
- **AND** 系统将用户信息和Token保存到本地存储
- **AND** 系统检查用户的加油站绑定状态

### Requirement: 用户注册
系统 SHALL 支持新用户通过手机号、验证码和密码创建账户。

#### Scenario: 注册成功
- **WHEN** 用户提供有效的姓名、手机号、验证码和符合规则的密码
- **THEN** 系统创建新用户账户
- **AND** 系统返回双Token和用户信息
- **AND** 系统将认证信息保存到本地存储
- **AND** 系统自动跳转到加油站绑定页面

#### Scenario: 注册失败 - 手机号已存在
- **WHEN** 用户尝试注册已被使用的手机号
- **THEN** 系统返回错误信息提示手机号已被注册
- **AND** 用户保持在注册页面

#### Scenario: 注册失败 - 验证码无效
- **WHEN** 用户输入错误或过期的验证码
- **THEN** 系统返回验证码错误信息
- **AND** 用户需要重新获取验证码

### Requirement: OTP验证码
系统 SHALL 提供短信验证码的发送和验证功能。

#### Scenario: 发送验证码成功
- **WHEN** 用户请求发送验证码到有效的手机号
- **THEN** 系统向该手机号发送4位数字验证码
- **AND** 系统记录发送时间用于验证码过期检查
- **AND** 用户被导航到验证码输入页面

#### Scenario: 验证码输入 - 自动聚焦
- **WHEN** 用户在验证码输入框中输入数字
- **THEN** 焦点自动移动到下一个输入框
- **AND** 当最后一位输入完成时，系统自动触发验证流程

#### Scenario: 验证码验证成功
- **WHEN** 用户输入的4位验证码与系统记录匹配且未过期
- **THEN** 系统验证通过
- **AND** 根据验证码用途（注册/登录）执行相应的后续流程

### Requirement: Token管理
系统 SHALL 实现双Token机制来管理用户会话。

#### Scenario: Token持久化存储
- **WHEN** 用户成功登录或注册
- **THEN** 系统将 access_token 和 refresh_token 保存到 HydratedBloc
- **AND** Token 在应用重启后仍然可用
- **AND** 用户信息同时被持久化保存

#### Scenario: API请求携带Token
- **WHEN** 系统发起需要认证的API请求
- **THEN** 请求头自动包含 access_token
- **AND** Token格式遵循 Bearer Token 标准

#### Scenario: Token自动刷新
- **WHEN** access_token 过期但 refresh_token 仍然有效
- **THEN** 系统自动使用 refresh_token 请求新的双Token
- **AND** 新Token替换旧Token并保存
- **AND** 原始API请求使用新Token重试

#### Scenario: Token完全失效
- **WHEN** refresh_token 也已过期或无效
- **THEN** 系统清除所有本地认证信息
- **AND** 用户被重定向到登录页面
- **AND** 显示会话过期提示

### Requirement: 用户退出登录
系统 SHALL 提供用户主动退出登录的功能。

#### Scenario: 退出登录成功
- **WHEN** 用户点击退出登录按钮
- **THEN** 系统清除本地存储的所有认证信息（access_token、refresh_token、用户信息）
- **AND** 系统调用退出登录API通知服务器
- **AND** 用户被重定向到登录页面
- **AND** 返回栈被清空，用户无法通过返回键回到已认证页面

### Requirement: 登录状态检查
系统 SHALL 在应用启动时检查用户的登录状态。

#### Scenario: 已登录用户启动应用
- **WHEN** 应用启动时检测到有效的 access_token
- **THEN** 系统验证Token有效性
- **AND** 用户直接进入主界面
- **AND** 系统在后台检查加油站绑定状态

#### Scenario: 未登录用户启动应用
- **WHEN** 应用启动时未检测到有效Token
- **THEN** 系统显示启动页后跳转到登录页面
- **AND** 用户需要完成登录才能访问其他功能

### Requirement: 表单验证
系统 SHALL 对用户输入进行客户端验证。

#### Scenario: 手机号格式验证
- **WHEN** 用户输入手机号
- **THEN** 系统实时验证手机号格式（11位数字）
- **AND** 不符合格式时显示错误提示
- **AND** 提交按钮在验证失败时保持禁用状态

#### Scenario: 密码强度验证
- **WHEN** 用户设置密码
- **THEN** 系统验证密码满足最低安全要求
- **AND** 显示密码强度指示器
- **AND** 不符合要求时阻止表单提交

#### Scenario: 表单状态管理
- **WHEN** 表单验证失败
- **THEN** 系统保留用户已输入的有效数据
- **AND** 仅清除验证失败的字段
- **AND** 焦点自动定位到第一个错误字段

## Technical Notes

### API Endpoints
- `POST /auth/login` - 用户登录（支持密码和验证码两种方式）
- `POST /auth/register` - 用户注册
- `POST /auth/send-verification` - 发送验证码
- `POST /auth/refresh` - 刷新Token（待实现）
- `POST /auth/logout` - 退出登录（待实现）

### Data Models
- `LoginRequest`: { phone, password?, code? }
- `RegisterRequest`: { name, phone, code, password }
- `SendCodeRequest`: { phone, type: 'register' | 'login' }
- `AuthResponse`: { accessToken, refreshToken, account }

### State Management
- 使用 Cubit 管理页面级状态（LoginCtrl, RegisterCtrl, OtpCtrl）
- 使用 HydratedCubit 持久化全局认证状态（AppController）
- 表单状态使用 flutter_form_builder

### Security Considerations
- 密码在传输前不进行客户端加密（依赖HTTPS）
- Token 存储在 HydratedBloc 的加密存储中
- 验证码有效期由服务器控制
- 敏感操作需要用户重新认证

### Navigation Flow
1. 登录成功 → 检查加油站状态 → 主界面 或 加油站绑定
2. 注册成功 → 加油站绑定
3. 退出登录 → 登录页面
4. Token失效 → 登录页面


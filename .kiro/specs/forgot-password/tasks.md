# 实现计划 - 找回密码功能

- [ ] 1. 创建ForgotPasswordState和ForgotPasswordCtrl
  - 创建新文件 `lib/pages/forgot_password/state.dart`
  - 实现 `ForgotPasswordState` 类，包含 `loading`、`resetSuccess`、`errorMessage`、`verificationCountdown`、`verificationCodeSent` 字段
  - 实现 `copyWith` 方法
  - 创建新文件 `lib/pages/forgot_password/controller.dart`
  - 实现 `ForgotPasswordCtrl` 继承自 `Cubit<ForgotPasswordState>`
  - 添加 `formKey` 用于表单管理
  - 添加 `Timer` 字段用于倒计时管理
  - 实现 `close` 方法取消定时器
  - _需求: 10.5_

- [ ] 2. 实现验证码发送和倒计时功能
  - 在 `ForgotPasswordCtrl` 中实现 `sendVerificationCode(String phone)` 方法
  - 调用 `authService.sendCode` 发送验证码，类型为 'password_reset'
  - 实现 `startCountdown()` 方法，启动60秒倒计时
  - 使用 `Timer.periodic` 每秒更新倒计时状态
  - 倒计时结束时重置状态
  - 处理发送验证码的错误情况
  - _需求: 3.4, 3.5, 3.6_

- [ ] 2.1 编写验证码服务调用的属性测试
  - **属性 11: 验证码服务调用**
  - **验证: 需求 3.4**

- [ ] 2.2 编写倒计时完整性的属性测试
  - **属性 3: 倒计时完整性**
  - **验证: 需求 3.5, 3.6**

- [ ] 3. 实现密码重置提交功能
  - 在 `ForgotPasswordCtrl` 中实现 `submitReset()` 方法
  - 验证表单数据（手机号、验证码、新密码、确认密码）
  - 调用 `authService.changePassword` 提交密码重置请求
  - 使用 `ChangePasswordRequest` 作为请求参数
  - 成功后导航到登录页面
  - 失败时显示错误信息并重新启用按钮
  - _需求: 7.3, 7.5, 7.6, 10.1, 10.2_

- [ ] 3.1 编写表单验证门控的属性测试
  - **属性 6: 表单验证门控**
  - **验证: 需求 7.2, 7.3**

- [ ] 3.2 编写加载状态一致性的属性测试
  - **属性 7: 加载状态一致性**
  - **验证: 需求 7.4**

- [ ] 3.3 编写错误恢复的属性测试
  - **属性 8: 错误恢复**
  - **验证: 需求 7.6**

- [ ] 4. 创建HeaderArea组件
  - 创建新文件 `lib/pages/forgot_password/widgets/header_area.dart`
  - 实现 `HeaderArea` StatelessWidget
  - 显示64x64圆形容器，背景色#EEECFC
  - 在圆形容器中显示锁形图标（32x32，颜色#7165E3）
  - 显示主标题"重置登录密码"（字体大小24，粗体700）
  - 显示副标题"请输入您的注册手机号并验证身份以设置新的安全密码"（字体大小14，颜色#6B7280）
  - 使用 `SvgAsset` 显示锁形图标
  - 使用 `CommonText` 显示文本
  - _需求: 1.2, 1.3, 1.4_

- [ ] 5. 创建PasswordRules组件
  - 创建新文件 `lib/pages/forgot_password/widgets/password_rules.dart`
  - 实现 `PasswordRules` StatelessWidget
  - 显示两条规则："8-20位字符" 和 "包含字母和数字"
  - 使用小圆点作为列表标记（4x4圆形，颜色#D1D5DB）
  - 字体大小11，颜色#6B7280
  - 使用 `Row` 和 `Container` 布局
  - _需求: 6.1, 6.2, 6.3, 6.4_

- [ ] 6. 创建SendCodeButton组件
  - 创建新文件 `lib/pages/forgot_password/widgets/send_code_button.dart`
  - 实现 `SendCodeButton` StatelessWidget
  - 接受 `countdown` 和 `onSendCode` 参数
  - 倒计时中显示剩余秒数（如"59s"）
  - 倒计时结束显示"获取验证码"
  - 倒计时中禁用按钮，颜色#9CA3AF
  - 可用时颜色#7165E3，粗体600
  - 左侧添加分隔线（1px，颜色#E5E7EB）
  - _需求: 3.2, 3.5, 3.6_

- [ ] 6.1 编写验证码按钮状态一致性的属性测试
  - **属性 2: 验证码按钮状态一致性**
  - **验证: 需求 3.3, 3.5**

- [ ] 7. 创建ContactSupport组件
  - 创建新文件 `lib/pages/forgot_password/widgets/contact_support.dart`
  - 实现 `ContactSupport` StatelessWidget
  - 显示文本"手机号已停用？"（字体大小13，颜色#6B7280）
  - 显示链接"联系人工客服"（字体大小13，颜色#7165E3，粗体600）
  - 点击链接时触发客服联系功能（待实现）
  - 使用 `Row` 布局，居中对齐
  - _需求: 8.1, 8.2, 8.3_

- [ ] 8. 创建ForgotPasswordScreen主界面
  - 创建新文件 `lib/pages/forgot_password/widgets/forgot_password_screen.dart`
  - 实现 `ForgotPasswordScreen` StatefulWidget
  - 使用 `Scaffold` 和 `SafeArea` 作为容器
  - 添加顶部导航栏，包含返回按钮和标题
  - 使用 `SingleChildScrollView` 包裹内容
  - 添加 `HeaderArea` 组件
  - 使用 `FormBuilder` 包裹表单
  - 添加手机号输入框（使用 `CommonTextFormField`）
  - 添加验证码输入框（使用 `CommonTextFormField` 和 `SendCodeButton`）
  - 添加新密码输入框（使用 `CommonTextFormField`，`isPasswordField: true`）
  - 添加确认密码输入框（使用 `CommonTextFormField`，`isPasswordField: true`）
  - 添加 `PasswordRules` 组件
  - 添加提交按钮（使用 `CommonButton`）
  - 添加 `ContactSupport` 组件
  - 所有输入框使用相同的样式：`borderColor: Color(0xFFE5E7EB)`，`fillColor: Color(0xFFF9FAFB)`，`radius: 12`
  - _需求: 1.1, 2.1, 2.2, 3.1, 4.1, 4.2, 5.1, 5.2, 7.1, 9.1, 9.2, 9.3, 9.4, 9.5_

- [ ] 8.1 编写手机号验证一致性的属性测试
  - **属性 1: 手机号验证一致性**
  - **验证: 需求 2.4**

- [ ] 8.2 编写密码可见性切换往返的属性测试
  - **属性 4: 密码可见性切换往返**
  - **验证: 需求 4.4**

- [ ] 8.3 编写密码一致性验证的属性测试
  - **属性 5: 密码一致性验证**
  - **验证: 需求 5.5**

- [ ] 8.4 编写输入框焦点样式的属性测试
  - **属性 9: 输入框焦点样式**
  - **验证: 需求 9.1, 9.2**

- [ ] 9. 实现表单验证逻辑
  - 手机号验证：使用 `PhoneValidator.validatePhone`
  - 验证码验证：必填，4位数字
  - 新密码验证：必填，8-20位，包含字母和数字
  - 确认密码验证：必填，与新密码一致
  - 在 `ForgotPasswordCtrl` 中添加验证方法
  - _需求: 2.3, 2.4, 5.5, 10.3, 10.4_

- [ ] 10. 创建ForgotPasswordView和ForgotPasswordPage
  - 创建新文件 `lib/pages/forgot_password/view.dart`
  - 实现 `ForgotPasswordView` HookWidget
  - 使用 `BlocBuilder` 监听状态变化
  - 渲染 `ForgotPasswordScreen`
  - 创建新文件 `lib/pages/forgot_password/page.dart`
  - 实现 `ForgotPasswordPage` StatelessWidget
  - 使用 `BlocProvider` 提供 `ForgotPasswordCtrl`
  - 使用 `BlocListener` 监听错误和成功状态
  - 显示错误提示（使用 `SportsToast`）
  - _需求: 7.6, 10.5_

- [ ] 11. 添加路由配置
  - 在 `lib/router/routes.dart` 中添加 `forgotPasswordPage` 路由常量
  - 在 `lib/router/router.dart` 中添加路由配置
  - 路径设置为 '/forgot-password'
  - 从登录页面的"忘记密码?"链接导航到找回密码页面
  - _需求: 1.5_

- [ ] 12. 实现导航逻辑
  - 在找回密码页面的返回按钮点击时返回登录页面
  - 在密码重置成功后导航到登录页面（使用 `BaseRouter.replace`）
  - 在登录页面的"忘记密码?"链接点击时导航到找回密码页面
  - _需求: 1.5, 7.5_

- [ ] 12.1 编写成功导航的属性测试
  - **属性 12: 成功导航**
  - **验证: 需求 7.5**

- [ ] 13. 实现错误处理
  - 处理网络错误（连接超时、无网络、服务器错误）
  - 处理验证码发送错误（频率限制、短信服务不可用、无效手机号）
  - 处理密码重置错误（验证码错误、验证码过期、账户不存在、账户锁定）
  - 在 `ForgotPasswordCtrl` 中添加错误处理逻辑
  - 使用 `SportsToast` 显示错误信息
  - 错误后重新启用提交按钮
  - _需求: 7.6_

- [ ] 14. 添加加载状态处理
  - 提交时显示加载状态
  - 禁用提交按钮
  - 在 `CommonButton` 上显示加载指示器
  - 完成后恢复按钮状态
  - _需求: 7.4_

- [ ] 15. 实现输入框焦点管理
  - 为每个输入框创建 `FocusNode`
  - 实现焦点切换逻辑
  - 键盘"下一步"按钮切换到下一个字段
  - 最后一个字段的"完成"按钮提交表单
  - 在 `dispose` 中释放 `FocusNode`
  - _需求: 2.5, 9.2_

- [ ] 16. 添加输入限制
  - 手机号输入框：仅数字，最多11位
  - 验证码输入框：仅数字，最多4位
  - 使用 `FilteringTextInputFormatter.digitsOnly` 限制输入
  - _需求: 2.3_

- [ ] 17. 实现密码规则验证
  - 创建密码验证器函数
  - 验证长度：8-20位
  - 验证内容：包含字母和数字
  - 返回清晰的错误信息
  - _需求: 6.1, 6.2_

- [ ] 18. 添加样式常量
  - 创建颜色常量类（如果需要）
  - 定义主色调：#7165E3
  - 定义文本颜色：#1F2937（主）、#6B7280（副）
  - 定义输入框颜色：#F9FAFB（背景）、#E5E7EB（边框）
  - 定义图标圆圈背景：#EEECFC
  - _需求: 1.2, 9.1_

- [ ] 19. 测试完整流程
  - 测试页面加载和UI显示
  - 测试手机号输入和验证
  - 测试验证码发送和倒计时
  - 测试密码输入和可见性切换
  - 测试表单验证
  - 测试密码重置提交
  - 测试错误处理
  - 测试成功后导航
  - _需求: 所有需求_

- [ ] 20. Checkpoint - 确保所有测试通过
  - 确保所有测试通过，如有问题请询问用户

# 设计文档 - 找回密码功能

## 概述

找回密码功能允许用户在忘记登录密码时，通过手机号和短信验证码来重置密码。该功能复用现有的修改密码API接口（`authService.changePassword`），但提供了更友好的用户界面和引导流程。

设计采用Flutter的widget组合和状态管理模式，创建一个独立的找回密码页面，包含清晰的视觉层次、友好的提示信息和流畅的交互体验。页面布局参考提供的HTML设计，采用居中对齐、圆角卡片和柔和的配色方案。

## 架构

### 组件结构

```
ForgotPasswordPage (新建)
└── ForgotPasswordView (新建)
    └── ForgotPasswordScreen (新建)
        ├── NavigationBar (导航栏)
        │   └── BackButton (返回按钮)
        ├── HeaderArea (头部区域)
        │   ├── IconCircle (锁形图标)
        │   ├── PageHeadline (主标题)
        │   └── PageSubhead (副标题)
        ├── FormContainer (表单容器)
        │   ├── PhoneNumberField (手机号输入框)
        │   ├── VerificationCodeField (验证码输入框)
        │   │   └── SendCodeButton (发送验证码按钮)
        │   ├── NewPasswordField (新密码输入框)
        │   │   └── VisibilityToggle (可见性切换)
        │   ├── ConfirmPasswordField (确认密码输入框)
        │   │   └── VisibilityToggle (可见性切换)
        │   └── PasswordRules (密码规则提示)
        ├── SubmitButton (提交按钮)
        └── ContactSupport (联系客服)
```

### 状态管理

创建新的`ForgotPasswordState`来管理页面状态：

```dart
class ForgotPasswordState {
  final bool loading;
  final bool resetSuccess;
  final String? errorMessage;
  final int? verificationCountdown;
  final bool verificationCodeSent;
  
  ForgotPasswordState({
    required this.loading,
    this.resetSuccess = false,
    this.errorMessage,
    this.verificationCountdown,
    this.verificationCodeSent = false,
  });
  
  ForgotPasswordState copyWith({
    bool? loading,
    bool? resetSuccess,
    String? errorMessage,
    int? verificationCountdown,
    bool? verificationCodeSent,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      resetSuccess: resetSuccess ?? this.resetSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationCountdown: verificationCountdown ?? this.verificationCountdown,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
    );
  }
}
```

### 控制器设计

创建`ForgotPasswordCtrl`继承自`Cubit<ForgotPasswordState>`：

```dart
class ForgotPasswordCtrl extends Cubit<ForgotPasswordState> {
  ForgotPasswordCtrl() : super(ForgotPasswordState(loading: false));
  
  final formKey = GlobalKey<FormBuilderState>();
  Timer? _countdownTimer;
  
  // 发送验证码
  Future<void> sendVerificationCode(String phone) async {
    // 调用 authService.sendCode
    // 启动倒计时
  }
  
  // 启动倒计时
  void startCountdown() {
    // 60秒倒计时
  }
  
  // 提交重置密码
  Future<void> submitReset() async {
    // 验证表单
    // 调用 authService.changePassword
    // 成功后导航到登录页
  }
  
  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
```

## 组件和接口

### 1. ForgotPasswordScreen Widget

**目的**: 找回密码页面的主容器组件

**接口**:
```dart
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
}
```

**职责**:
- 渲染页面布局
- 管理表单状态
- 协调与ForgotPasswordCtrl的交互

### 2. HeaderArea Widget

**目的**: 显示页面头部的视觉锚点和说明

**接口**:
```dart
class HeaderArea extends StatelessWidget {
  const HeaderArea({Key? key}) : super(key: key);
}
```

**样式**:
- 图标圆圈: 64x64像素，背景色#EEECFC，圆形
- 锁形图标: 32x32像素，颜色#7165E3
- 主标题: "重置登录密码"，字体大小24，粗体700
- 副标题: 字体大小14，颜色#6B7280，居中对齐

### 3. PhoneNumberField Widget

**目的**: 手机号输入框（复用登录页面的CommonTextFormField）

**接口**:
```dart
CommonTextFormField(
  name: 'phone',
  borderColor: const Color(0xFFE5E7EB),
  fillColor: const Color(0xFFF9FAFB),
  leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
  hintText: '请输入手机号码',
  keyboardType: TextInputType.phone,
  inputFormatter: FilteringTextInputFormatter.digitsOnly,
  maxLength: 11,
  radius: 12,
  validators: PhoneValidator.validatePhone,
)
```

**特性**:
- 使用CommonTextFormField组件
- 左侧手机图标
- 数字键盘
- 最多11位
- 自动验证格式
- 焦点时显示阴影效果
- 与登录页面样式完全一致

### 4. VerificationCodeField Widget

**目的**: 验证码输入框和发送按钮（复用登录页面的CommonTextFormField）

**接口**:
```dart
CommonTextFormField(
  name: 'code',
  borderColor: const Color(0xFFE5E7EB),
  fillColor: const Color(0xFFF9FAFB),
  leadingIcon: SvgAsset(assetName: AssetsSvg.CAPTCHA),
  hintText: '请输入4位验证码',
  keyboardType: TextInputType.number,
  maxLength: 4,
  radius: 12,
  suffixIcon: SendCodeButton(
    countdown: countdown,
    onSendCode: onSendCode,
  ),
)
```

**特性**:
- 使用CommonTextFormField组件
- 左侧盾牌图标
- 右侧发送验证码按钮
- 倒计时显示（如"59s"）
- 按钮禁用状态管理
- 与登录页面样式完全一致

### 5. PasswordField Widget

**目的**: 可复用的密码输入框组件（复用登录页面的CommonTextFormField）

**接口**:
```dart
CommonTextFormField(
  name: 'password',
  borderColor: const Color(0xFFE5E7EB),
  fillColor: const Color(0xFFF9FAFB),
  leadingIcon: SvgAsset(assetName: AssetsSvg.LOCK),
  hintText: '设置新密码',
  isPasswordField: true,
  radius: 12,
  validators: validator,
)
```

**特性**:
- 使用CommonTextFormField组件
- 左侧锁形图标
- 右侧可见性切换按钮（由CommonTextFormField自动提供）
- 默认隐藏密码
- 自定义验证器
- 与登录页面样式完全一致

### 6. PasswordRules Widget

**目的**: 显示密码规则提示

**接口**:
```dart
class PasswordRules extends StatelessWidget {
  const PasswordRules({Key? key}) : super(key: key);
}
```

**内容**:
- "8-20位字符"
- "包含字母和数字"
- 小圆点列表标记
- 字体大小11，颜色#6B7280

### 7. ContactSupport Widget

**目的**: 客服联系链接

**接口**:
```dart
class ContactSupport extends StatelessWidget {
  const ContactSupport({Key? key}) : super(key: key);
}
```

**样式**:
- 文本: "手机号已停用？"
- 链接: "联系人工客服"，颜色#7165E3，粗体600

## 数据模型

### ForgotPasswordState

```dart
class ForgotPasswordState {
  final bool loading;
  final bool resetSuccess;
  final String? errorMessage;
  final int? verificationCountdown;
  final bool verificationCodeSent;
  
  const ForgotPasswordState({
    required this.loading,
    this.resetSuccess = false,
    this.errorMessage,
    this.verificationCountdown,
    this.verificationCodeSent = false,
  });
  
  ForgotPasswordState copyWith({
    bool? loading,
    bool? resetSuccess,
    String? errorMessage,
    int? verificationCountdown,
    bool? verificationCodeSent,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      resetSuccess: resetSuccess ?? this.resetSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationCountdown: verificationCountdown ?? this.verificationCountdown,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
    );
  }
}
```

### 复用现有模型

- `ChangePasswordRequest`: 用于提交密码重置请求
- `SendCodeRequest`: 用于发送验证码请求

## 正确性属性

*属性是一个特征或行为，应该在系统的所有有效执行中保持为真——本质上是关于系统应该做什么的正式陈述。属性作为人类可读规范和机器可验证正确性保证之间的桥梁。*

### 属性 1: 手机号验证一致性

*对于任何*字符串输入，手机号验证应该返回true当且仅当输入是有效的11位数字格式。

**验证: 需求 2.4**

### 属性 2: 验证码按钮状态一致性

*对于任何*手机号输入状态和倒计时状态，"获取验证码"按钮应该启用当且仅当手机号有效且不在倒计时中。

**验证: 需求 3.3, 3.5**

### 属性 3: 倒计时完整性

*对于任何*成功的验证码发送，系统应该启动60秒倒计时，按钮显示剩余秒数，倒计时结束后按钮恢复可用状态。

**验证: 需求 3.5, 3.6**

### 属性 4: 密码可见性切换往返

*对于任何*密码字段状态，连续切换可见性两次应该返回到原始状态（显示或隐藏）。

**验证: 需求 4.4**

### 属性 5: 密码一致性验证

*对于任何*新密码和确认密码输入，验证应该通过当且仅当两个密码完全相同。

**验证: 需求 5.5**

### 属性 6: 表单验证门控

*对于任何*表单状态，当用户点击提交按钮时，系统应该验证所有必填字段（手机号、验证码、新密码、确认密码）后才能继续。

**验证: 需求 7.2, 7.3**

### 属性 7: 加载状态一致性

*对于任何*成功的表单验证，提交按钮应该进入加载状态（禁用并显示加载指示器）直到密码重置完成。

**验证: 需求 7.4**

### 属性 8: 错误恢复

*对于任何*密码重置失败，系统应该显示错误信息并重新启用提交按钮以允许重试。

**验证: 需求 7.6**

### 属性 9: 输入框焦点样式

*对于任何*输入框，当获得焦点时应该显示白色背景、主色调边框(#7165E3)和阴影效果，失去焦点时恢复默认样式。

**验证: 需求 9.1, 9.2**

### 属性 10: API接口一致性

*对于任何*密码重置请求，系统应该使用与修改密码相同的API接口（authService.changePassword）和相同的请求参数结构（ChangePasswordRequest）。

**验证: 需求 10.1, 10.2**

### 属性 11: 验证码服务调用

*对于任何*有效的手机号，当用户点击"获取验证码"按钮时，系统应该调用验证码服务并传递该手机号。

**验证: 需求 3.4**

### 属性 12: 成功导航

*对于任何*成功的密码重置，系统应该导航到登录页面。

**验证: 需求 7.5**

## 错误处理

### 输入验证错误

**手机号验证**:
- 空输入: 显示"请输入手机号"
- 无效格式: 显示"请输入有效的11位手机号"
- 非数字字符: 自动过滤

**验证码验证**:
- 空输入: 显示"请输入验证码"
- 格式错误: 显示"请输入4位数字验证码"

**密码验证**:
- 空输入: 显示"请输入新密码"
- 长度不足: 显示"密码长度必须为8-20位"
- 格式错误: 显示"密码必须包含字母和数字"

**确认密码验证**:
- 空输入: 显示"请确认新密码"
- 不一致: 显示"两次输入的密码不一致"

### 网络错误

**连接错误**:
- 连接超时: 显示"网络连接超时，请重试"
- 无网络: 显示"无网络连接，请检查网络设置"
- 服务器错误(5xx): 显示"服务器错误，请稍后重试"

### 业务错误

**验证码发送**:
- 频率限制: 显示"发送过于频繁，请稍后再试"
- 短信服务不可用: 显示"短信服务暂时不可用"
- 无效手机号: 显示"手机号无效，无法发送验证码"

**密码重置**:
- 验证码错误: 显示"验证码错误，请重新输入"
- 验证码过期: 显示"验证码已过期，请重新获取"
- 账户不存在: 显示"该手机号未注册"
- 账户锁定: 显示"账号已被锁定，请联系客服"

### 错误恢复策略

所有错误状态应该:
1. 显示清晰的中文错误信息
2. 重新启用提交按钮以允许重试
3. 清除加载状态
4. 保留用户输入（敏感密码数据除外）
5. 记录错误日志用于调试
6. 在可能的情况下提供可操作的指导

## 测试策略

### 单元测试

使用Flutter的widget测试框架验证组件行为：

**Widget测试**:
- 测试页面布局和组件渲染
- 测试表单字段验证逻辑
- 测试按钮启用/禁用状态
- 测试错误信息显示
- 测试导航触发

**控制器测试**:
- 测试ForgotPasswordCtrl中的状态转换
- 测试表单验证逻辑
- 测试验证码倒计时
- 测试错误状态处理

**示例单元测试**:
```dart
testWidgets('phone field validates 11-digit numbers', (tester) async {
  // Arrange: 渲染找回密码页面
  // Act: 输入有效/无效手机号
  // Assert: 验证结果正确
});

testWidgets('submit button disabled when form invalid', (tester) async {
  // Arrange: 渲染页面，字段为空
  // Act: 尝试点击提交按钮
  // Assert: 按钮禁用，未触发提交
});
```

### 基于属性的测试

使用基于属性的测试来验证跨多个输入的通用正确性属性。我们将使用Dart/Flutter的`test`包和自定义生成器进行基于属性的测试。

**属性测试配置**:
- 每个属性测试最少100次迭代
- 为手机号、验证码和密码创建自定义生成器
- 基于种子的随机化以实现可重现性

**属性测试示例**:
```dart
// 属性 1: 手机号验证一致性
test('phone validation consistency', () {
  final validPhones = generateValidPhoneNumbers(100);
  final invalidPhones = generateInvalidPhoneNumbers(100);
  
  for (final phone in validPhones) {
    expect(phoneValidator(phone), isTrue);
  }
  
  for (final phone in invalidPhones) {
    expect(phoneValidator(phone), isFalse);
  }
});

// 属性 4: 密码可见性切换往返
test('password visibility toggle round-trip', () {
  final initialStates = [true, false];
  
  for (final initialVisible in initialStates) {
    var currentVisible = initialVisible;
    currentVisible = !currentVisible; // 第一次切换
    currentVisible = !currentVisible; // 第二次切换
    expect(currentVisible, equals(initialVisible));
  }
});
```

**属性测试标记**:
每个基于属性的测试必须包含引用设计文档属性的注释标签：
```dart
// Feature: forgot-password, Property 1: 手机号验证一致性
test('phone validation consistency', () { ... });
```

### 集成测试

**完整流程测试**:
- 测试从输入到密码重置成功的完整流程
- 测试验证码发送和倒计时
- 测试错误恢复流程
- 测试导航到登录页面

**API集成测试**:
- 测试与authService.sendCode的集成
- 测试与authService.changePassword的集成
- 测试网络错误处理
- 测试业务错误处理

### 手动测试清单

- [ ] 视觉设计符合HTML参考
- [ ] 在真实设备上动画流畅
- [ ] 键盘行为正确（下一个字段、提交）
- [ ] 错误信息清晰有用
- [ ] 加载状态提供适当反馈
- [ ] 在不同屏幕尺寸上正常工作
- [ ] 无障碍功能正常（屏幕阅读器、字体缩放）
- [ ] 倒计时准确且可靠

## 实现说明

### 动画实现

使用Flutter的`AnimatedContainer`实现焦点状态过渡：
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  decoration: BoxDecoration(
    color: isFocused ? Colors.white : Color(0xFFF9FAFB),
    border: Border.all(
      color: isFocused ? Color(0xFF7165E3) : Color(0xFFE5E7EB),
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: isFocused ? [
      BoxShadow(
        color: Color(0xFF7165E3).withOpacity(0.1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ] : null,
  ),
)
```

### 倒计时实现

使用`Timer.periodic`实现验证码倒计时：
```dart
void startCountdown() {
  emit(state.copyWith(verificationCountdown: 60));
  
  _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (state.verificationCountdown! > 0) {
      emit(state.copyWith(
        verificationCountdown: state.verificationCountdown! - 1
      ));
    } else {
      timer.cancel();
      emit(state.copyWith(verificationCountdown: null));
    }
  });
}
```

### 表单验证

使用`CommonTextFormField`和`PhoneValidator`（与登录页面一致）：
```dart
CommonTextFormField(
  name: 'phone',
  borderColor: const Color(0xFFE5E7EB),
  fillColor: const Color(0xFFF9FAFB),
  hintText: '请输入手机号码',
  keyboardType: TextInputType.phone,
  inputFormatter: FilteringTextInputFormatter.digitsOnly,
  maxLength: 11,
  radius: 12,
  validators: PhoneValidator.validatePhone,
)
```

### 样式常量

定义颜色常量以保持一致性：
```dart
class ForgotPasswordColors {
  static const primary = Color(0xFF7165E3);
  static const primaryHover = Color(0xFF5B50C7);
  static const textMain = Color(0xFF1F2937);
  static const textSub = Color(0xFF6B7280);
  static const inputBg = Color(0xFFF9FAFB);
  static const border = Color(0xFFE5E7EB);
  static const iconCircleBg = Color(0xFFEEECFC);
}
```

### 无障碍考虑

- 确保所有交互元素都有语义标签
- 提供足够的颜色对比度（WCAG AA最低标准）
- 支持动态字体大小
- 确保键盘/屏幕阅读器可以导航
- 在按钮按下时提供触觉反馈（移动端）

## 路由配置

### 添加新路由

在`router/routes.dart`中添加：
```dart
static const forgotPasswordPage = '/forgot-password';
```

在`router/router.dart`中添加路由配置：
```dart
GoRoute(
  path: AppPage.forgotPasswordPage.path,
  name: AppPage.forgotPasswordPage.name,
  builder: (context, state) => ForgotPasswordPage(),
),
```

### 导航调用

从登录页面导航到找回密码页面：
```dart
BaseRouter.push(url: AppPage.forgotPasswordPage.path);
```

密码重置成功后导航到登录页面：
```dart
BaseRouter.replace(url: AppPage.loginPage.path);
```

## 与现有系统集成

### 复用现有服务

- `authService.sendCode`: 发送验证码
- `authService.changePassword`: 重置密码

### 复用现有组件

- `CommonButton`: 提交按钮
- `CommonText`: 文本显示
- `SvgAsset`: SVG图标
- `FormBuilder`: 表单管理
- `CommonTextFormField`: 输入框（与登录页面使用相同的组件和样式）

### 复用现有工具

- `AppSizes`: 响应式尺寸
- `BaseRouter`: 路由导航
- `l.d/l.e`: 日志记录

## 性能考虑

- 使用`const`构造函数减少重建
- 合理使用`FocusNode`避免不必要的重建
- 倒计时使用`Timer`而非`Stream`以减少开销
- 图标使用SVG格式以保持清晰度和小文件大小
- 避免在build方法中创建新对象

## 安全考虑

- 密码字段默认隐藏
- 不在日志中记录敏感信息（密码、验证码）
- 验证码有效期限制（服务端控制）
- 防止暴力破解（频率限制）
- HTTPS传输加密（网络层）

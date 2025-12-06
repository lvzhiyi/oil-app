# Design Document - Unified Login Screen

## Overview

The unified login screen consolidates the existing password-based and verification code-based authentication methods into a single, cohesive interface. This design leverages Flutter's widget composition and state management patterns to create a tab-based navigation system that allows users to seamlessly switch between authentication methods without page transitions.

The implementation will refactor the existing `LoginToYourAccountScreen` and `VerificationLoginScreen` widgets into a single unified component with shared branding elements and tab-controlled form switching. The design maintains compatibility with the existing `LoginCtrl` controller and authentication services while introducing a new tab state management layer.

## Architecture

### Component Structure

```
LoginView (existing)
└── UnifiedLoginScreen (new)
    ├── BrandHeader (extracted component)
    │   ├── Logo
    │   ├── AppName
    │   └── Slogan
    ├── TabNavigation (new component)
    │   ├── AccountLoginTab
    │   └── VerificationLoginTab
    ├── FormContainer (new component)
    │   ├── PasswordLoginForm (refactored)
    │   │   ├── PhoneNumberField
    │   │   └── PasswordField
    │   └── VerificationLoginForm (refactored)
    │       ├── PhoneNumberField
    │       └── VerificationCodeField
    ├── ActionLinks (extracted component)
    │   ├── RegisterLink
    │   └── ForgotPasswordLink
    ├── LoginButton (existing)
    └── AgreementFooter (extracted component)
```

### State Management

The design extends the existing `LoginState` to include tab selection state:

```dart
class LoginState {
  final bool loginLoading;
  final bool loginSuccess;
  final String? errorMessage;
  final LoginTabType activeTab; // NEW
  final int? verificationCountdown; // NEW for SMS countdown
  
  // existing fields...
}

enum LoginTabType {
  password,
  verification
}
```

### Controller Extensions

The existing `LoginCtrl` will be extended with tab management methods:

```dart
class LoginCtrl extends Cubit<LoginState> {
  // Existing methods...
  
  // NEW: Tab switching
  void switchTab(LoginTabType tab) {
    emit(state.copyWith(activeTab: tab));
  }
  
  // NEW: Verification code handling
  Future<void> sendVerificationCode(String phone) async {
    // Implementation
  }
  
  void startCountdown() {
    // Implementation
  }
}
```

## Components and Interfaces

### 1. UnifiedLoginScreen Widget

**Purpose**: Main container widget that orchestrates all login UI components

**Interface**:
```dart
class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({Key? key}) : super(key: key);
}
```

**Responsibilities**:
- Render brand header
- Manage tab navigation UI
- Display active form based on tab selection
- Coordinate with LoginCtrl for state updates

### 2. TabNavigation Widget

**Purpose**: Provides tab switching UI with visual indicators

**Interface**:
```dart
class TabNavigation extends StatelessWidget {
  final LoginTabType activeTab;
  final Function(LoginTabType) onTabChanged;
  
  const TabNavigation({
    required this.activeTab,
    required this.onTabChanged,
    Key? key
  }) : super(key: key);
}
```

**Styling**:
- Active tab: fontSize 18, fontWeight 700, with bottom indicator
- Inactive tab: fontSize 16, fontWeight 500, color #6B7280
- Bottom indicator: width 20px, height 3px, color #7165E3, borderRadius 2px

### 3. PasswordLoginForm Widget

**Purpose**: Refactored form for password-based authentication

**Interface**:
```dart
class PasswordLoginForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  
  const PasswordLoginForm({
    required this.formKey,
    Key? key
  }) : super(key: key);
}
```

**Fields**:
- Phone number field with user icon
- Password field with key icon and visibility toggle

### 4. VerificationLoginForm Widget

**Purpose**: Refactored form for SMS verification authentication

**Interface**:
```dart
class VerificationLoginForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final int? countdown;
  final VoidCallback onSendCode;
  
  const VerificationLoginForm({
    required this.formKey,
    this.countdown,
    required this.onSendCode,
    Key? key
  }) : super(key: key);
}
```

**Fields**:
- Phone number field with phone icon
- Verification code field with envelope icon and "获取验证码" button

### 5. BrandHeader Widget

**Purpose**: Reusable brand identity component

**Interface**:
```dart
class BrandHeader extends StatelessWidget {
  const BrandHeader({Key? key}) : super(key: key);
}
```

**Content**:
- Logo: 72x72 container with app logo
- App name: "欢迎回到买油呗" (fontSize 24, fontWeight 700)
- Slogan: "更专业的B2B成品油交易平台" (fontSize 13, color #6B7280)

## Data Models

### Extended LoginState

```dart
class LoginState extends Equatable {
  final bool loginLoading;
  final bool loginSuccess;
  final String? errorMessage;
  final LoginTabType activeTab;
  final int? verificationCountdown;
  final bool verificationCodeSent;
  
  const LoginState({
    required this.loginLoading,
    this.loginSuccess = false,
    this.errorMessage,
    this.activeTab = LoginTabType.password,
    this.verificationCountdown,
    this.verificationCodeSent = false,
  });
  
  LoginState copyWith({
    bool? loginLoading,
    bool? loginSuccess,
    String? errorMessage,
    LoginTabType? activeTab,
    int? verificationCountdown,
    bool? verificationCodeSent,
  }) {
    return LoginState(
      loginLoading: loginLoading ?? this.loginLoading,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTab: activeTab ?? this.activeTab,
      verificationCountdown: verificationCountdown ?? this.verificationCountdown,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
    );
  }
  
  @override
  List<Object?> get props => [
    loginLoading,
    loginSuccess,
    errorMessage,
    activeTab,
    verificationCountdown,
    verificationCodeSent,
  ];
}
```

### LoginTabType Enum

```dart
enum LoginTabType {
  password,
  verification
}
```

## 

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property 1: Tab switching updates active form and indicator

*For any* tab selection (password or verification), when the user switches to that tab, the system should display the corresponding form content and update the visual indicator to show the active tab with bold text and underline.

**Validates: Requirements 1.2, 1.3, 7.3**

### Property 2: Phone number validation consistency

*For any* string input in a phone number field, the validation should return true if and only if the input matches a valid phone number format (11 digits for Chinese phone numbers).

**Validates: Requirements 2.3**

### Property 3: Password visibility toggle round-trip

*For any* password field state, toggling the visibility icon twice should return the field to its original visibility state (masked or unmasked).

**Validates: Requirements 2.5**

### Property 4: Verification code button state consistency

*For any* phone number input in the verification tab, the "获取验证码" button should be enabled if and only if the phone number is valid, and after sending a code, the button should be disabled with a countdown timer.

**Validates: Requirements 3.3, 3.5**

### Property 5: Verification code service invocation

*For any* valid phone number, when the user taps the "获取验证码" button, the system should invoke the verification code service with that exact phone number.

**Validates: Requirements 3.4**

### Property 6: Common elements persistence across tabs

*For any* tab selection (password or verification), the system should display the action links ("没有账户? 立即注册", "忘记密码?"), the login button with text "登录", and the user agreement section.

**Validates: Requirements 4.2, 4.3, 4.4**

### Property 7: Agreement link navigation

*For any* agreement link (service agreement or privacy policy), tapping the link should trigger navigation to the corresponding policy page.

**Validates: Requirements 4.5**

### Property 8: Input field default styling

*For any* input field in the login forms, when not focused, the field should have background color #F9FAFB, border color #E5E7EB, and border radius 12 pixels.

**Validates: Requirements 5.1, 5.5**

### Property 9: Input field focus styling

*For any* input field in the login forms, when focused, the field should change to white background and primary color border (#7165E3).

**Validates: Requirements 5.2**

### Property 10: Input field icon positioning

*For any* input field with an icon, the icon should be positioned on the left side, and if the field has action buttons, they should be positioned on the right side with a separator.

**Validates: Requirements 5.3, 5.4**

### Property 11: Login button validation gate

*For any* form state (password or verification), when the user taps the login button, the system should validate all required fields before proceeding with authentication.

**Validates: Requirements 6.1**

### Property 12: Login button loading state

*For any* successful validation, the login button should enter a loading state (disabled with loading indicator) until authentication completes.

**Validates: Requirements 6.2**

### Property 13: Authentication error handling

*For any* authentication failure, the system should display an error message and re-enable the login button for retry.

**Validates: Requirements 6.4**


## Error Handling

### Input Validation Errors

**Phone Number Validation**:
- Empty input: Display "请输入手机号" (Please enter phone number)
- Invalid format: Display "请输入有效的手机号" (Please enter a valid phone number)
- Non-numeric characters: Automatically filter out during input

**Password Validation**:
- Empty input: Display "请输入密码" (Please enter password)
- Minimum length not met: Display "密码长度不足" (Password too short)

**Verification Code Validation**:
- Empty input: Display "请输入验证码" (Please enter verification code)
- Invalid format: Display "验证码格式错误" (Invalid verification code format)

### Authentication Errors

**Network Errors**:
- Connection timeout: Display "网络连接超时，请重试" (Network timeout, please retry)
- No internet: Display "无网络连接，请检查网络设置" (No internet connection)
- Server error (5xx): Display "服务器错误，请稍后重试" (Server error, please try again later)

**Authentication Failures**:
- Invalid credentials: Display "手机号或密码错误" (Incorrect phone or password)
- Account not found: Display "账户不存在，请先注册" (Account does not exist, please register)
- Account locked: Display "账号已被锁定，请联系您的业务员" (Account locked, contact support)
- Verification code expired: Display "验证码已过期，请重新获取" (Verification code expired)
- Verification code incorrect: Display "验证码错误" (Incorrect verification code)

### SMS Service Errors

**Verification Code Sending**:
- Rate limit exceeded: Display "发送过于频繁，请稍后再试" (Too many requests, try later)
- SMS service unavailable: Display "短信服务暂时不可用" (SMS service unavailable)
- Invalid phone number: Display "手机号无效，无法发送验证码" (Invalid phone number)

### Error Recovery

All error states should:
1. Display clear, user-friendly error messages in Chinese
2. Re-enable the submit button to allow retry
3. Clear loading states
4. Preserve user input (except sensitive password data on authentication failure)
5. Log errors for debugging purposes
6. Provide actionable guidance when possible (e.g., "请检查网络设置")

## Testing Strategy

### Unit Testing

The unified login screen will use Flutter's widget testing framework to verify component behavior:

**Widget Tests**:
- Test tab switching updates the visible form
- Test form field validation logic
- Test button enabled/disabled states
- Test error message display
- Test navigation triggers

**Controller Tests**:
- Test state transitions in LoginCtrl
- Test form validation logic
- Test countdown timer for verification codes
- Test error state handling

**Example Unit Tests**:
```dart
testWidgets('switching to verification tab shows verification form', (tester) async {
  // Arrange: render unified login screen
  // Act: tap verification tab
  // Assert: verification form is visible, password form is not
});

testWidgets('login button disabled when form invalid', (tester) async {
  // Arrange: render login screen with empty fields
  // Act: attempt to tap login button
  // Assert: button is disabled, no authentication triggered
});
```

### Property-Based Testing

The unified login screen will use property-based testing to verify universal correctness properties across many inputs. We'll use the `test` package with custom generators for property-based testing in Dart/Flutter.

**Property Test Configuration**:
- Minimum 100 iterations per property test
- Custom generators for phone numbers, passwords, and verification codes
- Seed-based randomization for reproducibility

**Property Test Examples**:
```dart
// Property 2: Phone number validation consistency
test('phone validation accepts valid numbers and rejects invalid', () {
  final validPhones = generateValidPhoneNumbers(100);
  final invalidPhones = generateInvalidPhoneNumbers(100);
  
  for (final phone in validPhones) {
    expect(phoneValidator(phone), isTrue);
  }
  
  for (final phone in invalidPhones) {
    expect(phoneValidator(phone), isFalse);
  }
});

// Property 3: Password visibility toggle round-trip
test('toggling password visibility twice returns to original state', () {
  final initialStates = [true, false]; // visible or hidden
  
  for (final initialVisible in initialStates) {
    var currentVisible = initialVisible;
    currentVisible = !currentVisible; // first toggle
    currentVisible = !currentVisible; // second toggle
    expect(currentVisible, equals(initialVisible));
  }
});
```

**Property Test Tagging**:
Each property-based test must include a comment tag referencing the design document property:
```dart
// Feature: unified-login, Property 2: Phone number validation consistency
test('phone validation consistency', () { ... });
```

### Integration Testing

**Authentication Flow Tests**:
- Test complete password login flow from input to navigation
- Test complete verification code login flow
- Test error recovery flows
- Test tab switching during active authentication

**Navigation Tests**:
- Test navigation to registration page
- Test navigation to forgot password page
- Test navigation to policy pages
- Test navigation to home after successful login

### Manual Testing Checklist

- [ ] Visual design matches HTML reference
- [ ] Tab animations are smooth on physical devices
- [ ] Keyboard behavior is correct (next field, submit)
- [ ] Error messages are clear and helpful
- [ ] Loading states provide appropriate feedback
- [ ] Works correctly on different screen sizes
- [ ] Accessibility features work (screen readers, font scaling)

## Implementation Notes

### Animation Implementation

Use Flutter's `AnimatedSwitcher` for form transitions:
```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: state.activeTab == LoginTabType.password
    ? PasswordLoginForm(key: ValueKey('password'))
    : VerificationLoginForm(key: ValueKey('verification')),
)
```

### Countdown Timer Implementation

Use `Timer.periodic` for verification code countdown:
```dart
Timer.periodic(const Duration(seconds: 1), (timer) {
  if (state.verificationCountdown! > 0) {
    emit(state.copyWith(
      verificationCountdown: state.verificationCountdown! - 1
    ));
  } else {
    timer.cancel();
  }
});
```

### Form Key Management

Use separate form keys for each tab to maintain independent validation:
```dart
final passwordFormKey = GlobalKey<FormBuilderState>();
final verificationFormKey = GlobalKey<FormBuilderState>();
```

### Styling Constants

Define color constants for consistency:
```dart
class LoginColors {
  static const primary = Color(0xFF7165E3);
  static const primaryHover = Color(0xFF5B50C7);
  static const textMain = Color(0xFF1F2937);
  static const textSub = Color(0xFF6B7280);
  static const inputBg = Color(0xFFF9FAFB);
  static const border = Color(0xFFE5E7EB);
}
```

### Accessibility Considerations

- Ensure all interactive elements have semantic labels
- Provide sufficient color contrast (WCAG AA minimum)
- Support dynamic font sizing
- Ensure tab navigation works with keyboard/screen readers
- Provide haptic feedback on button presses (mobile)

## Migration Strategy

### Phase 1: Create New Components
1. Create `UnifiedLoginScreen` widget
2. Extract `BrandHeader` component
3. Create `TabNavigation` component
4. Refactor forms into `PasswordLoginForm` and `VerificationLoginForm`

### Phase 2: Update Controller
1. Extend `LoginState` with tab and countdown fields
2. Add tab switching methods to `LoginCtrl`
3. Add verification code sending logic
4. Add countdown timer management

### Phase 3: Integration
1. Update `LoginView` to use `UnifiedLoginScreen`
2. Remove old `VerificationLoginScreen` route
3. Update navigation references
4. Test all authentication flows

### Phase 4: Cleanup
1. Delete old `verification_login.dart` file
2. Remove unused routes from router configuration
3. Update any deep links or external references
4. Archive old implementation for reference

### Rollback Plan

If issues arise:
1. Revert `LoginView` to use old `LoginToYourAccountScreen`
2. Re-enable `VerificationLoginScreen` route
3. Investigate and fix issues in development
4. Re-deploy when stable

The old implementation files should be kept in version control for at least one release cycle before permanent deletion.

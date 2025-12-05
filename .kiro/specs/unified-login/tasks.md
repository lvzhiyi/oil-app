# Implementation Plan - Unified Login Screen

- [x] 1. Extend LoginState and create LoginTabType enum


  - Add `activeTab` field to `LoginState` with default value `LoginTabType.password`
  - Add `verificationCountdown` nullable int field to `LoginState`
  - Add `verificationCodeSent` boolean field to `LoginState`
  - Create `LoginTabType` enum with `password` and `verification` values
  - Update `copyWith` method to include new fields
  - Update `props` getter for Equatable to include new fields
  - _Requirements: 8.1, 8.5_

- [x] 2. Create reusable BrandHeader component


  - Create new file `lib/pages/login/widgets/brand_header.dart`
  - Implement `BrandHeader` StatelessWidget with logo, app name, and slogan
  - Use existing logo asset from `AssetsImg.LOGO`
  - Apply styling: logo 72x72, app name fontSize 24 fontWeight 700, slogan fontSize 13
  - _Requirements: 4.1_

- [x] 3. Create TabNavigation component


  - Create new file `lib/pages/login/widgets/tab_navigation.dart`
  - Implement `TabNavigation` StatelessWidget with two tab items
  - Accept `activeTab` and `onTabChanged` callback parameters
  - Style active tab: fontSize 18, fontWeight 700, with bottom indicator (20px width, 3px height, primary color)
  - Style inactive tab: fontSize 16, fontWeight 500, color #6B7280
  - _Requirements: 1.1, 1.3_

- [x] 4. Refactor password login form into PasswordLoginForm component


  - Create new file `lib/pages/login/widgets/password_login_form.dart`
  - Extract phone and password fields from existing `LoginToYourAccountScreen`
  - Accept `formKey` parameter for FormBuilder integration
  - Implement phone number field with user icon
  - Implement password field with key icon and visibility toggle
  - Apply input field styling: background #F9FAFB, border #E5E7EB, radius 12px
  - Apply focus styling: white background, primary border #7165E3
  - _Requirements: 2.1, 2.2, 5.1, 5.2, 5.3, 5.5_

- [x] 4.1 Write property test for password visibility toggle


  - **Property 3: Password visibility toggle round-trip**
  - **Validates: Requirements 2.5**

- [x] 5. Create VerificationLoginForm component


  - Create new file `lib/pages/login/widgets/verification_login_form.dart`
  - Implement phone number field with phone icon
  - Implement verification code field with envelope icon
  - Add "获取验证码" button with separator line
  - Accept `formKey`, `countdown`, and `onSendCode` parameters
  - Display countdown timer when active
  - Disable button during countdown
  - Apply consistent input field styling
  - _Requirements: 3.1, 3.2, 5.1, 5.2, 5.4, 5.5_

- [x] 5.1 Write property test for verification button state


  - **Property 4: Verification code button state consistency**


  - **Validates: Requirements 3.3, 3.5**

- [x] 6. Create ActionLinks component
  - Create new file `lib/pages/login/widgets/action_links.dart`
  - Implement register link: "没有账户? 立即注册"
  - Implement forgot password link: "忘记密码?"
  - Add navigation handlers for both links
  - Apply text styling: regular text #6B7280, links primary color with fontWeight 600
  - _Requirements: 4.2_

- [x] 7. Create AgreementFooter component
  - Create new file `lib/pages/login/widgets/agreement_footer.dart`
  - Implement checkbox with toggle functionality
  - Implement agreement text with clickable policy links
  - Add navigation to service agreement and privacy policy pages
  - Apply styling: fontSize 12, checkbox 16x16 with 4px radius
  - _Requirements: 4.4, 4.5_

- [x] 7.1 Write property test for agreement link navigation
  - **Property 7: Agreement link navigation**
  - **Validates: Requirements 4.5**

- [x] 8. Extend LoginCtrl with tab management
  - Add `switchTab(LoginTabType tab)` method to emit new state with updated activeTab
  - Add `sendVerificationCode(String phone)` method to call auth service
  - Add `startCountdown()` method to manage 60-second countdown timer
  - Add `stopCountdown()` method to cancel active timer
  - Store Timer instance as class field for cleanup
  - Update dispose method to cancel timer if active
  - _Requirements: 3.4, 3.5, 8.1, 8.5_

- [x] 8.1 Write property test for verification code service invocation
  - **Property 5: Verification code service invocation**
  - **Validates: Requirements 3.4**


- [x] 9. Create UnifiedLoginScreen widget

  - Create new file `lib/pages/login/widgets/unified_login_screen.dart`
  - Implement main scaffold with SafeArea and SingleChildScrollView
  - Compose BrandHeader at top
  - Add TabNavigation below header
  - Use AnimatedSwitcher for form transitions (300ms duration)
  - Conditionally render PasswordLoginForm or VerificationLoginForm based on activeTab
  - Add ActionLinks below forms
  - Add login button with loading state handling
  - Add AgreementFooter at bottom
  - Connect to LoginCtrl for state management
  - _Requirements: 1.1, 1.2, 1.4, 1.5, 4.3_

- [x] 9.1 Write property test for tab switching

  - **Property 1: Tab switching updates active form and indicator**
  - **Validates: Requirements 1.2, 1.3, 7.3**

- [x] 9.2 Write property test for common elements persistence


  - **Property 6: Common elements persistence across tabs**
  - **Validates: Requirements 4.2, 4.3, 4.4**

- [x] 10. Add phone number validation


  - Create or update phone validator function
  - Validate format: exactly 11 digits for Chinese phone numbers
  - Apply to phone fields in both forms
  - Display appropriate error messages
  - _Requirements: 2.3_

- [x] 10.1 Write property test for phone validation


  - **Property 2: Phone number validation consistency**
  - **Validates: Requirements 2.3**

- [x] 11. Implement input field styling properties


  - Create shared input field styling constants in a new file or existing theme
  - Define default colors: background #F9FAFB, border #E5E7EB
  - Define focus colors: background white, border #7165E3
  - Define border radius: 12px
  - Apply to all CommonTextFormField instances
  - _Requirements: 5.1, 5.2, 5.5_

- [x] 11.1 Write property test for input field default styling


  - **Property 8: Input field default styling**
  - **Validates: Requirements 5.1, 5.5**

- [x] 11.2 Write property test for input field focus styling


  - **Property 9: Input field focus styling**
  - **Validates: Requirements 5.2**

- [x] 11.3 Write property test for input field icon positioning


  - **Property 10: Input field icon positioning**
  - **Validates: Requirements 5.3, 5.4**

- [x] 12. Implement login button validation and loading states


  - Update submit method in LoginCtrl to validate based on active tab
  - Use passwordFormKey for password tab, verificationFormKey for verification tab
  - Show loading state on button during authentication
  - Disable button during loading
  - Handle authentication success: navigate to home
  - Handle authentication failure: show error, re-enable button
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [x] 12.1 Write property test for login button validation gate


  - **Property 11: Login button validation gate**
  - **Validates: Requirements 6.1**

- [x] 12.2 Write property test for login button loading state


  - **Property 12: Login button loading state**
  - **Validates: Requirements 6.2**

- [x] 12.3 Write property test for authentication error handling


  - **Property 13: Authentication error handling**
  - **Validates: Requirements 6.4**

- [x] 13. Update LoginView to use UnifiedLoginScreen


  - Replace `LoginToYourAccountScreen` with `UnifiedLoginScreen` in `login/view.dart`
  - Ensure BlocProvider and BlocBuilder setup remains unchanged
  - Test that navigation after successful login still works
  - _Requirements: 8.1, 8.5_

- [x] 14. Update router configuration


  - Remove route for `verificationLoginPage` from router configuration
  - Update any references to verification login route
  - Ensure deep links point to unified login page
  - _Requirements: 8.4_


- [x] 15. Add error handling for all authentication scenarios
  - Implement error messages for network errors (timeout, no connection, server error)
  - Implement error messages for authentication failures (invalid credentials, account not found, account locked)
  - Implement error messages for SMS service errors (rate limit, service unavailable, invalid phone)
  - Display errors using existing error display mechanism
  - Ensure errors clear on retry
  - _Requirements: 6.4_

- [x] 16. Checkpoint - Ensure all tests pass
  - All 99 tests passing

- [x] 17. Clean up old implementation files
  - Old `verification_login.dart` file already deleted
  - No unused imports found
  - _Requirements: 8.1_

- [ ] 18. Write integration tests for complete authentication flows
  - Test password login flow from input to home navigation
  - Test verification code login flow from input to home navigation
  - Test tab switching during authentication
  - Test error recovery flows
  - _Requirements: 6.3_

# Requirements Document

## Introduction

This feature refactors the existing login functionality by merging the separate password login and verification code login screens into a unified login page with tab-based navigation. The unified interface will provide a seamless user experience with smooth transitions between authentication methods while maintaining all existing security and validation features.

## Glossary

- **Login System**: The authentication mechanism that verifies user credentials and grants access to the application
- **Tab Navigation**: A UI pattern that allows users to switch between different content views within the same screen
- **Password Login**: Authentication method using phone number and password credentials
- **Verification Code Login**: Authentication method using phone number and SMS verification code
- **Form Validation**: The process of checking user input against defined rules before submission
- **Authentication State**: The current status of the login process (idle, loading, success, error)

## Requirements

### Requirement 1

**User Story:** As a user, I want to see both login methods on a single screen with tab navigation, so that I can easily switch between password and verification code login without navigating to different pages.

#### Acceptance Criteria

1. WHEN the user opens the login screen THEN the Login System SHALL display a unified interface with two tabs labeled "账号登录" (Account Login) and "验证码登录" (Verification Code Login)
2. WHEN the user taps on a tab THEN the Login System SHALL switch the active form content with a smooth fade-in animation
3. WHEN a tab is active THEN the Login System SHALL display a visual indicator (underline and bold text) beneath the selected tab
4. WHEN switching tabs THEN the Login System SHALL preserve the brand header and footer agreement sections without re-rendering
5. WHEN the screen loads THEN the Login System SHALL display the "账号登录" (Account Login) tab as the default active tab

### Requirement 2

**User Story:** As a user, I want the password login form to include phone number and password fields with appropriate icons and validation, so that I can securely authenticate using my credentials.

#### Acceptance Criteria

1. WHEN the "账号登录" tab is active THEN the Login System SHALL display an input field for phone number with a user icon
2. WHEN the "账号登录" tab is active THEN the Login System SHALL display an input field for password with a key icon and password visibility toggle
3. WHEN the user enters data in the phone field THEN the Login System SHALL validate the input as a valid phone number format
4. WHEN the user enters data in the password field THEN the Login System SHALL mask the password characters by default
5. WHEN the user taps the password visibility icon THEN the Login System SHALL toggle between showing and hiding the password text

### Requirement 3

**User Story:** As a user, I want the verification code login form to include phone number and verification code fields with a send code button, so that I can authenticate using SMS verification.

#### Acceptance Criteria

1. WHEN the "验证码登录" tab is active THEN the Login System SHALL display an input field for phone number with a phone icon
2. WHEN the "验证码登录" tab is active THEN the Login System SHALL display an input field for verification code with an envelope icon
3. WHEN the user enters a valid phone number THEN the Login System SHALL enable the "获取验证码" (Get Code) button
4. WHEN the user taps the "获取验证码" button THEN the Login System SHALL send a verification code to the provided phone number
5. WHEN a verification code is sent THEN the Login System SHALL start a countdown timer and disable the button until the timer expires

### Requirement 4

**User Story:** As a user, I want consistent branding and navigation elements across both login methods, so that I have a cohesive experience regardless of which authentication method I choose.

#### Acceptance Criteria

1. WHEN the login screen renders THEN the Login System SHALL display the application logo, name "欢迎回到买油呗", and slogan "更专业的B2B成品油交易平台" at the top
2. WHEN either tab is active THEN the Login System SHALL display action links including "没有账户? 立即注册" (No account? Register) and "忘记密码?" (Forgot password?)
3. WHEN either tab is active THEN the Login System SHALL display a primary login button with the text "登录" (Login)
4. WHEN either tab is active THEN the Login System SHALL display the user agreement checkbox and text at the bottom
5. WHEN the user taps agreement links THEN the Login System SHALL navigate to the respective policy pages

### Requirement 5

**User Story:** As a user, I want input fields to have proper styling with icons, borders, and focus states, so that I can easily identify and interact with form elements.

#### Acceptance Criteria

1. WHEN an input field is rendered THEN the Login System SHALL display the field with a light gray background color (#F9FAFB) and border (#E5E7EB)
2. WHEN an input field receives focus THEN the Login System SHALL change the background to white and border to primary color (#7165E3) with a subtle shadow
3. WHEN an input field contains an icon THEN the Login System SHALL position the icon on the left side with proper padding
4. WHEN an input field has additional actions THEN the Login System SHALL position action buttons on the right side with a separator line
5. WHEN input fields are displayed THEN the Login System SHALL apply consistent border radius of 12 pixels

### Requirement 6

**User Story:** As a user, I want the login button to provide visual feedback and handle the authentication process, so that I know my login attempt is being processed.

#### Acceptance Criteria

1. WHEN the user taps the login button THEN the Login System SHALL validate all required fields before proceeding
2. WHEN validation passes THEN the Login System SHALL display a loading state on the button and disable further taps
3. WHEN authentication succeeds THEN the Login System SHALL navigate the user to the home screen
4. WHEN authentication fails THEN the Login System SHALL display an error message and re-enable the login button
5. WHEN the login button is pressed THEN the Login System SHALL provide visual feedback with a scale-down animation

### Requirement 7

**User Story:** As a user, I want the tab switching animation to be smooth and responsive, so that the interface feels polished and professional.

#### Acceptance Criteria

1. WHEN the user switches tabs THEN the Login System SHALL hide the current form content with a fade-out effect
2. WHEN the user switches tabs THEN the Login System SHALL show the new form content with a fade-in effect lasting 300 milliseconds
3. WHEN tab switching occurs THEN the Login System SHALL update the active tab indicator with a smooth transition
4. WHEN the user rapidly switches between tabs THEN the Login System SHALL cancel pending animations and start new ones
5. WHEN animations complete THEN the Login System SHALL ensure all interactive elements are immediately responsive

### Requirement 8

**User Story:** As a developer, I want the unified login screen to reuse existing controller logic and state management, so that the refactoring maintains consistency with the current architecture.

#### Acceptance Criteria

1. WHEN implementing the unified login THEN the Login System SHALL utilize the existing LoginCtrl controller for state management
2. WHEN implementing the unified login THEN the Login System SHALL maintain the existing form validation logic using FormBuilder
3. WHEN implementing the unified login THEN the Login System SHALL preserve the existing authentication service integration
4. WHEN implementing the unified login THEN the Login System SHALL maintain the existing navigation patterns using GoRouter
5. WHEN implementing the unified login THEN the Login System SHALL follow the existing BLoC pattern for state updates

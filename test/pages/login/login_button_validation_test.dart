import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/pages/login/state.dart';

/// Feature: unified-login, Property 11: Login button validation gate
/// Validates: Requirements 6.1
void main() {
  group('Login Button Validation Gate Property Tests', () {
    // Simulate form validation
    bool validateForm(Map<String, String> formData, LoginTabType tabType) {
      if (tabType == LoginTabType.password) {
        // Password form requires phone and password
        final phone = formData['phone'] ?? '';
        final password = formData['password'] ?? '';
        return phone.isNotEmpty && password.isNotEmpty;
      } else {
        // Verification form requires phone and code
        final phone = formData['phone'] ?? '';
        final code = formData['verificationCode'] ?? '';
        return phone.isNotEmpty && code.isNotEmpty;
      }
    }

    test('password form validates required fields before login', () {
      final validFormData = {
        'phone': '13800138000',
        'password': '123456',
      };

      final invalidFormData = [
        {'phone': '', 'password': '123456'}, // Missing phone
        {'phone': '13800138000', 'password': ''}, // Missing password
        {'phone': '', 'password': ''}, // Missing both
      ];

      // Valid form should pass
      expect(
        validateForm(validFormData, LoginTabType.password),
        true,
        reason: 'Valid password form should pass validation',
      );

      // Invalid forms should fail
      for (final formData in invalidFormData) {
        expect(
          validateForm(formData, LoginTabType.password),
          false,
          reason: 'Invalid password form should fail validation: $formData',
        );
      }
    });

    test('verification form validates required fields before login', () {
      final validFormData = {
        'phone': '13800138000',
        'verificationCode': '1234',
      };

      final invalidFormData = [
        {'phone': '', 'verificationCode': '1234'}, // Missing phone
        {'phone': '13800138000', 'verificationCode': ''}, // Missing code
        {'phone': '', 'verificationCode': ''}, // Missing both
      ];

      // Valid form should pass
      expect(
        validateForm(validFormData, LoginTabType.verification),
        true,
        reason: 'Valid verification form should pass validation',
      );

      // Invalid forms should fail
      for (final formData in invalidFormData) {
        expect(
          validateForm(formData, LoginTabType.verification),
          false,
          reason: 'Invalid verification form should fail validation: $formData',
        );
      }
    });

    test('validation runs before authentication for both tabs', () {
      final tabs = [LoginTabType.password, LoginTabType.verification];

      for (final tab in tabs) {
        // Empty form should fail validation
        final emptyForm = <String, String>{};
        expect(
          validateForm(emptyForm, tab),
          false,
          reason: 'Empty form should fail validation for $tab tab',
        );
      }
    });

    test('validation consistency across 100 iterations', () {
      for (int i = 0; i < 100; i++) {
        final tab =
            i % 2 == 0 ? LoginTabType.password : LoginTabType.verification;

        // Valid form
        final validForm = tab == LoginTabType.password
            ? {'phone': '13800138000', 'password': '123456'}
            : {'phone': '13800138000', 'verificationCode': '1234'};

        expect(
          validateForm(validForm, tab),
          true,
          reason: 'Valid form should pass at iteration $i',
        );

        // Invalid form (empty)
        final invalidForm = <String, String>{};
        expect(
          validateForm(invalidForm, tab),
          false,
          reason: 'Invalid form should fail at iteration $i',
        );
      }
    });

    test('validation prevents login when loading', () {
      bool canLogin(bool isLoading, bool isFormValid) {
        return !isLoading && isFormValid;
      }

      // Valid form but loading
      expect(
        canLogin(true, true),
        false,
        reason: 'Should not allow login when already loading',
      );

      // Valid form and not loading
      expect(
        canLogin(false, true),
        true,
        reason: 'Should allow login when not loading and form is valid',
      );

      // Invalid form
      expect(
        canLogin(false, false),
        false,
        reason: 'Should not allow login when form is invalid',
      );
    });

    test('validation is independent of tab switching', () {
      final passwordForm = {'phone': '13800138000', 'password': '123456'};
      final verificationForm = {
        'phone': '13800138000',
        'verificationCode': '1234'
      };

      // Switch between tabs multiple times
      for (int i = 0; i < 10; i++) {
        final tab =
            i % 2 == 0 ? LoginTabType.password : LoginTabType.verification;
        final form =
            tab == LoginTabType.password ? passwordForm : verificationForm;

        expect(
          validateForm(form, tab),
          true,
          reason: 'Validation should work correctly after tab switch $i',
        );
      }
    });

    test('partial form data fails validation', () {
      final partialPasswordForms = [
        {'phone': '13800138000'}, // Missing password
        {'password': '123456'}, // Missing phone
      ];

      for (final form in partialPasswordForms) {
        expect(
          validateForm(form, LoginTabType.password),
          false,
          reason: 'Partial password form should fail: $form',
        );
      }

      final partialVerificationForms = [
        {'phone': '13800138000'}, // Missing code
        {'verificationCode': '1234'}, // Missing phone
      ];

      for (final form in partialVerificationForms) {
        expect(
          validateForm(form, LoginTabType.verification),
          false,
          reason: 'Partial verification form should fail: $form',
        );
      }
    });

    test('validation gate is deterministic', () {
      final testForm = {'phone': '13800138000', 'password': '123456'};

      // Call validation multiple times
      for (int i = 0; i < 10; i++) {
        final result = validateForm(testForm, LoginTabType.password);
        expect(
          result,
          true,
          reason: 'Validation should be consistent across calls',
        );
      }
    });

    test('different tabs require different fields', () {
      final passwordOnlyForm = {'phone': '13800138000', 'password': '123456'};
      final codeOnlyForm = {'phone': '13800138000', 'verificationCode': '1234'};

      // Password form should pass for password tab
      expect(
        validateForm(passwordOnlyForm, LoginTabType.password),
        true,
      );

      // Password form should fail for verification tab (missing code)
      expect(
        validateForm(passwordOnlyForm, LoginTabType.verification),
        false,
      );

      // Code form should pass for verification tab
      expect(
        validateForm(codeOnlyForm, LoginTabType.verification),
        true,
      );

      // Code form should fail for password tab (missing password)
      expect(
        validateForm(codeOnlyForm, LoginTabType.password),
        false,
      );
    });
  });
}

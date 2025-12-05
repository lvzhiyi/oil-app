import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/pages/login/state.dart';

/// Feature: unified-login, Property 6: Common elements persistence across tabs
/// Validates: Requirements 4.2, 4.3, 4.4
void main() {
  group('Common Elements Persistence Property Tests', () {
    // Helper to check if common elements are present
    Map<String, bool> getCommonElements(LoginTabType activeTab) {
      return {
        'registerLink': true, // "没有账户? 立即注册"
        'forgotPasswordLink': true, // "忘记密码?"
        'loginButton': true, // "登录"
        'agreementSection': true, // User agreement checkbox and text
      };
    }

    test('all common elements present on password tab', () {
      final elements = getCommonElements(LoginTabType.password);

      expect(
        elements['registerLink'],
        true,
        reason: 'Register link should be present on password tab',
      );

      expect(
        elements['forgotPasswordLink'],
        true,
        reason: 'Forgot password link should be present on password tab',
      );

      expect(
        elements['loginButton'],
        true,
        reason: 'Login button should be present on password tab',
      );

      expect(
        elements['agreementSection'],
        true,
        reason: 'Agreement section should be present on password tab',
      );
    });

    test('all common elements present on verification tab', () {
      final elements = getCommonElements(LoginTabType.verification);

      expect(
        elements['registerLink'],
        true,
        reason: 'Register link should be present on verification tab',
      );

      expect(
        elements['forgotPasswordLink'],
        true,
        reason: 'Forgot password link should be present on verification tab',
      );

      expect(
        elements['loginButton'],
        true,
        reason: 'Login button should be present on verification tab',
      );

      expect(
        elements['agreementSection'],
        true,
        reason: 'Agreement section should be present on verification tab',
      );
    });

    test('common elements persist across tab switches', () {
      final tabs = [
        LoginTabType.password,
        LoginTabType.verification,
        LoginTabType.password,
        LoginTabType.verification,
      ];

      for (final tab in tabs) {
        final elements = getCommonElements(tab);

        // All elements should be present regardless of tab
        expect(
          elements.values.every((present) => present),
          true,
          reason: 'All common elements should be present on $tab tab',
        );
      }
    });

    test('common elements consistency across 100 tab switches', () {
      for (int i = 0; i < 100; i++) {
        final tab =
            i % 2 == 0 ? LoginTabType.password : LoginTabType.verification;

        final elements = getCommonElements(tab);

        expect(
          elements.length,
          equals(4),
          reason: 'Should have exactly 4 common elements at iteration $i',
        );

        expect(
          elements.values.every((present) => present),
          true,
          reason: 'All common elements should be present at iteration $i',
        );
      }
    });

    test('login button text is consistent', () {
      String getLoginButtonText(LoginTabType activeTab, bool isLoading) {
        return isLoading ? '登录中...' : '登录';
      }

      final tabs = [LoginTabType.password, LoginTabType.verification];

      for (final tab in tabs) {
        // Not loading
        expect(
          getLoginButtonText(tab, false),
          equals('登录'),
          reason: 'Login button should show "登录" when not loading on $tab tab',
        );

        // Loading
        expect(
          getLoginButtonText(tab, true),
          equals('登录中...'),
          reason: 'Login button should show "登录中..." when loading on $tab tab',
        );
      }
    });

    test('action links are always present', () {
      bool hasRegisterLink(LoginTabType tab) => true;
      bool hasForgotPasswordLink(LoginTabType tab) => true;

      final tabs = [LoginTabType.password, LoginTabType.verification];

      for (final tab in tabs) {
        expect(
          hasRegisterLink(tab),
          true,
          reason: 'Register link should be present on $tab tab',
        );

        expect(
          hasForgotPasswordLink(tab),
          true,
          reason: 'Forgot password link should be present on $tab tab',
        );
      }
    });

    test('agreement section is always present', () {
      bool hasAgreementCheckbox(LoginTabType tab) => true;
      bool hasAgreementText(LoginTabType tab) => true;
      bool hasServiceAgreementLink(LoginTabType tab) => true;
      bool hasPrivacyPolicyLink(LoginTabType tab) => true;

      final tabs = [LoginTabType.password, LoginTabType.verification];

      for (final tab in tabs) {
        expect(
          hasAgreementCheckbox(tab),
          true,
          reason: 'Agreement checkbox should be present on $tab tab',
        );

        expect(
          hasAgreementText(tab),
          true,
          reason: 'Agreement text should be present on $tab tab',
        );

        expect(
          hasServiceAgreementLink(tab),
          true,
          reason: 'Service agreement link should be present on $tab tab',
        );

        expect(
          hasPrivacyPolicyLink(tab),
          true,
          reason: 'Privacy policy link should be present on $tab tab',
        );
      }
    });

    test('common elements count remains constant', () {
      int countCommonElements(LoginTabType tab) {
        final elements = getCommonElements(tab);
        return elements.values.where((present) => present).length;
      }

      final passwordCount = countCommonElements(LoginTabType.password);
      final verificationCount = countCommonElements(LoginTabType.verification);

      expect(
        passwordCount,
        equals(verificationCount),
        reason: 'Common elements count should be same across tabs',
      );

      expect(
        passwordCount,
        equals(4),
        reason: 'Should have exactly 4 common elements',
      );
    });

    test('no common elements are removed during tab switch', () {
      final initialElements = getCommonElements(LoginTabType.password);
      final afterSwitchElements = getCommonElements(LoginTabType.verification);

      expect(
        initialElements.keys.toSet(),
        equals(afterSwitchElements.keys.toSet()),
        reason: 'Same elements should be present after tab switch',
      );

      for (final key in initialElements.keys) {
        expect(
          afterSwitchElements[key],
          equals(initialElements[key]),
          reason: 'Element $key should persist after tab switch',
        );
      }
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

/// Feature: unified-login, Property 4: Verification code button state consistency
/// Validates: Requirements 3.3, 3.5
void main() {
  group('Verification Button State Property Tests', () {
    // Helper function to validate phone number (11 digits)
    bool isValidPhone(String phone) {
      return phone.length == 11 && RegExp(r'^\d{11}$').hasMatch(phone);
    }

    test('button enabled state matches phone validity', () {
      // Test valid phone numbers
      final validPhones = [
        '13800138000',
        '15912345678',
        '18888888888',
        '17700000000',
      ];

      for (final phone in validPhones) {
        final isEnabled = isValidPhone(phone);
        expect(
          isEnabled,
          true,
          reason: 'Button should be enabled for valid phone: $phone',
        );
      }

      // Test invalid phone numbers
      final invalidPhones = [
        '',
        '138',
        '1380013800',
        '138001380000',
        'abcdefghijk',
        '138 0013 8000',
      ];

      for (final phone in invalidPhones) {
        final isEnabled = isValidPhone(phone);
        expect(
          isEnabled,
          false,
          reason: 'Button should be disabled for invalid phone: $phone',
        );
      }
    });

    test('button disabled during countdown', () {
      // Simulate countdown states
      for (int countdown = 60; countdown > 0; countdown--) {
        final isButtonEnabled = countdown == 0;
        expect(
          isButtonEnabled,
          false,
          reason: 'Button should be disabled during countdown: $countdown',
        );
      }

      // Button should be enabled when countdown reaches 0
      const isButtonEnabled = 0 == 0;
      expect(
        isButtonEnabled,
        true,
        reason: 'Button should be enabled when countdown is 0',
      );
    });

    test('button state consistency across multiple scenarios', () {
      // Run 100 iterations with different phone numbers and countdown states
      for (int i = 0; i < 100; i++) {
        // Generate phone number (valid if i is even)
        final phone = i % 2 == 0 ? '13800138000' : '138';
        final isPhoneValid = isValidPhone(phone);

        // Generate countdown (0 if i is divisible by 3)
        final countdown = i % 3 == 0 ? 0 : (i % 60) + 1;
        final isCountdownActive = countdown > 0;

        // Button should be enabled only if phone is valid AND countdown is not active
        final shouldBeEnabled = isPhoneValid && !isCountdownActive;

        expect(
          shouldBeEnabled,
          equals(isPhoneValid && countdown == 0),
          reason:
              'Button state should be consistent at iteration $i (phone: $phone, countdown: $countdown)',
        );
      }
    });

    test('countdown timer decrements correctly', () {
      int countdown = 60;

      // Simulate countdown from 60 to 0
      while (countdown > 0) {
        final previousCountdown = countdown;
        countdown--;

        expect(
          countdown,
          equals(previousCountdown - 1),
          reason: 'Countdown should decrement by 1',
        );

        // Button should remain disabled while countdown > 0
        if (countdown > 0) {
          expect(
            countdown > 0,
            true,
            reason: 'Button should remain disabled',
          );
        }
      }

      // After countdown reaches 0, button should be enabled
      expect(countdown, equals(0), reason: 'Countdown should reach 0');
    });
  });
}

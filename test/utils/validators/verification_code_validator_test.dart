import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/utils/validators/verification_code_validator.dart';

void main() {
  group('Verification Code Validator Tests', () {
    test('valid verification codes pass validation', () {
      final validCodes = [
        '1234', // 4 digits
        '0000',
        '9999',
        '5678',
      ];

      for (final code in validCodes) {
        final result = VerificationCodeValidator.validateCode(code);
        expect(
          result,
          isNull,
          reason: 'Valid code $code should pass validation',
        );

        expect(
          VerificationCodeValidator.isValidCode(code),
          true,
          reason: 'isValidCode should return true for $code',
        );
      }
    });

    test('invalid verification codes fail validation', () {
      final invalidCodes = [
        '', // Empty
        '123', // Too short (< 4)
        '12345', // Too long (> 4)
        '123456', // Too long (> 4)
        'abcd', // Letters
        '12a4', // Mixed
      ];

      for (final code in invalidCodes) {
        final result = VerificationCodeValidator.validateCode(code);
        expect(
          result,
          isNotNull,
          reason: 'Invalid code $code should fail validation',
        );

        expect(
          VerificationCodeValidator.isValidCode(code),
          false,
          reason: 'isValidCode should return false for $code',
        );
      }
    });

    test('null and empty values fail validation', () {
      expect(
        VerificationCodeValidator.validateCode(null),
        isNotNull,
        reason: 'Null should fail validation',
      );

      expect(
        VerificationCodeValidator.validateCode(''),
        isNotNull,
        reason: 'Empty string should fail validation',
      );

      expect(
        VerificationCodeValidator.isValidCode(null),
        false,
        reason: 'isValidCode should return false for null',
      );

      expect(
        VerificationCodeValidator.isValidCode(''),
        false,
        reason: 'isValidCode should return false for empty string',
      );
    });

    test('validation error messages are appropriate', () {
      expect(
        VerificationCodeValidator.validateCode(''),
        equals('请输入验证码'),
        reason: 'Empty code should return appropriate message',
      );

      expect(
        VerificationCodeValidator.validateCode('123'),
        equals('验证码长度不足'),
        reason: 'Short code should return appropriate message',
      );

      expect(
        VerificationCodeValidator.validateCode('12345'),
        equals('验证码长度过长'),
        reason: 'Long code should return appropriate message',
      );

      expect(
        VerificationCodeValidator.validateCode('abcd'),
        equals('验证码只能包含数字'),
        reason: 'Non-numeric code should return appropriate message',
      );
    });

    test('codes with spaces are handled', () {
      final codesWithSpaces = [
        '12 34',
        ' 1234',
        '1234 ',
        '1 2 3 4',
      ];

      for (final code in codesWithSpaces) {
        final result = VerificationCodeValidator.validateCode(code);
        // After removing spaces, these should be valid (exactly 4 digits)
        final cleanCode = code.replaceAll(' ', '');
        final expected =
            cleanCode.length == 4 && RegExp(r'^\d+$').hasMatch(cleanCode);

        if (expected) {
          expect(
            result,
            isNull,
            reason: 'Code with spaces $code should pass after cleaning',
          );
        }
      }
    });

    test('validation is deterministic', () {
      const testCode = '1234';

      // Call validation multiple times
      for (int i = 0; i < 10; i++) {
        final result = VerificationCodeValidator.validateCode(testCode);
        expect(
          result,
          isNull,
          reason: 'Validation should be consistent across calls',
        );
      }

      const invalidCode = '123';
      for (int i = 0; i < 10; i++) {
        final result = VerificationCodeValidator.validateCode(invalidCode);
        expect(
          result,
          isNotNull,
          reason: 'Invalid code validation should be consistent',
        );
      }
    });

    test('boundary length validation', () {
      // Exactly 4 digits (valid)
      expect(
        VerificationCodeValidator.isValidCode('1234'),
        true,
        reason: '4 digits should be valid',
      );

      // 3 digits (below minimum)
      expect(
        VerificationCodeValidator.isValidCode('123'),
        false,
        reason: '3 digits should be invalid',
      );

      // 5 digits (above maximum)
      expect(
        VerificationCodeValidator.isValidCode('12345'),
        false,
        reason: '5 digits should be invalid',
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/utils/validators/phone_validator.dart';

/// Feature: unified-login, Property 2: Phone number validation consistency
/// Validates: Requirements 2.3
void main() {
  group('Phone Validation Property Tests', () {
    test('valid 11-digit phone numbers pass validation', () {
      final validPhones = [
        '13800138000',
        '15912345678',
        '18888888888',
        '17700000000',
        '19999999999',
        '13012345678',
        '14512345678',
        '16612345678',
      ];

      for (final phone in validPhones) {
        final result = PhoneValidator.validatePhone(phone);
        expect(
          result,
          isNull,
          reason: 'Valid phone $phone should pass validation',
        );

        expect(
          PhoneValidator.isValidPhone(phone),
          true,
          reason: 'isValidPhone should return true for $phone',
        );
      }
    });

    test('invalid phone numbers fail validation', () {
      final invalidPhones = [
        '', // Empty
        '138', // Too short
        '1380013800', // 10 digits
        '138001380000', // 12 digits
        'abcdefghijk', // Letters
        '23800138000', // Not starting with 1
        '00000000000', // Not starting with 1
        '1234567890a', // Contains letter
        '02345678901', // Starts with 0
      ];

      for (final phone in invalidPhones) {
        final result = PhoneValidator.validatePhone(phone);
        expect(
          result,
          isNotNull,
          reason: 'Invalid phone $phone should fail validation',
        );

        expect(
          PhoneValidator.isValidPhone(phone),
          false,
          reason: 'isValidPhone should return false for $phone',
        );
      }
    });

    test('null and empty values fail validation', () {
      expect(
        PhoneValidator.validatePhone(null),
        isNotNull,
        reason: 'Null should fail validation',
      );

      expect(
        PhoneValidator.validatePhone(''),
        isNotNull,
        reason: 'Empty string should fail validation',
      );

      expect(
        PhoneValidator.isValidPhone(null),
        false,
        reason: 'isValidPhone should return false for null',
      );

      expect(
        PhoneValidator.isValidPhone(''),
        false,
        reason: 'isValidPhone should return false for empty string',
      );
    });

    test('validation consistency across 100 iterations', () {
      for (int i = 0; i < 100; i++) {
        // Generate valid phone (starts with 1, 11 digits)
        final validPhone = '138${i.toString().padLeft(8, '0')}';
        expect(
          PhoneValidator.isValidPhone(validPhone),
          true,
          reason: 'Generated valid phone should pass at iteration $i',
        );

        // Generate invalid phone (too short)
        final invalidPhone = '138${i.toString().padLeft(7, '0')}';
        expect(
          PhoneValidator.isValidPhone(invalidPhone),
          false,
          reason: 'Generated invalid phone should fail at iteration $i',
        );
      }
    });

    test('phone numbers with spaces are handled', () {
      final phonesWithSpaces = [
        '138 0013 8000',
        '159 1234 5678',
        ' 18888888888',
        '17700000000 ',
      ];

      for (final phone in phonesWithSpaces) {
        final result = PhoneValidator.validatePhone(phone);
        // After removing spaces, these should be valid
        final cleanPhone = phone.replaceAll(' ', '');
        final expected = cleanPhone.length == 11 &&
            RegExp(r'^\d{11}$').hasMatch(cleanPhone) &&
            cleanPhone.startsWith('1');

        if (expected) {
          expect(
            result,
            isNull,
            reason: 'Phone with spaces $phone should pass after cleaning',
          );
        }
      }
    });

    test('validation error messages are appropriate', () {
      expect(
        PhoneValidator.validatePhone(''),
        equals('请输入手机号'),
        reason: 'Empty phone should return appropriate message',
      );

      expect(
        PhoneValidator.validatePhone('138'),
        equals('请输入有效的手机号'),
        reason: 'Short phone should return appropriate message',
      );

      expect(
        PhoneValidator.validatePhone('abcdefghijk'),
        equals('请输入有效的手机号'),
        reason: 'Non-numeric phone should return appropriate message',
      );

      expect(
        PhoneValidator.validatePhone('23800138000'),
        equals('请输入有效的手机号'),
        reason: 'Phone not starting with 1 should return appropriate message',
      );
    });

    test('all valid Chinese mobile prefixes pass validation', () {
      // Common Chinese mobile prefixes
      final prefixes = [
        '130',
        '131',
        '132',
        '133',
        '134',
        '135',
        '136',
        '137',
        '138',
        '139',
        '145',
        '147',
        '149',
        '150',
        '151',
        '152',
        '153',
        '155',
        '156',
        '157',
        '158',
        '159',
        '162',
        '165',
        '166',
        '167',
        '170',
        '171',
        '172',
        '173',
        '175',
        '176',
        '177',
        '178',
        '180',
        '181',
        '182',
        '183',
        '184',
        '185',
        '186',
        '187',
        '188',
        '189',
        '190',
        '191',
        '192',
        '193',
        '195',
        '196',
        '197',
        '198',
        '199',
      ];

      for (final prefix in prefixes) {
        final phone = '$prefix${12345678.toString().padLeft(8, '0')}';
        expect(
          PhoneValidator.isValidPhone(phone),
          true,
          reason: 'Phone with prefix $prefix should be valid',
        );
      }
    });

    test('validation is deterministic', () {
      final testPhone = '13800138000';

      // Call validation multiple times
      for (int i = 0; i < 10; i++) {
        final result = PhoneValidator.validatePhone(testPhone);
        expect(
          result,
          isNull,
          reason: 'Validation should be consistent across calls',
        );
      }

      final invalidPhone = '138';
      for (int i = 0; i < 10; i++) {
        final result = PhoneValidator.validatePhone(invalidPhone);
        expect(
          result,
          isNotNull,
          reason: 'Invalid phone validation should be consistent',
        );
      }
    });
  });
}

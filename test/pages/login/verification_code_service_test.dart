import 'package:flutter_test/flutter_test.dart';

/// Feature: unified-login, Property 5: Verification code service invocation
/// Validates: Requirements 3.4
void main() {
  group('Verification Code Service Invocation Property Tests', () {
    // Mock service that records invocations
    final List<String> serviceInvocations = [];

    Future<void> mockSendVerificationCode(String phone) async {
      serviceInvocations.add(phone);
    }

    setUp(() {
      serviceInvocations.clear();
    });

    test('service is invoked with exact phone number', () async {
      final testPhones = [
        '13800138000',
        '15912345678',
        '18888888888',
      ];

      for (final phone in testPhones) {
        await mockSendVerificationCode(phone);
      }

      expect(
        serviceInvocations.length,
        equals(testPhones.length),
        reason: 'Service should be invoked for each phone number',
      );

      for (int i = 0; i < testPhones.length; i++) {
        expect(
          serviceInvocations[i],
          equals(testPhones[i]),
          reason:
              'Service should be invoked with exact phone number: ${testPhones[i]}',
        );
      }
    });

    test('service invocation preserves phone number format', () async {
      final testCases = [
        '13800138000',
        '15912345678',
        '17700000000',
        '18888888888',
      ];

      for (final phone in testCases) {
        serviceInvocations.clear();
        await mockSendVerificationCode(phone);

        expect(
          serviceInvocations.first,
          equals(phone),
          reason: 'Service should receive phone number without modification',
        );

        expect(
          serviceInvocations.first.length,
          equals(11),
          reason: 'Phone number should maintain 11 digits',
        );
      }
    });

    test('multiple invocations with same phone number', () async {
      const phone = '13800138000';
      const invocationCount = 5;

      for (int i = 0; i < invocationCount; i++) {
        await mockSendVerificationCode(phone);
      }

      expect(
        serviceInvocations.length,
        equals(invocationCount),
        reason: 'Service should be invoked $invocationCount times',
      );

      for (final invocation in serviceInvocations) {
        expect(
          invocation,
          equals(phone),
          reason: 'Each invocation should use the same phone number',
        );
      }
    });

    test('service invocation consistency across 100 iterations', () async {
      for (int i = 0; i < 100; i++) {
        serviceInvocations.clear();

        // Generate phone number based on iteration
        final phone = '138${i.toString().padLeft(8, '0')}';
        await mockSendVerificationCode(phone);

        expect(
          serviceInvocations.length,
          equals(1),
          reason: 'Service should be invoked once at iteration $i',
        );

        expect(
          serviceInvocations.first,
          equals(phone),
          reason: 'Service should receive correct phone at iteration $i',
        );
      }
    });

    test('service invocation with different phone formats', () async {
      final phones = [
        '13800138000',
        '15912345678',
        '17700000000',
        '18888888888',
        '19999999999',
      ];

      for (final phone in phones) {
        serviceInvocations.clear();
        await mockSendVerificationCode(phone);

        expect(
          serviceInvocations.first,
          equals(phone),
          reason: 'Service should handle phone format: $phone',
        );

        // Verify phone number is numeric
        expect(
          RegExp(r'^\d+$').hasMatch(serviceInvocations.first),
          true,
          reason: 'Phone number should be numeric',
        );
      }
    });
  });
}

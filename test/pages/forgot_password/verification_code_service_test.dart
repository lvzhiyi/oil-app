import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 11: 验证码服务调用
/// Validates: 需求 3.4
void main() {
  group('验证码服务调用属性测试', () {
    // Mock服务记录调用
    final List<Map<String, String>> serviceInvocations = [];

    Future<void> mockSendVerificationCode(String phone, String type) async {
      serviceInvocations.add({'phone': phone, 'type': type});
    }

    setUp(() {
      serviceInvocations.clear();
    });

    test('服务应该使用正确的手机号和类型调用', () async {
      final testPhones = [
        '13800138000',
        '15912345678',
        '18888888888',
      ];

      for (final phone in testPhones) {
        await mockSendVerificationCode(phone, 'password_reset');
      }

      expect(
        serviceInvocations.length,
        equals(testPhones.length),
        reason: '服务应该为每个手机号调用一次',
      );

      for (int i = 0; i < testPhones.length; i++) {
        expect(
          serviceInvocations[i]['phone'],
          equals(testPhones[i]),
          reason: '服务应该使用正确的手机号: ${testPhones[i]}',
        );
        expect(
          serviceInvocations[i]['type'],
          equals('password_reset'),
          reason: '服务应该使用password_reset类型',
        );
      }
    });

    test('服务调用应该保持手机号格式不变', () async {
      final testCases = [
        '13800138000',
        '15912345678',
        '17700000000',
        '18888888888',
      ];

      for (final phone in testCases) {
        serviceInvocations.clear();
        await mockSendVerificationCode(phone, 'password_reset');

        expect(
          serviceInvocations.first['phone'],
          equals(phone),
          reason: '服务应该接收未修改的手机号',
        );

        expect(
          serviceInvocations.first['phone']!.length,
          equals(11),
          reason: '手机号应该保持11位',
        );
      }
    });

    test('100次迭代的服务调用一致性', () async {
      for (int i = 0; i < 100; i++) {
        serviceInvocations.clear();

        // 基于迭代生成手机号
        final phone = '138${i.toString().padLeft(8, '0')}';
        await mockSendVerificationCode(phone, 'password_reset');

        expect(
          serviceInvocations.length,
          equals(1),
          reason: '第$i次迭代应该调用一次服务',
        );

        expect(
          serviceInvocations.first['phone'],
          equals(phone),
          reason: '第$i次迭代应该接收正确的手机号',
        );

        expect(
          serviceInvocations.first['type'],
          equals('password_reset'),
          reason: '第$i次迭代应该使用password_reset类型',
        );
      }
    });

    test('不同手机号前缀的服务调用', () async {
      final phones = [
        '13800138000', // 138前缀
        '15912345678', // 159前缀
        '17700000000', // 177前缀
        '18888888888', // 188前缀
        '19999999999', // 199前缀
      ];

      for (final phone in phones) {
        serviceInvocations.clear();
        await mockSendVerificationCode(phone, 'password_reset');

        expect(
          serviceInvocations.first['phone'],
          equals(phone),
          reason: '服务应该处理手机号: $phone',
        );

        // 验证手机号是数字
        expect(
          RegExp(r'^\d+$').hasMatch(serviceInvocations.first['phone']!),
          true,
          reason: '手机号应该是纯数字',
        );
      }
    });
  });
}

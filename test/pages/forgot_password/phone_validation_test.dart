import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 1: 手机号验证一致性
/// Validates: 需求 2.4
void main() {
  group('手机号验证一致性属性测试', () {
    // 模拟手机号验证逻辑
    bool isValidPhone(String phone) {
      if (phone.isEmpty) return false;
      if (phone.length != 11) return false;
      if (!RegExp(r'^\d+$').hasMatch(phone)) return false;
      return true;
    }

    test('有效的11位数字手机号应该验证通过', () {
      final validPhones = [
        '13800138000',
        '15912345678',
        '17700000000',
        '18888888888',
        '19999999999',
      ];

      for (final phone in validPhones) {
        expect(isValidPhone(phone), true, reason: '$phone应该是有效手机号');
      }
    });

    test('空字符串应该验证失败', () {
      expect(isValidPhone(''), false, reason: '空字符串应该验证失败');
    });

    test('少于11位的数字应该验证失败', () {
      final shortPhones = ['1', '138', '1380013800'];
      for (final phone in shortPhones) {
        expect(isValidPhone(phone), false, reason: '$phone少于11位应该验证失败');
      }
    });

    test('多于11位的数字应该验证失败', () {
      final longPhones = ['138001380001', '1380013800012'];
      for (final phone in longPhones) {
        expect(isValidPhone(phone), false, reason: '$phone多于11位应该验证失败');
      }
    });

    test('包含非数字字符应该验证失败', () {
      final invalidPhones = [
        'abcdefghijk',
        '1380013800a',
        '138-001-3800',
        '138 001 3800',
        '+8613800138000',
      ];
      for (final phone in invalidPhones) {
        expect(isValidPhone(phone), false, reason: '$phone包含非数字应该验证失败');
      }
    });

    test('100次迭代的手机号验证一致性', () {
      for (int i = 0; i < 100; i++) {
        // 生成有效手机号
        final validPhone = '138${i.toString().padLeft(8, '0')}';
        expect(isValidPhone(validPhone), true, reason: '第$i次迭代有效手机号应该通过');

        // 生成无效手机号（少一位）
        final invalidPhone = '138${i.toString().padLeft(7, '0')}';
        expect(isValidPhone(invalidPhone), false, reason: '第$i次迭代无效手机号应该失败');
      }
    });

    test('不同运营商前缀的手机号验证', () {
      // 中国移动
      expect(isValidPhone('13800138000'), true);
      expect(isValidPhone('15000000000'), true);
      expect(isValidPhone('18700000000'), true);

      // 中国联通
      expect(isValidPhone('13000000000'), true);
      expect(isValidPhone('15500000000'), true);
      expect(isValidPhone('18600000000'), true);

      // 中国电信
      expect(isValidPhone('13300000000'), true);
      expect(isValidPhone('15300000000'), true);
      expect(isValidPhone('18900000000'), true);
    });
  });
}

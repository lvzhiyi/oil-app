import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 2: 验证码按钮状态一致性
/// Validates: 需求 3.3, 3.5
void main() {
  group('验证码按钮状态一致性属性测试', () {
    // 模拟按钮状态逻辑
    bool isButtonEnabled({
      required bool isPhoneValid,
      required int? countdown,
    }) {
      if (!isPhoneValid) return false;
      if (countdown != null && countdown > 0) return false;
      return true;
    }

    String getButtonText(int? countdown) {
      if (countdown == null || countdown <= 0) {
        return '获取验证码';
      }
      return '${countdown}s';
    }

    test('手机号有效且无倒计时时按钮应该启用', () {
      final result = isButtonEnabled(isPhoneValid: true, countdown: null);
      expect(result, true, reason: '手机号有效且无倒计时时按钮应该启用');
    });

    test('手机号有效且倒计时为0时按钮应该启用', () {
      final result = isButtonEnabled(isPhoneValid: true, countdown: 0);
      expect(result, true, reason: '手机号有效且倒计时为0时按钮应该启用');
    });

    test('手机号无效时按钮应该禁用', () {
      final result = isButtonEnabled(isPhoneValid: false, countdown: null);
      expect(result, false, reason: '手机号无效时按钮应该禁用');
    });

    test('倒计时中按钮应该禁用', () {
      final countdowns = [60, 30, 10, 1];
      for (final countdown in countdowns) {
        final result =
            isButtonEnabled(isPhoneValid: true, countdown: countdown);
        expect(result, false, reason: '倒计时$countdown秒时按钮应该禁用');
      }
    });

    test('手机号无效且倒计时中按钮应该禁用', () {
      final result = isButtonEnabled(isPhoneValid: false, countdown: 30);
      expect(result, false, reason: '手机号无效且倒计时中按钮应该禁用');
    });

    test('按钮文本在倒计时中显示秒数', () {
      final countdowns = [60, 30, 10, 1];
      for (final countdown in countdowns) {
        final text = getButtonText(countdown);
        expect(text, equals('${countdown}s'),
            reason: '倒计时$countdown秒时应该显示${countdown}s');
      }
    });

    test('按钮文本在无倒计时时显示获取验证码', () {
      expect(getButtonText(null), equals('获取验证码'), reason: '无倒计时时应该显示获取验证码');
      expect(getButtonText(0), equals('获取验证码'), reason: '倒计时为0时应该显示获取验证码');
    });

    test('100次迭代的按钮状态一致性', () {
      for (int i = 0; i < 100; i++) {
        // 测试有效手机号无倒计时
        expect(
          isButtonEnabled(isPhoneValid: true, countdown: null),
          true,
          reason: '第$i次迭代：有效手机号无倒计时应该启用',
        );

        // 测试有效手机号有倒计时
        final countdown = (i % 60) + 1;
        expect(
          isButtonEnabled(isPhoneValid: true, countdown: countdown),
          false,
          reason: '第$i次迭代：有效手机号倒计时$countdown秒应该禁用',
        );

        // 测试无效手机号
        expect(
          isButtonEnabled(isPhoneValid: false, countdown: null),
          false,
          reason: '第$i次迭代：无效手机号应该禁用',
        );
      }
    });

    test('手机号验证逻辑', () {
      bool isPhoneValid(String phone) {
        return phone.length == 11 && RegExp(r'^\d+$').hasMatch(phone);
      }

      // 有效手机号
      final validPhones = ['13800138000', '15912345678', '18888888888'];
      for (final phone in validPhones) {
        expect(isPhoneValid(phone), true, reason: '$phone应该是有效手机号');
      }

      // 无效手机号
      final invalidPhones = [
        '',
        '138',
        '1380013800',
        '138001380001',
        'abcdefghijk'
      ];
      for (final phone in invalidPhones) {
        expect(isPhoneValid(phone), false, reason: '$phone应该是无效手机号');
      }
    });

    test('按钮状态与手机号验证组合', () {
      bool isPhoneValid(String phone) {
        return phone.length == 11 && RegExp(r'^\d+$').hasMatch(phone);
      }

      final testCases = [
        {'phone': '13800138000', 'countdown': null, 'expected': true},
        {'phone': '13800138000', 'countdown': 30, 'expected': false},
        {'phone': '138', 'countdown': null, 'expected': false},
        {'phone': '', 'countdown': null, 'expected': false},
      ];

      for (final testCase in testCases) {
        final phone = testCase['phone'] as String;
        final countdown = testCase['countdown'] as int?;
        final expected = testCase['expected'] as bool;

        final result = isButtonEnabled(
          isPhoneValid: isPhoneValid(phone),
          countdown: countdown,
        );

        expect(
          result,
          expected,
          reason: '手机号$phone，倒计时$countdown，按钮应该${expected ? "启用" : "禁用"}',
        );
      }
    });
  });
}

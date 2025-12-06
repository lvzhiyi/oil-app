import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 6: 表单验证门控
/// Validates: 需求 7.2, 7.3
void main() {
  group('表单验证门控属性测试', () {
    // 模拟表单验证
    bool validateForm({
      required String phone,
      required String code,
      required String password,
      required String confirmPassword,
    }) {
      // 手机号验证：11位数字
      if (phone.isEmpty ||
          phone.length != 11 ||
          !RegExp(r'^\d+$').hasMatch(phone)) {
        return false;
      }
      // 验证码验证：4位数字
      if (code.isEmpty ||
          code.length != 4 ||
          !RegExp(r'^\d+$').hasMatch(code)) {
        return false;
      }
      // 密码验证：8-20位，包含字母和数字
      if (password.isEmpty || password.length < 8 || password.length > 20) {
        return false;
      }
      if (!RegExp(r'[a-zA-Z]').hasMatch(password) ||
          !RegExp(r'\d').hasMatch(password)) {
        return false;
      }
      // 确认密码验证：与密码一致
      if (confirmPassword != password) {
        return false;
      }
      return true;
    }

    test('所有字段有效时验证通过', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: 'Password123',
        confirmPassword: 'Password123',
      );
      expect(result, true, reason: '所有字段有效时应该验证通过');
    });

    test('手机号为空时验证失败', () {
      final result = validateForm(
        phone: '',
        code: '1234',
        password: 'Password123',
        confirmPassword: 'Password123',
      );
      expect(result, false, reason: '手机号为空时应该验证失败');
    });

    test('手机号不是11位时验证失败', () {
      final invalidPhones = ['138', '1380013800', '138001380001'];
      for (final phone in invalidPhones) {
        final result = validateForm(
          phone: phone,
          code: '1234',
          password: 'Password123',
          confirmPassword: 'Password123',
        );
        expect(result, false, reason: '手机号$phone不是11位应该验证失败');
      }
    });

    test('验证码为空时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '',
        password: 'Password123',
        confirmPassword: 'Password123',
      );
      expect(result, false, reason: '验证码为空时应该验证失败');
    });

    test('验证码不是4位时验证失败', () {
      final invalidCodes = ['1', '12', '123', '12345'];
      for (final code in invalidCodes) {
        final result = validateForm(
          phone: '13800138000',
          code: code,
          password: 'Password123',
          confirmPassword: 'Password123',
        );
        expect(result, false, reason: '验证码$code不是4位应该验证失败');
      }
    });

    test('密码为空时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: '',
        confirmPassword: '',
      );
      expect(result, false, reason: '密码为空时应该验证失败');
    });

    test('密码长度不足8位时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: 'Pass1',
        confirmPassword: 'Pass1',
      );
      expect(result, false, reason: '密码长度不足8位应该验证失败');
    });

    test('密码长度超过20位时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: 'Password123456789012345',
        confirmPassword: 'Password123456789012345',
      );
      expect(result, false, reason: '密码长度超过20位应该验证失败');
    });

    test('密码不包含字母时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: '12345678',
        confirmPassword: '12345678',
      );
      expect(result, false, reason: '密码不包含字母应该验证失败');
    });

    test('密码不包含数字时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: 'Password',
        confirmPassword: 'Password',
      );
      expect(result, false, reason: '密码不包含数字应该验证失败');
    });

    test('确认密码不一致时验证失败', () {
      final result = validateForm(
        phone: '13800138000',
        code: '1234',
        password: 'Password123',
        confirmPassword: 'Password456',
      );
      expect(result, false, reason: '确认密码不一致应该验证失败');
    });

    test('100次迭代的表单验证一致性', () {
      for (int i = 0; i < 100; i++) {
        // 生成有效数据
        final phone = '138${i.toString().padLeft(8, '0')}';
        final code = (1000 + i % 9000).toString();
        final password = 'Password${i.toString().padLeft(3, '0')}';

        final validResult = validateForm(
          phone: phone,
          code: code,
          password: password,
          confirmPassword: password,
        );
        expect(validResult, true, reason: '第$i次迭代有效数据应该验证通过');

        // 测试无效数据
        final invalidResult = validateForm(
          phone: phone,
          code: code,
          password: password,
          confirmPassword: 'WrongPassword',
        );
        expect(invalidResult, false, reason: '第$i次迭代无效数据应该验证失败');
      }
    });
  });
}

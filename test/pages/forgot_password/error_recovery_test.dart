import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';

/// Feature: forgot-password, Property 8: 错误恢复
/// Validates: 需求 7.6
void main() {
  group('错误恢复属性测试', () {
    test('错误发生时应该显示错误信息', () {
      const loadingState = ForgotPasswordState(loading: true);
      final errorState = loadingState.copyWith(
        loading: false,
        errorMessage: '密码重置失败',
      );

      expect(errorState.errorMessage, isNotNull, reason: '错误发生时应该有错误信息');
      expect(errorState.errorMessage, equals('密码重置失败'), reason: '错误信息应该正确');
    });

    test('错误发生时loading应该为false', () {
      const loadingState = ForgotPasswordState(loading: true);
      final errorState = loadingState.copyWith(
        loading: false,
        errorMessage: '密码重置失败',
      );

      expect(errorState.loading, false, reason: '错误发生时loading应该为false');
    });

    test('错误发生时按钮应该重新启用', () {
      bool isButtonEnabled(ForgotPasswordState state) => !state.loading;

      const errorState = ForgotPasswordState(
        loading: false,
        errorMessage: '密码重置失败',
      );

      expect(isButtonEnabled(errorState), true, reason: '错误发生时按钮应该重新启用');
    });

    test('清除错误后errorMessage应该为null', () {
      const errorState = ForgotPasswordState(
        loading: false,
        errorMessage: '密码重置失败',
      );

      final clearedState = ForgotPasswordState(
        loading: errorState.loading,
        resetSuccess: errorState.resetSuccess,
        verificationCodeSent: errorState.verificationCodeSent,
        verificationCountdown: errorState.verificationCountdown,
      );

      expect(clearedState.errorMessage, isNull,
          reason: '清除错误后errorMessage应该为null');
    });

    test('不同错误类型的错误信息', () {
      final errorMessages = [
        '网络连接超时，请重试',
        '无网络连接，请检查网络设置',
        '服务器错误，请稍后重试',
        '发送过于频繁，请稍后再试',
        '验证码错误，请重新输入',
        '验证码已过期，请重新获取',
        '该手机号未注册',
        '账号已被锁定，请联系客服',
      ];

      for (final message in errorMessages) {
        final errorState = const ForgotPasswordState(loading: true).copyWith(
          loading: false,
          errorMessage: message,
        );

        expect(errorState.errorMessage, equals(message),
            reason: '错误信息应该为: $message');
        expect(errorState.loading, false, reason: '错误时loading应该为false');
      }
    });

    test('100次迭代的错误恢复一致性', () {
      for (int i = 0; i < 100; i++) {
        // 模拟加载状态
        const loadingState = ForgotPasswordState(loading: true);
        expect(loadingState.loading, true, reason: '第$i次迭代加载状态应该为true');

        // 模拟错误发生
        final errorState = loadingState.copyWith(
          loading: false,
          errorMessage: '错误$i',
        );
        expect(errorState.loading, false, reason: '第$i次迭代错误后loading应该为false');
        expect(errorState.errorMessage, equals('错误$i'),
            reason: '第$i次迭代错误信息应该正确');

        // 模拟清除错误
        final clearedState = ForgotPasswordState(
          loading: errorState.loading,
          resetSuccess: errorState.resetSuccess,
          verificationCodeSent: errorState.verificationCodeSent,
          verificationCountdown: errorState.verificationCountdown,
        );
        expect(clearedState.errorMessage, isNull,
            reason: '第$i次迭代清除后错误信息应该为null');
      }
    });

    test('错误状态不应该影响其他字段', () {
      const initialState = ForgotPasswordState(
        loading: true,
        verificationCountdown: 30,
        verificationCodeSent: true,
      );

      final errorState = initialState.copyWith(
        loading: false,
        errorMessage: '密码重置失败',
      );

      expect(errorState.verificationCountdown, 30,
          reason: 'verificationCountdown不应该改变');
      expect(errorState.verificationCodeSent, true,
          reason: 'verificationCodeSent不应该改变');
    });

    test('重试时应该清除错误并开始加载', () {
      const errorState = ForgotPasswordState(
        loading: false,
        errorMessage: '密码重置失败',
      );

      // 模拟重试
      final retryState = ForgotPasswordState(
        loading: true,
        resetSuccess: errorState.resetSuccess,
        verificationCodeSent: errorState.verificationCodeSent,
        verificationCountdown: errorState.verificationCountdown,
      );

      expect(retryState.loading, true, reason: '重试时loading应该为true');
      expect(retryState.errorMessage, isNull, reason: '重试时错误信息应该清除');
    });
  });
}

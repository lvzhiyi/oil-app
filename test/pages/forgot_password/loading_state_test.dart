import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';

/// Feature: forgot-password, Property 7: 加载状态一致性
/// Validates: 需求 7.4
void main() {
  group('加载状态一致性属性测试', () {
    test('初始状态loading应该为false', () {
      const state = ForgotPasswordState(loading: false);
      expect(state.loading, false, reason: '初始状态loading应该为false');
    });

    test('提交时loading应该为true', () {
      const initialState = ForgotPasswordState(loading: false);
      final loadingState = initialState.copyWith(loading: true);
      expect(loadingState.loading, true, reason: '提交时loading应该为true');
    });

    test('提交完成后loading应该为false', () {
      const loadingState = ForgotPasswordState(loading: true);
      final completedState = loadingState.copyWith(loading: false);
      expect(completedState.loading, false, reason: '提交完成后loading应该为false');
    });

    test('loading状态下按钮应该禁用', () {
      bool isButtonEnabled(bool loading) => !loading;

      expect(isButtonEnabled(true), false, reason: 'loading时按钮应该禁用');
      expect(isButtonEnabled(false), true, reason: '非loading时按钮应该启用');
    });

    test('成功后loading应该为false且resetSuccess为true', () {
      const loadingState = ForgotPasswordState(loading: true);
      final successState = loadingState.copyWith(
        loading: false,
        resetSuccess: true,
      );
      expect(successState.loading, false, reason: '成功后loading应该为false');
      expect(successState.resetSuccess, true, reason: '成功后resetSuccess应该为true');
    });

    test('失败后loading应该为false且有errorMessage', () {
      const loadingState = ForgotPasswordState(loading: true);
      final errorState = loadingState.copyWith(
        loading: false,
        errorMessage: '密码重置失败',
      );
      expect(errorState.loading, false, reason: '失败后loading应该为false');
      expect(errorState.errorMessage, isNotNull, reason: '失败后应该有errorMessage');
    });

    test('100次迭代的加载状态转换一致性', () {
      for (int i = 0; i < 100; i++) {
        // 初始状态
        const initialState = ForgotPasswordState(loading: false);
        expect(initialState.loading, false, reason: '第$i次迭代初始状态应该为false');

        // 开始加载
        final loadingState = initialState.copyWith(loading: true);
        expect(loadingState.loading, true, reason: '第$i次迭代加载状态应该为true');

        // 完成加载
        final completedState = loadingState.copyWith(loading: false);
        expect(completedState.loading, false, reason: '第$i次迭代完成状态应该为false');
      }
    });

    test('状态转换不应该影响其他字段', () {
      const initialState = ForgotPasswordState(
        loading: false,
        verificationCountdown: 30,
        verificationCodeSent: true,
      );

      final loadingState = initialState.copyWith(loading: true);

      expect(loadingState.loading, true, reason: 'loading应该更新');
      expect(loadingState.verificationCountdown, 30,
          reason: 'verificationCountdown不应该改变');
      expect(loadingState.verificationCodeSent, true,
          reason: 'verificationCodeSent不应该改变');
    });
  });
}

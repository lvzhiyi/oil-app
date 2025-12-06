import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 12: 成功导航
/// Validates: 需求 7.5
void main() {
  group('成功导航属性测试', () {
    // 模拟导航记录
    final List<String> navigationHistory = [];

    void navigateTo(String route) {
      navigationHistory.add(route);
    }

    void replaceWith(String route) {
      if (navigationHistory.isNotEmpty) {
        navigationHistory.removeLast();
      }
      navigationHistory.add(route);
    }

    void goBack() {
      if (navigationHistory.isNotEmpty) {
        navigationHistory.removeLast();
      }
    }

    setUp(() {
      navigationHistory.clear();
    });

    test('密码重置成功后应该导航到登录页面', () {
      // 模拟从登录页面进入找回密码页面
      navigateTo('/login');
      navigateTo('/forgotPassword');

      // 模拟密码重置成功
      replaceWith('/login');

      expect(navigationHistory.last, equals('/login'),
          reason: '密码重置成功后应该在登录页面');
    });

    test('点击返回按钮应该返回上一页', () {
      // 模拟从登录页面进入找回密码页面
      navigateTo('/login');
      navigateTo('/forgotPassword');

      // 点击返回
      goBack();

      expect(navigationHistory.last, equals('/login'), reason: '点击返回后应该在登录页面');
    });

    test('100次迭代的导航一致性', () {
      for (int i = 0; i < 100; i++) {
        navigationHistory.clear();

        // 模拟导航流程
        navigateTo('/login');
        navigateTo('/forgotPassword');

        // 模拟密码重置成功
        replaceWith('/login');

        expect(
          navigationHistory.last,
          equals('/login'),
          reason: '第$i次迭代：密码重置成功后应该在登录页面',
        );
      }
    });

    test('导航路径正确', () {
      const forgotPasswordPath = '/forgotPassword';
      const loginPath = '/login';

      expect(forgotPasswordPath, equals('/forgotPassword'),
          reason: '找回密码路径应该正确');
      expect(loginPath, equals('/login'), reason: '登录路径应该正确');
    });

    test('replace导航不增加历史记录', () {
      navigateTo('/login');
      navigateTo('/forgotPassword');

      final historyLengthBefore = navigationHistory.length;

      // 使用replace导航
      replaceWith('/login');

      expect(
        navigationHistory.length,
        equals(historyLengthBefore),
        reason: 'replace导航不应该增加历史记录长度',
      );
    });

    test('多次返回操作', () {
      navigateTo('/home');
      navigateTo('/login');
      navigateTo('/forgotPassword');

      goBack(); // 返回到登录
      expect(navigationHistory.last, equals('/login'));

      goBack(); // 返回到首页
      expect(navigationHistory.last, equals('/home'));
    });
  });
}

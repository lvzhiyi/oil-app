import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oil_business_app/resources/colors.dart';

/// Property 3: Theme color value correctness
/// Validates: Requirements 1.1, 1.2, 1.3
void main() {
  group('AppColor - 琥珀金主题颜色常量测试', () {
    test('primaryColor 应该是深琥珀色 #D97706', () {
      expect(AppColor.primaryColor, equals(const Color(0xFFD97706)));
    });

    test('secondaryColor 应该是极浅黄色 #FFFBEB', () {
      expect(AppColor.secondaryColor, equals(const Color(0xFFFFFBEB)));
    });

    test('accentColor 应该是Logo呼应色 #F59E0B', () {
      expect(AppColor.accentColor, equals(const Color(0xFFF59E0B)));
    });

    test('primaryLight 应该是明亮琥珀色 #F59E0B', () {
      expect(AppColor.primaryLight, equals(const Color(0xFFF59E0B)));
    });

    test('primaryDark 应该是深琥珀色 #B45309', () {
      expect(AppColor.primaryDark, equals(const Color(0xFFB45309)));
    });

    test('secondaryLight 应该是浅黄色 #FEF3C7', () {
      expect(AppColor.secondaryLight, equals(const Color(0xFFFEF3C7)));
    });
  });

  group('AppColor - Legacy颜色别名一致性测试', () {
    /// Property 1: Legacy color alias consistency
    /// Validates: Requirements 5.1, 5.2, 5.3, 5.4, 6.4

    test('btnPurple 应该指向 primaryColor', () {
      expect(AppColor.btnPurple, equals(AppColor.primaryColor));
    });

    test('txtPurple 应该指向 accentColor', () {
      expect(AppColor.txtPurple, equals(AppColor.accentColor));
    });

    test('borderPurple 应该指向 primaryColor', () {
      expect(AppColor.borderPurple, equals(AppColor.primaryColor));
    });

    test('icPurple 应该指向 accentColor', () {
      expect(AppColor.icPurple, equals(AppColor.accentColor));
    });
  });

  group('AppColor - 油品颜色主题测试', () {
    test('dieselBg 应该是浅黄色 #FEF3C7', () {
      expect(AppColor.dieselBg, equals(const Color(0xFFFEF3C7)));
    });

    test('dieselText 应该是深琥珀色 #B45309', () {
      expect(AppColor.dieselText, equals(const Color(0xFFB45309)));
    });

    test('gasText 应该是Logo呼应色 #F59E0B', () {
      expect(AppColor.gasText, equals(const Color(0xFFF59E0B)));
    });
  });
}

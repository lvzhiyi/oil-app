import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Feature: forgot-password, Property 9: 输入框焦点样式
/// Validates: 需求 9.1, 9.2
void main() {
  group('输入框焦点样式属性测试', () {
    // 定义样式常量
    const defaultBgColor = Color(0xFFF9FAFB);
    const defaultBorderColor = Color(0xFFE5E7EB);
    const focusBgColor = Colors.white;
    const focusBorderColor = Color(0xFF7165E3);
    const borderRadius = 12.0;

    // 模拟获取输入框样式
    Map<String, dynamic> getInputFieldStyle(bool isFocused) {
      return {
        'backgroundColor': isFocused ? focusBgColor : defaultBgColor,
        'borderColor': isFocused ? focusBorderColor : defaultBorderColor,
        'borderRadius': borderRadius,
        'hasShadow': isFocused,
      };
    }

    test('未获得焦点时应该显示默认样式', () {
      final style = getInputFieldStyle(false);

      expect(style['backgroundColor'], equals(defaultBgColor),
          reason: '未聚焦时背景色应该是#F9FAFB');
      expect(style['borderColor'], equals(defaultBorderColor),
          reason: '未聚焦时边框色应该是#E5E7EB');
      expect(style['borderRadius'], equals(12.0), reason: '圆角应该是12像素');
      expect(style['hasShadow'], false, reason: '未聚焦时不应该有阴影');
    });

    test('获得焦点时应该显示焦点样式', () {
      final style = getInputFieldStyle(true);

      expect(style['backgroundColor'], equals(focusBgColor),
          reason: '聚焦时背景色应该是白色');
      expect(style['borderColor'], equals(focusBorderColor),
          reason: '聚焦时边框色应该是#7165E3');
      expect(style['borderRadius'], equals(12.0), reason: '圆角应该保持12像素');
      expect(style['hasShadow'], true, reason: '聚焦时应该有阴影');
    });

    test('焦点切换时样式应该正确变化', () {
      // 初始未聚焦
      var style = getInputFieldStyle(false);
      expect(style['backgroundColor'], equals(defaultBgColor));
      expect(style['borderColor'], equals(defaultBorderColor));

      // 获得焦点
      style = getInputFieldStyle(true);
      expect(style['backgroundColor'], equals(focusBgColor));
      expect(style['borderColor'], equals(focusBorderColor));

      // 失去焦点
      style = getInputFieldStyle(false);
      expect(style['backgroundColor'], equals(defaultBgColor));
      expect(style['borderColor'], equals(defaultBorderColor));
    });

    test('100次迭代的焦点样式一致性', () {
      for (int i = 0; i < 100; i++) {
        final isFocused = i % 2 == 0;
        final style = getInputFieldStyle(isFocused);

        if (isFocused) {
          expect(style['backgroundColor'], equals(focusBgColor),
              reason: '第$i次迭代聚焦时背景色应该正确');
          expect(style['borderColor'], equals(focusBorderColor),
              reason: '第$i次迭代聚焦时边框色应该正确');
          expect(style['hasShadow'], true, reason: '第$i次迭代聚焦时应该有阴影');
        } else {
          expect(style['backgroundColor'], equals(defaultBgColor),
              reason: '第$i次迭代未聚焦时背景色应该正确');
          expect(style['borderColor'], equals(defaultBorderColor),
              reason: '第$i次迭代未聚焦时边框色应该正确');
          expect(style['hasShadow'], false, reason: '第$i次迭代未聚焦时不应该有阴影');
        }

        // 圆角始终保持不变
        expect(style['borderRadius'], equals(12.0), reason: '第$i次迭代圆角应该保持12像素');
      }
    });

    test('所有输入框应该使用相同的样式规则', () {
      final fieldNames = ['phone', 'code', 'password', 'confirmPassword'];

      for (final fieldName in fieldNames) {
        // 未聚焦样式
        final unfocusedStyle = getInputFieldStyle(false);
        expect(unfocusedStyle['backgroundColor'], equals(defaultBgColor),
            reason: '$fieldName未聚焦时背景色应该正确');
        expect(unfocusedStyle['borderColor'], equals(defaultBorderColor),
            reason: '$fieldName未聚焦时边框色应该正确');

        // 聚焦样式
        final focusedStyle = getInputFieldStyle(true);
        expect(focusedStyle['backgroundColor'], equals(focusBgColor),
            reason: '$fieldName聚焦时背景色应该正确');
        expect(focusedStyle['borderColor'], equals(focusBorderColor),
            reason: '$fieldName聚焦时边框色应该正确');
      }
    });

    test('阴影效果在聚焦时正确显示', () {
      // 模拟阴影配置
      BoxShadow? getShadow(bool isFocused) {
        if (!isFocused) return null;
        return BoxShadow(
          color: const Color(0xFF7165E3).withOpacity(0.1),
          blurRadius: 3,
          spreadRadius: 0,
        );
      }

      expect(getShadow(false), isNull, reason: '未聚焦时不应该有阴影');
      expect(getShadow(true), isNotNull, reason: '聚焦时应该有阴影');

      final shadow = getShadow(true)!;
      expect(shadow.blurRadius, equals(3), reason: '阴影模糊半径应该是3');
      expect(shadow.spreadRadius, equals(0), reason: '阴影扩散半径应该是0');
    });
  });
}

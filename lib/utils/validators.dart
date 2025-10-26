/// 密码格式校验器
class PasswordValidator {
  /// 校验密码格式：8-16位，包含大写字母、小写字母、数字和特殊字符
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入你的密码';
    }

    // 长度校验：8-16位
    if (value.length < 8 || value.length > 16) {
      return '密码长度必须为8-16位';
    }

    // 大写字母校验
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '密码必须包含大写字母';
    }

    // 小写字母校验
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return '密码必须包含小写字母';
    }

    // 数字校验
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '密码必须包含数字';
    }

    // 特殊字符校验
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(value)) {
      return '密码必须包含特殊字符';
    }

    return null; // 校验通过
  }

  /// 获取密码强度文本
  static String getPasswordStrengthText(String password) {
    if (password.isEmpty) return '';

    int score = 0;

    // 长度评分
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // 字符类型评分
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(password)) {
      score++;
    }

    if (score < 3) return '弱';
    if (score < 5) return '中';
    return '强';
  }

  /// 检查密码是否符合完整格式要求
  static bool isPasswordValid(String password) {
    return validatePassword(password) == null;
  }
}

/// 手机号校验器
class PhoneValidator {
  /// 校验中国大陆手机号
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入你的手机号码';
    }

    // 中国大陆手机号正则表达式
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
      return '请输入正确的手机号';
    }

    return null; // 校验通过
  }
}

/// 验证码验证器
class VerificationCodeValidator {
  /// 验证验证码格式（4位数字）
  static String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }

    // 移除所有空格
    final code = value.replaceAll(' ', '');

    // 检查长度（必须为4位）
    if (code.length < 4) {
      return '验证码长度不足';
    }

    if (code.length > 4) {
      return '验证码长度过长';
    }

    // 检查是否全为数字
    if (!RegExp(r'^\d+$').hasMatch(code)) {
      return '验证码只能包含数字';
    }

    return null;
  }

  /// 检查验证码是否有效（返回布尔值）
  static bool isValidCode(String? value) {
    return validateCode(value) == null;
  }
}

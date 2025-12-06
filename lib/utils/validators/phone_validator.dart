/// 手机号验证器
class PhoneValidator {
  /// 验证中国手机号格式（11位数字）
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }

    // 移除所有空格
    final phone = value.replaceAll(' ', '');

    // 检查是否为11位数字
    if (phone.length != 11) {
      return '请输入有效的手机号';
    }

    // 检查是否全为数字
    if (!RegExp(r'^\d{11}$').hasMatch(phone)) {
      return '请输入有效的手机号';
    }

    // 检查是否以1开头
    if (!phone.startsWith('1')) {
      return '请输入有效的手机号';
    }

    return null;
  }

  /// 检查手机号是否有效（返回布尔值）
  static bool isValidPhone(String? value) {
    return validatePhone(value) == null;
  }
}

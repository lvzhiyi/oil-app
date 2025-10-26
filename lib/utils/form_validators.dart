/// 表单校验工具类
class FormValidators {
  /// 校验员工姓名
  static String? validateEmployeeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入员工姓名';
    }
    
    final trimmedValue = value.trim();
    if (trimmedValue.length > 20) {
      return '姓名不能超过20个字符';
    }
    
    return null;
  }

  /// 校验手机号
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入手机号';
    }
    
    final trimmedValue = value.trim();
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(trimmedValue)) {
      return '请输入正确的手机号格式';
    }
    
    return null;
  }

  /// 校验密码格式：大小写字母+数字的组合
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入密码';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < 8) {
      return '密码长度不能少于8位';
    }
    
    if (trimmedValue.length > 20) {
      return '密码长度不能超过20位';
    }
    
    // 检查是否包含大写字母
    if (!RegExp(r'[A-Z]').hasMatch(trimmedValue)) {
      return '密码必须包含大写字母';
    }
    
    // 检查是否包含小写字母
    if (!RegExp(r'[a-z]').hasMatch(trimmedValue)) {
      return '密码必须包含小写字母';
    }
    
    // 检查是否包含数字
    if (!RegExp(r'[0-9]').hasMatch(trimmedValue)) {
      return '密码必须包含数字';
    }
    
    return null;
  }

  /// 校验角色选择
  static String? validateRoles(List<dynamic>? roles) {
    if (roles == null || roles.isEmpty) {
      return '请至少选择一个角色';
    }
    
    return null;
  }
}

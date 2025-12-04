/// 发票信息校验器
class InvoiceValidator {
  /// 校验发票抬头
  static String? validateInvoiceTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入发票抬头';
    }
    return null;
  }

  /// 校验税号
  /// 税号格式：15-20位字母数字组合
  static String? validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入税号';
    }
    // 统一社会信用代码/税号：15-20位字母数字
    if (!RegExp(r'^[A-Za-z0-9]{15,20}$').hasMatch(value)) {
      return '税号格式不正确';
    }
    return null;
  }

  /// 校验开户银行
  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入开户银行';
    }
    return null;
  }

  /// 校验银行账号
  /// 银行账号：纯数字
  static String? validateBankAccount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入银行账号';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '银行账号格式不正确';
    }
    return null;
  }

  /// 校验公司地址
  static String? validateCompanyAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入公司地址';
    }
    return null;
  }

  /// 校验公司电话
  /// 支持手机号和座机号
  static String? validateCompanyPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请输入公司电话';
    }
    // 支持手机号（11位）或座机号（区号-号码格式或纯数字）
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value) &&
        !RegExp(r'^(\d{3,4}-?)?\d{7,8}$').hasMatch(value)) {
      return '电话号码格式不正确';
    }
    return null;
  }

  /// 校验发票类型
  static String? validateInvoiceType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请选择发票类型';
    }
    return null;
  }

  /// 校验所有字段
  static bool validateAll({
    required String invoiceTitle,
    required String taxNumber,
    required String bankName,
    required String bankAccount,
    required String companyAddress,
    required String companyPhone,
    required String invoiceType,
  }) {
    return validateInvoiceTitle(invoiceTitle) == null &&
        validateTaxNumber(taxNumber) == null &&
        validateBankName(bankName) == null &&
        validateBankAccount(bankAccount) == null &&
        validateCompanyAddress(companyAddress) == null &&
        validateCompanyPhone(companyPhone) == null &&
        validateInvoiceType(invoiceType) == null;
  }
}

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottery_app/widgets/popup/toast.dart';

/// 文本处理工具类
class TextUtil {
  ///特殊字符验证
  static bool isSpecialChar(String str) {
    if (str.isEmpty) return false;
    return RegExp(
            r"[_`~!@#$%^&*()+=|{}':;',\[\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t|\s")
        .hasMatch(str);
  }

  ///手机号验证
  static bool isChinaPhoneLegal(String str) {
    if (str.isEmpty) return false;
    return RegExp(r"^1[3-9]\d{9}$").hasMatch(str);
  }

  ///短信验证码验证
  static bool isSMSCode(String str) {
    if (str.isEmpty) return false;
    return RegExp(r"^\d{6}$").hasMatch(str);
  }

  static bool isEmpty(String? text) {
    if (text == null) return true;
    return (text.isEmpty || text.toString() == 'null');
  }

  static bool isNotEmpty(String? text) {
    if (text == null) return false;
    return (text.isNotEmpty);
  }

  ///验证手机号11位
  static bool isPhone(String str) {
    if (TextUtil.isEmpty(str)) {
      return false;
    }
    RegExp exp = RegExp(r'^1\d{10}$');
    return exp.hasMatch(str);
  }

  ///邮箱验证
  static bool isEmail(String? str) {
    if (TextUtil.isEmpty(str) || str == null) {
      return false;
    }
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }

  static bool isNumeric(String? str) {
    if (TextUtil.isEmpty(str) || str == null) return false;
    try {
      double.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }

  static bool isChinese(String str) {
    RegExp reg = RegExp(r"[\u4e00-\u9fa5]+");
    return reg.hasMatch(str);
  }

  static bool isGcash(String? str) {
    if (TextUtil.isEmpty(str)) {
      return false;
    }
    RegExp reg = RegExp(r"^(gcash)$");
    return reg.hasMatch(str!.toLowerCase());
  }

  static bool isMaya(String? str) {
    if (TextUtil.isEmpty(str)) {
      return false;
    }
    RegExp reg = RegExp(r"^(maya|maya2)$");
    return reg.hasMatch(str!.toLowerCase());
  }

  static bool isBank(String? str) {
    if (TextUtil.isEmpty(str)) {
      return false;
    }
    return !isGcash(str!) && !isMaya(str);
  }

  static String formatNumber(double number, {int? digistLength}) {
    String decimal = number.toString().split('.')[1];
    int decimalDigits = decimal == '0' ? 0 : decimal.length;
    return NumberFormat.currency(
            locale: 'en',
            symbol: '',
            decimalDigits: digistLength ?? decimalDigits)
        .format(number);
  }

  /// 将每一节转成对应的英文
  static String mapNumberToEnglish(int number) {
    if (number == 0) {
      return 'Full';
    } else if (number < 1 || number > 20) {
      return 'Invalid Number';
    }

    List<String> numbers = [
      'Full',
      'First',
      'Second',
      'Third',
      'Fourth',
      'Fifth',
      'Sixth',
      'Seventh',
      'Eighth',
      'Ninth',
      'Tenth',
      'Eleventh',
      'Twelfth',
      'Thirteenth',
      'Fourteenth',
      'Fifteenth',
      'Sixteenth',
      'Seventeenth',
      'Eighteenth',
      'Nineteenth',
      'Twentieth'
    ];

    return numbers[number];
  }

  /// 将输入的厘米转成多少英尺和英寸
  static String cmToFeetInches(double cm) {
    double totalInches = cm / 2.54; // 将厘米转换为英寸
    int feet = (totalInches / 12).floor(); // 获取英尺部分
    int inches = (totalInches % 12).round(); // 获取英寸部分
    return '$feet\'$inches"';
  }

  static double maxValue(double a, double b) {
    return a > b ? a : b;
  }

  static double minValue(double a, double b) {
    return a < b ? a : b;
  }

  /// 输入一个任意数字，返回一个11位的字符串数组，带有逗号的
  static List<String> generateFormattedArray(int number) {
    var formattedNumber = number.toString();
    if (formattedNumber.length > 9) {
      formattedNumber = formattedNumber.substring(formattedNumber.length - 9);
    }
    List<String> numberDigits = formattedNumber.split('');
    if (numberDigits.length < 9) {
      int zerosToFill = 9 - numberDigits.length;
      List<String> zeroArray = List.filled(zerosToFill, '0');
      numberDigits = zeroArray + numberDigits;
    }

    List<String> newArray = [];
    int count = -1;

    for (int i = 0; i < 11; i++) {
      count++;
      if (i >= numberDigits.length) {
        break;
      }
      if (i > 0 && i % 3 == 0) {
        newArray.add(',');
        newArray.add(numberDigits[count]);
      } else {
        newArray.add(numberDigits[count]);
      }
    }
    return newArray;
  }

  /// 复制文本
  ///
  /// `text` 要复制的文本
  static Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    SportsToast.show('复制成功', ToastType.success);
  }
}

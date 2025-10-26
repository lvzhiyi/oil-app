String convertToChinese(int number) {
  if (number == 0) {
    return '零';
  }

  List<String> chineseDigits = [
    '零',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
    '七',
    '八',
    '九'
  ];
  List<String> chineseUnits = ['', '十', '百', '千', '万', '十', '百', '千', '亿'];

  String result = '';
  int unitIndex = 0;

  while (number > 0) {
    int digit = number % 10;
    if (digit != 0) {
      result = chineseDigits[digit] + chineseUnits[unitIndex] + result;
    } else {
      if (result.isNotEmpty && result[0] != '零') {
        result = chineseDigits[digit] + result;
      }
    }
    number ~/= 10;
    unitIndex++;
  }

  // 定义正则表达式模式
  RegExp pattern = RegExp('一十');

  // 使用正则表达式替换文本
  result = result.replaceAll(pattern, '十');
  if (result == '二') {
    result = '两';
  }

  return result;
}

String dateToZh(int timestamp) {
  // 将时间戳转换为 DateTime 对象
  DateTime targetDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // 获取当前日期的年、月、日
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;

  // 获取目标日期的年、月、日
  int targetYear = targetDateTime.year;
  int targetMonth = targetDateTime.month;
  int targetDay = targetDateTime.day;

  // 构造当前日期和目标日期的 DateTime 对象
  DateTime currentDateTime = DateTime(currentYear, currentMonth, currentDay);
  DateTime targetDateOnly = DateTime(targetYear, targetMonth, targetDay);

  // 计算两个日期之间的天数差
  int differenceInDays = targetDateOnly.difference(currentDateTime).inDays;

  int days = differenceInDays.abs();
  // int days = difference.inDays;
  if (days < 1) {
    return '今天';
  } else if (days < 7) {
    return '${convertToChinese(days)}天前';
  } else if (days >= 7 && days < 14) {
    return '一周前';
  } else if (days >= 14 && days < 21) {
    return '两周前';
  } else if (days >= 21 && days < 30) {
    return '三周前';
  } else if (days >= 30 && days < 365) {
    return '${convertToChinese(days ~/ 30)}月前';
  } else {
    return '${convertToChinese(days ~/ 365)}年前';
  }
}

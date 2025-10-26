import 'package:intl/intl.dart';

/// 构建时分秒`00:00:00`
String buildHHMMSS(int seconds) {
  int hour = seconds ~/ 3600;
  int minute = (seconds ~/ 60) % 60;
  int second = seconds % 60;
  return "${formatTime(hour)}:${formatTime(minute)}:${formatTime(second)}";
}

/// 构建分秒`00:00:00`
String buildMMSS(int seconds) {
  int minute = seconds ~/ 60;
  int second = seconds % 60;
  return "${formatTime(minute)}:${formatTime(second)}";
}

//数字格式化，将 0~9 的时间转换为 00~09
String formatTime(int timeNum) {
  return timeNum < 10 ? "0$timeNum" : timeNum.toString();
}

/// 日期格式化
/// @param dateTime 日期
/// @param format 格式
/// @return 格式化后的日期
String formatDate(DateTime dateTime, {String format = "yyyy.MM.dd"}) {
  DateFormat dateFormat = DateFormat(format);
  return dateFormat.format(dateTime.toLocal());
}

/// 日期格式化
/// @param timestamp 时间戳毫秒
/// @param format 格式
/// @return 格式化后的日期
String formatDateFromMilliSecond(int timestamp,
    {String format = "dd.MM.yyyy"}) {
  // 将时间戳转换为 DateTime 对象
  DateTime targetDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateFormat dateFormat = DateFormat(format);
  return dateFormat.format(targetDateTime.toLocal());
}

List<String> getRangeDateString({int dateRange = 7, format = 'yyyy-MM-dd'}) {
  return [
    formatDate(DateTime.now().subtract(Duration(days: dateRange)),
        format: '$format 00:00:00Z'),
    formatDate(DateTime.now(), format: '$format 23:59:59Z'),
  ];
}

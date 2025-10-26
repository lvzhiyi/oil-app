library log;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// global log class
final l = _Log._();

/// 日志工具类，
class _Log {
  /// 全局控制，是否允许打印log
  bool enablePrintLog = true;

  /// 允许写日志文件
  bool enableWriteFile = false;

  var printer = PrettyPrinter(
    methodCount: 3, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    dateTimeFormat: DateTimeFormat.none, // Change the format of the DateTime
  );

  _Log._() {
    _logger = Logger(
      filter: ProductionFilter(),
      printer: printer,
    );
    Logger.level = Level.trace;
  }

  late Logger _logger;

  sportsLog(
    Level level,
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    if (!enablePrintLog) return;
    switch (level) {
      case Level.trace:
        _logger.t('$tag#: $message', error: error, stackTrace: stackTrace);
        break;
      case Level.debug:
        _logger.d('$tag#: $message', error: error, stackTrace: stackTrace);
        break;
      case Level.info:
        _logger.i('$tag#: $message', error: error, stackTrace: stackTrace);
        break;
      case Level.warning:
        _logger.w('$tag#: $message', error: error, stackTrace: stackTrace);
        break;
      case Level.error:
        _logger.e('$tag#: $message', error: error, stackTrace: stackTrace);
        break;
      case Level.fatal:
        break;
      case Level.off:
        break;
      case Level.all:
        break;
      // ignore: deprecated_member_use
      case Level.verbose:
      // ignore: deprecated_member_use
      case Level.wtf:
      // ignore: deprecated_member_use
      case Level.nothing:
    }

    if (showApp) {
      if (!kDebugMode) {
        // ignore: avoid_print
        print('$tag#: $message');
      }
    }
    if (showUmi) {
      debugPrint('$tag#: $message');
    }
  }

  void v(
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    sportsLog(
      Level.trace,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      showApp: showApp,
      showUmi: showUmi,
    );
  }

  void d(
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    sportsLog(
      Level.debug,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      showApp: showApp,
      showUmi: showUmi,
    );
  }

  void i(
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    sportsLog(
      Level.info,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      showApp: showApp,
      showUmi: showUmi,
    );
  }

  void w(
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    sportsLog(
      Level.warning,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      showApp: showApp,
      showUmi: showUmi,
    );
  }

  void e(
    String tag,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showApp = false,
    bool showUmi = false,
  }) {
    sportsLog(
      Level.error,
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
      showApp: showApp,
      showUmi: showUmi,
    );
  }
}

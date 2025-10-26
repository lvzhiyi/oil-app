import 'dart:io';
import 'package:flutter/foundation.dart';

class SportsPlatform {
  static bool get isRunInMobile => kReleaseMode && isMobile;

  static bool get isDebug => kDebugMode;
  static bool get isProfile => kProfileMode;
  static bool get isRelease => kReleaseMode;

  static bool get isWeb => kIsWeb;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isIOS => !isWeb && Platform.isIOS;
  static bool get isAndroid => !isWeb && Platform.isAndroid;
}

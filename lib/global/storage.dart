import 'package:hive/hive.dart';

/// 全局存储
class GlobalStorage {
  static late Box<dynamic> sportsSingleton;
  static init() async {
    sportsSingleton = await Hive.openBox('sportsGlobal');
  }

  static int get httpEnv =>
      GlobalStorage.sportsSingleton.get(StorageKey.httpEnv, defaultValue: 3);

  static set httpEnv(int value) =>
      GlobalStorage.sportsSingleton.put(StorageKey.httpEnv, value);

  static String get proxyUri =>
      GlobalStorage.sportsSingleton.get(StorageKey.proxyUri, defaultValue: '');

  static set proxyUri(String value) =>
      GlobalStorage.sportsSingleton.put(StorageKey.proxyUri, value);

  static DateTime? get lastShowVersionTime => GlobalStorage.sportsSingleton
      .get(StorageKey.lastShowVersionTime, defaultValue: null);

  static set lastShowVersionTime(DateTime? value) =>
      GlobalStorage.sportsSingleton.put(StorageKey.lastShowVersionTime, value);
}

class StorageKey {
  static String httpEnv = 'httpenv';
  static String proxyUri = 'proxyUri';
  static String lastShowVersionTime = 'lastShowVersionTime';
}

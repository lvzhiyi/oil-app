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

  /// dio 代理 uri
  static String get dioProxyUri => GlobalStorage.sportsSingleton
      .get(StorageKey.dioProxyUri, defaultValue: '');

  static String get oldVersion => GlobalStorage.sportsSingleton
      .get(StorageKey.oldVersion, defaultValue: '1.0.0');

  /// 是否已经进入过基础信息页面
  static int get hasEnteredBasicInfo => GlobalStorage.sportsSingleton
      .get(StorageKey.hasEnteredBasicInfo, defaultValue: 0);

  static DateTime? get lastShowVersionTime => GlobalStorage.sportsSingleton
      .get(StorageKey.lastShowVersionTime, defaultValue: null);
}

class StorageKey {
  static String httpEnv = 'httpenv';
  static String lastShownTimeKey = 'lastShownTimeKey';
  static String oldVersion = 'oldVersion';
  static String hasEnteredBasicInfo = 'hasEnteredBasicInfo';
  static String lastShowVersionTime = 'lastShowVersionTime';
  static String dioProxyUri = 'dioProxyUri';
}

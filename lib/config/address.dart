import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/config/env.dart';

/// 地址数据
class BaseAddress {
  static bool isMock = false;

  /// 是否使用本地开发模式
  static bool useLocalDev = true; // 设置为true使用本地服务器

  /// 基本的path
  static String baseHost = '';

  /// 远程服务器地址映射
  static Map<HttpEnv, String> envDomainMap = {
    HttpEnv.qa: 'https://test.maiyoubei.com',
    HttpEnv.pro: 'https://sszc.quicksales.cn',
  };

  /// 远程服务器地址映射
  static String get envBaseUrlPath =>
      '${envDomainMap[BaseConfig.share.httpEnv]}/api/app/';

  static String get envAppDownloadUrl =>
      '${envDomainMap[BaseConfig.share.httpEnv]}/app-download';

  static String get commonBaseHost =>
      '${envDomainMap[BaseConfig.share.httpEnv]}/api/common/';

  static String get appDownloadUrl => envAppDownloadUrl;

  static String get clientBaseUrl =>
      '${envDomainMap[BaseConfig.share.httpEnv]}';
  // static String get clientBaseUrl => 'http://192.168.1.2:5173';

  /// API实际使用地址 - 支持本地开发模式
  static String get baseApiPath {
    return envBaseUrlPath;
  }
}

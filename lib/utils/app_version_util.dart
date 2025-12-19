import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/model/app_version_type.dart';
import 'package:oil_business_app/global/service/app_version_service.dart';
import 'package:oil_business_app/global/storage.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// print(result); // 输出 1, 因为 '1.0.1' 较新。
/// ```
class AppVersionUtil {
  static String get appStoreUrl => 'https://apps.apple.com/app/6755539430';

  /// 应用宝APP深度链接
  static String get tencentAppUrl =>
      'tmast://appdetails?pname=com.maiyoubei.businessapp';

  /// 应用宝网页版链接（备用）
  static String get tencentWebUrl =>
      'https://a.app.qq.com/o/simple.jsp?pkgname=com.maiyoubei.businessapp';

  /// 打开应用宝更新页面
  /// 优先尝试打开应用宝APP，如果失败则打开网页版
  static Future<bool> launchTencentStore() async {
    final appUri = Uri.parse(tencentAppUrl);
    try {
      // 直接尝试打开应用宝APP
      final launched = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        return true;
      }
    } catch (_) {
      // 打开失败，继续尝试网页版
    }
    // 如果应用宝APP未安装或打开失败，则打开网页版
    final webUri = Uri.parse(tencentWebUrl);
    return await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  /// 比较两个版本号，返回比较结果。
  ///
  /// - [version1] 和 [version2] 是需要比较的版本号字符串。
  /// - 返回 `1` 表示 `version1` 大于 `version2`。
  /// - 返回 `-1` 表示 `version2` 大于 `version1`。
  /// - 返回 `0` 表示两个版本号相等。
  static int compareVersion(String version1, String version2) {
    if (version1.isEmpty || version2.isEmpty) {
      return 0;
    }
    // 将版本号按照点号分割并转成整型的列表
    List<int> v1Parts = version1.split('.').map(int.parse).toList();
    List<int> v2Parts = version2.split('.').map(int.parse).toList();

    // 获取两个版本号列表的最大长度
    int length =
        v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

    // 逐一比较版本号的每个部分
    for (int i = 0; i < length; i++) {
      // 如果某个版本号的部分长度不足，用 0 代替
      int v1 = i < v1Parts.length ? v1Parts[i] : 0;
      int v2 = i < v2Parts.length ? v2Parts[i] : 0;

      // 比较当前部分的值
      if (v1 > v2) {
        return 1; // version1 较新
      } else if (v1 < v2) {
        return -1; // version2 较新
      }
    }

    // 如果没有任何部分不同，说明版本号相等
    return 0;
  }

  /// 检查应用的新版本。
  ///
  /// 此方法会根据当前版本号 `currentVersion` 检查是否有新的应用版本可用。
  ///
  /// 参数:
  /// - `currentVersion`：当前应用的版本号。
  ///
  /// 返回:
  /// - `NewVersionModel?`：如果有新版本可用，则返回包含新版本信息的 `NewVersionModel` 对象；
  ///   否则返回 `null`。
  ///
  /// 异常:
  /// - `DioException`：如果在检查新版本时发生网络请求错误，则返回 `null`。      throw '无法打开 $downloadUrl';
  ///
  /// 使用示例:
  /// ```dart
  /// Future<void> checkNewVersion(String currentVersion) async {
  ///   NewVersionModel? newVersion = await checkNewVersion(currentVersion);
  ///   if (newVersion != null) {
  ///     print('发现新版本：${newVersion.appVersion}');
  ///   } else {
  ///     print('当前已是最新版本');
  ///   }
  /// }
  /// ```
  static Future<AppVersionInfo?> checkNewVersion() async {
    try {
      AppVersionInfo _res = await appVersionService
          .appVersion(Platform.isAndroid ? 'android' : 'ios')
          .then((value) => value ?? const AppVersionInfo());
      appVersionUpdateTip = _res.updateMessage;
      return _res;
    } on DioException catch (_) {
      return Future.value(null);
    }
  }

  static Future<void> showUpdateDialog({bool isForceUpdate = false}) async {
    await SportsDialog.show(
      title: '发现新版本',
      clickMaskDismiss: newVersion?.forceUpdate == false,
      showClose: newVersion?.forceUpdate == false,
      bodyText: newVersion?.updateMessage ?? '',
      okText: '立即更新',
      onOk: () async {
        bool launched = false;
        if (Platform.isAndroid) {
          launched = await launchTencentStore();
        } else {
          launched = await launchUrl(Uri.parse(appStoreUrl));
        }
        if (!launched) {
          throw Exception('Could not launch app store');
        }
        if (!isForceUpdate) {
          SportsDialog.dismiss();
        }
      },
    );
  }

  static Future<void> checkVersionShowDialog() async {
    final newVersionInfo = await AppVersionUtil.checkNewVersion();

    AppVersionUtil.newVersion = newVersionInfo;

    final hasNewVersion = hasNewVersionUpdate();

    /// 如果存在新版本且强制更新，则显示更新弹窗
    if (hasNewVersion == true && newVersion?.forceUpdate == true) {
      await showUpdateDialog(isForceUpdate: true);
      return;
    }

    /// 上次显示时间
    final lastShowVersionTime = GlobalStorage.lastShowVersionTime ??
        DateTime.now().subtract(const Duration(days: 2));

    /// 距离上次显示时间大于1天
    final isShowDoneToOneDay = lastShowVersionTime
        .isBefore(DateTime.now().subtract(const Duration(days: 1)));

    /// 如果存在新版本且上次显示时间距今大于1天，则显示更新弹窗
    if (hasNewVersion == true && isShowDoneToOneDay) {
      GlobalStorage.sportsSingleton
          .put(StorageKey.lastShowVersionTime, DateTime.now());
      await showUpdateDialog();
    }
  }

  static String? appVersionUpdateTip;

  /// 获取应用版本信息。
  ///
  /// 返回一个包含以下信息的列表:
  /// - 应用版本号
  /// - 当前日期，格式为 'yyyyMMdd'
  /// - 应用构建序列号
  ///
  /// 返回:
  ///   包含应用版本信息的字符串列表。
  static List<String> get appVersionInfo {
    return [
      BaseConfig.share.packageInfo.version,
      formatDate(DateTime.now(), format: 'ddMMyyyy'),
      const String.fromEnvironment('BUILD_NUMBER', defaultValue: '')
    ];
  }

  /// 版本号
  static String get appVersion {
    return appVersionInfo[0];
  }

  /// 构建日期
  static String get appVersionDate {
    return appVersionInfo[1];
  }

  /// 构建版本号
  static String get appVersionBuildNumber {
    return appVersion[2];
  }

  static AppVersionInfo? newVersion;

  /// 是否有更新新版本
  static bool? hasNewVersionUpdate() {
    if (newVersion?.version?.isEmpty == true) {
      return false;
    }
    return AppVersionUtil.compareVersion(
            newVersion?.version ?? '', BaseConfig.share.packageInfo.version) !=
        0;
  }

  /// 拼接好的版本信息字符串
  static String get appVersionText {
    return '$appVersion($appVersionDate$appVersionBuildNumber)';
  }
}

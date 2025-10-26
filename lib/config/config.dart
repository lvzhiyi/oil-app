import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lottery_app/config/env.dart';
import 'package:lottery_app/global/storage.dart';
import 'package:lottery_app/models/device_info.dart';
import 'package:lottery_app/utils/app_util.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BaseConfig {
  /// fe环境变量
  HttpEnv httpEnv = debug ? HttpEnv.qa : HttpEnv.pro;

  /// 设备信息
  DeviceInfo deviceInfo = DeviceInfo();

  /// 版本信息
  PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  static String tokenHeader = 'token-live-sports';

  static const String appVersion = '1.0.0';

  static final share = BaseConfig();

  static const debug = kDebugMode;

  static String packageName = '';

  bool isPad = MediaQueryData.fromView(
              WidgetsBinding.instance.platformDispatcher.views.single)
          .size
          .width >
      600;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// 获取顶层BuildContext
  static BuildContext? appContext;

  setEnvName(HttpEnv httpEnv) async {
    share.httpEnv = httpEnv;
  }

  /// 是否为正式环境
  bool get isProduction {
    return httpEnv == HttpEnv.pro;
  }

  /// 获取设备信息
  ///
  /// 默认全部取值 DeviceInfoPlugin
  /// 需要注意安卓 [identifierForVendor]，有兼容问题，在未取到时，需要手动生成
  Future<void> _setDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    share.deviceInfo = DeviceInfo.fromMap(deviceInfo.data);
    if (Platform.isAndroid && share.deviceInfo.identifierForVendor == null) {
      String deviceId = await getAndroidDeviceId();
      share.deviceInfo.identifierForVendor = deviceId;
    }
  }

  /// 初始化版本信息
  ///
  /// [buildNumber] 取值于 jinkens 打包时环境变量的注入
  /// 其他值为 PackageInfo 取值
  Future<void> _versionInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    const build_number =
        String.fromEnvironment('BUILD_NUMBER', defaultValue: '');
    share.packageInfo = PackageInfo(
      appName: _packageInfo.appName,
      packageName: _packageInfo.packageName,
      version: _packageInfo.version,
      buildNumber: build_number,
    );
  }

  /// 基础配置初始化
  ///
  /// 在项目启动时调用
  /// 1、初始化设备信息
  /// 2、初始化版本信息
  /// 3、初始化环境变量
  init() async {
    await Future.wait([_setDeviceInfo(), _versionInfo()]);
    GlobalStorage.httpEnv = HttpEnv.mapEnvName(
      const String.fromEnvironment('HTTP_ENV', defaultValue: '1'),
    ).value;

    final httpEnv =
        BaseConfig.debug ? HttpEnv.qa : HttpEnv.mapEnv(GlobalStorage.httpEnv);
    l.d('env---------------->', 'httpEnv:$httpEnv');
    setEnvName(httpEnv);
  }
}

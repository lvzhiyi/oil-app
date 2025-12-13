import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_ume_kit_console_plus/flutter_ume_kit_console_plus.dart';
import 'package:flutter_ume_kit_device_plus/flutter_ume_kit_device_plus.dart';
import 'package:flutter_ume_kit_perf_plus/flutter_ume_kit_perf_plus.dart';
import 'package:flutter_ume_kit_ui_plus/flutter_ume_kit_ui_plus.dart';
import 'package:flutter_ume_plus/flutter_ume_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'config/address.dart';
import 'net/net_manager.dart';

void oilAppFlutterRun(
  Future<void> Function() prepareAppRun, {
  VoidCallback? appRun,
  String? packageName,
}) async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      Hive.init(
          await getApplicationDocumentsDirectory().then((value) => value.path));
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
      );
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      ErrorWidget.builder = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, (details.stack)!);
        return Material(
          child: Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'error: ${details.exception}',
                style: TextStyle(fontSize: 24, color: Colors.yellow[300]),
              ),
            ),
          ),
        );
      };

      BaseConfig.packageName = packageName ?? 'flutter_package';

      await prepareAppRun();

      /** 网络管理器初始化，添加错误处理避免启动失败 */
      try {
        netManager.init(BaseAddress.baseApiPath, withCredentials: true);
        l.d('NetManager', '网络初始化成功: ${BaseAddress.baseApiPath}');
      } catch (e) {
        l.e('NetManager', '网络初始化失败: $e');
        l.w('NetManager', '应用将以离线模式启动');
      }

      if (appRun != null) {
        appRun();
      } else {
        // 确保状态栏正常显示
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
          overlays: SystemUiOverlay.values,
        );
        await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
        ]).then((_) => runMyApp());
      }
    },
    (Object exception, StackTrace stackTrace) async {
      l.e('ERROR', 'happend stack:$stackTrace  exception: $exception');
    },
  );
}

void runMyApp() async {
  /// sentry sdk init
  sentryRunWidget({required Widget child}) {
    return child;
  }

  if (kDebugMode) {
    // PluginManager.instance // Register plugin kits
    //   ..register(const WidgetInfoInspector())
    //   ..register(const WidgetDetailInspector())
    //   ..register(const ColorSucker())
    //   ..register(AlignRuler())
    //   ..register(const ColorPicker()) // New feature
    //   ..register(const TouchIndicator()) // New feature
    //   ..register(Performance())
    //   ..register(const MemoryInfoPage())
    //   ..register(const CpuInfoPage())
    //   ..register(const DeviceInfoPanel())
    //   ..register(Console());
    // ..register(DioInspector(dio: dio)); // Pass in your Dio instance
    // After flutter_ume 0.3.0
    runApp(
      const UMEWidget(
        enable: true,
        child: SportsInitedApp(),
      ),
    );
  } else {
    runApp(
      sentryRunWidget(
        child: const SportsInitedApp(),
      ),
    );
  }
}

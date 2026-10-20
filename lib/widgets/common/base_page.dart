import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:oil_business_app/utils/screen.dart';
import 'package:oil_business_app/utils/log.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  void onResume() {}

  void onPause() {}
}

abstract class BaseState<TPage extends BasePage> extends State<TPage>
    with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void _registerEvent() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _removeEvent() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (ModalRoute.of(context)?.isCurrent == true) {
          deactivate();
        }
        break;
      case AppLifecycleState.resumed:
        if (ModalRoute.of(context)?.isCurrent == true) {
          activate();
        }
        break;
      case AppLifecycleState.detached:
        dispose();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _registerEvent();
  }

  @override
  void dispose() {
    super.dispose();
    _removeEvent();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}

/// 混入 init 状态
mixin BasicInitPage<TPage extends BasePage> on BaseState<TPage> {
  bool inited = false;

  Orientation? orientationNow;
  int renderCount = 1; // 用于触发重新渲染

  /// 启动页最小显示时长（毫秒）
  static const int _splashMinDuration = 1000;

  /// 标记是否是首次启动（静态变量，只在第一次页面初始化时等待）
  static bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    l.i('', '######################## base page init ########################');

    // 记录初始化开始时间
    final startTime = DateTime.now();

    screen.init();

    l.i('',
        '######################## base page init end ########################');

    // 只在首次启动时等待，确保启动页显示足够时间
    if (_isFirstLaunch) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final remainingDelay = _splashMinDuration - elapsed;

      if (remainingDelay > 0) {
        await Future.delayed(Duration(milliseconds: remainingDelay));
      }
      _isFirstLaunch = false;
    }

    setState(() {
      inited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: 启动时显示空白。考虑是否替换
    if (!inited) return const Scaffold(backgroundColor: Colors.white);
    FlutterNativeSplash.remove();

    return OrientationBuilder(
      builder: ((context, Orientation orientation) {
        if (orientation != orientationNow) {
          screen.init(true);
          orientationNow = orientation;
        }

        return body(context);
      }),
    );
  }

  Widget body(context);
}

/// 混入 init 状态 hooks专用
mixin BasicInitHooksPage<TPage extends BasePage> on State<TPage> {
  bool inited = false;

  Orientation? orientationNow;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    l.i('', '######################## base page init ########################');
    screen.init();
    l.i('',
        '######################## base page init end ########################');

    setState(() {
      inited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: 启动时显示空白。考虑是否替换
    if (!inited) return const Scaffold(backgroundColor: Colors.white);

    return OrientationBuilder(
      builder: ((context, Orientation orientation) {
        if (orientation != orientationNow) {
          screen.init(true);
          orientationNow = orientation;
        }

        return body(context);
      }),
    );
  }

  Widget body(context);
}

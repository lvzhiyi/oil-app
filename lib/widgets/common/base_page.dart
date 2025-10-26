import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottery_app/utils/screen.dart';
import 'package:lottery_app/utils/log.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  void onResume() {}

  void onPause() {}
}

abstract class BaseState<Page extends BasePage> extends State<Page>
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
mixin BasicInitPage<Page extends BasePage> on BaseState<Page> {
  bool inited = false;

  Orientation? orientationNow;
  int renderCount = 1; // 用于触发重新渲染

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
mixin BasicInitHooksPage<Page extends BasePage> on State<Page> {
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

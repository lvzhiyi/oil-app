import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_state.dart';

class AppController extends HydratedCubit<AppState>
    with WidgetsBindingObserver {
  AppController() : super(AppState()) {
    listenAppLifecycle();
    initState();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      /// 应用从后台切换到前台，或从锁屏状态恢复
      case AppLifecycleState.resumed:
        _appOnResume();
        break;

      /// 应用处于非活动状态（可能是锁屏状态）
      case AppLifecycleState.inactive:
        break;

      /// 应用切换到后台
      case AppLifecycleState.paused:
        break;

      /// 应用程序仍然在 Flutter 引擎上运行，但没有附加到任何视图
      case AppLifecycleState.detached:
        break;

      /// 应用程序不可见
      case AppLifecycleState.hidden:
      // xxx
    }
  }

  /// app从后台切换到前台
  _appOnResume() {}

  /// app生命周期监听
  listenAppLifecycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  initState() async {}

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState();
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {};
  }
}

final appController = AppController();

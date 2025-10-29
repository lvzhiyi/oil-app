import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/global/model/agent_info_type.dart';
import 'package:oil_business_app/global/service/agent_info_service.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/utils/token_manager.dart';

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

  initState() async {
    if (TokenManager.instance.getAccessToken() == null) {
      return;
    }
    fetchAgentInfo();
  }

  setAgentInfo(AgentInfo? agentInfo) {
    emit(state.copyWith(agentInfo: agentInfo));
  }

  AgentInfo? getAgentInfo() {
    return state.agentInfo;
  }

  /// 获取当前代理商信息
  Future<void> fetchAgentInfo() async {
    final agentResponse = await agentInfoService.getAgentInfo();
    if (agentResponse.code == HttpCode.success && agentResponse.data != null) {
      setAgentInfo(agentResponse.data);
    }
  }

  /// 更新代理商信息
  Future<void> updateAgentInfo(UpdateAgentInfoRequest request) async {
    final agentResponse = await agentInfoService.updateAgentInfo(request);
    if (agentResponse.code == HttpCode.success && agentResponse.data != null) {
      fetchAgentInfo();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    final agentInfo = json['agentInfo'] != null
        ? AgentInfo.fromJson(json['agentInfo'])
        : null;
    return AppState(
      agentInfo: agentInfo,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'agentInfo': state.agentInfo?.toJson(),
    };
  }
}

final appController = AppController();

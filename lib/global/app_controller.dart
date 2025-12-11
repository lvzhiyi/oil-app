import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/app_version_util.dart';
import 'package:oil_business_app/utils/log.dart';

import 'app_state.dart';

class AppController extends HydratedCubit<AppState>
    with WidgetsBindingObserver {
  bool _hasCheckedStartup = false;

  AppController() : super(AppState()) {
    listenAppLifecycle();
    initState();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  /// app生命周期监听
  listenAppLifecycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  initState() async {
    if (state.authResponse?.accessToken != null &&
        state.selectedStation?.id == null) {
      final pendingAndActiveStation = await getStationStatus(1, 1, [
        StationStatus.active,
      ]);
      final findStationActive = pendingAndActiveStation.list?.firstWhere(
        (element) => element.status == StationStatus.active,
        orElse: () => Station(),
      );
      if (findStationActive?.id != null) {
        setSelectedStation(findStationActive!);
      }
    }
  }

  /// 应用启动检查（版本更新检查和绑定加油站流程）
  /// 在主页初始化时调用
  Future<void> checkStartupProcess() async {
    if (_hasCheckedStartup) return;
    _hasCheckedStartup = true;

    try {
      // 检查版本更新
      await AppVersionUtil.checkVersionShowDialog();

      // 执行绑定加油站流程
      if (state.authResponse?.accessToken != null) {
        await bindStationProcess();
      }
    } catch (e) {
      l.e('AppController', '启动检查失败: $e');
    }
  }

  setAuthResponse(AuthResponse authResponse) {
    emit(state.copyWith(authResponse: authResponse));
  }

  void setSelectedStation(Station station) {
    emit(state.copyWith(selectedStation: station));
  }

  void clearSelectedStation() {
    emit(state.copyWith(selectedStation: Station()));
  }

  /// 登录成功后流程
  loginSucessProcess(AuthResponse authResponse, {AuthReqType? type}) async {
    setAuthResponse(authResponse);
    if (type == AuthReqType.register) {
      BaseRouter.push(url: AppPage.bindStationPage.path);
      return;
    }
    bindStationProcess(isFromLogin: true);
  }

  /// 绑定加油站流程
  bindStationProcess({bool isFromLogin = false}) async {
    final activeStation = await getStationStatus(1, 1, [
      StationStatus.active,
    ]);
    if (activeStation.list?.isNotEmpty ?? false) {
      BaseRouter.replace(url: AppPage.mainLayoutPage.path, extra: {
        'isFromLogin': isFromLogin,
      });
    } else {
      final pendingStation = await getStationStatus(1, 1, [
        StationStatus.pending_review,
        StationStatus.rejected,
      ]);

      if (pendingStation.list?.isNotEmpty ?? false) {
        BaseRouter.replace(url: AppPage.pendingReviewPage.path, extra: {
          'station': pendingStation.list?[0],
          'isFromLogin': isFromLogin,
        });
        return;
      }

      BaseRouter.replace(url: AppPage.bindStationPage.path, extra: {
        'isFromLogin': isFromLogin,
      });
    }
  }

  Future<GetStationResponse> getStationStatus(
      int page, int pageSize, List<StationStatus> statuses) async {
    final response = await stationService.getStationStatus(
      page,
      pageSize,
      statuses.map((e) => e.name).toList(),
    );
    return response;
  }

  logout() {
    clearSelectedStation();
    setAuthResponse(
        AuthResponse(accessToken: null, refreshToken: null, account: null));
    BaseRouter.replace(url: AppPage.loginPage.path);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      authResponse: json['authResponse'] != null
          ? AuthResponse.fromJson(json['authResponse'])
          : null,
      selectedStation: json['selectedStation'] != null
          ? Station.fromJson(json['selectedStation'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'authResponse': state.authResponse?.toJson(),
      'selectedStation': state.selectedStation?.toJson(),
    };
  }
}

final appController = AppController();

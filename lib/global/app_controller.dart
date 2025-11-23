import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';

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

  /// app生命周期监听
  listenAppLifecycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  initState() async {
    if (state.authResponse?.accessToken != null &&
        state.selectedStation == null) {
      final pendingAndActiveStation = await getStationStatus(1, 1);
      final findStationActive = pendingAndActiveStation.list?.firstWhere(
        (element) => element.status == StationStatus.active,
        orElse: () => Station(),
      );
      if (findStationActive?.id != null) {
        setSelectedStation(findStationActive!);
      }
    }
  }

  setAuthResponse(AuthResponse authResponse) {
    emit(state.copyWith(authResponse: authResponse));
  }

  void setSelectedStation(Station station) {
    emit(state.copyWith(selectedStation: station));
  }

  void clearSelectedStation() {
    emit(state.copyWith(selectedStation: null));
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
    final pendingAndActiveStation = await getStationStatus(1, 1);
    if (pendingAndActiveStation.list?.isEmpty ?? true) {
      BaseRouter.push(url: AppPage.bindStationPage.path, extra: {
        'isFromLogin': isFromLogin,
      });
    } else {
      /// 查找有没有审核过的页面
      final findStationActive = pendingAndActiveStation.list?.firstWhere(
        (element) => element.status == StationStatus.active,
        orElse: () => Station(),
      );
      if (findStationActive?.id != null) {
        setSelectedStation(findStationActive!);
        BaseRouter.replace(url: AppPage.mainLayoutPage.path);
        return;
      }

      BaseRouter.replace(url: AppPage.pendingReviewPage.path, extra: {
        'station': pendingAndActiveStation.list?[0],
        'isFromLogin': isFromLogin,
      });
    }
  }

  Future<GetStationResponse> getStationStatus(int page, int pageSize) async {
    final response = await stationService.getStationStatus(
      page,
      pageSize,
      [
        StationStatus.active.name,
        StationStatus.pending_review.name,
        StationStatus.rejected.name
      ],
    );
    return response;
  }

  logout() {
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
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

  initState() async {}

  setAuthResponse(AuthResponse authResponse) {
    emit(state.copyWith(authResponse: authResponse));
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
    final pendingAndActiveStation = await getStationStatus();
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
        BaseRouter.replace(url: AppPage.mainLayoutPage.path);
        return;
      }

      BaseRouter.replace(url: AppPage.pendingReviewPage.path);
    }
  }

  Future<GetStationResponse> getStationStatus() async {
    final response = await stationService.getStationStatus(
        1, 1, [StationStatus.active.name, StationStatus.pending_review.name]);
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
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'authResponse': state.authResponse?.toJson(),
    };
  }
}

final appController = AppController();

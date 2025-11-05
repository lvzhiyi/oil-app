import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oil_business_app/global/model/auth_rep_type.dart';

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

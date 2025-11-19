import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/pages/station_management_list/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class StationManagementListCtrl extends Cubit<StationManagementListState> {
  StationManagementListCtrl() : super(StationManagementListState(stations: [])) {
    initState();
  }

  StationModel _convertToStationModel(Station station) {
    return StationModel(
      id: station.id?.toString() ?? '',
      name: station.stationName ?? '',
      address: _buildFullAddress(station),
      latitude: null,
      longitude: null,
      isActive: station.status == StationStatus.active,
    );
  }

  String _buildFullAddress(Station station) {
    final parts = [
      station.provinceName,
      station.cityName,
      station.areaName,
      station.addressDetail,
    ].where((part) => part != null && part.isNotEmpty);
    return parts.join('');
  }

  void initState() async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await appController.getStationStatus();

      final stations = (response.list ?? [])
          .map((station) => _convertToStationModel(station))
          .toList();

      emit(state.copyWith(
        stations: stations,
        isLoading: false,
        hasError: false,
      ));
    } catch (e) {
      l.e('StationManagementListCtrl', '加载加油站列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void navigateToEdit(StationModel station, BuildContext context) {
    BaseRouter.push(
      url: AppPage.stationEditPage.path,
      extra: {'stationId': station.id},
    );
  }

  void navigateToAdd(BuildContext context) {
    BaseRouter.push(url: AppPage.stationEditPage.path);
  }

  void updateStation(StationModel station) {
    final updated = state.stations.map((s) {
      return s.id == station.id ? station : s;
    }).toList();
    emit(state.copyWith(stations: updated));
  }
}


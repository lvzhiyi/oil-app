import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
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
      status: station.status,
      rejectReason: station.rejectReason,
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
    await loadStations();
  }

  Future<void> loadStations() async {
    emit(state.copyWith(isLoading: true));
    try {
      final statuses = state.selectedStatus == null
          ? StationStatus.values.map((e) => e.name).toList()
          : [state.selectedStatus!.name];

      final response = await stationService.getStationStatus(1, 100, statuses);

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

  void filterByStatus(StationStatus? status) {
    if (status == null) {
      emit(state.copyWith(clearSelectedStatus: true));
    } else {
      emit(state.copyWith(selectedStatus: status));
    }
    loadStations();
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


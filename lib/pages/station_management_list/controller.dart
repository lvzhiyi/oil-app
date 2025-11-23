import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/pages/station_management_list/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/station_extension.dart';

class StationManagementListCtrl extends Cubit<StationManagementListState> {
  static const int _pageSize = 10;

  StationManagementListCtrl() : super(StationManagementListState(stations: [])) {
    onRefresh();
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;
    
    emit(state.copyWith(
      isLoading: true,
      hasError: false,
      page: 1,
      hasMore: true,
    ));

    await _loadData(isRefresh: true);
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    await _loadData(isRefresh: false);
  }

  Future<void> _loadData({required bool isRefresh}) async {
    try {
      final pageToLoad = isRefresh ? 1 : state.page + 1;
      
      final statuses = state.selectedStatus == null
          ? StationStatus.values.map((e) => e.name).toList()
          : [state.selectedStatus!.name];

      final response = await stationService.getStationStatus(pageToLoad, _pageSize, statuses);

      // 直接使用 Station 模型
      final newStations = response.list ?? [];
      final hasMore = newStations.length >= _pageSize;

      List<Station> finalStations;
      if (isRefresh) {
        finalStations = newStations;
      } else {
        finalStations = [...state.stations, ...newStations];
      }

      emit(state.copyWith(
        stations: finalStations,
        isLoading: false,
        isLoadingMore: false,
        hasError: false,
        page: pageToLoad,
        hasMore: hasMore,
      ));
    } catch (e) {
      l.e('StationManagementListCtrl', '加载加油站列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void filterByStatus(StationStatus? status) {
    if (status == state.selectedStatus && !(status == null && state.selectedStatus == null)) {
       return;
    }
    
    if (status == null) {
      emit(state.copyWith(clearSelectedStatus: true));
    } else {
      emit(state.copyWith(selectedStatus: status));
    }
    onRefresh();
  }

  void navigateToEdit(Station station, BuildContext context) {
    BaseRouter.push(
      url: AppPage.stationEditPage.path,
      extra: {'stationId': station.idString},
    );
  }

  void navigateToAdd(BuildContext context) {
    BaseRouter.push(url: AppPage.stationEditPage.path);
  }

  void updateStation(Station station) {
    final updated = state.stations.map((s) {
      return s.id == station.id ? station : s;
    }).toList();
    emit(state.copyWith(stations: updated));
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/log.dart';

class StationEditCtrl extends Cubit<StationEditState> {
  StationEditCtrl({String? stationId}) : super(StationEditState()) {
    if (stationId != null) {
      initState(stationId);
    }
  }

  static final List<StationModel> _mockStations = [
    StationModel(
      id: '1',
      name: '中石化北京朝阳加油站',
      address: '北京市朝阳区建国路88号',
    ),
    StationModel(
      id: '2',
      name: '中石油上海浦东加油站',
      address: '上海市浦东新区世纪大道1000号',
    ),
    StationModel(
      id: '3',
      name: '中海油广州天河加油站',
      address: '广州市天河区天河路123号',
    ),
    StationModel(
      id: '4',
      name: '中石化深圳南山加油站',
      address: '深圳市南山区科技园南路2001号',
    ),
  ];

  void initState(String stationId) {
    final station = _mockStations.firstWhere(
      (s) => s.id == stationId,
      orElse: () => StationModel(
        id: stationId,
        name: '',
        address: '',
      ),
    );

    emit(state.copyWith(
      station: station,
      name: station.name,
      address: station.address,
    ));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateAddress(String address) {
    emit(state.copyWith(address: address));
  }

  Future<bool> save(BuildContext context) async {
    if (state.name.isEmpty) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: '请输入加油站名称',
      ));
      return false;
    }

    if (state.address.isEmpty) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: '请输入加油站地址',
      ));
      return false;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedStation = state.station?.copyWith(
            name: state.name,
            address: state.address,
          ) ??
          StationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: state.name,
            address: state.address,
          );

      final index = _mockStations.indexWhere((s) => s.id == updatedStation.id);
      if (index != -1) {
        _mockStations[index] = updatedStation;
      } else {
        _mockStations.add(updatedStation);
      }

      emit(state.copyWith(
        isLoading: false,
        hasError: false,
        station: updatedStation,
      ));

      BaseRouter.pop();
      return true;
    } catch (e) {
      l.e('StationEditCtrl', '保存失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }
}


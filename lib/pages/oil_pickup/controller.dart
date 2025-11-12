import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/vehicle_info_parser.dart';

class OilPickupCtrl extends Cubit<OilPickupState> {
  OilPickupCtrl() : super(OilPickupState()) {
    initState();
  }

  void initState() {
    final selectedStation = appController.state.selectedStation;
    if (selectedStation != null) {
      emit(state.copyWith(selectedStation: selectedStation));
    }
  }

  void updateOilAmount(String amount) {
    emit(state.copyWith(
      oilAmount: amount,
      errorMessage: null,
    ));
    
    if (amount.isNotEmpty) {
      final oilAmountInt = int.tryParse(amount);
      if (oilAmountInt != null && oilAmountInt <= 0) {
        emit(state.copyWith(
          errorMessage: '提油量必须大于0',
        ));
      }
    }
  }

  void onVehicleInfoPasted(String text) {
    try {
      final vehicleModel = VehicleInfoParser.parse(text);
      final jsonString = VehicleInfoParser.toJson(vehicleModel);
      final missing = VehicleInfoParser.validateRequired(vehicleModel);

      emit(state.copyWith(
        vehicleInfo: jsonString,
        vehicleModel: vehicleModel,
        missingFields: missing,
        parseSuccess: true,
        errorMessage: null,
      ));

      if (missing.isNotEmpty) {
        l.w('OilPickup', '缺少必填字段: ${missing.join(', ')}');
      } else {
        l.i('OilPickup', '车辆信息解析成功');
      }
    } catch (e) {
      l.e('OilPickup', '车辆信息解析失败: $e');
      emit(state.copyWith(
        parseSuccess: false,
        errorMessage: '解析失败,请检查格式',
      ));
    }
  }

  void selectStation(BuildContext context) async {
    final result = await BaseRouter.push(
      url: AppPage.stationListPage.path,
    );

    if (result != null) {
      initState();
    }
  }

  Future<void> generateCertificate(BuildContext context) async {
    if (state.selectedStation == null) {
      emit(state.copyWith(
        errorMessage: '请先选择加油站',
      ));
      return;
    }

    if (state.oilAmount.isEmpty) {
      emit(state.copyWith(
        errorMessage: '请输入提油量',
      ));
      return;
    }

    final oilAmountInt = int.tryParse(state.oilAmount);
    if (oilAmountInt == null) {
      emit(state.copyWith(
        errorMessage: '提油量必须为数字',
      ));
      return;
    }
    
    if (oilAmountInt <= 0) {
      emit(state.copyWith(
        errorMessage: '提油量必须大于0',
      ));
      return;
    }

    final missing = VehicleInfoParser.validateRequired(
      state.vehicleModel ?? VehicleModel(),
    );
    if (missing.isNotEmpty) {
      emit(state.copyWith(
        errorMessage: '缺少必填字段: ${missing.join(', ')}',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      l.i('OilPickup', '生成提油凭证成功');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      l.e('OilPickup', '生成提油凭证失败: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '生成失败,请重试',
      ));
    }
  }
}


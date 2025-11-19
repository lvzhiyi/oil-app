import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/vehicle_info_parser.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class OilPickupDetailCtrl extends Cubit<OilPickupDetailState> {
  OilPickupDetailCtrl(InventoryModel inventory)
      : super(OilPickupDetailState(inventory: inventory)) {
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
        l.w('OilPickupDetail', '缺少必填字段: ${missing.join(', ')}');
      } else {
        l.i('OilPickupDetail', '车辆信息解析成功');
      }
    } catch (e) {
      l.e('OilPickupDetail', '车辆信息解析失败: $e');
      emit(state.copyWith(
        parseSuccess: false,
        errorMessage: '解析失败,请检查格式',
      ));
    }
  }

  void selectStation(BuildContext context) async {
    final result = await BaseRouter.push(
      context: context,
      url: AppPage.stationListPage.path,
    );

    if (result != null) {
      final selectedStation = appController.state.selectedStation;
      if (selectedStation != null) {
        emit(state.copyWith(selectedStation: selectedStation));
      }
    }
  }

  Future<void> generateCertificate(BuildContext context) async {
    if (state.inventory == null || state.inventory!.inventoryId == null) {
      emit(state.copyWith(
        errorMessage: '库存信息异常',
      ));
      return;
    }

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

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // 构建提油请求参数
      final stationId = int.tryParse(state.selectedStation!.id);
      if (stationId == null) {
        l.e('OilPickupDetail', '加油站ID格式错误: ${state.selectedStation!.id}');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '加油站ID格式错误',
        ));
        return;
      }

      final request = WithdrawRequest(
        withdrawTon: oilAmountInt,
        stationId: stationId,
        vehicleInfo: state.vehicleInfo,
      );

      // 调用提油接口
      final response = await oilPickupService.submitWithdraw(
        state.inventory!.inventoryId!,
        request,
      );

      l.i('OilPickupDetail', '提油申请提交成功: ${response.id}');

      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));

      if (context.mounted) {
        SportsToast.showSuccess('提油凭证生成成功');
        await Future.delayed(const Duration(milliseconds: 500));
        BaseRouter.pop(context: context, result: true);
      }

    } catch (e) {
      l.e('OilPickupDetail', '提油申请提交失败: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '提交失败,请重试',
      ));
    }
  }
}

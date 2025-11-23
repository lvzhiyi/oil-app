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

  void resetVehicleInfo() {
    emit(state.copyWith(
      vehicleInfo: '',
      vehicleModel: null,
      missingFields: const [],
      parseSuccess: false,
      errorMessage: null,
    ));
  }

  void selectStation(BuildContext context) async {
    final result = await BaseRouter.push(
      context: context,
      url: AppPage.stationListPage.path,
      extra: {'allowEdit': false},
    );

    if (result != null) {
      final selectedStation = appController.state.selectedStation;
      if (selectedStation != null) {
        emit(state.copyWith(selectedStation: selectedStation));
      }
    }
  }

  Future<void> generateCertificate(BuildContext context, {String? currentOilAmount}) async {
    if (currentOilAmount != '' && currentOilAmount != state.oilAmount) {
      emit(state.copyWith(
        oilAmount: currentOilAmount,
        errorMessage: null,
      ));
    }

    if (state.inventory == null || state.inventory!.inventoryId == null) {
      SportsToast.showWarning('库存信息异常');
      return;
    }

    if (state.selectedStation == null) {
      SportsToast.showWarning('请先选择加油站');
      return;
    }

    final finalOilAmount = currentOilAmount ?? state.oilAmount;
    if (finalOilAmount.isEmpty || finalOilAmount.trim().isEmpty) {
      SportsToast.showWarning('请输入提油量');
      return;
    }

    final oilAmountDouble = double.tryParse(finalOilAmount);
    if (oilAmountDouble == null) {
      SportsToast.showWarning('提油量必须为数字');
      return;
    }

    if (oilAmountDouble <= 0) {
      SportsToast.showWarning('提油量必须大于0');
      return;
    }

    final oilAmountInt = oilAmountDouble.toInt();

    final missing = VehicleInfoParser.validateRequired(
      state.vehicleModel ?? VehicleModel(),
    );
    if (missing.isNotEmpty) {
      SportsToast.showWarning('请完善车辆信息，缺少必填字段: ${missing.join(', ')}');
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // 构建提油请求参数
      final stationId = state.selectedStation!.id;
      if (stationId == null) {
        l.e('OilPickupDetail', '加油站ID为空');
        emit(state.copyWith(isLoading: false));
        SportsToast.showWarning('加油站ID为空');
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

      l.i('OilPickupDetail', '提油申请提交成功: ${response.withdrawNo ?? response.withdrawId ?? '-'}');

      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));

      if (context.mounted) {
        if (state.inventory == null || state.selectedStation == null || state.vehicleModel == null) {
          SportsToast.showWarning('数据异常，无法跳转');
          return;
        }

        BaseRouter.push(
          context: context,
          url: AppPage.oilPickupSuccessPage.path,
          extra: {
            'response': response,
            'inventory': state.inventory!,
            'station': state.selectedStation!,
            'oilAmount': finalOilAmount,
            'vehicleModel': state.vehicleModel!,
          },
        );
      }

    } catch (e) {
      l.e('OilPickupDetail', '提油申请提交失败: $e');
      emit(state.copyWith(
        isLoading: false,
      ));
      SportsToast.showWarning('提交失败,请重试');
    }
  }
}

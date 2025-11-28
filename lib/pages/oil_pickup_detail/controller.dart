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

  String? _validateOilAmount(String amount, {required bool forSubmit}) {
    final value = amount.trim();
    if (value.isEmpty) {
      return forSubmit ? '请输入提油量' : null;
    }

    final oilAmountDouble = double.tryParse(value);
    if (oilAmountDouble == null) {
      return '提油量必须为数字';
    }
    if (oilAmountDouble <= 0) {
      return '提油量必须大于0';
    }

    final availableTon = state.inventory?.availableTon ?? 0;
    if (oilAmountDouble > availableTon) {
      return '提油量不能超过可用库存${availableTon.toInt()} 吨';
    }

    return null;
  }

  void initState() {
    final selectedStation = appController.state.selectedStation;
    if (selectedStation != null) {
      emit(state.copyWith(selectedStation: selectedStation));
    }
  }

  void updateOilAmount(String amount) {
    final error = _validateOilAmount(amount, forSubmit: false);
    emit(state.copyWith(oilAmount: amount, errorMessage: error));
  }

  void onVehicleInfoPasted(String text) {
    emit(state.copyWith(
      vehicleInfo: text.trim(),
      vehicleModel: null,
      missingFields: const [],
      parseSuccess: false,
      errorMessage: null,
    ));
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

  Future<void> generateCertificate(
    BuildContext context, {
    String? currentOilAmount,
    required VehicleModel vehicleModel,
  }) async {
    if (state.inventory == null || state.inventory!.inventoryId == null) {
      SportsToast.showWarning('库存信息异常');
      return;
    }

    if (state.selectedStation == null) {
      SportsToast.showWarning('请先选择加油站');
      return;
    }

    final finalOilAmount = currentOilAmount ?? state.oilAmount;
    final validationError = _validateOilAmount(finalOilAmount, forSubmit: true);
    emit(state.copyWith(
      oilAmount: finalOilAmount,
      errorMessage: validationError,
    ));

    if (validationError != null) {
      SportsToast.showWarning(validationError);
      return;
    }

    final oilAmountDouble = double.parse(finalOilAmount);
    final oilAmountInt = oilAmountDouble.toInt();

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final stationId = state.selectedStation!.id;
      if (stationId == null) {
        l.e('OilPickupDetail', '加油站ID为空');
        emit(state.copyWith(isLoading: false));
        SportsToast.showWarning('加油站ID为空');
        return;
      }

      String vehicleInfoJson;
      if (state.vehicleInfo.isNotEmpty) {
        final parsedModel = VehicleInfoParser.parse(state.vehicleInfo);
        final mergedModel = parsedModel.copyWith(
          oilAmount: parsedModel.oilAmount ?? finalOilAmount,
        );
        // 格式：原始字符串|||JSON字符串
        vehicleInfoJson = '${state.vehicleInfo}|||${VehicleInfoParser.toJson(mergedModel)}';
      } else {
        final finalVehicleModel = vehicleModel.copyWith(
          oilAmount: vehicleModel.oilAmount ?? finalOilAmount,
        );
        // 格式：|||JSON字符串 (原始字符串为空)
        vehicleInfoJson = '|||${VehicleInfoParser.toJson(finalVehicleModel)}';
      }
      // print('vehicleInfoJson: $vehicleInfoJson');
      final request = WithdrawRequest(
        withdrawTon: oilAmountInt,
        stationId: stationId,
        vehicleInfo: vehicleInfoJson,
      );

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
        if (state.inventory == null || state.selectedStation == null) {
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
            'vehicleModel': vehicleModel,
            'dispatchInfo': state.vehicleInfo,
          },
        );
      }
    } catch (e) {
      l.e('OilPickupDetail', '提油申请提交失败: $e');
      emit(state.copyWith(
        isLoading: false,
      ));
      SportsToast.showWarning('提交失败，请重试');
    }
  }
}

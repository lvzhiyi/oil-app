import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/pages/oil_pickup/state.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/vehicle_info_parser.dart';

class OilPickupCtrl extends Cubit<OilPickupState> {
  OilPickupCtrl() : super(OilPickupState()) {
    initState();
  }

  void initState() async {
    final selectedStation = appController.state.selectedStation;
    if (selectedStation != null) {
      emit(state.copyWith(selectedStation: selectedStation));
    }

    // 加载可用库存油
    await _loadPendingOilOrder();
  }

  /// 加载可用库存油
  Future<void> _loadPendingOilOrder() async {
    emit(state.copyWith(isLoadingOrder: true, orderError: null));

    try {
      final inventoryResponse = await oilPickupService.getInventories(
        InventoryQueryRequest(
          page: 1,
          pageSize: 1,
        ),
      );

      if (inventoryResponse.list != null && inventoryResponse.list!.isNotEmpty) {
        final inventory = inventoryResponse.list!.first;
        final orderId = inventory.oilOrderId;
        
        if (orderId != null) {
          l.i('OilPickup', '获取到库存油，订单ID: $orderId，库存: ${inventory.purchaseTon}');
          
          // 将 InventoryModel 转换为 OrderModel
          final orderModel = _convertInventoryToOrder(inventory);
          
          emit(state.copyWith(
            pendingOilOrderId: orderId,
            pendingOilOrder: orderModel,
            isLoadingOrder: false,
          ));
        } else {
          l.w('OilPickup', '订单ID为空');
          emit(state.copyWith(
            isLoadingOrder: false,
            orderError: '订单信息异常',
          ));
        }
      } else {
        l.i('OilPickup', '暂无可用库存油');
        emit(state.copyWith(
          isLoadingOrder: false,
          orderError: null,
          pendingOilOrder: null,
        ));
      }
    } catch (e) {
      l.e('OilPickup', '查询可用库存油失败: $e');
      emit(state.copyWith(
        isLoadingOrder: false,
        orderError: '加载库存信息失败,请重试',
        pendingOilOrder: null,
      ));
    }
  }

  /// 将 InventoryModel 转换为 OrderModel
  OrderModel _convertInventoryToOrder(InventoryModel inventory) {
    return OrderModel(
      id: inventory.oilOrderId,
      depotName: inventory.depotName,
      fuelType: inventory.fuelType,
      purchaseTon: inventory.purchaseTon,
      createdAt: inventory.createdAt,
      updatedAt: inventory.updatedAt,
    );
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
    // 检查是否有可用库存油
    if (state.pendingOilOrderId == null) {
      emit(state.copyWith(
        errorMessage: '暂无可用库存油',
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
        l.e('OilPickup', '加油站ID格式错误: ${state.selectedStation!.id}');
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
        state.pendingOilOrderId!,
        request,
      );

      l.i('OilPickup', '提油申请提交成功: ${response.id}');

      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));

      // TODO: 显示成功提示并导航到其他页面
      // 可以在这里添加成功后的处理逻辑,比如显示Toast、导航等

    } catch (e) {
      l.e('OilPickup', '提油申请提交失败: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '提交失败,请重试',
      ));
    }
  }
}


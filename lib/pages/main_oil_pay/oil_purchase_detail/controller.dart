import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_req_type.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';
import 'package:oil_business_app/pages/pay_order_detail/service/pay_order_service.dart';
import 'package:oil_business_app/pages/pay_order_list/service/pay_order_list.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import 'state.dart';

class OilPurchaseDetailCtrl extends Cubit<OilPurchaseDetailState> {
  OilPurchaseDetailCtrl({required Depot depot})
      : super(OilPurchaseDetailState(depot: depot)) {
    // 默认选择第一个油品
    if (depot.fuels != null && depot.fuels!.isNotEmpty) {
      emit(state.copyWith(selectedFuel: depot.fuels!.first));
    }
  }

  final formKey = GlobalKey<FormBuilderState>();

  /// 选择油品
  void selectFuel(Fuel fuel) {
    emit(state.copyWith(selectedFuel: fuel));
  }

  /// 更新购买量
  void updatePurchaseQuantity(String quantity) {
    emit(state.copyWith(purchaseQuantity: quantity));
  }

  /// 更新备注
  void updateRemark(String remark) {
    emit(state.copyWith(remark: remark));
  }

  /// 提交购买
  Future<void> submitPurchase(BuildContext context) async {
    // 验证表单
    if (!formKey.currentState!.saveAndValidate()) {
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final formData = formKey.currentState?.value ?? {};
      final request = OilOrderRequest(
        depotId: state.depot!.depotId!,
        fuelType: state.selectedFuel?.fuelType ?? '',
        purchaseTon: formData['purchaseTon'] ?? '',
        remark: formData['remark'] ?? '',
      );

      await oilOrderService.createOilOrder(request);
      emit(state.copyWith(isLoading: false));
      SportsToast.showSuccess('订单创建成功');

      // 延迟一下再返回，让用户看到成功提示
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取最新订单列表，找到刚创建的订单
      try {
        final orderListResponse =
            await payOrderListService.getOrderList(page: 1, pageSize: 1);
        final latestOrder = orderListResponse.list?.isNotEmpty == true
            ? orderListResponse.list!.first
            : null;

        if (latestOrder != null) {
          BaseRouter.push(
            url: AppPage.payOrderDetailPage.path,
            extra: {'order': latestOrder, 'from': 'oilPurchaseDetail'},
          );
        } else {
          // 如果获取不到最新订单，跳转到订单列表页
          BaseRouter.push(url: AppPage.payOrderListPage.path);
        }
      } catch (e) {
        // 如果获取订单列表失败，跳转到订单列表页
        BaseRouter.push(url: AppPage.payOrderListPage.path);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      if (e is DioException && e.response?.data['code'] == 4001) {
        // 从错误响应中提取订单ID和错误消息
        final responseData = e.response?.data;
        final nestedData = responseData?['data'];
        final orderId = nestedData?['orderId'];
        final message = nestedData?['message'] ?? '您已存在待支付订单，请先完成支付';

        if (orderId != null) {
          // 显示对话框，提示用户有待支付订单
          await SportsDialog.show(
            title: '提示',
            bodyText: message,
            okText: '去支付',
            onOk: () async {
              // 关闭对话框
              await SportsDialog.dismiss();
              try {
                // 根据订单ID获取订单详情
                final order =
                    await payOrderService.getOrderDetail(orderId.toString());
                // 跳转到订单详情页
                BaseRouter.push(
                  url: AppPage.payOrderDetailPage.path,
                  extra: {'order': order, 'from': 'oilPurchaseDetail'},
                );
              } catch (error) {
                SportsToast.showError('获取订单详情失败，请稍后重试');
              }
            },
          );
        } else {
          SportsToast.showError(message);
        }
      } else {
        // 其他错误，显示通用错误提示
        SportsToast.showError('订单创建失败，请稍后重试');
      }
    }
  }
}

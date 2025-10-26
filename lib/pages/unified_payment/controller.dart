import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/unified_payment/model/payment_type.dart';
import 'package:lottery_app/pages/unified_payment/state.dart';
import 'package:lottery_app/net/code.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';

import 'model/lottery_package_info.dart';
import 'model/selected_package_info.dart';
import 'service/payment_service.dart';
import 'service/recharge_records_service.dart';

class UnifiedPaymentCtrl extends Cubit<UnifiedPaymentState> {
  UnifiedPaymentCtrl() : super(const UnifiedPaymentState()) {
    initState();
  }

  /// 初始化页面
  Future<void> initState() async {
    await _loadInitialData();
    await _checkUnpaidRechargeAndPrompt();
  }

  /// 加载初始数据
  Future<void> _loadInitialData() async {
    emit(state.copyWith(isLoading: true));

    try {
      // 加载套餐数据
      await _loadPackages();

      emit(state.copyWith(
        isLoading: false,
        accountBalance:
            BaseConfig.appContext!.read<AppController>().state.balance,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  /// 加载套餐数据
  Future<void> _loadPackages() async {
    try {
      // 暂时固定使用双色球类型
      final res = await paymentService.getPackages(
        LotteryType.doubleColorBall.value,
      );

      final data = res.data;
      var packages = <LotteryPackageInfo>[];

      if (res.code == HttpCode.success && data.list.isNotEmpty) {
        packages = data.list
            .map((packageInfo) => SelectedPackageInfo(
                  uuid: packageInfo.uuid,
                  lotteryType: packageInfo.lotteryType.toString(),
                  minQuantity: packageInfo.minQuantity.toString(),
                  bonusQuantity: packageInfo.bonusQuantity.toString(),
                  rechargeAmount: packageInfo.rechargeAmount,
                  hasBonus: packageInfo.bonusQuantity > 0,
                  totalQuantity: packageInfo.minQuantity.toInt() +
                      packageInfo.bonusQuantity.toInt(),
                ))
            .toList();
      }

      emit(state.copyWith(packages: packages, isLoading: false));
    } catch (e) {
      // 如果套餐加载失败，使用空列表
      emit(state.copyWith(packages: []));
      SportsToast.showError('加载套餐数据失败: ${e.toString()}');
    }
  }

  Future<void> _showUnpaidRechargeDialog(String uuid) async {
    await SportsDialog.show(
      title: '提示',
      bodyText: '您有一笔未完成的支付订单，是否前往处理？',
      cancelText: '取消',
      okText: '去处理',
      onOk: () {
        SportsDialog.dismiss();
        // 标记用户已处理过提示
        emit(state.copyWith(hasHandledUnpaidPrompt: true));
        BaseRouter.push(
          url: AppPage.payOrderDetailPage.path,
          extra: uuid,
        );
      },
      onCancel: () {
        // 标记用户已处理过提示
        emit(state.copyWith(hasHandledUnpaidPrompt: true));
      },
    );
  }

  /// 进入页面后检测是否存在未支付充值订单
  Future<void> _checkUnpaidRechargeAndPrompt() async {
    // 如果已经处理过提示，则不再检查
    if (state.hasHandledUnpaidPrompt) return;

    try {
      final res = await rechargeRecordsService.getRechargeRecords(
        null,
        'DESC',
        'createTime',
        1,
        1,
      );
      if (res.code != HttpCode.success || res.data.list.isEmpty) return;
      final firstOrder = res.data.list.first;
      if (firstOrder.status != OrderStatus.Pending.value &&
          firstOrder.status != OrderStatus.Submitted.value) {
        return;
      }

      _showUnpaidRechargeDialog(firstOrder.uuid);
    } on DioException catch (e) {
      l.e('UnifiedPaymentCtrl', '获取充值订单失败: ${e.response?.data?['message']}');
      // SportsToast.showError(e.response?.data?['message'] ?? '获取充值订单失败');
    }
  }

  /// 切换支付类型
  void switchPaymentType(PaymentType type) {
    emit(state.copyWith(
      paymentType: type,
      clearSelectedPackage: true,
      customAmount: 0.0,
      hasError: false,
      errorMessage: null,
    ));
  }

  /// 切换彩票类型
  Future<void> switchLotteryType(LotteryType lotteryType) async {
    if (state.currentLotteryType == lotteryType) return;

    emit(state.copyWith(
      currentLotteryType: lotteryType,
      clearSelectedPackage: true, // 清空选择的套餐
    ));

    // 重新加载套餐数据
    await _loadPackages();
  }

  /// 选择套餐
  void selectPackage(SelectedPackageInfo package) {
    emit(state.copyWith(selectedPackage: package));
  }

  /// 设置自定义金额
  void setCustomAmount(double amount) {
    emit(state.copyWith(customAmount: amount));
  }

  /// 设置备注
  void setRemark(String remark) {
    emit(state.copyWith(remark: remark));
  }

  /// 重置表单
  void resetForm() {
    emit(state.copyWith(
      clearSelectedPackage: true,
      customAmount: 0.0,
      remark: '',
      hasError: false,
      errorMessage: null,
    ));
  }

  /// 验证余额充值金额
  bool validateRechargeAmount(double amount) {
    final appState = BaseConfig.appContext!.read<AppController>().state;
    return amount >= appState.miniDepositAmount;
  }

  /// 获取最小金额提示文本
  String getMinAmountText() {
    final appState = BaseConfig.appContext!.read<AppController>().state;
    return '最小充值金额 ¥${appState.miniDepositAmount}';
  }

  /// 发起支付
  Future<void> initiatePayment(BuildContext context) async {
    // 验证支付条件并给出用户友好的提示
    if (!_validatePaymentConditions()) {
      return;
    }

    emit(state.copyWith(isProcessing: true));

    try {
      if (state.paymentType == PaymentType.Package) {
        await _handlePackagePayment(context);
      } else {
        await _handleBalancePayment(context);
      }
    } catch (e) {
      // 支付失败只显示toast提示，不改变页面错误状态
      emit(state.copyWith(isProcessing: false));
    }
  }

  /// 验证支付条件并显示相应提示
  bool _validatePaymentConditions() {
    final appState = BaseConfig.appContext!.read<AppController>().state;
    if (state.isProcessing || state.isLoading) {
      return false;
    }

    if (state.paymentType == PaymentType.Package) {
      if (state.selectedPackage == null) {
        SportsToast.showWarning('请选择要购买的套餐');
        return false;
      }
    } else {
      // 余额充值验证
      if (state.customAmount <= 0) {
        SportsToast.showWarning('请输入充值金额');
        return false;
      }
      if (state.customAmount < appState.miniDepositAmount) {
        SportsToast.showWarning('充值金额不能少于¥${appState.miniDepositAmount}');
        return false;
      }
    }

    return true;
  }

  Future<void> _handlePackagePayment(BuildContext context) async {
    try {
      final request = CreatePackageOrderRequest(
        type: state.paymentType.value,
        paymentMethod: PaymentMethod.CorpToCorp.value,
        packageUuid: state.selectedPackage?.uuid,
        remark: state.remark,
      );

      final response = await paymentService.createPackagePaymentOrder(request);

      if (response.data.uuid != null && response.data.uuid!.isNotEmpty) {
        BaseRouter.push(
          url: AppPage.payOrderDetailPage.path,
          extra: response.data.uuid,
        );
      }
      emit(state.copyWith(isProcessing: false));

      // if (context.mounted) {
      //   await _openWebViewPayment(
      //       context, '', response.uuid);
      // }
    } on DioException catch (e) {
      SportsToast.showError(e.response?.data?['message'] ?? '创建支付订单失败');
      rethrow;
    }
  }

  Future<void> _handleBalancePayment(BuildContext context) async {
    try {
      final request = CreateBalanceOrderRequest(
        type: state.paymentType.value,
        paymentMethod: PaymentMethod.CorpToCorp.value,
        quota: state.paymentAmount.toInt(),
        remark: state.remark,
      );
      print('request.remark: ${request.remark}');
      final response = await paymentService.createBalancePaymentOrder(request);

      if (response.data.uuid != null && response.data.uuid!.isNotEmpty) {
        BaseRouter.push(
          url: AppPage.payOrderDetailPage.path,
          extra: response.data.uuid,
        );
      }
      emit(state.copyWith(isProcessing: false));

      // if (context.mounted) {
      //   await _openWebViewPayment(
      //       context, '', response.uuid);
      // }
    } on DioException catch (e) {
      SportsToast.showError(e.response?.data?['message'] ?? '创建支付订单失败');
      rethrow;
    }
  }

  /// 智能切换到充值模式并设置金额
  void switchToRechargeMode(double amount) {
    emit(state.copyWith(
      paymentType: PaymentType.Balance,
      customAmount: amount,
      clearSelectedPackage: true,
    ));
  }

  /// 检查余额并处理购买（套餐购买不需要余额检查，直接支付）
  Future<void> checkBalanceAndPurchase(BuildContext context) async {
    await initiatePayment(context);
  }
}

import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';
import 'package:lottery_app/pages/gift_lottery/service/gift_lottery_service.dart';
import 'package:lottery_app/pages/gift_lottery/state.dart';

class GiftLotteryCtrl extends Cubit<GiftLotteryState> {
  Timer? _dynamicRefreshTimer;

  GiftLotteryCtrl({GiftLotteryService? service})
      : super(const GiftLotteryState()) {
    initState();
  }

  final EasyRefreshController refreshController = EasyRefreshController();

  @override
  Future<void> close() {
    _dynamicRefreshTimer?.cancel();
    return super.close();
  }

  /// 初始化状态
  void initState() async {
    await loadAccountInfo();
  }

  /// 加载账户信息
  Future<void> loadAccountInfo() async {
    try {
      /// Mock 数据
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  bool roleHasCodeGenerate(QrCodeType type) {
    final employee =
        BaseConfig.appContext!.read<AppController>().state.currentEmployee;
    final codeConf = employee?.codeConf;
    final role = employee?.roles;
    if (codeConf == null || role == null) {
      return false;
    }

    /// 老板角色可以生成所有类型的二维码
    if (role.contains(EmployeeRole.owner.name)) {
      return true;
    }

    /// 如果没有配置二维码类型, 则不支持生成
    final codeConfEnable = codeConf.any((element) {
      if (element.type == type.code && element.enable == 1) {
        return true;
      }
      return false;
    });
    return codeConfEnable;
  }

  /// 选择彩票类型
  void selectLotteryType(LotteryType type) {
    emit(state.copyWith(selectedLotteryType: type));
  }

  /// 设置批量生成数量
  void setBatchCount(int count) {
    emit(state.copyWith(batchCount: count));
  }

  /// 清除错误状态
  void clearError() {
    emit(state.copyWith(
      hasError: false,
      errorMessage: null,
    ));
  }
}

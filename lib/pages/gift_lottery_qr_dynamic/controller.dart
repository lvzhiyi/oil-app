import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/address.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_dynamic/model/common_type.dart';

import 'package:lottery_app/pages/gift_lottery_qr_dynamic/state.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';

import 'service/gift_lottery_dynamic_service.dart';

class GiftLotteryQrDynamicCtrl extends Cubit<GiftLotteryQrDynamicState> {
  Timer? _dynamicRefreshTimer;

  GiftLotteryQrDynamicCtrl() : super(const GiftLotteryQrDynamicState()) {
    initState();
  }

  @override
  Future<void> close() {
    _dynamicRefreshTimer?.cancel();
    return super.close();
  }

  /// 初始化状态
  void initState() async {}

  /// 选择彩票类型
  void selectLotteryType(LotteryType type) {
    emit(state.copyWith(selectedLotteryType: type));
  }

  /// 选择二维码类型
  void selectQrType(QrCodeType type) {
    emit(state.copyWith(
      selectedQrType: type,
      dynamicQrCode: null,
    ));
  }

  /// 生成动态二维码
  Future<void> generateDynamicQrCode() async {
    final balance = BaseConfig.appContext!.read<AppController>().state.balance;
    final hasLottery =
        BaseConfig.appContext!.read<AppController>().state.hasLottery;
    if (balance <= 0 && !hasLottery) {
      SportsDialog.show(
        title: '提示',
        bodyText: '余额不足，请先充值',
        okText: '充值',
        cancelText: '取消',
        onCancel: () {
          SportsDialog.dismiss();
        },
        onOk: () {
          BaseRouter.push(url: AppPage.unifiedPaymentPage.path);
        },
      );
      return;
    }

    emit(state.copyWith(
      isGenerating: true,
    ));

    try {
      final dynamicQr = await giftLotteryDynamicService.generateDynamicQr(
        DynamicQrRequest(lotteryType: state.selectedLotteryType),
      );

      /// 生成新的动态二维码
      final qrCode = QrCodeDynamicInfo(
        uuid: dynamicQr.data ?? '',
        lotteryType: state.selectedLotteryType,
        url: '${BaseAddress.clientBaseUrl}?code=${dynamicQr.data}',
      );

      emit(state.copyWith(
        dynamicQrCode: qrCode,
        isGenerating: false,
        isExpired: false,
        dynamicRefreshCountdown: 15,
      ));

      /// 启动15秒自动刷新计时器
      _startDynamicRefreshTimer();
    } catch (e) {
      emit(state.copyWith(
        isExpired: true,
        isGenerating: false,
      ));
    }
  }

  /// 启动动态二维码自动刷新计时器
  /// 每15秒刷新一次
  void _startDynamicRefreshTimer() {
    _dynamicRefreshTimer?.cancel();

    _dynamicRefreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(
        dynamicRefreshCountdown: state.dynamicRefreshCountdown - 1,
      ));

      if (state.dynamicRefreshCountdown <= 0) {
        _dynamicRefreshTimer?.cancel();
        _dynamicRefreshTimer = null;
        emit(state.copyWith(
          isExpired: true,
        ));
      }
    });
  }
}

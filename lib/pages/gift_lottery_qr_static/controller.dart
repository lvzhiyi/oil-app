import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/model/common_type.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/state.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/widgets/exports_pdf.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';
import 'package:lottery_app/widgets/popup/loading.dart';
import 'package:lottery_app/widgets/popup/toast.dart';
import 'package:screenshot/screenshot.dart';

import 'service/gift_lottery_static_service.dart';

class GiftLotteryQrStaticCtrl extends Cubit<GiftLotteryQrStaticState> {
  GiftLotteryQrStaticCtrl() : super(const GiftLotteryQrStaticState()) {
    initState();
  }

  ScreenshotController screenshotController = ScreenshotController();
  final newCodeInputFocusNode = FocusNode();
  final newCodeInputController = TextEditingController();

  int pageNum = 1;
  int total = 0;
  int pageSize = 10;
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 初始化状态
  void initState() async {
    await getStaticCodes();
  }

  /// 选择彩票类型
  void selectLotteryType(LotteryType type) {
    emit(state.copyWith(selectedLotteryType: type));
  }

  /// 选择彩票类型
  void selectLotteryTypeOfNewCode(LotteryType type) {
    emit(state.copyWith(selectedLotteryTypeOfNewCode: type));
  }

  /// 选择时间排序
  void selectSortType(SortType type) {
    pageNum = 1;
    emit(state.copyWith(selectedSortType: type));
    getStaticCodes();
  }

  /// 选择二维码状态
  void selectStatus(QrCodeStatus? status) {
    pageNum = 1;
    emit(state.copyWith(selectedStatus: status));
    getStaticCodes();
  }

  /// 设置批量生成数量
  void setBatchCount(int count) {
    emit(state.copyWith(batchCount: count));
  }

  /// 加载更多
  void onLoading() async {
    if (state.staticCodes.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    final staticCodesNewData = await getStaticCodes(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      staticCodes: [...state.staticCodes, ...staticCodesNewData.list],
    ));
  }

  /// 刷新
  void onRefresh() async {
    pageNum = 1;
    await getStaticCodes(onRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
  }

  /// 获取静态码
  Future<QrCodeStaticData> getStaticCodes({
    bool onRefresh = false,
    bool loadMore = false,
  }) async {
    if (!onRefresh && !loadMore) {
      emit(state.copyWith(pageStatus: PageStatus.loading));
    }
    try {
      final staticCodes = await giftLotteryStaticService.getStaticQrCodes(
        state.selectedSortType.value,
        'createTime',
        pageNum.toString(),
        pageSize.toString(),
        state.selectedStatus.code,
        QrCodeType.static.code,
      );

      total = staticCodes.data.total;

      if (staticCodes.data.list.isEmpty) {
        emit(state.copyWith(
          pageStatus: PageStatus.empty,
        ));
        return staticCodes.data;
      }

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          staticCodes: staticCodes.data.list,
          pageStatus: PageStatus.success,
        ));
      }
      return staticCodes.data;
    } catch (e) {
      emit(state.copyWith(
        pageStatus: PageStatus.error,
      ));
      return const QrCodeStaticData(list: [], total: 0);
    }
  }

  Future<void> exportPdf(QrCodeStatus? status) async {
    SportsLoading.dismiss();
    SportsLoading.show(msg: '导出中...');
    try {
      final staticCodes = await giftLotteryStaticService.getStaticQrCodes(
        SortType.timeDesc.value,
        'createTime',
        '1',
        '1001',
        status?.code,
        QrCodeType.static.code,
      );

      if (staticCodes.data.list.length > 1000) {
        SportsLoading.dismiss();
        SportsToast.show('您导出的数量过大, 请联系闪省赠彩平台', ToastType.error);
        return;
      }

      await ExportPdf.exportPdf(staticCodes.data.list);
      SportsToast.show('导出成功', ToastType.success);
    } catch (e) {
      SportsToast.show('导出失败', ToastType.error);
    }
    SportsLoading.dismiss();
  }

  generateNewCodes() async {
    final count = int.tryParse(newCodeInputController.text);
    if (count == null) {
      SportsToast.show('请输入生成数量', ToastType.error);
      return;
    }
    if (count <= 0) {
      SportsToast.show('生成数量不能小于等于0', ToastType.error);
      return;
    }
    SportsDialog.dismiss();
    SportsLoading.show(msg: '生成中...');

    try {
      await giftLotteryStaticService.generateBatchQr(
        BatchQrCodeRequest(
          lotteryType: state.selectedLotteryType,
          num: count,
        ),
      );

      newCodeInputController.clear();
      pageNum = 1;
      await getStaticCodes();
      SportsLoading.dismiss();
      SportsToast.show('二维码已成功生成', ToastType.success);
      emit(state.copyWith(
        pageStatus: PageStatus.success,
      ));
    } catch (e) {
      SportsLoading.dismiss();
    }
  }
}

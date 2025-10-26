import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/recharge_records/service/recharge_records_service.dart';
import 'package:lottery_app/pages/recharge_records/state.dart';
import 'package:lottery_app/pages/recharge_records/model/common_type.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class RechargeRecordsCtrl extends Cubit<RechargeRecordsState> {
  RechargeRecordsCtrl() : super(const RechargeRecordsState()) {
    initState();
  }

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );
  int pageNum = 1;
  int total = 0;
  int pageSize = 10;

  /// 初始化状态
  void initState() async {
    loadRecords();
    BaseConfig.appContext!.read<AppController>().fetchAgentInfo();
  }

  /// 选择排序方式
  void selectSortType(SortType sortType) {
    pageNum = 1;
    emit(state.copyWith(sortType: sortType));
    loadRecords();
  }

  /// 选择充值类型
  void selectRechargeType(RechargeType rechargeType) {
    pageNum = 1;
    emit(state.copyWith(rechargeType: rechargeType));
    loadRecords();
  }

  /// 加载更多
  void onLoading() async {
    if (state.records.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    await loadRecords(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      records:
          pageNum == 1 ? state.records : [...state.records, ...state.records],
    ));
  }

  /// 刷新
  void onRefresh() async {
    pageNum = 1;
    await loadRecords(onRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
    BaseConfig.appContext!.read<AppController>().fetchAgentInfo();
  }

  /// 加载记录列表
  Future<RechargeRecordPageData> loadRecords(
      {bool loadMore = false, bool onRefresh = false}) async {
    try {
      if (!onRefresh && !loadMore) {
        emit(state.copyWith(pageStatus: PageStatus.loading));
      }
      RechargeRecordResponse? response;

      response = await rechargeRecordsService.getRechargeRecords(
        state.rechargeType.value,
        state.sortType.value,
        'createTime',
        pageNum,
        pageSize,
      );

      final List<RechargeRecord> newRecords = response.data.list;
      total = response.data.total;

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          records: newRecords,
          pageStatus: PageStatus.success,
        ));
      }

      if (response.data.list.isEmpty) {
        emit(state.copyWith(pageStatus: PageStatus.empty));
      }

      return response.data;
    } catch (e) {
      l.e('加载记录失败', e.toString());
      emit(state.copyWith(pageStatus: PageStatus.error));
      pageNum = 1;
      return const RechargeRecordPageData(list: [], total: 0);
    }
  }

  /// 加载更多记录
  Future<void> loadMoreRecords() async {
    try {
      final List<RechargeRecord> newRecords = [
        ...state.records,
      ];

      emit(state.copyWith(
        records: newRecords,
      ));
    } catch (e) {
      l.e('加载更多记录失败', e.toString());
    }
  }
}

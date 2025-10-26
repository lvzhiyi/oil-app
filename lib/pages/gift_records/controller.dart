import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:lottery_app/pages/gift_records/model/common_type.dart';
import 'package:lottery_app/pages/gift_records/model/gift_records_response.dart';
import 'package:lottery_app/pages/gift_records/state.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

import 'service/gift_records_service.dart';

class GiftRecordsCtrl extends Cubit<GiftRecordsState> {
  final GiftRecordsService _service;
  int pageNum = 1;
  int total = 0;
  int pageSize = 10;
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  GiftRecordsCtrl({required GiftRecordsService service})
      : _service = service,
        super(const GiftRecordsState()) {
    initState();
  }

  /// 初始化状态
  void initState() async {
    await loadRecords();
    // await loadStats();
  }

  /// 刷新数据
  Future<void> onRefresh() async {
    pageNum = 1;
    await loadRecords(isRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
  }

  /// 加载更多
  void onLoading() async {
    if (state.records.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    final recordsNewData = await loadRecords(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      records: [...state.records, ...recordsNewData],
    ));
  }

  /// 加载记录列表
  Future<List<GiftRecordItem>> loadRecords(
      {bool isRefresh = false, bool loadMore = false}) async {
    try {
      if (!isRefresh && !loadMore) {
        emit(state.copyWith(pageStatus: PageStatus.loading));
      }
      final response = await _service.getGiftRecords(state.filter.toJson());

      total = response.data?.total ?? 0;

      if (response.data?.list?.isEmpty ?? true) {
        emit(state.copyWith(pageStatus: PageStatus.empty));
        return [];
      }

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          records: response.data?.list ?? [],
          pageStatus: PageStatus.success,
        ));
      }
      return response.data?.list ?? [];
    } catch (e) {
      l.e('加载记录失败', e.toString());
      emit(state.copyWith(
        pageStatus: PageStatus.error,
      ));
      return [];
    }
  }

  /// 应用筛选条件
  Future<void> applyFilter(GiftRecordFilter newFilter) async {
    final filterWithPage = newFilter.copyWith(page: 1);
    emit(state.copyWith(
      filter: filterWithPage,
      records: [],
    ));

    await loadRecords(isRefresh: true);
  }

  /// 重置筛选条件
  Future<void> resetFilter() async {
    const newFilter = GiftRecordFilter();
    emit(state.copyWith(
      filter: newFilter,
      records: [],
    ));

    await loadRecords(isRefresh: true);
  }

  /// 获取记录详情
  Future<GiftRecordItem?> getRecordDetail(String recordId) async {
    try {
      /// 从当前列表中查找
      return state.records
          .firstWhere((record) => record.id.toString() == recordId);
    } catch (e) {
      l.e('获取记录详情失败', e.toString());
      return null;
    }
  }

  /// 刷新单个记录状态
  Future<void> refreshRecordStatus(String recordId) async {
    try {
      /// Mock刷新：这里可以调用API刷新状态
      l.i('刷新记录状态', '记录ID: $recordId');
    } catch (e) {
      l.e('刷新记录状态失败', e.toString());
    }
  }

  /// 更新排序
  void updateSort(String orderByName, String orderByType) {
    final newFilter = state.filter.copyWith(
      orderByName: orderByName,
      orderByType: orderByType,
      page: 1,
    );
    applyFilter(newFilter);
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}

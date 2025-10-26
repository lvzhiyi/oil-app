import 'package:lottery_app/pages/gift_records/model/common_type.dart';
import 'package:lottery_app/pages/gift_records/model/gift_records_response.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';

class GiftRecordsState {
  /// 记录列表数据
  final List<GiftRecordItem> records;

  /// 当前筛选条件
  final GiftRecordFilter filter;

  /// 分页信息
  final GiftRecordsData? pageData;

  /// 统计信息
  final GiftRecordStats? stats;

  /// 页面状态
  final PageStatus pageStatus;

  const GiftRecordsState({
    this.records = const [],
    this.filter = const GiftRecordFilter(),
    this.pageData,
    this.stats,
    this.pageStatus = PageStatus.loading,
  });

  GiftRecordsState copyWith({
    List<GiftRecordItem>? records,
    GiftRecordFilter? filter,
    GiftRecordsData? pageData,
    GiftRecordStats? stats,
    PageStatus? pageStatus,
  }) {
    return GiftRecordsState(
      records: records ?? this.records,
      filter: filter ?? this.filter,
      pageData: pageData ?? this.pageData,
      stats: stats ?? this.stats,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}

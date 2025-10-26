import 'package:lottery_app/global/enum/common.dart';

/// 筛选条件
class GiftRecordFilter {
  /// 排序字段（目前只支持createTime）
  final String orderByName;

  /// 排序方向（ASC/DESC）
  final String orderByType;

  /// 页码
  final int page;

  /// 每页大小
  final int pageSize;

  const GiftRecordFilter({
    this.orderByName = 'createTime',
    this.orderByType = 'DESC',
    this.page = 1,
    this.pageSize = 20,
  });

  GiftRecordFilter copyWith({
    String? orderByName,
    String? orderByType,
    int? page,
    int? pageSize,
  }) {
    return GiftRecordFilter(
      orderByName: orderByName ?? this.orderByName,
      orderByType: orderByType ?? this.orderByType,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderByName': orderByName,
      'orderByType': orderByType,
      'page': page,
      'pageSize': pageSize,
    };
  }

  factory GiftRecordFilter.fromJson(Map<String, dynamic> json) {
    return GiftRecordFilter(
      orderByName: json['orderByName'] ?? 'createTime',
      orderByType: json['orderByType'] ?? 'DESC',
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
    );
  }
}

/// 赠送记录数据
class GiftRecord {
  /// 记录ID
  final String id;

  /// 赠送日期
  final DateTime giftDate;

  /// 用户手机号
  final String userPhone;

  /// 彩票类型
  final LotteryType lotteryType;

  /// 彩票号码
  final String lotteryNumber;

  /// 倍数
  final int multiple;

  /// 状态
  final LotteryStatus status;

  /// 中奖金额（如已中奖）
  final double? winAmount;

  /// 创建时间
  final DateTime createTime;

  /// 更新时间
  final DateTime? updateTime;

  /// 二维码ID
  final String? qrCodeId;

  /// 领取时间
  final DateTime? claimTime;

  /// 开奖期号
  final String? drawNumber;

  /// 开奖时间
  final DateTime? drawTime;

  const GiftRecord({
    required this.id,
    required this.giftDate,
    required this.userPhone,
    required this.lotteryType,
    required this.lotteryNumber,
    this.multiple = 1,
    required this.status,
    this.winAmount,
    required this.createTime,
    this.updateTime,
    this.qrCodeId,
    this.claimTime,
    this.drawNumber,
    this.drawTime,
  });

  GiftRecord copyWith({
    String? id,
    DateTime? giftDate,
    String? userPhone,
    LotteryType? lotteryType,
    String? lotteryNumber,
    int? multiple,
    LotteryStatus? status,
    double? winAmount,
    DateTime? createTime,
    DateTime? updateTime,
    String? qrCodeId,
    DateTime? claimTime,
    String? drawNumber,
    DateTime? drawTime,
  }) {
    return GiftRecord(
      id: id ?? this.id,
      giftDate: giftDate ?? this.giftDate,
      userPhone: userPhone ?? this.userPhone,
      lotteryType: lotteryType ?? this.lotteryType,
      lotteryNumber: lotteryNumber ?? this.lotteryNumber,
      multiple: multiple ?? this.multiple,
      status: status ?? this.status,
      winAmount: winAmount ?? this.winAmount,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      qrCodeId: qrCodeId ?? this.qrCodeId,
      claimTime: claimTime ?? this.claimTime,
      drawNumber: drawNumber ?? this.drawNumber,
      drawTime: drawTime ?? this.drawTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'giftDate': giftDate.toIso8601String(),
      'userPhone': userPhone,
      'lotteryType': lotteryType.code,
      'lotteryNumber': lotteryNumber,
      'multiple': multiple,
      'status': status.code,
      'winAmount': winAmount,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime?.toIso8601String(),
      'qrCodeId': qrCodeId,
      'claimTime': claimTime?.toIso8601String(),
      'drawNumber': drawNumber,
      'drawTime': drawTime?.toIso8601String(),
    };
  }

  factory GiftRecord.fromJson(Map<String, dynamic> json) {
    return GiftRecord(
      id: json['id'],
      giftDate: DateTime.parse(json['giftDate']),
      userPhone: json['userPhone'],
      lotteryType: LotteryType.fromValue(json['lotteryType']),
      lotteryNumber: json['lotteryNumber'],
      multiple: json['multiple'] ?? 1,
      status: LotteryStatus.fromCode(json['status']),
      winAmount: json['winAmount']?.toDouble(),
      createTime: DateTime.parse(json['createTime']),
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : null,
      qrCodeId: json['qrCodeId'],
      claimTime:
          json['claimTime'] != null ? DateTime.parse(json['claimTime']) : null,
      drawNumber: json['drawNumber'],
      drawTime:
          json['drawTime'] != null ? DateTime.parse(json['drawTime']) : null,
    );
  }
}

/// 分页数据
class PageData<T> {
  /// 数据列表
  final List<T> data;

  /// 当前页码
  final int currentPage;

  /// 每页大小
  final int pageSize;

  /// 总条数
  final int total;

  /// 总页数
  final int totalPages;

  /// 是否有下一页
  final bool hasNext;

  /// 是否有上一页
  final bool hasPrevious;

  const PageData({
    required this.data,
    required this.currentPage,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  PageData<T> copyWith({
    List<T>? data,
    int? currentPage,
    int? pageSize,
    int? total,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return PageData<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}

/// 赠送记录列表响应
class GiftRecordResponse {
  /// 分页数据
  final PageData<GiftRecord> pageData;

  /// 统计信息
  final GiftRecordStats? stats;

  const GiftRecordResponse({
    required this.pageData,
    this.stats,
  });

  factory GiftRecordResponse.fromJson(Map<String, dynamic> json) {
    return GiftRecordResponse(
      pageData: PageData<GiftRecord>(
        data: (json['pageData']['data'] as List)
            .map((item) => GiftRecord.fromJson(item))
            .toList(),
        currentPage: json['pageData']['currentPage'],
        pageSize: json['pageData']['pageSize'],
        total: json['pageData']['total'],
        totalPages: json['pageData']['totalPages'],
        hasNext: json['pageData']['hasNext'],
        hasPrevious: json['pageData']['hasPrevious'],
      ),
      stats: json['stats'] != null
          ? GiftRecordStats.fromJson(json['stats'])
          : null,
    );
  }
}

/// 统计信息
class GiftRecordStats {
  /// 总赠送数量
  final int totalGiftCount;

  /// 总中奖数量
  final int totalWinCount;

  /// 总中奖金额
  final double totalWinAmount;

  /// 今日赠送数量
  final int todayGiftCount;

  /// 今日中奖数量
  final int todayWinCount;

  /// 今日中奖金额
  final double todayWinAmount;

  const GiftRecordStats({
    this.totalGiftCount = 0,
    this.totalWinCount = 0,
    this.totalWinAmount = 0.0,
    this.todayGiftCount = 0,
    this.todayWinCount = 0,
    this.todayWinAmount = 0.0,
  });

  factory GiftRecordStats.fromJson(Map<String, dynamic> json) {
    return GiftRecordStats(
      totalGiftCount: json['totalGiftCount'] ?? 0,
      totalWinCount: json['totalWinCount'] ?? 0,
      totalWinAmount: (json['totalWinAmount'] ?? 0).toDouble(),
      todayGiftCount: json['todayGiftCount'] ?? 0,
      todayWinCount: json['todayWinCount'] ?? 0,
      todayWinAmount: (json['todayWinAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGiftCount': totalGiftCount,
      'totalWinCount': totalWinCount,
      'totalWinAmount': totalWinAmount,
      'todayGiftCount': todayGiftCount,
      'todayWinCount': todayWinCount,
      'todayWinAmount': todayWinAmount,
    };
  }
}

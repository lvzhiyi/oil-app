import 'package:flutter/material.dart';
import 'package:lottery_app/global/enum/common.dart';

/// 筛选条件
class RechargeRecordFilter {
  /// 充值类型（余额充值/套餐购买）
  final RechargeType? rechargeType;

  /// 排序方式：asc(升序) / desc(降序)
  final SortType orderByType;

  /// 排序字段：createTime(创建时间) / amount(金额)
  final String orderByName;

  /// 页码
  final int current;

  /// 每页大小
  final int pageSize;

  final String? status;

  const RechargeRecordFilter({
    this.rechargeType = RechargeType.all,
    this.orderByType = SortType.timeDesc,
    this.orderByName = 'createTime',
    this.current = 1,
    this.pageSize = 20,
    this.status,
  });

  RechargeRecordFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    RechargeType? rechargeType,
    SortType? orderByType,
    String? orderByName,
    int? page,
    int? pageSize,
    String? status,
  }) {
    return RechargeRecordFilter(
      rechargeType: rechargeType ?? this.rechargeType,
      orderByType: orderByType ?? this.orderByType,
      orderByName: orderByName ?? this.orderByName,
      current: current,
      pageSize: pageSize ?? this.pageSize,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rechargeType': rechargeType,
      'orderByType': orderByType,
      'orderByName': orderByName,
      'current': current,
      'pageSize': pageSize,
    };
  }

  factory RechargeRecordFilter.fromJson(Map<String, dynamic> json) {
    return RechargeRecordFilter(
      rechargeType: json['rechargeType'],
      orderByType: json['orderByType'] ?? SortType.timeDesc,
      orderByName: json['orderByName'] ?? 'createTime',
      current: json['current'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      status: json['status'],
    );
  }
}

/// 充值记录数据
class RechargeRecord {
  /// 创建时间
  final int createTime;

  /// 更新时间
  final int updateTime;

  /// 记录ID
  final String uuid;

  /// 充值类型（余额充值/套餐购买）
  final RechargeType type;

  /// 充值金额
  final String quota;

  /// 彩票类型（如果是套餐购买）
  final LotteryType? lotteryType;

  /// 支付金额
  final String payAmount;

  /// 备注
  final String? remark;

  /// 支付方式
  final PaymentMethod paymentMethod;

  /// 充值状态：pending(处理中) / success(成功) / failed(失败) / canceled(取消)
  final String status;

  const RechargeRecord({
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.type,
    required this.quota,
    this.lotteryType,
    required this.payAmount,
    required this.paymentMethod,
    required this.status,
    this.remark,
  });

  RechargeRecord copyWith({
    String? uuid,
    int? createTime,
    int? updateTime,
    RechargeType? type,
    String? quota,
    LotteryType? lotteryType,
    String? payAmount,
    PaymentMethod? paymentMethod,
    String? status,
    String? remark,
  }) {
    return RechargeRecord(
      uuid: uuid ?? this.uuid,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      type: type ?? this.type,
      quota: quota ?? this.quota,
      lotteryType: lotteryType ?? this.lotteryType,
      payAmount: payAmount ?? this.payAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      remark: remark ?? this.remark,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'createTime': createTime,
      'updateTime': updateTime,
      'type': type,
      'quota': quota,
      'lotteryType': lotteryType?.code,
      'payAmount': payAmount,
      'paymentMethod': paymentMethod.value,
      'status': status,
      'remark': remark,
    };
  }

  factory RechargeRecord.fromJson(Map<String, dynamic> json) {
    return RechargeRecord(
      uuid: json['uuid'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      type: RechargeType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => RechargeType.balance,
      ),
      quota: json['quota'],
      lotteryType: json['lotteryType'] != null
          ? LotteryType.fromValue(json['lotteryType'])
          : null,
      payAmount: json['payAmount'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.value == json['paymentMethod'],
        orElse: () => PaymentMethod.Heepay,
      ),
      status: json['status'],
      remark: json['remark'],
    );
  }

  /// 获取状态颜色
  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// 分页数据
class RechargeRecordPageData {
  /// 数据列表
  final List<RechargeRecord> list;

  /// 总条数
  final int total;

  const RechargeRecordPageData({
    required this.list,
    required this.total,
  });

  RechargeRecordPageData copyWith({
    List<RechargeRecord>? data,
    int? currentPage,
    int? pageSize,
  }) {
    return RechargeRecordPageData(
      list: list,
      total: total,
    );
  }

  factory RechargeRecordPageData.fromJson(Map<String, dynamic> json) {
    return RechargeRecordPageData(
      list: (json['list'] as List)
          .map((item) => RechargeRecord.fromJson(item))
          .toList(),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((item) => (item as dynamic).toJson()).toList(),
      'total': total,
    };
  }
}

/// 充值记录统计信息
class RechargeRecordStats {
  /// 总充值次数
  final int totalRechargeCount;

  /// 总充值金额
  final double totalRechargeAmount;

  /// 今日充值次数
  final int todayRechargeCount;

  /// 今日充值金额
  final double todayRechargeAmount;

  const RechargeRecordStats({
    required this.totalRechargeCount,
    required this.totalRechargeAmount,
    required this.todayRechargeCount,
    required this.todayRechargeAmount,
  });

  RechargeRecordStats copyWith({
    int? totalRechargeCount,
    double? totalRechargeAmount,
    int? todayRechargeCount,
    double? todayRechargeAmount,
  }) {
    return RechargeRecordStats(
      totalRechargeCount: totalRechargeCount ?? this.totalRechargeCount,
      totalRechargeAmount: totalRechargeAmount ?? this.totalRechargeAmount,
      todayRechargeCount: todayRechargeCount ?? this.todayRechargeCount,
      todayRechargeAmount: todayRechargeAmount ?? this.todayRechargeAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRechargeCount': totalRechargeCount,
      'totalRechargeAmount': totalRechargeAmount,
      'todayRechargeCount': todayRechargeCount,
      'todayRechargeAmount': todayRechargeAmount,
    };
  }

  factory RechargeRecordStats.fromJson(Map<String, dynamic> json) {
    return RechargeRecordStats(
      totalRechargeCount: json['totalRechargeCount'] ?? 0,
      totalRechargeAmount:
          (json['totalRechargeAmount'] as num?)?.toDouble() ?? 0.0,
      todayRechargeCount: json['todayRechargeCount'] ?? 0,
      todayRechargeAmount:
          (json['todayRechargeAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// 充值记录响应
class RechargeRecordResponse {
  final RechargeRecordPageData data;

  final int code;
  final String? message;
  final String? requestId;

  RechargeRecordResponse({
    required this.data,
    required this.code,
    this.message,
    this.requestId,
  });

  RechargeRecordResponse copyWith({
    RechargeRecordPageData? pageData,
    RechargeRecordStats? stats,
  }) {
    return RechargeRecordResponse(
      data: data,
      code: code,
      message: message,
      requestId: requestId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'code': code,
      'message': message,
      'requestId': requestId,
    };
  }

  factory RechargeRecordResponse.fromJson(Map<String, dynamic> json) {
    return RechargeRecordResponse(
      data: RechargeRecordPageData.fromJson(json['data']),
      code: json['code'],
      message: json['message'],
      requestId: json['requestId'],
    );
  }
}

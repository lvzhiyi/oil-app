import 'package:lottery_app/global/enum/common.dart';

class QrCodeStaticInfoCreator {
  final int id;
  final String uuid;
  final String username;

  const QrCodeStaticInfoCreator({
    required this.id,
    required this.uuid,
    required this.username,
  });

  factory QrCodeStaticInfoCreator.fromJson(Map<String, dynamic> json) {
    return QrCodeStaticInfoCreator(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'username': username,
    };
  }
}

class QrCodeStaticData {
  final List<QrCodeStaticItem> list;
  final int total;

  const QrCodeStaticData({
    required this.list,
    required this.total,
  });

  factory QrCodeStaticData.fromJson(Map<String, dynamic> json) {
    return QrCodeStaticData(
      list: (json['list'] as List<dynamic>?)
              ?.map((item) => QrCodeStaticItem.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }

  QrCodeStaticData copyWith({
    List<QrCodeStaticItem>? list,
    int? total,
  }) {
    return QrCodeStaticData(
      list: list ?? this.list,
      total: total ?? this.total,
    );
  }
}

/// 静态二维码列表项
class QrCodeStaticItem {
  final int id;
  final int createTime;
  final String createBy;
  final String creatorName;
  final String tenantUuid;
  final String uuid;
  final LotteryType lotteryType;
  final QrCodeType? type;
  final QrCodeStatus status;
  final int expireTime;

  const QrCodeStaticItem({
    required this.id,
    required this.createTime,
    required this.createBy,
    required this.creatorName,
    required this.tenantUuid,
    required this.uuid,
    required this.lotteryType,
    required this.type,
    required this.status,
    required this.expireTime,
  });

  factory QrCodeStaticItem.fromJson(Map<String, dynamic> json) {
    return QrCodeStaticItem(
      id: json['id'] ?? 0,
      createTime: json['createTime'] ?? 0,
      createBy: json['createBy'] ?? '',
      creatorName: json['creatorName'] ?? '',
      tenantUuid: json['tenantUuid'] ?? '',
      uuid: json['uuid'] ?? '',
      lotteryType: LotteryType.values.firstWhere(
        (e) => e.code == json['lotteryType'],
        orElse: () => LotteryType.doubleColorBall,
      ),
      type: QrCodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QrCodeType.static,
      ),
      status: QrCodeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QrCodeStatus.unredeemed,
      ),
      expireTime: json['expireTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createTime': createTime,
      'createBy': createBy,
      'creatorName': creatorName,
      'tenantUuid': tenantUuid,
      'uuid': uuid,
      'lotteryType': lotteryType.code,
      'type': type?.name,
      'status': status.name,
      'expireTime': expireTime,
    };
  }

  QrCodeStaticItem copyWith({
    String? uuid,
    String? url,
    LotteryType? lotteryType,
    QrCodeType? qrType,
    int? expireTime,
    int? id,
    int? createTime,
    String? createBy,
    String? creatorName,
    String? tenantUuid,
    QrCodeType? type,
    QrCodeStatus? status,
  }) {
    return QrCodeStaticItem(
      id: id ?? this.id,
      createTime: createTime ?? this.createTime,
      createBy: createBy ?? this.createBy,
      creatorName: creatorName ?? this.creatorName,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      uuid: uuid ?? this.uuid,
      lotteryType: lotteryType ?? this.lotteryType,
      type: type ?? this.type,
      status: status ?? this.status,
      expireTime: expireTime ?? this.expireTime,
    );
  }

  /// 是否已过期
  bool get isExpired {
    return DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(expireTime));
  }
}

/// 批量生成二维码请求
class BatchQrCodeRequest {
  final LotteryType lotteryType;
  final int num;

  const BatchQrCodeRequest({
    required this.lotteryType,
    required this.num,
  });

  factory BatchQrCodeRequest.fromJson(Map<String, dynamic> json) {
    return BatchQrCodeRequest(
      lotteryType: LotteryType.values.firstWhere(
        (e) => e.code == json['lotteryType'],
        orElse: () => LotteryType.doubleColorBall,
      ),
      num: json['num'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotteryType': lotteryType.value,
      'num': num,
    };
  }
}

/// 批量生成二维码响应
class BatchQrCodeResponse {
  final List<QrCodeStaticItem> data;
  final int code;
  final String message;
  final String requestId;

  const BatchQrCodeResponse({
    required this.data,
    required this.code,
    required this.message,
    required this.requestId,
  });

  factory BatchQrCodeResponse.fromJson(Map<String, dynamic> json) {
    return BatchQrCodeResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => QrCodeStaticItem.fromJson(item))
              .toList() ??
          [],
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'code': code,
      'message': message,
      'requestId': requestId,
    };
  }
}

class GetStaticQrCodesResponse {
  final QrCodeStaticData data;
  final int code;
  final String message;
  final String requestId;

  const GetStaticQrCodesResponse({
    required this.data,
    required this.code,
    required this.message,
    required this.requestId,
  });

  factory GetStaticQrCodesResponse.fromJson(Map<String, dynamic> json) {
    return GetStaticQrCodesResponse(
      data: QrCodeStaticData.fromJson(json['data']),
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      requestId: json['requestId'] ?? '',
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

  GetStaticQrCodesResponse copyWith({
    QrCodeStaticData? data,
    int? code,
    String? message,
    String? requestId,
  }) {
    return GetStaticQrCodesResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      requestId: requestId ?? this.requestId,
    );
  }
}

class GetStaticQrCodesRequest {
  final SortType orderByType;
  final String orderByName;
  final String current;
  final String pageSize;

  const GetStaticQrCodesRequest({
    required this.orderByType,
    required this.orderByName,
    required this.current,
    required this.pageSize,
  });

  factory GetStaticQrCodesRequest.fromJson(Map<String, dynamic> json) {
    return GetStaticQrCodesRequest(
      orderByType: SortType.values.firstWhere(
        (e) => e.value == json['orderByType'],
        orElse: () => SortType.timeDesc,
      ),
      orderByName: json['orderByName'] ?? '',
      current: json['current'] ?? '',
      pageSize: json['pageSize'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderByType': orderByType.value,
      'orderByName': orderByName,
      'current': current,
      'pageSize': pageSize,
    };
  }
}

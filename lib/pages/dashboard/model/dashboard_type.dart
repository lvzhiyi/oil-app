class DashboardGiftData {
  /// 今日赠送数量
  final int today;

  /// 累计赠送数量
  final int total;

  DashboardGiftData({
    required this.today,
    required this.total,
  });

  factory DashboardGiftData.fromJson(Map<String, dynamic> json) {
    return DashboardGiftData(
      today: json['today'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'total': total,
    };
  }
}

class DashboardDataResponse {
  final DashboardGiftData data;
  final int code;
  final String message;
  final String requestId;

  const DashboardDataResponse({
    required this.data,
    required this.code,
    required this.message,
    required this.requestId,
  });

  factory DashboardDataResponse.fromJson(Map<String, dynamic> json) {
    return DashboardDataResponse(
      data: DashboardGiftData.fromJson(json['data']),
      code: json['code'],
      message: json['message'],
      requestId: json['requestId'],
    );
  }
}

class DashboardTrendsDataItem {
  final String date;
  final int count;

  DashboardTrendsDataItem({
    required this.date,
    required this.count,
  });

  factory DashboardTrendsDataItem.fromJson(Map<String, dynamic> json) {
    return DashboardTrendsDataItem(
      date: json['date'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'count': count,
    };
  }
}

class DashboardTrendsResponse {
  final List<DashboardTrendsDataItem> data;
  final int code;
  final String message;
  final String requestId;

  const DashboardTrendsResponse({
    required this.data,
    required this.code,
    required this.message,
    required this.requestId,
  });

  factory DashboardTrendsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardTrendsResponse(
      data: (json['data'] as List)
          .map((e) => DashboardTrendsDataItem.fromJson(e))
          .toList(),
      code: json['code'],
      message: json['message'],
      requestId: json['requestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'code': code,
      'message': message,
      'requestId': requestId,
    };
  }
}

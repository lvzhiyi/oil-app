import 'package:lottery_app/global/enum/common.dart';

/// 二维码信息
class QrCodeDynamicInfo {
  final String uuid;
  final String? url;
  final LotteryType? lotteryType;
  final QrCodeType? qrType;
  final int? expireTime;

  const QrCodeDynamicInfo({
    required this.uuid,
    this.url,
    this.lotteryType,
    this.qrType,
    this.expireTime,
  });

  factory QrCodeDynamicInfo.fromJson(Map<String, dynamic> json) {
    return QrCodeDynamicInfo(
      uuid: json['uuid'] ?? '',
      url: json['url'] ?? '',
      lotteryType: LotteryType.values.firstWhere(
        (e) => e.code == json['lotteryType'],
        orElse: () => LotteryType.doubleColorBall,
      ),
      qrType: QrCodeType.values.firstWhere(
        (e) => e.name == json['qrType'],
        orElse: () => QrCodeType.static,
      ),
      expireTime: json['expireTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'url': url,
      'lotteryType': lotteryType?.code ?? '',
      'qrType': qrType?.name ?? '',
      'expireTime': expireTime,
    };
  }

  QrCodeDynamicInfo copyWith({
    String? uuid,
    String? url,
    LotteryType? lotteryType,
    QrCodeType? qrType,
    int? expireTime,
  }) {
    return QrCodeDynamicInfo(
      uuid: uuid ?? this.uuid,
      url: url ?? this.url,
      lotteryType: lotteryType ?? this.lotteryType,
      qrType: qrType ?? this.qrType,
      expireTime: expireTime ?? this.expireTime,
    );
  }

  /// 是否已过期
  bool get isExpired {
    if (expireTime == null) return false;
    return DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(expireTime!));
  }
}

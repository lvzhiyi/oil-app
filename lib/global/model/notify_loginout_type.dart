import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'notify_loginout_type.freezed.dart';
part 'notify_loginout_type.g.dart';

/// 监听余额变化回调后的 model
///
@freezed
class NotifyLoginoutType with _$NotifyLoginoutType {
  factory NotifyLoginoutType({
    String? playerId,
    String? playerObjId,
    String? serviceName,
    String? messageType,

    /// 是否为黑名单
    bool? isBlacklisted,
  }) = _NotifyLoginoutModel;

  factory NotifyLoginoutType.fromJson(Map<String, Object?> json) =>
      _$NotifyLoginoutTypeFromJson(json);
}

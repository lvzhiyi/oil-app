import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'http_config_type.freezed.dart';
part 'http_config_type.g.dart';

@freezed
abstract class HttpConfigType with _$HttpConfigType {
  factory HttpConfigType({
    /// 0关 1开
    int? canVisit,
    String? endTime,
    String? startTime,
    String? tip,
  }) = _HttpConfigType;

  factory HttpConfigType.fromJson(Map<String, Object?> json) =>
      _$HttpConfigTypeFromJson(json);
}

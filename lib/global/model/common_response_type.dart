import 'package:json_annotation/json_annotation.dart';

part 'common_response_type.g.dart';

/// 通用响应
@JsonSerializable()
class CommonResponse {
  /// 消息
  final String message;

  final String? requestId;

  final int? code;

  final String? data;

  const CommonResponse({
    required this.message,
    this.requestId,
    this.code,
    this.data,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);
}

/// 通用响应
@JsonSerializable()
class CommonBoolResponse {
  /// 消息
  final String message;

  final String? requestId;

  final int? code;

  final bool? data;

  const CommonBoolResponse({
    required this.message,
    this.requestId,
    this.code,
    this.data,
  });

  factory CommonBoolResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonBoolResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonBoolResponseToJson(this);
}
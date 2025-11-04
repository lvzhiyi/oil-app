import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_response_type.g.dart';

@JsonSerializable()
class CommonResponse {
  final String? message;

  final int? code;

  final dynamic data;

  CommonResponse({this.message, this.code, this.data});
  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);
}

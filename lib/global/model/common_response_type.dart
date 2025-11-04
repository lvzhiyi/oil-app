import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_response_type.g.dart';

@JsonSerializable()
abstract class CommonResponse {
  final String? message;

  final int? code;

  CommonResponse({this.message, this.code});

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommonResponseToJson(this);
}

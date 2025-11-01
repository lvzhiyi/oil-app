import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_response_type.g.dart';

@JsonSerializable()
class CommonResponse {
  final String? message;

  final int? code;

  CommonResponse({this.message, this.code});
}

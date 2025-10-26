import 'package:json_annotation/json_annotation.dart';
part 'rest_employee_response_data.g.dart';

@JsonSerializable()
class RestEmployeeResponseData {
  String? uuid;
  String? password;
  String? phone;

  RestEmployeeResponseData({
    this.uuid,
    this.password,
    this.phone,
  });

  factory RestEmployeeResponseData.fromJson(Map<String, dynamic> json) =>
      _$RestEmployeeResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$RestEmployeeResponseDataToJson(this);

  RestEmployeeResponseData copyWith({
    String? uuid,
    String? password,
    String? phone,
  }) {
    return RestEmployeeResponseData(
      uuid: uuid ?? this.uuid,
      password: password ?? this.password,
      phone: phone ?? this.phone,
    );
  }
}

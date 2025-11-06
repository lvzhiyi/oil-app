import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_res_type.g.dart';

@JsonSerializable()
class GetStationResponse {
  final int page;
  final int pageSize;
  final int total;
  final List<Station> list;

  GetStationResponse(
      {required this.page,
      required this.pageSize,
      required this.total,
      required this.list});

  factory GetStationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetStationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetStationResponseToJson(this);
}

@JsonSerializable()
class Station {
  final int id;
  final String phone;
  final String name;
  final int status;

  Station(
      {required this.id,
      required this.phone,
      required this.name,
      required this.status});

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}

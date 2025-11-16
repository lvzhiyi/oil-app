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

@JsonSerializable()
class UploadSignatureResponse {
  final String? accessKeyId;
  final String? policy;
  final String? signature;
  final String? signatureVersion;
  final String? credential;
  final String? date;
  final String? securityToken;
  final String? dir;
  final String? path;
  final String? bucket;
  final String? endpoint;
  final String? host;
  final String? expireAt;

  UploadSignatureResponse({
    this.accessKeyId,
    this.policy,
    this.signature,
    this.signatureVersion,
    this.credential,
    this.date,
    this.securityToken,
    this.dir,
    this.path,
    this.bucket,
    this.endpoint,
    this.host,
    this.expireAt,
  });
  factory UploadSignatureResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadSignatureResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadSignatureResponseToJson(this);
}

@JsonSerializable()
class Fuel {
  final String? fuelType;
  final double? priceCny;

  Fuel({this.fuelType, this.priceCny});

  factory Fuel.fromJson(Map<String, dynamic> json) => _$FuelFromJson(json);

  Map<String, dynamic> toJson() => _$FuelToJson(this);
}

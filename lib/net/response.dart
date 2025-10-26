class BaseResponse {
  dynamic data;
  int code;
  String? message;
  String? requestId;

  BaseResponse(this.data, this.code, this.message, this.requestId);

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      json['data'],
      json['code'] as int,
      json['message'] as String?,
      json['requestId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'code': code,
        'message': message,
        'requestId': requestId,
      };
}

/// 版本信息
class AppVersionInfo {
  /// ios当前版本
  final VersionInfo iosVersion;

  /// android当前版本
  final VersionInfo androidVersion;

  const AppVersionInfo({
    required this.iosVersion,
    required this.androidVersion,
  });

  factory AppVersionInfo.fromJson(Map<String, dynamic> json) {
    return AppVersionInfo(
      iosVersion: VersionInfo.fromJson(json['iosVersion']),
      androidVersion: VersionInfo.fromJson(json['androidVersion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iosVersion': iosVersion.toJson(),
      'androidVersion': androidVersion.toJson(),
    };
  }
}

enum TypeVersion {
  android('android'),
  ios('iOS');

  final String value;
  const TypeVersion(this.value);

  factory TypeVersion.fromValue(String value) {
    return TypeVersion.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TypeVersion.android,
    );
  }
}

class VersionInfo {
  final String? version;
  final String? downloadUrl;
  final TypeVersion? type;
  final String? updateTip;
  final bool? isForceUpdate;

  const VersionInfo({
    this.version,
    this.downloadUrl,
    this.type,
    this.updateTip,
    this.isForceUpdate,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      version: json['version'] ?? '',
      downloadUrl: json['downloadUrl'] ?? '',
      type: TypeVersion.fromValue(json['type'] ?? ''),
      isForceUpdate: json['isForceUpdate'] ?? false,
      updateTip: json['updateTip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version ?? '',
      'downloadUrl': downloadUrl,
      'type': type?.value ?? '',
      'isForceUpdate': isForceUpdate ?? false,
      'updateTip': updateTip ?? '',
    };
  }
}

class AppVersionInfoResponse {
  final int code;
  final String message;
  final AppVersionInfo data;
  final String? requestId;

  AppVersionInfoResponse({
    required this.code,
    required this.message,
    required this.data,
    this.requestId,
  });

  factory AppVersionInfoResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionInfoResponse(
      code: json['code'],
      message: json['message'],
      data: AppVersionInfo.fromJson(json['data']),
      requestId: json['requestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
      'requestId': requestId,
    };
  }
}

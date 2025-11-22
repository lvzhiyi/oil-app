/// 版本信息
class AppVersionInfo {
  final String platform;
  final String version;
  final bool forceUpdate;
  final String updateMessage;
  final String publishedAt;

  const AppVersionInfo({
    required this.platform,
    required this.version,
    required this.forceUpdate,
    required this.updateMessage,
    required this.publishedAt,
  });

  factory AppVersionInfo.fromJson(Map<String, dynamic> json) {
    return AppVersionInfo(
      platform: json['platform'],
      version: json['version'],
      forceUpdate: json['forceUpdate'],
      updateMessage: json['updateMessage'],
      publishedAt: json['publishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'version': version,
      'forceUpdate': forceUpdate,
      'updateMessage': updateMessage,
      'publishedAt': publishedAt,
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

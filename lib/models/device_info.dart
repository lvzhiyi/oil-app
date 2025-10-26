class DeviceInfo {
  DeviceInfo({
    this.systemName,
    this.model,
    this.systemVersion,
    this.name,
    this.identifierForVendor,
  });

  /// 系统名称 ios、android
  String? systemName;

  /// 设备类型 IPhone
  String? model;

  /// 系统版本
  String? systemVersion;

  /// 设备名称
  String? name;

  /// 设备唯一标识
  String? identifierForVendor;

  factory DeviceInfo.fromMap(Map<String, dynamic> json) {
    return DeviceInfo(
      systemName: json['systemName'],
      model: json['model'],
      systemVersion: json['systemVersion'],
      name: json['name'],
      identifierForVendor: json['identifierForVendor'],
    );
  }
}

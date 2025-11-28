class VehicleModel {
  final String? date;
  final String? oilType;
  final String? oilSource;
  final String? vehicleType;
  final String? driverName;
  final String? driverIdCard;
  final String? driverPhone;
  final String? driverLicense;
  final String? plateNumber;
  final String? loadCapacity;
  final String? vehicleLicense;
  final String? tankType;
  final String? tank1Capacity;
  final String? tank2Capacity;
  final String? hasPump;
  final String? oilAmount;

  VehicleModel({
    this.date,
    this.oilType,
    this.oilSource,
    this.vehicleType,
    this.driverName,
    this.driverIdCard,
    this.driverPhone,
    this.driverLicense,
    this.plateNumber,
    this.loadCapacity,
    this.vehicleLicense,
    this.tankType,
    this.tank1Capacity,
    this.tank2Capacity,
    this.hasPump,
    this.oilAmount,
  });

  VehicleModel copyWith({
    String? date,
    String? oilType,
    String? oilSource,
    String? vehicleType,
    String? driverName,
    String? driverIdCard,
    String? driverPhone,
    String? driverLicense,
    String? plateNumber,
    String? loadCapacity,
    String? vehicleLicense,
    String? tankType,
    String? tank1Capacity,
    String? tank2Capacity,
    String? hasPump,
    String? oilAmount,
  }) {
    return VehicleModel(
      date: date ?? this.date,
      oilType: oilType ?? this.oilType,
      oilSource: oilSource ?? this.oilSource,
      vehicleType: vehicleType ?? this.vehicleType,
      driverName: driverName ?? this.driverName,
      driverIdCard: driverIdCard ?? this.driverIdCard,
      driverPhone: driverPhone ?? this.driverPhone,
      driverLicense: driverLicense ?? this.driverLicense,
      plateNumber: plateNumber ?? this.plateNumber,
      loadCapacity: loadCapacity ?? this.loadCapacity,
      vehicleLicense: vehicleLicense ?? this.vehicleLicense,
      tankType: tankType ?? this.tankType,
      tank1Capacity: tank1Capacity ?? this.tank1Capacity,
      tank2Capacity: tank2Capacity ?? this.tank2Capacity,
      hasPump: hasPump ?? this.hasPump,
      oilAmount: oilAmount ?? this.oilAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'oilType': oilType,
      'oilSource': oilSource,
      'vehicleType': vehicleType,
      'driverName': driverName,
      'driverIdCard': driverIdCard,
      'driverPhone': driverPhone,
      'driverLicense': driverLicense,
      'plateNumber': plateNumber,
      'loadCapacity': loadCapacity,
      'vehicleLicense': vehicleLicense,
      'tankType': tankType,
      'tank1Capacity': tank1Capacity,
      'tank2Capacity': tank2Capacity,
      'hasPump': hasPump,
      'oilAmount': oilAmount,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      date: json['date'] as String?,
      oilType: json['oilType'] as String?,
      oilSource: json['oilSource'] as String?,
      vehicleType: json['vehicleType'] as String?,
      driverName: json['driverName'] as String?,
      driverIdCard: json['driverIdCard'] as String?,
      driverPhone: json['driverPhone'] as String?,
      driverLicense: json['driverLicense'] as String?,
      plateNumber: json['plateNumber'] as String?,
      loadCapacity: json['loadCapacity'] as String?,
      vehicleLicense: json['vehicleLicense'] as String?,
      tankType: json['tankType'] as String?,
      tank1Capacity: json['tank1Capacity'] as String?,
      tank2Capacity: json['tank2Capacity'] as String?,
      hasPump: json['hasPump'] as String?,
      oilAmount: json['oilAmount'] as String?,
    );
  }
}

import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/vehicle_model.dart';

class PickupCertificateModel {
  final String id;
  final Station station;
  final String oilAmount;
  final VehicleModel vehicleInfo;
  final DateTime createdAt;

  PickupCertificateModel({
    required this.id,
    required this.station,
    required this.oilAmount,
    required this.vehicleInfo,
    required this.createdAt,
  });

  PickupCertificateModel copyWith({
    String? id,
    Station? station,
    String? oilAmount,
    VehicleModel? vehicleInfo,
    DateTime? createdAt,
  }) {
    return PickupCertificateModel(
      id: id ?? this.id,
      station: station ?? this.station,
      oilAmount: oilAmount ?? this.oilAmount,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station': station.toJson(),
      'oilAmount': oilAmount,
      'vehicleInfo': vehicleInfo.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PickupCertificateModel.fromJson(Map<String, dynamic> json) {
    return PickupCertificateModel(
      id: json['id'] as String,
      station: Station.fromJson(json['station'] as Map<String, dynamic>),
      oilAmount: json['oilAmount'] as String,
      vehicleInfo: VehicleModel.fromJson(json['vehicleInfo'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}


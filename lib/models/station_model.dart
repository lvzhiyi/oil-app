import 'package:oil_business_app/global/enum/common.dart';

class StationModel {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final StationStatus? status;
  final String? rejectReason;

  StationModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.isActive = true,
    this.status,
    this.rejectReason,
  });

  StationModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
    StationStatus? status,
    String? rejectReason,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'status': status?.name,
      'rejectReason': rejectReason,
    };
  }

  factory StationModel.fromJson(Map<String, dynamic> json) {
    StationStatus? status;
    if (json['status'] != null) {
      try {
        status = StationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => StationStatus.active,
        );
      } catch (e) {
        status = null;
      }
    }

    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      isActive: json['isActive'] as bool? ?? true,
      status: status,
      rejectReason: json['rejectReason'] as String?,
    );
  }
}


class StationModel {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isActive;

  StationModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.isActive = true,
  });

  StationModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
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
    };
  }

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}


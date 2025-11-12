import 'package:oil_business_app/models/station_model.dart';

class StationEditState {
  final StationModel? station;
  final String name;
  final String address;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  StationEditState({
    this.station,
    this.name = '',
    this.address = '',
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  StationEditState copyWith({
    StationModel? station,
    String? name,
    String? address,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return StationEditState(
      station: station ?? this.station,
      name: name ?? this.name,
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


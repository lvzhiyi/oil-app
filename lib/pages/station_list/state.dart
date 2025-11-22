import 'package:oil_business_app/global/model/station_res_type.dart';

class StationListState {
  final List<Station> stations;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  StationListState({
    required this.stations,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  StationListState copyWith({
    List<Station>? stations,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return StationListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

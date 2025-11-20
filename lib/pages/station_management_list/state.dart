import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/station_model.dart';

class StationManagementListState {
  final List<StationModel> stations;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<StationStatus> selectedStatuses;

  StationManagementListState({
    required this.stations,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.selectedStatuses = const [],
  });

  StationManagementListState copyWith({
    List<StationModel>? stations,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<StationStatus>? selectedStatuses,
  }) {
    return StationManagementListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }
}


import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/station_model.dart';

class StationManagementListState {
  final List<StationModel> stations;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final StationStatus? selectedStatus;

  StationManagementListState({
    required this.stations,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.selectedStatus,
  });

  StationManagementListState copyWith({
    List<StationModel>? stations,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    StationStatus? selectedStatus,
    bool clearSelectedStatus = false,
  }) {
    return StationManagementListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatus: clearSelectedStatus ? null : (selectedStatus ?? this.selectedStatus),
    );
  }
}


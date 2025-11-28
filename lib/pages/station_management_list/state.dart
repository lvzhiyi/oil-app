import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';

class StationManagementListState {
  final List<Station> stations;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final StationStatus? selectedStatus;

  // Pagination
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  StationManagementListState({
    required this.stations,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.selectedStatus,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  StationManagementListState copyWith({
    List<Station>? stations,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    StationStatus? selectedStatus,
    bool clearSelectedStatus = false,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return StationManagementListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatus:
          clearSelectedStatus ? null : (selectedStatus ?? this.selectedStatus),
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

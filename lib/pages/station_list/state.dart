import 'package:oil_business_app/global/model/station_res_type.dart';

class StationListState {
  final List<Station> stations;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  // Pagination
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  StationListState({
    required this.stations,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  StationListState copyWith({
    List<Station>? stations,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return StationListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

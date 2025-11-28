import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

class OilPickupState {
  final List<InventoryModel> inventories;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  OilPickupState({
    this.inventories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  OilPickupState copyWith({
    List<InventoryModel>? inventories,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return OilPickupState(
      inventories: inventories ?? this.inventories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

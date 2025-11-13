import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';

class MainOilPayState {
  final List<Depot>? depotList;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final int total;
  final String? errorMessage;

  MainOilPayState({
    this.depotList,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  MainOilPayState copyWith({
    List<Depot>? depotList,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    int? total,
    String? errorMessage,
  }) {
    return MainOilPayState(
      depotList: depotList ?? this.depotList,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

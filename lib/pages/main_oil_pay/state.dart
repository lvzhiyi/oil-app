import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

class MainOilPayState {
  final List<Depot>? depotList;
  final PageStatus pageStatus;
  final int currentPage;
  final int total;
  final String? errorMessage;

  MainOilPayState({
    this.depotList,
    this.pageStatus = PageStatus.loading,
    this.currentPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  MainOilPayState copyWith({
    List<Depot>? depotList,
    PageStatus? pageStatus,
    int? currentPage,
    int? total,
    String? errorMessage,
  }) {
    return MainOilPayState(
      depotList: depotList ?? this.depotList,
      pageStatus: pageStatus ?? this.pageStatus,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';

class OilPurchaseDetailState {
  final Depot? depot;
  final Fuel? selectedFuel;
  final String? purchaseQuantity;
  final String? remark;
  final bool isLoading;

  OilPurchaseDetailState({
    this.depot,
    this.selectedFuel,
    this.purchaseQuantity,
    this.remark,
    this.isLoading = false,
  });

  OilPurchaseDetailState copyWith({
    Depot? depot,
    Fuel? selectedFuel,
    String? purchaseQuantity,
    String? remark,
    bool? isLoading,
  }) {
    return OilPurchaseDetailState(
      depot: depot ?? this.depot,
      selectedFuel: selectedFuel ?? this.selectedFuel,
      purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
      remark: remark ?? this.remark,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/global/model/bank_info_model.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';

class AppState {
  AuthResponse? authResponse;
  Station? selectedStation;
  BankInfoModel? bankInfo;

  AppState({
    this.authResponse,
    this.selectedStation,
    this.bankInfo,
  });

  AppState copyWith({
    AuthResponse? authResponse,
    Station? selectedStation,
    BankInfoModel? bankInfo,
  }) {
    return AppState(
      authResponse: authResponse ?? this.authResponse,
      selectedStation: selectedStation ?? this.selectedStation,
      bankInfo: bankInfo ?? this.bankInfo,
    );
  }
}

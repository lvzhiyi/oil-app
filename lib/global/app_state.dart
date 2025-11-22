import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';

class AppState {
  AuthResponse? authResponse;
  Station? selectedStation;

  AppState({
    this.authResponse,
    this.selectedStation,
  });

  AppState copyWith({
    AuthResponse? authResponse,
    Station? selectedStation,
  }) {
    return AppState(
      authResponse: authResponse ?? this.authResponse,
      selectedStation: selectedStation ?? this.selectedStation,
    );
  }
}

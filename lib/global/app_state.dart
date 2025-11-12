import 'package:oil_business_app/global/model/auth_rep_type.dart';
import 'package:oil_business_app/models/station_model.dart';

class AppState {
  AuthResponse? authResponse;
  StationModel? selectedStation;

  AppState({
    this.authResponse,
    this.selectedStation,
  });

  AppState copyWith({
    AuthResponse? authResponse,
    StationModel? selectedStation,
  }) {
    return AppState(
      authResponse: authResponse ?? this.authResponse,
      selectedStation: selectedStation ?? this.selectedStation,
    );
  }
}

import 'package:oil_business_app/global/model/auth_rep_type.dart';

class AppState {
  AuthResponse? authResponse;
  AppState({this.authResponse});

  AppState copyWith({AuthResponse? authResponse}) {
    return AppState(authResponse: authResponse ?? this.authResponse);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SportsPopup {
  static NavigatorObserver get observer => FlutterSmartDialog.observer;
  static TransitionBuilder init({TransitionBuilder? builder}) =>
      FlutterSmartDialog.init(builder: builder);
}

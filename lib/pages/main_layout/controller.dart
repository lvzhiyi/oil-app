import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/events.dart';
import 'package:oil_business_app/pages/main_layout/state.dart';

class MainLayoutCtrl extends Cubit<MainLayoutState> {
  MainLayoutCtrl() : super(MainLayoutState());

  /// 切换Tab
  void changeTab(int index) {
    if (index != state.selectedIndex) {
      emit(state.copyWith(selectedIndex: index));
    }

    globalTabChangeEventBus.fire(index);
  }

  /// 显示/隐藏底部导航栏
  void toggleBottomNavigation(bool show) {
    if (show != state.showBottomNavigation) {
      emit(state.copyWith(showBottomNavigation: show));
    }
  }
}

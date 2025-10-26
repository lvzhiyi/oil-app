import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/events.dart';
import 'package:lottery_app/pages/main_layout/state.dart';

class MainLayoutCtrl extends Cubit<MainLayoutState> {
  MainLayoutCtrl() : super(MainLayoutState());

  /// 切换Tab
  void changeTab(int index) {
    if (index != state.selectedIndex) {
      emit(state.copyWith(selectedIndex: index));
    }

    /// 刷新当前员工信息
    if (index == 3) {
      BaseConfig.appContext!.read<AppController>().fetchCurrentEmployee();
    }

    /// 刷新代理信息
    if (index == 1 || index == 2) {
      BaseConfig.appContext!.read<AppController>().fetchAgentInfo();
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

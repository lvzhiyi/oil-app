class MainLayoutState {
  /// 当前选中的tab索引
  final int selectedIndex;

  /// 是否显示底部导航栏
  final bool showBottomNavigation;

  MainLayoutState({
    this.selectedIndex = 0,
    this.showBottomNavigation = true,
  });

  MainLayoutState copyWith({
    int? selectedIndex,
    bool? showBottomNavigation,
  }) {
    return MainLayoutState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      showBottomNavigation: showBottomNavigation ?? this.showBottomNavigation,
    );
  }
}

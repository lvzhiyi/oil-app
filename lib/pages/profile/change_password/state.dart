class ProfileChangePasswordState {
  /// 是否加载中
  bool loading;

  ProfileChangePasswordState({this.loading = false});

  ProfileChangePasswordState copyWith({bool? loading}) {
    return ProfileChangePasswordState(loading: loading ?? this.loading);
  }
}

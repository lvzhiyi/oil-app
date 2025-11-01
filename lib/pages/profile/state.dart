class ProfileState {
  /// 是否正在加载
  bool isLoading;

  /// 是否有错误
  bool hasError;

  /// 错误信息
  String? errorMessage;

  ProfileState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

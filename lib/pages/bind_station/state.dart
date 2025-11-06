class BindStationState {
  bool loading;
  BindStationState({
    this.loading = false,
  });

  BindStationState copyWith({
    bool? loading,
  }) {
    return BindStationState(
      loading: loading ?? this.loading,
    );
  }
}

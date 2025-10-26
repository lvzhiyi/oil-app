class SplaseState {
  int percent;

  SplaseState({required this.percent});

  SplaseState copyWith() {
    return SplaseState(
      percent: percent,
    );
  }
}

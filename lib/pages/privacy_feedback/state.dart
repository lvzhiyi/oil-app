class PrivacyFeedbackItem {
  final String id;
  final String title;
  final String date;
  final String status;

  PrivacyFeedbackItem({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });
}

class PrivacyFeedbackState {
  bool isLoading;
  List<PrivacyFeedbackItem> items;
  bool htmlLoading;

  PrivacyFeedbackState({
    this.isLoading = false,
    this.items = const [],
    this.htmlLoading = false,
  });

  PrivacyFeedbackState copyWith({
    bool? isLoading,
    List<PrivacyFeedbackItem>? items,
    bool? htmlLoading,
  }) {
    return PrivacyFeedbackState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      htmlLoading: htmlLoading ?? this.htmlLoading,
    );
  }
}

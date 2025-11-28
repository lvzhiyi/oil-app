## 1. Implementation
- [x] 1.1 Update `StationListState` to include `page`, `hasMore`, and `isLoadingMore` properties.
- [x] 1.2 Modify `StationListCtrl` to implement `loadNextPage` method.
- [x] 1.3 Update `StationListView` to use a scroll listener (e.g., `NotificationListener<ScrollNotification>`) or a library (like `pull_to_refresh` or custom implementation) to trigger loading.
- [x] 1.4 Add loading indicator at the bottom of the list.
- [x] 1.5 Verify that "pull to refresh" resets the list to page 1.

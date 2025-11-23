## 1. Implementation
- [ ] 1.1 Modify `PickupListState` to include `isLoadingMore` (it already has `hasMore` and `page`).
- [ ] 1.2 Refactor `PickupListCtrl`: Remove `EasyRefreshController`, implement `onRefresh` and `onLoadMore` following the pattern in `StationListCtrl`.
- [ ] 1.3 Refactor `PickupListView`: Replace `EasyRefresh` with `RefreshIndicator` + `ListView` + `NotificationListener`.
- [ ] 1.4 Add standard footer loader/text.

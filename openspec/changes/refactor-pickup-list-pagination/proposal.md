# Change: Refactor Pickup List Pagination

## Why
Consistency. The project is moving towards standard `RefreshIndicator` + `NotificationListener` for pagination (waterfall) instead of using `EasyRefresh`. The current Pickup List uses `EasyRefresh` and should be refactored to match the pattern used in Station List and Station Management.

## What Changes
- Remove `EasyRefresh` dependency from `PickupListView`.
- Implement standard infinite scroll using `RefreshIndicator` and `NotificationListener`.
- Update `PickupListCtrl` to manage loading states manually (remove `EasyRefreshController`).
- Ensure loading indicators and "no more data" states are handled consistently with other lists.

## Impact
- Affected specs: `pickup-management` (if exists, otherwise creating new capability context)
- Affected code: `lib/pages/pickup_list/` (Controller, View)

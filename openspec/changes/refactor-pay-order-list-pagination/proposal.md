# Change: Refactor Pay Order List Pagination

## Why
The current `pay_order_list` implementation uses `EasyRefresh` and contains a bug where data is duplicated instead of appended during pagination. Refactoring to the standard `RefreshIndicator` + `NotificationListener` pattern will ensure consistency across the app and fix the data loading issues.

## What Changes
- Remove `EasyRefresh` and `PullOrRefreshEasy` from `OrdersScreen`.
- Implement standard infinite scroll using `RefreshIndicator` and `NotificationListener`.
- Refactor `PayOrderListCtrl` to fix data appending logic and manage loading states manually.
- Add `hasMore` and `isLoadingMore` to `PayOrderListState`.

## Impact
- Affected specs: `pay-order-management`
- Affected code: `lib/pages/pay_order_list/` (Controller, State, View/OrdersScreen)

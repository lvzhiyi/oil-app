# Change: Refactor Pickup List Naming to Pickup Order List

## Why
The current naming `pickup_list` is ambiguous and misleading. The page actually displays a list of pickup **orders** (提油订单列表), not just a generic "pickup list". This causes confusion for developers when navigating the codebase, as the folder name doesn't accurately reflect its purpose.

## What Changes
- Rename directory from `lib/pages/pickup_list/` to `lib/pages/pickup_order_list/`
- Rename all component classes to use `PickupOrderList` prefix instead of `PickupList`:
  - `PickupListPage` → `PickupOrderListPage`
  - `PickupListCtrl` → `PickupOrderListCtrl`
  - `PickupListState` → `PickupOrderListState`
  - `PickupListView` → `PickupOrderListView`
  - `PickupListItem` → `PickupOrderListItem`
- Update all import statements across the codebase
- Update route configuration in `router/routes.dart`

## Impact
- Affected specs: `main-navigation` (route naming)
- Affected code:
  - `lib/pages/pickup_list/` → entire directory
  - `lib/router/routes.dart` → import and route definition
  - All files importing from `pickup_list` directory
- **BREAKING**: None (internal refactor only, no API or user-facing changes)

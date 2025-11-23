# Change: Add Pagination to Station Management

## Why
Similar to the station selection list, the station management page currently loads all stations in one go (or fixed page size). Adding pagination improves performance and scalability as the number of managed stations grows.

## What Changes
- Implement infinite scroll pagination in Station Management List.
- Update Controller to handle `page`, `hasMore`, and `isLoadingMore` states.
- Update UI to support pull-to-refresh and scroll-to-load-more.

## Impact
- Affected specs: `station-management`
- Affected code: `lib/pages/station_management_list/` (Controller, State, View)

# Change: Add Pagination to Station List

## Why
Current station list implementation loads a fixed page (page 1, size 10), preventing users from accessing all available stations if they have more than 10. Adding infinite scroll pagination improves usability and performance.

## What Changes
- Implement infinite scroll (waterfall) pagination in Station List.
- Update Controller to handle page increments and appending data.
- Update UI to show loading indicators at the bottom and handle "no more data" state.

## Impact
- Affected specs: `station-management`
- Affected code: `lib/pages/station_list/` (Controller, State, View)

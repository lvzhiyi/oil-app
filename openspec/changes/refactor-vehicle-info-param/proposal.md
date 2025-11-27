# Change: Refactor Vehicle Info Parameter

## Why
Currently, the system only sends the parsed JSON object for vehicle information. However, there is a business requirement to display the original raw string in some scenarios (e.g., history logs, audit) while using the parsed fields in others.

## What Changes
- Update `OilPickupDetailCtrl` to combine the raw vehicle info string and the parsed JSON string using a separator (`|||`).
- The `vehicleInfo` field in `WithdrawRequest` will now follow the format: `rawString|||jsonString`.

## Impact
- Affected specs: `oil-pickup`
- Affected code:
    - `lib/pages/oil_pickup_detail/controller.dart`

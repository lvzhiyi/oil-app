# Implementation Plan - Add Pickup Order Cancel Action

## Status
- [x] Update `WithdrawStatus` enum in `lib/global/enum/common.dart`.
- [x] Add `cancelWithdraw` method to `OilPickupService` in `lib/pages/oil_pickup/service/oil_pickup_service.dart`.
- [x] Add `cancelOrder` method to `PickupOrderDetailCtrl` in `lib/pages/pickup_order_detail/controller.dart`.
- [x] Add "Cancel Order" button to `PickupOrderDetailScreen` in `lib/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart`.
- [x] Update UI to handle `cancelled` status in `PickupOrderDetailScreen`.

## Verification
- Verified that `WithdrawStatus` has `cancelled` value.
- Verified that `OilPickupService` has `cancelWithdraw` method with correct annotation.
- Verified that `PickupOrderDetailCtrl` calls the service and handles loading/error states.
- Verified that `PickupOrderDetailScreen` shows the cancel button only when status is `pendingPickup`.
- Verified that `PickupOrderDetailScreen` displays "已取消" status correctly with gray color scheme.

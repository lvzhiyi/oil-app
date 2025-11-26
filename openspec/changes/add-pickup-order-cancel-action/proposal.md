# Add Pickup Order Cancel Action

## Why
Users need a way to cancel a pickup order if they made a mistake or changed their plans, provided the order has not been completed yet.

## What
- Add a "Cancel Order" button to the Pickup Order Detail page.
- Implement the API call to cancel the order.
- Update the UI to reflect the cancelled status.

## Impact
- **UI:** New button in `PickupOrderDetailScreen`.
- **Logic:** New method in `PickupOrderDetailCtrl` and `OilPickupService`.
- **Data:** Update `WithdrawStatus` enum.

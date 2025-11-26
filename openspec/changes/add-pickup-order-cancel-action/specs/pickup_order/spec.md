# Pickup Order Spec

## ADDED Requirements

- **Cancel Action:**
  - Users MUST be able to cancel a pickup order if the status is `pending_pickup`.
  - The cancel action MUST prompt for confirmation before proceeding.
  - Upon successful cancellation, the UI MUST update to show the `cancelled` status or navigate back/refresh.

## MODIFIED Requirements

- **WithdrawStatus Enum:**
  - Added `cancelled` status with value `cancelled` and display name `已取消`.

- **OilPickupService:**
  - Added `cancelWithdraw(int orderId)` method.

# Change: Add Regenerate Certificate Button

## Why
Users need to be able to regenerate and save the pickup certificate image for "Pending Pickup" orders directly from the order detail page, similar to the functionality available on the success page.

## What Changes
- Update `PickupOrderDetailScreen` to include a "Regenerate Certificate Image" button for orders in "Pending Pickup" status.
- Implement the image generation and saving logic (Save to Gallery, Save to Directory, Share) mirroring `OilPickupSuccessScreen`.
- Embed `OilPickupReceiptCard` (hidden) in `PickupOrderDetailScreen` to serve as the source for the generated image.

## Impact
- Affected specs: `oil-pickup`
- Affected code:
    - `lib/pages/pickup_order_detail/widgets/pickup_order_detail_screen.dart`

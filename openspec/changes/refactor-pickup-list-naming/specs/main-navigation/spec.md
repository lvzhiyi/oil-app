## MODIFIED Requirements

### Requirement: Pickup Order List Navigation
The system SHALL provide navigation to the pickup order list page using the route path `/pickupList`.

#### Scenario: Navigate to pickup order list
- **WHEN** user navigates to `/pickupList` route
- **THEN** the `PickupOrderListPage` component is displayed
- **AND** the page title shows "提油订单"

#### Scenario: Import path consistency
- **WHEN** importing the pickup order list page
- **THEN** the import path SHALL be `package:oil_business_app/pages/pickup_order_list/page.dart`
- **AND** the class name SHALL be `PickupOrderListPage`

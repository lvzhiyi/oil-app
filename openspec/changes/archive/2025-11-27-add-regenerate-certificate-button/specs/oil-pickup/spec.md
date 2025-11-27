## ADDED Requirements
### Requirement: Regenerate Certificate Image
The system SHALL allow users to regenerate and save the pickup certificate image from the order detail page for orders in "Pending Pickup" status.

#### Scenario: Regenerate image
- **WHEN** user views a "Pending Pickup" order
- **THEN** a "Regenerate Certificate Image" button is displayed
- **WHEN** user taps the button
- **THEN** the system generates the certificate image and presents options to save or share it (Gallery, File, Share)

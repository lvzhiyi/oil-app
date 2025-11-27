# oil-pickup Specification

## Purpose
TBD - created by archiving change refactor-vehicle-info-param. Update Purpose after archive.
## Requirements
### Requirement: Withdraw Request Vehicle Info Format
The system SHALL submit vehicle information containing both the raw input string and the parsed JSON data, separated by `|||`.

#### Scenario: Submit with raw text
- **WHEN** user pastes vehicle info text "京A88888 13800138000"
- **THEN** the request `vehicleInfo` field contains "京A88888 13800138000|||{\"plateNumber\":\"京A88888\",...}"

#### Scenario: Submit without raw text
- **WHEN** user manually enters vehicle info without pasting
- **THEN** the request `vehicleInfo` field contains "|||{\"plateNumber\":\"...\",...}" (empty raw string)

### Requirement: Regenerate Certificate Image
The system SHALL allow users to regenerate and save the pickup certificate image from the order detail page for orders in "Pending Pickup" status.

#### Scenario: Regenerate image
- **WHEN** user views a "Pending Pickup" order
- **THEN** a "Regenerate Certificate Image" button is displayed
- **WHEN** user taps the button
- **THEN** the system generates the certificate image and presents options to save or share it (Gallery, File, Share)


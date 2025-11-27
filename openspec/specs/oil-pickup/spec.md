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


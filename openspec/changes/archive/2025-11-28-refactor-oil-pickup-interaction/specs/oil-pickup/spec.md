## ADDED Requirements

### Requirement: Vehicle Information Entry
The system SHALL provide a structured form for entering vehicle and driver information, supported by an intelligent text parser.

#### Scenario: Manual Entry
- **WHEN** the user opens the Oil Pickup Detail page
- **THEN** a structured form SHALL be displayed with fields for:
  - Driver Name
  - Plate Number (Vehicle No.)
  - ID Card Number
  - Phone Number
  - Oil Amount (Ton)
- **AND** all fields SHALL be manually editable.

#### Scenario: Intelligent Parsing (Auto-Fill)
- **WHEN** the user pastes vehicle dispatch information into the "Intelligent Parse" area and triggers identification
- **THEN** the system SHALL parse the text.
- **AND** automatically populate the corresponding fields in the structured form.
- **AND** keep the form editable for user corrections.

### Requirement: Validation
The system SHALL validate vehicle information before generating a pickup certificate.

#### Scenario: Missing Required Fields
- **WHEN** the user clicks "Generate Certificate"
- **AND** one or more required fields (Driver Name, Plate Number, ID Card) are empty
- **THEN** the system SHALL prevent submission.
- **AND** highlight the empty fields with a visual error indicator (Inline Validation).
- **AND** display a Toast warning indicating the validation failure.

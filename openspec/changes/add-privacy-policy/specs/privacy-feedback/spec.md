# Spec: Privacy Policy

## ADDED Requirements

### Requirement: Privacy Policy Display
The system SHALL display the Privacy Policy text to the user.

#### Scenario: User views privacy policy
Given the user is on the "Privacy Policy" page
When the page loads
Then the full text of the Privacy Policy is displayed

### Requirement: Entry Point
The system SHALL provide a way for users to access the Privacy Policy page from their profile.

#### Scenario: User navigates to privacy policy
Given the user is on the "My" page
When they tap on the "Privacy Policy" menu item
Then they are navigated to the "Privacy Policy" page

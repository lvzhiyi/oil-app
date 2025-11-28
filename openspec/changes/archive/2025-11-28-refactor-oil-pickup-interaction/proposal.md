# Change: Refactor Oil Pickup Interaction

## Why
The current interaction for entering vehicle and driver information on the Oil Pickup Detail page is brittle. It relies on a modal "parse-only" approach where users must switch between a raw text input mode and a read-only result display. If parsing is partially incorrect (e.g., one digit wrong in a phone number), users are forced to re-paste and edit the raw text rather than correcting the specific field. Additionally, validation errors are displayed in a disconnected list at the bottom, making it hard for users to identify which fields need attention.

## What Changes
- **Interaction Model**: Shift from "Parse OR View" to "Parse AND Edit" (Form Fill Mode).
- **UI Layout**:
  - **Top**: Intelligent Parse Area (Paste text -> Auto-fill).
  - **Bottom**: Structured Form (Always editable, pre-filled by parser).
- **Validation**: Move from a detached error list to **Inline Form Validation** (highlighting specific fields).
- **Logic**: 
  - Parsing now updates the form field controllers/state directly.
  - Users can manually correct any field after parsing.
  - "Generate Certificate" validates the form fields directly.

## Impact
- **Affected Specs**: `oil-pickup` (New capability spec)
- **Affected Code**:
  - `lib/pages/oil_pickup_detail/view.dart`: Complete layout restructure.
  - `lib/pages/oil_pickup_detail/widgets/oil_pickup_detail_screen.dart`: Widget decomposition and form implementation.
  - `lib/pages/oil_pickup_detail/controller.dart`: Update state management to support individual field editing and form validation.
  - `lib/pages/oil_pickup_detail/state.dart`: Add fields for individual inputs if not present (or map to existing model).

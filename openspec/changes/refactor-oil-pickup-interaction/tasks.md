## 1. UI Refactoring
- [ ] 1.1 Create `SmartParseCard` widget for the top area (Text input + "Identify" button).
- [ ] 1.2 Create `VehicleInfoForm` widget for the bottom area (TextFormFields for all properties).
- [ ] 1.3 Integrate `SmartParseCard` and `VehicleInfoForm` into `OilPickupDetailScreen`.

## 2. State & Logic Updates
- [ ] 2.1 Update `OilPickupDetailCtrl` to handle individual field updates (not just bulk parse).
- [ ] 2.2 Implement `parseAndFill` logic: Parse text -> Update Form State.
- [ ] 2.3 Remove "Parse Success" vs "Input Mode" toggle logic (State should always allow editing).

## 3. Validation
- [ ] 3.1 Add `Form` widget and `GlobalKey<FormState>` to the page.
- [ ] 3.2 Implement `validator` functions for each `TextFormField`.
- [ ] 3.3 Update `generateCertificate` to trigger `formKey.currentState!.validate()`.
- [ ] 3.4 Remove the old `missingFields` list display.

## 4. Cleanup
- [ ] 4.1 Remove unused widgets/methods related to the old "read-only result" view.
- [ ] 4.2 Verify all fields from `VehicleModel` are covered in the form.

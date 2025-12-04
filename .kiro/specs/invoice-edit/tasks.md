# Implementation Plan

- [x] 1. Create data models and API service


  - [x] 1.1 Create InvoiceInfo model


    - Create `lib/global/model/invoice_info.dart` with InvoiceInfo class
    - Add JSON serialization support with freezed/json_serializable
    - Include all fields: invoiceTitle, taxNumber, bankName, bankAccount, companyAddress, companyPhone, invoiceType
    - _Requirements: 3.1_
  - [x] 1.2 Create UpdateInvoiceRequest model


    - Create `lib/global/model/invoice_req_type.dart` with UpdateInvoiceRequest class
    - Add JSON serialization support
    - _Requirements: 4.1_
  - [x] 1.3 Add invoice API to StationService



    - Add PUT `/stations/{id}/invoice` endpoint to `lib/global/service/station_service.dart`
    - Run build_runner to generate service implementation
    - _Requirements: 4.1_

- [x] 2. Create InvoiceValidator utility



  - [x] 2.1 Implement invoice field validators

    - Create `lib/utils/invoice_validator.dart`
    - Implement validateInvoiceTitle (non-empty check)
    - Implement validateTaxNumber (format: 15-20 alphanumeric characters)
    - Implement validateBankAccount (numeric only)
    - Implement validatePhone (valid phone format)
    - _Requirements: 3.2, 3.3, 3.4, 3.5, 5.1-5.6_
  - [ ]* 2.2 Write property test for form validation
    - **Property 3: Form Field Validation**
    - **Validates: Requirements 3.2, 3.3, 3.4, 3.5**

- [x] 3. Create InvoiceEditPage structure


  - [x] 3.1 Create InvoiceEditState


    - Create `lib/pages/invoice_edit/state.dart`
    - Include all form fields and UI state (isLoading, hasError, errorMessage)
    - Implement copyWith method
    - _Requirements: 3.1_
  - [x] 3.2 Create InvoiceEditCtrl


    - Create `lib/pages/invoice_edit/controller.dart`
    - Implement field update methods
    - Implement validate() method using InvoiceValidator
    - Implement save() method calling StationService
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 5.1-5.6_
  - [ ]* 3.3 Write property test for station ID initialization
    - **Property 1: Station ID Parameter Initialization**
    - **Validates: Requirements 1.2, 2.2**
  - [ ]* 3.4 Write property test for invoice data pre-population
    - **Property 2: Invoice Data Pre-population**
    - **Validates: Requirements 1.3**


  - [ ] 3.5 Create InvoiceEditPage and InvoiceEditView
    - Create `lib/pages/invoice_edit/page.dart`
    - Create `lib/pages/invoice_edit/view.dart`


    - Handle route parameters (stationId, invoice)
    - _Requirements: 1.2, 2.2_

- [x] 4. Create InvoiceEditForm UI

  - [x] 4.1 Implement invoice edit form widget

    - Create `lib/pages/invoice_edit/widgets/invoice_edit_form.dart`
    - Add text fields for all invoice fields
    - Add dropdown for invoice type selection
    - Add save button with loading state
    - Follow existing StationEditForm patterns
    - _Requirements: 3.1, 3.6, 4.4_
  - [ ]* 4.2 Write property test for API request data integrity
    - **Property 4: API Request Data Integrity**
    - **Validates: Requirements 4.1**

- [ ] 9. Refactor UI with modern B2B design

  - [ ] 9.1 Create StationRelationCard widget
    - Create `lib/pages/invoice_edit/widgets/station_relation_card.dart`
    - Display station name with link icon
    - Use purple theme (#EEECFC background, #7165E3 text)
    - Add rounded corners (8px) and proper padding
    - _Requirements: 6.1, 6.2, 6.3_

  - [ ] 9.2 Create InvoiceTypeSegmentedControl widget
    - Create `lib/pages/invoice_edit/widgets/invoice_type_segmented_control.dart`
    - Replace dropdown with segmented control UI
    - Implement two options: "增值税专用发票" and "增值税普通发票"
    - Add smooth transition animation on selection
    - Use gray container (#F3F4F6) with white selected state
    - _Requirements: 7.1, 7.2, 7.3_

  - [ ]* 9.3 Write property test for invoice type selection
    - **Property 5: Invoice Type Selection State**
    - **Validates: Requirements 7.2**

  - [ ] 9.4 Update form field styling
    - Update input fields to use modern styling from design spec
    - Add focus effects (purple border + shadow)
    - Use monospace font for tax number and bank account fields
    - Add required field markers (red asterisk)
    - Update background colors (#F9FAFB for inputs, #F5F7FA for page)
    - Update field labels: "公司地址" and "公司电话"
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

  - [ ] 9.5 Add visual grouping with dividers
    - Add divider with "银行及地址信息" label between form sections
    - Style divider with #F3F4F6 background and purple label
    - _Requirements: 8.5_

  - [ ] 9.6 Update save button styling
    - Move save button to fixed bottom position
    - Use rounded button (28px border radius)
    - Ensure proper safe area handling
    - _Requirements: 8.6_

  - [ ] 9.7 Add bottom warning text
    - Add "请确保信息与营业执照一致，否则可能导致无法开票" text
    - Style with gray color (#9CA3AF) and center alignment
    - Position above save button
    - _Requirements: 8.7_

  - [ ] 9.8 Update InvoiceEditForm to use new components
    - Integrate StationRelationCard at top
    - Replace dropdown with InvoiceTypeSegmentedControl
    - Apply all new styling to form fields
    - Ensure proper layout and spacing
    - _Requirements: 6.1, 7.1, 8.1-8.7_

- [x] 5. Register route and add navigation entries


  - [x] 5.1 Register InvoiceEditPage route


    - Add `invoiceEditPage` to AppPage enum in `lib/router/routes.dart`
    - Implement route builder with parameter handling
    - _Requirements: 1.1, 2.1_
  - [x] 5.2 Add invoice entry to StationManagementItem


    - Modify `lib/pages/station_management_list/widgets/station_management_item.dart`
    - Add "发票信息" button/link
    - Navigate to InvoiceEditPage with stationId
    - _Requirements: 1.1_
  - [x] 5.3 Add invoice entry to StationEditPage (if applicable)


    - Add navigation entry in station edit/detail view
    - _Requirements: 2.1_

- [x] 6. Checkpoint - Ensure all tests pass


  - Ensure all tests pass, ask the user if questions arise.

- [ ]* 7. Write unit tests
  - [ ]* 7.1 Write unit tests for InvoiceValidator
    - Test each validation function with valid and invalid inputs
    - _Requirements: 3.2, 3.3, 3.4, 3.5_
  - [ ]* 7.2 Write unit tests for InvoiceEditCtrl
    - Test state update methods
    - Test validate() method
    - Test save() method with mocked service
    - _Requirements: 4.1, 4.2, 4.3_

- [x] 8. Final Checkpoint - Ensure all tests pass


  - Ensure all tests pass, ask the user if questions arise.

- [ ] 10. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

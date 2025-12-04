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

# Requirements Document

## Introduction

This feature enhances the Asset management section (items/assignees pages) of the EmpireOne inventory system with two complementary improvements:

1. **Deployed Status Display** — When an asset's `asset_status` is `"assigned"` (meaning it is currently checked out to an employee), the View modal in the grouped serial-number list should display the availability as "Deployed" rather than the raw database value "Occupied". This aligns the UI label with the business language already used throughout the system (e.g., the "Deploy" button, "Date Deployed" column).

2. **Deployed Date Field** — A `deployed_date` date-time field should be added to both the Add Asset modal and the Edit Asset modal (accessible via the "Edit" button inside the View modal). The field is positioned immediately after the Supplier/Vendor field and allows users to record when an asset was physically put into service. This date is stored on the `products` table and is distinct from `assigned_at` (the date an assignment record was created).

## Glossary

- **Asset**: A physical inventory item tracked in the `products` table, identified by serial number.
- **Add Asset Modal**: The modal form opened by the "+ Add asset" button on `items.html`. Used to create a new asset record.
- **Edit Asset Modal**: The modal form opened by the "Edit" button inside the View modal on `items.html`. It reuses the same `#modal` element with a different title, and is used to update an existing asset record.
- **View Modal**: The `#image-modal` overlay on `items.html` that shows asset details including the serial-number list for grouped items.
- **Availability**: The display label shown in the "Availability" column of the serial-number list inside the View modal. Derived from the product's active assignment state and `asset_status`.
- **Deployed Status**: The business-facing label "Deployed" used when an asset is currently assigned to an employee (i.e., has an active assignment record or `asset_status === 'assigned'`).
- **Deployed Date**: A user-defined date (and optionally time) recording when an asset was physically put into service. Stored in the `deployed_date` column on the `products` table.
- **Supplier/Vendor Field**: The `<select id="item-supplier">` field in both the Add and Edit Asset modals.
- **ProductController**: The PHP controller at `controller/ProductController.php` that handles asset CRUD API requests.
- **ProductService**: The PHP service at (implied) `services/ProductService.php` that contains business logic for asset creation and updates.
- **ProductModel**: The PHP model at `model/ProductModel.php` that executes SQL queries against the `products` table.

## Requirements

### Requirement 1: Deployed Status Label in View Modal

**User Story:** As an inventory manager, I want deployed assets to be labeled "Deployed" in the View modal's serial-number list, so that the availability label matches the business language used everywhere else in the system.

#### Acceptance Criteria

1. WHEN the View modal serial-number list renders an asset that has an active assignment record (i.e., a matching entry exists in the locally loaded assignments data), THE View_Modal SHALL display the Availability column label as "&#128640; Deployed" instead of any label derived from the raw `asset_status` value of `"assigned"`.
2. WHEN the View modal serial-number list renders an asset whose `asset_status` is `"assigned"` but no active assignment record is found in the locally loaded data, THE View_Modal SHALL display the Availability column label as "&#128640; Deployed".
3. WHILE an asset's Availability column label is displayed as "&#128640; Deployed", THE View_Modal SHALL continue to render the Return button, Report button, and Edit button for that row without modification.
4. WHEN the View modal serial-number list renders an asset that has no active assignment and whose `assigned_employee` value is empty or null, THE View_Modal SHALL display "Available" as the Availability column label.
5. WHEN the View modal serial-number list renders an asset that has a damage record, THE View_Modal SHALL display "Damaged" as the Availability column label, taking precedence over any deployment state derived from `asset_status`.

### Requirement 2: Deployed Date Field in Add Asset Modal

**User Story:** As an inventory manager, I want to enter a deployed date when adding a new asset, so that I can record when the asset was first put into service without needing to edit it later.

#### Acceptance Criteria

1. THE Add_Asset_Modal SHALL include a date-time input field labeled "Deployed Date" positioned immediately after the Supplier/Vendor field in the form layout.
2. WHEN a user submits the Add Asset form with a value in the Deployed Date field, THE ProductController SHALL accept and persist the `deployed_date` value to the `products` table.
3. WHEN a user submits the Add Asset form without filling in the Deployed Date field, THE System SHALL create the asset record with a `NULL` value for `deployed_date`.
4. WHEN the Deployed Date field contains a value, THE System SHALL accept date-time values in ISO 8601 local format `YYYY-MM-DDTHH:MM`.
5. IF a submitted `deployed_date` value is not a valid date-time string in the expected format, THEN THE ProductController SHALL reject the entire request with an HTTP 400 error response containing a message indicating the value is not a valid date-time, and no asset record SHALL be created.

### Requirement 3: Deployed Date Field in Edit Asset Modal

**User Story:** As an inventory manager, I want to view and update the deployed date when editing an existing asset, so that I can correct or set the deployment date for assets already in the system.

#### Acceptance Criteria

1. THE Edit_Asset_Modal SHALL include a date-time input field labeled "Deployed Date" in ISO 8601 local format `YYYY-MM-DDTHH:MM`, positioned immediately after the Supplier/Vendor field in the form layout.
2. WHEN the Edit Asset modal opens for an asset that already has a `deployed_date` value, THE Edit_Asset_Modal SHALL pre-populate the Deployed Date field with that asset's existing `deployed_date` value formatted as `YYYY-MM-DDTHH:MM`.
3. WHEN the Edit Asset modal opens for an asset that has no `deployed_date` value, THE Edit_Asset_Modal SHALL render the Deployed Date field empty.
4. WHEN a user saves the Edit Asset form with a new or updated value in the Deployed Date field in format `YYYY-MM-DDTHH:MM`, THE ProductController SHALL persist the updated `deployed_date` to the `products` table for that asset.
5. WHEN a user saves the Edit Asset form with the Deployed Date field cleared, THE ProductController SHALL update the asset's `deployed_date` to `NULL` in the `products` table.
6. IF a submitted `deployed_date` value is not a valid date-time string in the expected format, THEN THE ProductController SHALL reject the request with an HTTP 400 error response containing a message indicating the value is not a valid date-time, and the asset's existing `deployed_date` SHALL remain unchanged.

### Requirement 4: Deployed Date Persistence in Backend

**User Story:** As a system administrator, I want the `deployed_date` field to be correctly handled by the backend data layer, so that the value is reliably stored and retrieved across all asset operations.

#### Acceptance Criteria

1. THE ProductModel SHALL include `deployed_date` in the fixed column list for the `INSERT` query in `ProductModel::create()` so the value is persisted when a new asset is created.
2. THE `ProductService::update()` method's `$allowed` array SHALL include `deployed_date` so the field passes through the update pipeline; additionally, `deployed_date` SHALL be included in the empty-string-to-null normalization loop so that an empty string submitted by the frontend is converted to `NULL` before reaching the database.
3. WHEN the API retrieves asset records via `ProductModel::findAll()`, `findById()`, `findByName()`, or `findByPoId()`, THE `deployed_date` column SHALL be returned in the result set as part of `p.*` once the column exists in the `products` table.
4. WHEN a `deployed_date` value is present in an API request body, THE ProductController SHALL extract it and pass it to the service layer; WHEN it is absent from the request body, THE ProductController SHALL pass `null` for that field.

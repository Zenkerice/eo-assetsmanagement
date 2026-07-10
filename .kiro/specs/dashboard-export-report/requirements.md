# Requirements Document

## Introduction

This feature adds an **"Export full report"** button to the Dashboard page (`index.html`) header. The button sits next to the page title in the topbar and allows admins to export the entire dashboard — summary metric cards, all chart sections, and the asset age funnel — as either a PDF or Excel file. A dropdown previews exactly which sections are included before the user picks a format. This is a page-level export that complements the existing per-chart export buttons; admins can choose a full-dashboard snapshot or a single-chart extract depending on the audience.

The project uses vanilla JS, a PHP backend, Chart.js for charts, and html2canvas for screenshot-based exports. The export must respect the active location filter and match the existing dark-theme design language (border, download icon, chevron for the dropdown).

---

## Glossary

- **Dashboard**: The main `index.html` page that displays summary metric cards, chart sections, and the asset age funnel.
- **Export_Button**: The "Export full report" split-button control rendered in the Dashboard topbar.
- **Section_Dropdown**: The dropdown panel attached to the Export_Button that lists all exportable sections with checkboxes and exposes the format-selection controls.
- **Report_Section**: A discrete, named area of the Dashboard that can be individually included in or excluded from an export (e.g., "Summary Metrics", "Asset Status", "Stock In vs Deployed", "Deployed Assets", "Stock Received", "Asset Age Funnel", "Assets by Category").
- **PDF_Export**: A portable document generated client-side by capturing each selected Report_Section as an image via html2canvas and composing the images into a multi-page PDF.
- **Excel_Export**: A spreadsheet file generated client-side that contains one worksheet per selected Report_Section, populated with the numeric data currently rendered in that section.
- **Location_Filter**: The dropdown in the topbar (`#filter-location`) whose selected value scopes all dashboard data to a single location or all locations.
- **Admin**: A logged-in user with the `admin` role who has access to the Dashboard.
- **Toast**: The project's existing in-page notification mechanism (see `js/toast.js`).

---

## Requirements

### Requirement 1: Export Button Placement

**User Story:** As an Admin, I want an "Export full report" button in the dashboard header, so that I can start a full-dashboard export from the same place I see the data.

#### Acceptance Criteria

1. THE Export_Button SHALL be rendered inside the Dashboard topbar's `.topbar-actions` container, to the right of the location filter dropdown and the Refresh button.
2. THE Export_Button SHALL display a download icon (⬇) and the label "Export full report" as its primary visual.
3. THE Export_Button SHALL display a chevron (▾) to the right of the label to signal that a dropdown is available.
4. THE Export_Button SHALL use the project's existing `btn btn-ghost btn-sm` style class so that its appearance matches the other topbar controls (border, muted text, dark background).
5. WHEN the Admin clicks the chevron portion of the Export_Button, THE Section_Dropdown SHALL open.
6. WHEN the Admin clicks anywhere outside the Section_Dropdown while it is open and the Section_Dropdown was opened via a chevron click, THE Section_Dropdown SHALL close without initiating an export.
7. WHILE the Section_Dropdown is open, THE Export_Button SHALL maintain its active/focused visual state (border highlighted) to indicate the dropdown is attached to it.

---

### Requirement 2: Section Dropdown Preview

**User Story:** As an Admin, I want to see exactly which dashboard sections will be included before I export, so that I can confidently select only what I need.

#### Acceptance Criteria

1. WHEN the Section_Dropdown opens, THE Section_Dropdown SHALL list all Report_Sections as individually-toggleable checkbox rows in the following order: Summary Metrics, Asset Status, Stock In vs Deployed, Deployed Assets, Stock Received, Asset Age Funnel, Assets by Category.
2. WHEN the Section_Dropdown opens for the first time in a session, THE Section_Dropdown SHALL have all Report_Section checkboxes checked by default.
3. THE Section_Dropdown SHALL display each Report_Section name alongside a short descriptor (e.g., the section heading text already present on the Dashboard) so the Admin can identify each section without scrolling the page.
4. THE Section_Dropdown SHALL include a "Select all / Deselect all" toggle link above the checkbox list that checks or unchecks all checkboxes with a single click.
5. WHEN the Admin deselects all checkboxes, THE Section_Dropdown SHALL disable the export action buttons and display a validation message "Select at least one section".
6. WHEN at least one checkbox is checked, THE Section_Dropdown SHALL enable the export action buttons and hide any validation message.
7. THE Section_Dropdown SHALL display two action buttons at the bottom: "Export as PDF" and "Export as Excel".
8. THE Section_Dropdown SHALL preserve the checked/unchecked state of each Report_Section checkbox for the duration of the browser session (until page reload).

---

### Requirement 3: PDF Export

**User Story:** As an Admin, I want to export the selected dashboard sections as a PDF, so that I can share a formatted snapshot with stakeholders who prefer document files.

#### Acceptance Criteria

1. WHEN the Admin clicks "Export as PDF" in the Section_Dropdown, THE PDF_Export SHALL close the Section_Dropdown, display a Toast notification "Generating PDF…", and begin capturing the selected Report_Sections.
2. WHEN capturing Report_Sections for PDF_Export, THE PDF_Export SHALL use html2canvas to render each selected section's DOM element to a canvas image at a scale of 2× for retina sharpness.
3. THE PDF_Export SHALL compose captured section images into a single PDF document in the same order as the Report_Sections appear on the Dashboard.
4. THE PDF_Export SHALL add a header on the first page containing the text "Dashboard Report — EmpireOne", the active Location_Filter name (or "All Locations" when no filter is applied), and the export date/time in the format "Mon D, YYYY, H:MM AM/PM".
5. WHEN the PDF document is ready, THE PDF_Export SHALL trigger a browser download with the filename `dashboard-report-YYYY-MM-DD.pdf`.
6. WHEN the PDF generation is complete, THE PDF_Export SHALL replace the "Generating PDF…" Toast with a "Report exported successfully" success Toast.
7. IF an error occurs during PDF_Export, THEN THE PDF_Export SHALL display an error Toast "Export failed: [reason]", prevent any file download from being triggered, and re-enable the Export_Button.
8. WHILE PDF generation is in progress, THE Export_Button SHALL be disabled to prevent duplicate export requests; WHEN generation completes (success or failure), THE Export_Button SHALL be re-enabled.

---

### Requirement 4: Excel Export

**User Story:** As an Admin, I want to export the selected dashboard sections as an Excel file, so that I can share the raw numbers with stakeholders who need to analyse or re-format the data.

#### Acceptance Criteria

1. WHEN the Admin clicks "Export as Excel" in the Section_Dropdown, THE Excel_Export SHALL close the Section_Dropdown, display a Toast notification "Generating Excel…", and begin building the workbook.
2. THE Excel_Export SHALL create one worksheet per selected Report_Section, with each worksheet named after the Report_Section (e.g., "Summary Metrics", "Asset Status").
3. THE Excel_Export SHALL populate the "Summary Metrics" worksheet with a two-column table: the metric name (Total Assets, Categories, Available, Open Issues) in column A and the current numeric value in column B.
4. THE Excel_Export SHALL populate chart-based worksheets (Asset Status, Stock In vs Deployed, Deployed Assets, Stock Received) with a header row containing the chart's label columns and one data row per data point currently rendered in the chart.
5. THE Excel_Export SHALL populate the "Asset Age Funnel" worksheet with a two-column table: the age stage name (New, Active, Aging, Old, End of Life) in column A and the asset count in column B.
6. THE Excel_Export SHALL populate the "Assets by Category" worksheet with a two-column table: the category name in column A and the asset count in column B.
7. THE Excel_Export SHALL include a "Report Info" worksheet as the first sheet, containing the export date/time, the active Location_Filter name, and the list of included sections.
8. WHEN the workbook is successfully built, THE Excel_Export SHALL format the filename as `dashboard-report-YYYY-MM-DD.xlsx` and trigger a browser download.
9. WHEN the Excel generation is complete, THE Excel_Export SHALL replace the "Generating Excel…" Toast with a "Report exported successfully" success Toast.
10. IF an error occurs during Excel_Export, THEN THE Excel_Export SHALL display an error Toast "Export failed: [reason]", cancel any in-progress download, and not trigger a new file download.
11. WHILE Excel generation is in progress, THE Export_Button SHALL be disabled to prevent duplicate export requests; WHEN generation completes (success or failure), THE Export_Button SHALL be re-enabled.

---

### Requirement 5: Location Filter Respect

**User Story:** As an Admin, I want the exported report to reflect the currently active location filter, so that the export matches exactly what I see on the dashboard.

#### Acceptance Criteria

1. WHEN an export is initiated with a specific location selected in the Location_Filter, THE PDF_Export and THE Excel_Export SHALL include only data scoped to that location, matching what is currently displayed on the Dashboard.
2. WHEN an export is initiated with no location selected (All Locations), THE PDF_Export and THE Excel_Export SHALL include data for all locations.
3. THE PDF_Export header and the Excel_Export "Report Info" sheet SHALL display the active location name (or "All Locations") so the recipient can identify the scope of the report.

---

### Requirement 6: Accessibility and Theme Compatibility

**User Story:** As an Admin, I want the export button and dropdown to be keyboard-accessible and to match the active theme, so that the feature works for all users in both dark and light mode.

#### Acceptance Criteria

1. THE Export_Button SHALL be focusable via the Tab key and SHALL open the Section_Dropdown when the Enter or Space key is pressed while focused.
2. WHILE the Section_Dropdown is open, THE Section_Dropdown SHALL trap focus within the dropdown so that Tab and Shift+Tab cycle through the checkboxes and action buttons without moving focus to background elements.
3. WHEN the Escape key is pressed while the Section_Dropdown is open, THE Section_Dropdown SHALL close and return focus to the Export_Button; IF the Export_Button cannot receive focus, THE Section_Dropdown SHALL allow focus to fall back to `document.body`.
4. THE Export_Button and Section_Dropdown SHALL render correctly in both the dark theme (default) and the light theme, inheriting CSS variables (`--bg2`, `--border2`, `--text`, `--muted2`) so no hard-coded colours break the light-mode palette.
5. THE Export_Button and Section_Dropdown SHALL not overflow or obscure topbar controls on viewport widths down to 1024 px.

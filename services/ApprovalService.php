<?php
require_once __DIR__ . '/../model/ApprovalModel.php';
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/../model/CategoryModel.php';
require_once __DIR__ . '/../model/NotificationModel.php';
require_once __DIR__ . '/../model/UserModel.php';
require_once __DIR__ . '/../services/AuditLogService.php';
require_once __DIR__ . '/../services/EmailService.php';

/**
 * Handles the approval workflow for staff-initiated mutations.
 */
class ApprovalService {
    private ApprovalModel      $model;
    private NotificationModel  $notif;
    private EmailService       $mailer;
    private UserModel          $userModel;

    public function __construct() {
        $this->model     = new ApprovalModel();
        $this->notif     = new NotificationModel();
        $this->mailer    = new EmailService();
        $this->userModel = new UserModel();
    }

    // ── Email helpers ─────────────────────────────────────────────────────────

    /**
     * Send an email to every admin user who has an email address on file.
     */
    private function emailAdmins(string $subject, string $bodyText, string $bodyHtml): void {
        $admins = array_filter(
            $this->userModel->findAll(),
            fn($u) => $u['role'] === 'admin' && !empty($u['email'])
        );
        foreach ($admins as $admin) {
            $this->mailer->send($admin['email'], $admin['name'], $subject, $bodyText, $bodyHtml);
        }
    }

    /**
     * Send an email to a specific user by their user ID.
     */
    private function emailUser(?int $userId, string $subject, string $bodyText, string $bodyHtml): void {
        if (!$userId) return;
        $user = $this->userModel->findById($userId);
        if ($user && !empty($user['email'])) {
            $this->mailer->send($user['email'], $user['name'], $subject, $bodyText, $bodyHtml);
        }
    }

    /**
     * Build Request ID and Employee ID HTML rows + plain-text lines from a payload.
     * Returns [plainText, htmlRows].
     * Rows are omitted when the values are absent.
     */
    private function buildMetaRows(array $payload): array {
        $reqId    = trim($payload['request_id']        ?? '');
        $empId    = trim($payload['requestor_id']      ?? '');
        $location = trim($payload['requestor_location'] ?? '');

        $plain = '';
        if ($reqId)    $plain .= "Request ID: {$reqId}\n";
        if ($empId)    $plain .= "Employee ID: {$empId}\n";
        if ($location) $plain .= "Location: {$location}\n";

        $html = '';
        if ($reqId) {
            $safe = htmlspecialchars($reqId, ENT_QUOTES);
            $html .= "<tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request ID</td><td style='padding:8px 12px;color:#e6edf3;font-family:monospace;letter-spacing:.5px;'>{$safe}</td></tr>\n";
        }
        if ($empId) {
            $safe = htmlspecialchars($empId, ENT_QUOTES);
            $html .= "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Employee ID</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
        }
        if ($location) {
            $safe = htmlspecialchars($location, ENT_QUOTES);
            $html .= "<tr><td style='padding:8px 12px;color:#8b949e;'>Location</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
        }

        return [$plain, $html];
    }

    /**
     * Build meta rows identical to buildMetaRows() but replacing the standalone
     * "Employee ID" row with an "On behalf of" row (Name + ID) when $payload
     * contains an `on_behalf_of` key.
     *
     * Returns [plainText, htmlRows] — same shape as buildMetaRows().
     */
    private function buildMetaRowsForStaff(array $payload): array {
        $reqId        = trim($payload['request_id']         ?? '');
        $empId        = trim($payload['requestor_id']       ?? '');
        $onBehalfName = trim($payload['on_behalf_of']       ?? '');
        $location     = trim($payload['requestor_location'] ?? '');

        $plain = '';
        if ($reqId) $plain .= "Request ID: {$reqId}\n";
        if ($onBehalfName) {
            $plain .= "On behalf of: {$onBehalfName}" . ($empId ? " ({$empId})" : '') . "\n";
        } elseif ($empId) {
            $plain .= "Employee ID: {$empId}\n";
        }
        if ($location) $plain .= "Location: {$location}\n";

        $html = '';
        if ($reqId) {
            $safe = htmlspecialchars($reqId, ENT_QUOTES);
            $html .= "<tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request ID</td><td style='padding:8px 12px;color:#e6edf3;font-family:monospace;letter-spacing:.5px;'>{$safe}</td></tr>\n";
        }
        if ($onBehalfName) {
            $display = htmlspecialchars($onBehalfName, ENT_QUOTES)
                . ($empId ? ' <span style="color:#8b949e;font-size:12px;">(' . htmlspecialchars($empId, ENT_QUOTES) . ')</span>' : '');
            $html .= "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>On behalf of</td><td style='padding:8px 12px;color:#e6edf3;'>{$display}</td></tr>\n";
        } elseif ($empId) {
            $safe = htmlspecialchars($empId, ENT_QUOTES);
            $html .= "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Employee ID</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
        }
        if ($location) {
            $safe = htmlspecialchars($location, ENT_QUOTES);
            $html .= "<tr><td style='padding:8px 12px;color:#8b949e;'>Location</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
        }

        return [$plain, $html];
    }

    /**
     * Build the asset list sections for approval emails.
     *
     * Returns [plainTextBlock, htmlTableRows] where htmlTableRows is a string of <tr> elements.
     *
     * Looks for assets in payload['assets'], falls back to resource_name.
     * Also picks up serial numbers that the admin filled in (asset['tag'] or asset['serial_number']).
     */
    private function buildAssetEmailParts(array $req, array $payload): array {
        $assetsList = $payload['assets'] ?? [];

        // Filter out completely empty rows — slots the user left blank on the request form.
        // A row counts as "requested" only when it has more than just a category name —
        // i.e. at least one of: a specific name, brand, model, or serial tag.
        $assetsList = array_values(array_filter($assetsList, function ($asset) {
            $name        = trim($asset['name']          ?? '');
            $brand       = trim($asset['brand']         ?? '');
            $model       = trim($asset['model']         ?? '');
            $tag         = trim($asset['tag']           ?? $asset['serial_number'] ?? '');
            $categoryName = trim($asset['category_name'] ?? '');

            // If there is no specific name AND no brand/model/tag, the user left this slot blank
            // (the form may have pre-filled category_name but nothing else).
            if ($name === '' && $brand === '' && $model === '' && $tag === '') return false;

            // If the only "name" we have IS the category name and nothing else, it's also blank.
            if ($brand === '' && $model === '' && $tag === '' && $name === $categoryName && $categoryName !== '') return false;

            return true;
        }));

        if (!empty($assetsList)) {
            $plainLines = [];
            $htmlRows   = '';
            foreach ($assetsList as $i => $asset) {
                $name   = trim(($asset['name']  ?? '') ?: ($asset['category_name'] ?? ''));
                $brand  = trim($asset['brand']  ?? '');
                $model  = trim($asset['model']  ?? '');
                $tag    = trim($asset['tag']    ?? $asset['serial_number'] ?? '');
                $parts  = array_filter([$brand, $model]);
                $detail = implode(' ', $parts);

                // Plain text
                $line = ($i + 1) . '. ' . ($name ?: 'Asset ' . ($i + 1));
                if ($detail) $line .= ' — ' . $detail;
                if ($tag)    $line .= ' (SN: ' . $tag . ')';
                $plainLines[] = $line;

                // HTML
                $nameSafe   = htmlspecialchars($name   ?: 'Asset ' . ($i + 1), ENT_QUOTES);
                $detailSafe = htmlspecialchars($detail, ENT_QUOTES);
                $tagSafe    = htmlspecialchars($tag,    ENT_QUOTES);
                $sub = trim(($detailSafe ? $detailSafe : '') . ($tagSafe ? ($detailSafe ? ' · ' : '') . 'SN: ' . $tagSafe : ''));
                $rowBg = ($i % 2 === 1) ? "background:#1c2333;" : '';
                $num   = $i + 1;
                $htmlRows .= "<tr style='{$rowBg}'>
  <td style='padding:8px 12px;color:#8b949e;width:140px;'>Asset {$num}</td>
  <td style='padding:8px 12px;color:#e6edf3;'>{$nameSafe}" .
                    ($sub ? "<br><span style='font-size:12px;color:#8b949e;'>{$sub}</span>" : '') .
                "</td></tr>\n";
            }
            return [implode("\n", $plainLines), $htmlRows];
        }

        // Fallback: single resource name
        $name     = htmlspecialchars($req['resource_name'] ?? 'Asset', ENT_QUOTES);
        $htmlRows = "<tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Item</td><td style='padding:8px 12px;color:#e6edf3;'>{$name}</td></tr>\n";
        return [$req['resource_name'] ?? 'Asset', $htmlRows];
    }

    // ── Queue a request ───────────────────────────────────────────────────────

    public function queue(array $data): array {
        $id = $this->model->create($data);

        AuditLogService::log(
            'pending',
            $data['resource_type'],
            $data['resource_id'] ?? null,
            $data['resource_name'] ?? null,
            ucfirst($data['action_type']) . ' request submitted by ' . $data['requested_by'] . ' — awaiting approval'
        );

        // Notify all admins
        $action   = ucfirst($data['action_type']);
        $resource = $data['resource_name'] ?? $data['resource_type'];
        $this->notif->create([
            'for_role' => 'admin',
            'type'     => 'approval_submitted',
            'title'    => "New approval request from {$data['requested_by']}",
            'body'     => "{$action} {$data['resource_type']}: {$resource}",
            'link'     => 'approvals.html',
            'meta'     => ['approval_id' => $id, 'action_type' => $data['action_type']],
        ]);

        // Email all admins — wrapped in try/catch so SMTP errors never break the API response
        try {
            $payload = is_string($data['payload'] ?? null)
                           ? json_decode($data['payload'], true)
                           : ($data['payload'] ?? []);

            // ── Return request — dedicated, richly formatted email ──────────
            $isReturnRequest = strtolower($data['action_type']) === 'delete'
                            && strtolower($data['resource_type']) === 'assignment';

            if ($isReturnRequest) {
                $returnId      = trim($payload['return_id']     ?? '');
                $assetName     = trim($resource);
                // Strip " · return by <name>" suffix that the JS appends to resource_name
                $assetName     = preg_replace('/\s*·\s*return by .+$/i', '', $assetName);
                $returnMethod  = trim($payload['return_method'] ?? $payload['method'] ?? '');
                $condition     = trim($payload['condition']     ?? '');
                $notes         = trim($payload['notes']         ?? $data['notes'] ?? '');
                $submittedBy   = $data['requested_by'];

                // Human-readable labels
                $methodLabels = [
                    'dropoff' => 'Drop off at IT desk',
                    'pickup'  => 'Schedule pickup',
                    'courier' => 'Send via courier',
                ];
                $conditionLabels = [
                    'good'    => 'Good · no damage',
                    'minor'   => 'Minor wear',
                    'damaged' => 'Damaged · needs repair',
                    'broken'  => 'Broken / non-functional',
                ];
                $methodLabel    = $methodLabels[$returnMethod]    ?? ucfirst($returnMethod)    ?: '·';
                $conditionLabel = $conditionLabels[$condition]     ?? ucfirst($condition)       ?: '·';

                // Plain text
                $returnEmailText = "{$submittedBy} has submitted an asset return request and requires your approval.\n\n"
                    . ($returnId    ? "Return ID     : {$returnId}\n"       : '')
                    . "Asset         : {$assetName}\n"
                    . "Return Method : {$methodLabel}\n"
                    . "Condition     : {$conditionLabel}\n"
                    . ($notes       ? "Notes         : {$notes}\n"          : '')
                    . "\nSubmitted by: {$submittedBy}\n"
                    . "\nPlease log in to review the request:\nhttp://localhost/inventory/public/approvals.html";

                // HTML rows
                $returnIdRow  = $returnId
                    ? "<tr><td style='padding:8px 12px;color:#8b949e;width:160px;'>Return ID</td><td style='padding:8px 12px;color:#e6edf3;font-family:monospace;letter-spacing:.5px;'>" . htmlspecialchars($returnId, ENT_QUOTES) . "</td></tr>\n"
                    : '';
                $notesRow     = $notes
                    ? "<tr><td style='padding:8px 12px;color:#8b949e;'>Notes / Reason</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($notes, ENT_QUOTES) . "</td></tr>\n"
                    : '';

                $returnEmailHtml = "<p><strong>" . htmlspecialchars($submittedBy, ENT_QUOTES) . "</strong> has submitted an asset return request and requires your approval.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;border:1px solid #30363d;border-radius:8px;overflow:hidden;'>
  {$returnIdRow}
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:160px;'>Asset to Return</td><td style='padding:8px 12px;color:#e6edf3;font-weight:600;'>" . htmlspecialchars($assetName, ENT_QUOTES) . "</td></tr>
  <tr><td style='padding:8px 12px;color:#8b949e;'>Return Method</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($methodLabel, ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Condition</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($conditionLabel, ENT_QUOTES) . "</td></tr>
  {$notesRow}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($submittedBy, ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f0a500;'>Pending approval</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/approvals.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Review Return Request</a></p>";

                $this->emailAdmins(
                    "🔄 Asset return request from {$submittedBy}",
                    $returnEmailText,
                    $returnEmailHtml
                );

            } else {
                // ── Generic approval email for all other request types ───────
                $fakeReq = ['resource_name' => $resource, 'payload' => $payload];
                [$assetsTextBlock, $assetRowsHtml] = $this->buildAssetEmailParts($fakeReq, $payload);

                // Build meta rows — but swap Employee ID for "On behalf" when present
                $onBehalfName = trim($payload['on_behalf_of']   ?? '');
                $empId        = trim($payload['requestor_id']   ?? '');
                $reqId        = trim($payload['request_id']     ?? '');
                $location     = trim($payload['requestor_location'] ?? '');

                // Plain-text meta
                $metaPlain = '';
                if ($reqId)    $metaPlain .= "Request ID: {$reqId}\n";
                if ($onBehalfName) {
                    $metaPlain .= "On behalf of: {$onBehalfName}" . ($empId ? " ({$empId})" : '') . "\n";
                } elseif ($empId) {
                    $metaPlain .= "Employee ID: {$empId}\n";
                }
                if ($location) $metaPlain .= "Location: {$location}\n";

                // HTML meta rows
                $metaRowsHtml = '';
                if ($reqId) {
                    $safe = htmlspecialchars($reqId, ENT_QUOTES);
                    $metaRowsHtml .= "<tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request ID</td><td style='padding:8px 12px;color:#e6edf3;font-family:monospace;letter-spacing:.5px;'>{$safe}</td></tr>\n";
                }
                if ($onBehalfName) {
                    $onBehalfDisplay = htmlspecialchars($onBehalfName, ENT_QUOTES)
                        . ($empId ? ' <span style="color:#8b949e;font-size:12px;">(' . htmlspecialchars($empId, ENT_QUOTES) . ')</span>' : '');
                    $metaRowsHtml .= "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>On behalf of</td><td style='padding:8px 12px;color:#e6edf3;'>{$onBehalfDisplay}</td></tr>\n";
                } elseif ($empId) {
                    $safe = htmlspecialchars($empId, ENT_QUOTES);
                    $metaRowsHtml .= "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Employee ID</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
                }
                if ($location) {
                    $safe = htmlspecialchars($location, ENT_QUOTES);
                    $metaRowsHtml .= "<tr><td style='padding:8px 12px;color:#8b949e;'>Location</td><td style='padding:8px 12px;color:#e6edf3;'>{$safe}</td></tr>\n";
                }

                $reqNotes = trim(
                    $data['notes'] ?? $payload['purpose'] ?? $payload['description'] ?? $payload['notes'] ?? ''
                );
                $reqNotesHtml = $reqNotes
                    ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($reqNotes, ENT_QUOTES) . "</td></tr>\n"
                    : '';
                $reqNotesText = $reqNotes ? "\nReason / Notes: {$reqNotes}" : '';

                // Intro sentence — mention on-behalf employee when applicable
                $introSuffix = $onBehalfName
                    ? " on behalf of <strong>" . htmlspecialchars($onBehalfName, ENT_QUOTES) . "</strong>"
                      . ($empId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($empId, ENT_QUOTES) . ')</span>' : '')
                    : '';
                $introText = $onBehalfName
                    ? "A new approval request has been submitted on behalf of {$onBehalfName}" . ($empId ? " ({$empId})" : '') . " and requires your review."
                    : "A new approval request has been submitted and requires your review.";

                $emailSubject = "New approval request from {$data['requested_by']}";
                $emailText    = "{$introText}\n\n{$metaPlain}Request Type: {$action} {$data['resource_type']}\nRequested Assets:\n{$assetsTextBlock}{$reqNotesText}\nSubmitted by: {$data['requested_by']}\n\nPlease log in to review the request:\nhttp://localhost/inventory/public/approvals.html";
                $emailHtml    = "<p>A new approval request has been submitted and requires your review{$introSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>{$action} {$data['resource_type']}</td></tr>
  {$metaRowsHtml}
  {$assetRowsHtml}
  {$reqNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($data['requested_by'], ENT_QUOTES) . "</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/approvals.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Review Request</a></p>";
                $this->emailAdmins($emailSubject, $emailText, $emailHtml);
            }
        } catch (\Throwable $e) {
            error_log('EmailService (queue → admins): ' . $e->getMessage());
        }

        return $this->model->findById($id);
    }

    // ── Count pending ─────────────────────────────────────────────────────────

    public function countPending(): int {
        return $this->model->countPending();
    }

    // ── List ──────────────────────────────────────────────────────────────────

    public function getAll(array $filters = []): array {
        return $this->model->findAll($filters);
    }

    public function getById(int $id): array {
        $row = $this->model->findById($id);
        if (!$row) throw new RuntimeException('Approval request not found', 404);
        return $row;
    }

    public function cancel(int $id, string $userName): void {
        $req = $this->getById($id);
        if ($req['status'] !== 'pending') {
            throw new RuntimeException('Only pending requests can be cancelled', 409);
        }
        if ($req['requested_by'] !== $userName) {
            throw new RuntimeException('Access denied', 403);
        }
        if (!$this->model->deletePending($id)) {
            throw new RuntimeException('Could not cancel request', 500);
        }
        AuditLogService::log(
            'cancelled',
            $req['resource_type'],
            $req['resource_id'] ?? null,
            $req['resource_name'] ?? null,
            'Request cancelled by ' . $userName
        );
    }

    // ── Staff confirms a forwarded request ────────────────────────────────────

    public function confirm(int $id, string $userName): array {
        $req = $this->getById($id);

        if ($req['status'] !== 'forwarded') {
            throw new RuntimeException('Only forwarded requests can be confirmed', 409);
        }
        if ($req['requested_by'] !== $userName) {
            throw new RuntimeException('Access denied', 403);
        }

        // Mark as confirmed — asset is NOT deployed yet.
        // Admin must fill serial numbers and re-forward before the asset is assigned.
        $this->model->review($id, 'confirmed', $userName, 'Assets confirmed by requestor — awaiting serial release');

        AuditLogService::log(
            'updated',
            $req['resource_type'],
            $req['resource_id'] ?? null,
            $req['resource_name'] ?? null,
            'Assets confirmed by ' . $userName . ' — pending admin serial release'
        );

        // Notify all admins: staff confirmed, add serials and re-forward
        $this->notif->create([
            'for_role' => 'admin',
            'type'     => 'asset_confirmed',
            'title'    => '✅ Assets confirmed — release serial',
            'body'     => $userName . ' has confirmed the assets for "' . ($req['resource_name'] ?? 'Asset') . '". Assets confirmed, you may now release serial.',
            'link'     => 'approvals.html',
            'meta'     => ['approval_id' => $id, 'confirmed_by' => $userName],
        ]);

        // Email all admins — wrapped in try/catch so SMTP errors never break the API response
        try {
            $confirmPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
            [$confirmPlainAssets, $confirmHtmlAssetRows] = $this->buildAssetEmailParts($req, $confirmPayload);
            [$confirmMetaPlain, $confirmMetaHtml] = $this->buildMetaRowsForStaff($confirmPayload);

            $confirmOnBehalf = trim($confirmPayload['on_behalf_of'] ?? '');
            $confirmEmpId    = trim($confirmPayload['requestor_id'] ?? '');
            $confirmIntroSuffix = $confirmOnBehalf
                ? " on behalf of <strong>" . htmlspecialchars($confirmOnBehalf, ENT_QUOTES) . "</strong>"
                  . ($confirmEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($confirmEmpId, ENT_QUOTES) . ')</span>' : '')
                : '';

            $confirmDesc = trim($confirmPayload['description'] ?? $confirmPayload['purpose'] ?? $confirmPayload['notes'] ?? '');
            $confirmNotesRow = $confirmDesc
                ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($confirmDesc, ENT_QUOTES) . "</td></tr>\n"
                : '';
            $confirmNotesText = $confirmDesc ? "Reason / Notes: {$confirmDesc}\n" : '';

            $adminEmailSubject = "✅ Assets confirmed by {$userName} — release serial numbers";
            $adminEmailText    = "{$userName} has confirmed the assets for the following request:\n\n{$confirmMetaPlain}Request Type: Confirm Asset\n{$confirmNotesText}Assets:\n{$confirmPlainAssets}\nConfirmed by: {$userName}\n\nYou may now release the serial numbers to complete the assignment.\n\nLog in to review:\nhttp://localhost/inventory/public/approvals.html";
            $adminEmailHtml    = "<p><strong>" . htmlspecialchars($userName, ENT_QUOTES) . "</strong> has confirmed the assets for the following request{$confirmIntroSuffix}:</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Confirm Asset</td></tr>
  {$confirmMetaHtml}
  {$confirmHtmlAssetRows}
  {$confirmNotesRow}
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Confirmed by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($userName, ENT_QUOTES) . "</td></tr>
</table>
<p>You may now release the serial numbers to complete the assignment.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/approvals.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Release Serial Numbers</a></p>";
            $this->emailAdmins($adminEmailSubject, $adminEmailText, $adminEmailHtml);
        } catch (\Throwable $e) {
            error_log('EmailService (confirm → admins): ' . $e->getMessage());
        }

        // Notify the requestor that their confirmation was received
        $this->notif->create([
            'for_role'    => 'staff',
            'for_user_id' => $req['user_id'] ?? null,
            'type'        => 'approval_forwarded',
            'title'       => '⏳ Waiting for admin approval',
            'body'        => 'Your confirmation for "' . ($req['resource_name'] ?? 'Asset') . '" has been received. Waiting for the admin to release the serial number.',
            'link'        => 'requests.html',
            'meta'        => ['approval_id' => $id],
        ]);

        // Email the requestor — wrapped in try/catch so SMTP errors never break the API response
        try {
            $confirmStaffPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
            [$confirmStaffPlainAssets, $confirmStaffHtmlAssetRows] = $this->buildAssetEmailParts($req, $confirmStaffPayload);
            [$confirmStaffMetaPlain, $confirmStaffMetaHtml] = $this->buildMetaRowsForStaff($confirmStaffPayload);

            $csOnBehalf = trim($confirmStaffPayload['on_behalf_of'] ?? '');
            $csEmpId    = trim($confirmStaffPayload['requestor_id'] ?? '');
            $csIntroSuffix = $csOnBehalf
                ? " on behalf of <strong>" . htmlspecialchars($csOnBehalf, ENT_QUOTES) . "</strong>"
                  . ($csEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($csEmpId, ENT_QUOTES) . ')</span>' : '')
                : '';
            $csDesc = trim($confirmStaffPayload['description'] ?? $confirmStaffPayload['purpose'] ?? $confirmStaffPayload['notes'] ?? '');
            $csNotesRow  = $csDesc
                ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($csDesc, ENT_QUOTES) . "</td></tr>\n"
                : '';
            $csNotesText = $csDesc ? "Reason / Notes: {$csDesc}\n" : '';

            $staffEmailSubject = "⏳ Confirmation received — awaiting serial release";
            $staffEmailText    = "Your asset confirmation has been received.\n\n{$confirmStaffMetaPlain}Request Type: Confirm Asset\n{$csNotesText}Submitted by: {$req['requested_by']}\n\nThe admin will now release the serial numbers for your assigned assets.\n\nTrack your request:\nhttp://localhost/inventory/public/requests.html";
            $staffEmailHtml    = "<p>Your asset confirmation has been received successfully{$csIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Confirm Asset</td></tr>
  {$confirmStaffMetaHtml}
  {$confirmStaffHtmlAssetRows}
  {$csNotesRow}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f0a500;'>Awaiting serial number release</td></tr>
</table>
<p>The admin will release the serial numbers for your assigned assets shortly.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html' style='background:#1f6feb;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Track My Request</a></p>";
            $this->emailUser($req['user_id'] ?? null, $staffEmailSubject, $staffEmailText, $staffEmailHtml);
        } catch (\Throwable $e) {
            error_log('EmailService (confirm → staff): ' . $e->getMessage());
        }

        return [
            'request' => $this->model->findById($id),
        ];
    }

    /**
     * Handle a forwarded Asset/asset_request approval confirmation by the staff member.
     * Finds the best matching available product and creates an assignment.
     */
    private function executeForwardedAssetRequest(array $req, array $payload, string $assigneeName): array {
        require_once __DIR__ . '/AssignmentService.php';
        require_once __DIR__ . '/../model/ProductModel.php';

        $assignSvc    = new AssignmentService();
        $productModel = new ProductModel();
        $assignedBy   = $req['reviewed_by'] ?? 'Admin';
        $created      = [];

        // Resolve assignee name — prefer explicit payload field, fall back to session user
        $resolvedAssignee = trim(
            $payload['requestor_name'] ?? $payload['assignee_name'] ?? $payload['assignee'] ?? $assigneeName
        );
        if ($resolvedAssignee === '') $resolvedAssignee = $assigneeName;

        // Collect assets list — either explicit assets array or single item from payload fields
        $assets = $payload['assets'] ?? [];
        if (empty($assets)) {
            // Single-asset request built from brand/model/category fields
            $assets = [[
                'name'  => $payload['resource_name'] ?? $req['resource_name'] ?? '',
                'brand' => $payload['brand']  ?? '',
                'tag'   => $payload['serial_number'] ?? $payload['sku'] ?? '',
            ]];
        }

        // Build a set of product_ids already actively assigned to this person so we
        // never re-deploy a pre-filled row that represents an existing assignment.
        $existingProductIds = [];
        foreach ($assignSvc->getByAssigneeName($resolvedAssignee) as $er) {
            $existingProductIds[(int)$er['product_id']] = true;
        }

        foreach ($assets as $asset) {
            $assetName  = trim($asset['name']  ?? $req['resource_name'] ?? '');
            $assetTag   = trim($asset['tag']   ?? $payload['serial_number'] ?? $payload['sku'] ?? '');
            $assetBrand = trim($asset['brand'] ?? $payload['brand'] ?? '');

            // Skip rows with no identifying information — empty rows from the
            // accountability form that the admin left blank.
            if ($assetTag === '' && $assetBrand === '') continue;

            $product = null;

            // Helper: PDO fetch() returns false on no match; ?? only skips null,
            // so we normalise false → null before assigning.
            $fetch = static function($result) {
                return ($result !== false && $result !== null) ? $result : null;
            };

            // 1. Try serial / SKU tag (explicit tag takes highest priority)
            if ($assetTag !== '') {
                $product = $fetch($productModel->findBySku($assetTag))
                        ?? $fetch($productModel->findBySerial($assetTag));
            }

            // 2. Brand field as a serial — only when it has no spaces (i.e. looks
            // like a SKU/serial code, not a descriptive brand name).
            if (!$product && $assetBrand !== '' && strpos($assetBrand, ' ') === false) {
                $product = $fetch($productModel->findBySku($assetBrand))
                        ?? $fetch($productModel->findBySerial($assetBrand));
            }

            // 3. Exact name match — available products only to avoid phantom deployments.
            if (!$product && $assetName !== '') {
                foreach ($productModel->findByName($assetName) as $m) {
                    if ($m['asset_status'] === 'available') { $product = $m; break; }
                }
                // Allow any status only when an explicit tag was also provided
                if (!$product && $assetTag !== '') {
                    $matches = $productModel->findByName($assetName);
                    if (!empty($matches)) $product = $matches[0];
                }
            }

            // 4. Category-filtered search — last resort, available units only.
            if (!$product) {
                $catId = !empty($asset['category_id'])
                    ? (int)$asset['category_id']
                    : (!empty($payload['category_id']) ? (int)$payload['category_id'] : null);
                if ($catId) {
                    $candidates = $productModel->findAvailableByCategory($catId);
                    $product = $candidates[0] ?? null;
                }
            }

            // 5. Partial name match — available units only.
            if (!$product && $assetName !== '') {
                $candidate = $fetch($productModel->findByPartialName($assetName));
                if ($candidate && ($candidate['asset_status'] === 'available' || $assetTag !== '')) {
                    $product = $candidate;
                }
            }

            if (!$product) continue; // no matching product — skip

            // Skip products already actively assigned to this person — these are
            // pre-filled rows from existing assignments and must not be re-deployed.
            if (isset($existingProductIds[(int)$product['id']])) continue;

            try {
                $assignment = $assignSvc->create([
                    'product_id'    => (int)$product['id'],
                    'assignee_name' => $resolvedAssignee,
                    'assigned_by'   => $assignedBy,
                    'due_back'      => null,
                    'notes'         => trim($payload['description'] ?? $payload['purpose'] ?? $req['notes'] ?? '') ?: null,
                    'location_id'   => $product['location_id'] ?? null,
                ], skipAvailabilityCheck: true);
                $created[] = $assignment['id'];
            } catch (\Exception $e) {
                // Non-fatal — continue with remaining assets
            }
        }

        return ['assignments_created' => $created];
    }

    // ── Review (admin only) ───────────────────────────────────────────────────

    public function review(int $id, string $decision, string $reviewedBy, ?string $reviewNotes = null): array {
        $req = $this->getById($id);

        if ($req['status'] !== 'pending') {
            // Recovery path: older bug marked approved before execute ran
            if ($decision === 'approved' && $req['status'] === 'approved'
                && strtolower($req['resource_type']) === 'assignment'
                && $req['action_type'] === 'create') {
                $result = $this->execute($req, $reviewedBy);
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Deployment completed',
                ];
            }
            // Re-forward path: admin fills serials on a confirmed request and forwards to staff
            if ($decision === 'forwarded' && $req['status'] === 'confirmed') {
                $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes ?? 'Serial added by admin');
                AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Re-forwarded with serial numbers by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_forwarded',
                    'title'       => '📦 Assets Ready — Please Receive',
                    'body'        => 'The serial number of your assets for "' . ($req['resource_name'] ?? 'Asset') . '" is released. Please receive the assets.',
                    'link'        => 'requests.html?tab=myrequests',
                    'meta'        => ['approval_id' => $id],
                ]);
                // Email the requestor
                try {
                    $fwdConfPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                    [$fwdConfPlainAssets, $fwdConfHtmlAssetRows] = $this->buildAssetEmailParts($req, $fwdConfPayload);
                    [,$fwdConfMetaHtml]  = $this->buildMetaRowsForStaff($fwdConfPayload);
                    [$fwdConfMetaPlain,] = $this->buildMetaRowsForStaff($fwdConfPayload);
                    $fwdConfOnBehalf = trim($fwdConfPayload['on_behalf_of'] ?? '');
                    $fwdConfEmpId    = trim($fwdConfPayload['requestor_id'] ?? '');
                    $fwdConfIntroSuffix = $fwdConfOnBehalf
                        ? " on behalf of <strong>" . htmlspecialchars($fwdConfOnBehalf, ENT_QUOTES) . "</strong>"
                          . ($fwdConfEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($fwdConfEmpId, ENT_QUOTES) . ')</span>' : '')
                        : '';
                    $fwdConfDesc = trim($fwdConfPayload['description'] ?? $fwdConfPayload['purpose'] ?? $fwdConfPayload['notes'] ?? '');
                    $fwdConfNotesHtml = $fwdConfDesc
                        ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($fwdConfDesc, ENT_QUOTES) . "</td></tr>\n"
                        : '';
                    $fwdConfNotesText = $fwdConfDesc ? "Reason / Notes: {$fwdConfDesc}\n" : '';
                    $fwdConfOnBehalfText = $fwdConfOnBehalf ? ' on behalf of ' . $fwdConfOnBehalf : '';
                    $this->emailUser(
                        $req['user_id'] ?? null,
                        '📦 Assets Ready — Please Receive',
                        "The serial numbers for your assets have been released by the admin{$fwdConfOnBehalfText}.\n\n{$fwdConfMetaPlain}Request Type: Release Asset\nAssets:\n{$fwdConfPlainAssets}\n{$fwdConfNotesText}Submitted by: {$req['requested_by']}\n\nPlease log in to confirm receipt of your assets:\nhttp://localhost/inventory/public/requests.html?tab=myrequests",
                        "<p>The serial numbers for your assets have been released{$fwdConfIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Release Asset</td></tr>
  {$fwdConfMetaHtml}
  {$fwdConfHtmlAssetRows}
  {$fwdConfNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;'>Ready to receive</td></tr>
</table>
<p>Please log in to confirm receipt of your assets.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html?tab=myrequests' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Receive Assets</a></p>"
                    );
                } catch (\Throwable $e) {
                    error_log('EmailService (re-forward confirmed → staff): ' . $e->getMessage());
                }
                return [
                    'request' => $this->model->findById($id),
                    'message' => 'Forwarded with serial numbers',
                ];
            }
            // Update-and-re-forward path: admin updates serials on an already-forwarded request
            if ($decision === 'forwarded' && $req['status'] === 'forwarded') {
                $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes ?? 'Serial updated by admin');
                AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Serial numbers updated and re-forwarded by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_forwarded',
                    'title'       => '📦 Assets Ready — Please Receive',
                    'body'        => 'The serial number of your assets for "' . ($req['resource_name'] ?? 'Asset') . '" is released. Please receive the assets.',
                    'link'        => 'requests.html?tab=myrequests',
                    'meta'        => ['approval_id' => $id],
                ]);
                // Email the requestor
                try {
                    $updPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                    [$updPlainAssets, $updHtmlAssetRows] = $this->buildAssetEmailParts($req, $updPayload);
                    [,$updMetaHtml] = $this->buildMetaRowsForStaff($updPayload);
                    [$updMetaPlain,] = $this->buildMetaRowsForStaff($updPayload);
                    $updOnBehalf = trim($updPayload['on_behalf_of'] ?? '');
                    $updEmpId    = trim($updPayload['requestor_id'] ?? '');
                    $updIntroSuffix = $updOnBehalf
                        ? " on behalf of <strong>" . htmlspecialchars($updOnBehalf, ENT_QUOTES) . "</strong>"
                          . ($updEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($updEmpId, ENT_QUOTES) . ')</span>' : '')
                        : '';
                    $updDesc = trim($updPayload['description'] ?? $updPayload['purpose'] ?? $updPayload['notes'] ?? '');
                    $updNotesHtml = $updDesc
                        ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($updDesc, ENT_QUOTES) . "</td></tr>\n"
                        : '';
                    $updNotesText = $updDesc ? "Reason / Notes: {$updDesc}\n" : '';
                    $updOnBehalfText = $updOnBehalf ? ' on behalf of ' . $updOnBehalf : '';
                    $this->emailUser(
                        $req['user_id'] ?? null,
                        '📦 Assets Ready — Please Receive',
                        "The serial numbers for your assets have been updated and released by the admin{$updOnBehalfText}.\n\n{$updMetaPlain}Request Type: Release Asset\nAssets:\n{$updPlainAssets}\n{$updNotesText}Submitted by: {$req['requested_by']}\n\nPlease log in to confirm receipt of your assets:\nhttp://localhost/inventory/public/requests.html?tab=myrequests",
                        "<p>The serial numbers for your assets have been updated and released{$updIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Release Asset</td></tr>
  {$updMetaHtml}
  {$updHtmlAssetRows}
  {$updNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;'>Ready to receive</td></tr>
</table>
<p>Please log in to confirm receipt of your assets.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html?tab=myrequests' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Receive Assets</a></p>"
                    );
                } catch (\Throwable $e) {
                    error_log('EmailService (re-forward forwarded → staff): ' . $e->getMessage());
                }
                return [
                    'request' => $this->model->findById($id),
                    'message' => 'Re-forwarded with updated serial numbers',
                ];
            }
            // Release path: admin releases assets from a forwarded request directly → deploy
            if ($decision === 'approved' && $req['status'] === 'forwarded') {
                $payload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                $assigneeName = trim($payload['admin_assignee'] ?? $payload['requestor_name'] ?? $req['requested_by'] ?? '');
                $result = $this->executeForwardedAssetRequest($req, $payload, $assigneeName);
                $this->model->review($id, 'approved', $reviewedBy, $reviewNotes ?? 'Assets released by admin');
                AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Assets released and deployed by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_approved',
                    'title'       => '✅ Asset assigned to you',
                    'body'        => '"' . ($req['resource_name'] ?? 'Asset') . '" has been released by the admin and is now assigned to you.',
                    'link'        => 'requests.html?tab=myassets',
                    'meta'        => ['approval_id' => $id],
                ]);
                // Email the requestor
                try {
                    [$relPlainAssets, $relHtmlAssetRows] = $this->buildAssetEmailParts($req, $payload);
                    [,$relMetaHtml]  = $this->buildMetaRowsForStaff($payload);
                    [$relMetaPlain,] = $this->buildMetaRowsForStaff($payload);
                    $relOnBehalf = trim($payload['on_behalf_of'] ?? '');
                    $relEmpId    = trim($payload['requestor_id'] ?? '');
                    $relIntroSuffix = $relOnBehalf
                        ? " on behalf of <strong>" . htmlspecialchars($relOnBehalf, ENT_QUOTES) . "</strong>"
                          . ($relEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($relEmpId, ENT_QUOTES) . ')</span>' : '')
                        : '';
                    $relNotes = trim($payload['description'] ?? $payload['purpose'] ?? $payload['notes'] ?? $reviewNotes ?? '');
                    $relNotesHtml = $relNotes
                        ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($relNotes, ENT_QUOTES) . "</td></tr>\n"
                        : '';
                    $relNotesText = $relNotes ? "Reason / Notes: {$relNotes}\n" : '';
                    $relOnBehalfText = $relOnBehalf ? ' on behalf of ' . $relOnBehalf : '';
                    $this->emailUser(
                        $req['user_id'] ?? null,
                        '✅ Asset assigned to you',
                        "Your requested assets have been released by the admin and are now assigned to you{$relOnBehalfText}.\n\n{$relMetaPlain}Request Type: Release Asset\nAssets:\n{$relPlainAssets}\n{$relNotesText}Submitted by: {$req['requested_by']}\n\nView your assigned assets:\nhttp://localhost/inventory/public/requests.html?tab=myassets",
                        "<p>Your asset request has been approved and the assets are now assigned to you{$relIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Release Asset</td></tr>
  {$relMetaHtml}
  {$relHtmlAssetRows}
  {$relNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;'>Assigned to you</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html?tab=myassets' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>View My Assets</a></p>"
                    );
                } catch (\Throwable $e) {
                    error_log('EmailService (release forwarded → staff): ' . $e->getMessage());
                }
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Assets released and deployed',
                ];
            }
            // Release path: admin approves a staff-confirmed request (serial release → deploy)
            if ($decision === 'approved' && $req['status'] === 'confirmed') {
                $payload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                $assigneeName = trim($payload['admin_assignee'] ?? $payload['requestor_name'] ?? $req['requested_by'] ?? '');
                $result = $this->executeForwardedAssetRequest($req, $payload, $assigneeName);
                $this->model->review($id, 'approved', $reviewedBy, $reviewNotes ?? 'Serial released by admin');
                AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Serial released and asset deployed by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_approved',
                    'title'       => '✅ Asset assigned to you',
                    'body'        => '"' . ($req['resource_name'] ?? 'Asset') . '" has been released by the admin and is now assigned to you.',
                    'link'        => 'requests.html?tab=myassets',
                    'meta'        => ['approval_id' => $id],
                ]);
                // Email the requestor
                try {
                    [$confPlainAssets, $confHtmlAssetRows] = $this->buildAssetEmailParts($req, $payload);
                    [,$confMetaHtml]  = $this->buildMetaRowsForStaff($payload);
                    [$confMetaPlain,] = $this->buildMetaRowsForStaff($payload);
                    $confOnBehalf = trim($payload['on_behalf_of'] ?? '');
                    $confEmpId    = trim($payload['requestor_id'] ?? '');
                    $confIntroSuffix = $confOnBehalf
                        ? " on behalf of <strong>" . htmlspecialchars($confOnBehalf, ENT_QUOTES) . "</strong>"
                          . ($confEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($confEmpId, ENT_QUOTES) . ')</span>' : '')
                        : '';
                    $confNotes = trim($payload['description'] ?? $payload['purpose'] ?? $payload['notes'] ?? $reviewNotes ?? '');
                    $confNotesHtml = $confNotes
                        ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($confNotes, ENT_QUOTES) . "</td></tr>\n"
                        : '';
                    $confNotesText = $confNotes ? "Reason / Notes: {$confNotes}\n" : '';
                    $confOnBehalfText = $confOnBehalf ? ' on behalf of ' . $confOnBehalf : '';
                    $this->emailUser(
                        $req['user_id'] ?? null,
                        '✅ Asset assigned to you',
                        "Your requested assets have been released by the admin and are now assigned to you{$confOnBehalfText}.\n\n{$confMetaPlain}Request Type: Release Asset\nAssets:\n{$confPlainAssets}\n{$confNotesText}Submitted by: {$req['requested_by']}\n\nView your assigned assets:\nhttp://localhost/inventory/public/requests.html?tab=myassets",
                        "<p>Your asset request has been approved and the assets are now assigned to you{$confIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>Release Asset</td></tr>
  {$confMetaHtml}
  {$confHtmlAssetRows}
  {$confNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;'>Assigned to you</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html?tab=myassets' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>View My Assets</a></p>"
                    );
                } catch (\Throwable $e) {
                    error_log('EmailService (release confirmed → staff): ' . $e->getMessage());
                }
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Serial released and asset deployed',
                ];
            }
            throw new RuntimeException('Request has already been reviewed', 409);
        }
        if (!in_array($decision, ['approved', 'rejected', 'forwarded'], true)) {
            throw new InvalidArgumentException('Decision must be "approved", "rejected", or "forwarded"');
        }

        $result   = null;
        $resource = $req['resource_name'] ?? $req['resource_type'];
        $action   = ucfirst($req['action_type']);

        // Asset-type requests from the request form are "forwarded to requestor" —
        // skip execute() since the payload is a request form, not a product creation payload.
        $isAssetForward = $req['resource_type'] === 'Asset' && $decision === 'forwarded';

        if ($decision === 'approved') {
            $result = $this->execute($req, $reviewedBy);
            $this->model->review($id, 'approved', $reviewedBy, $reviewNotes);
            AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Approved by ' . $reviewedBy . ': ' . $req['action_type'] . ' on ' . $req['resource_type']);
        } elseif ($decision === 'forwarded') {
            $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes);
            AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Forwarded to requestor by ' . $reviewedBy);
        } else {
            $this->model->review($id, 'rejected', $reviewedBy, $reviewNotes);
            AuditLogService::log('rejected', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Rejected by ' . $reviewedBy . ': ' . ($reviewNotes ?: 'No reason given'));
        }

        // Notify the staff member who submitted the request
        $isAssetForward = $decision === 'forwarded';
        $notifType  = match($decision) {
            'approved'  => 'approval_approved',
            'rejected'  => 'approval_rejected',
            'forwarded' => 'approval_forwarded',
            default     => 'approval_approved',
        };
        $notifTitle = $isAssetForward
            ? "📋 Asset Form Confirmation"
            : ($decision === 'approved' ? "✅ Your request was approved" : "✖ Your request was rejected");

        $friendlyType = $req['resource_type'] === 'asset_request' ? 'Asset Request' : $req['resource_type'];
        $notifBody  = $isAssetForward
            ? "Your asset request for \"{$resource}\" requires your confirmation. Please review and sign the accountability form."
            : ("{$action} {$friendlyType}: {$resource}" . ($reviewNotes ? " — \"{$reviewNotes}\"" : ''));

        $this->notif->create([
            'for_role'    => 'staff',
            'for_user_id' => $req['user_id'] ?? null,
            'type'        => $notifType,
            'title'       => $notifTitle,
            'body'        => $notifBody,
            'link'        => $isAssetForward ? 'requests.html?tab=myrequests' : 'requests.html',
            'meta'        => ['approval_id' => $id, 'decision' => $decision],
        ]);

        // Email the requestor
        if ($isAssetForward) {
            $fwdPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
            [$fwdPlainAssets, $fwdHtmlAssetRows] = $this->buildAssetEmailParts($req, $fwdPayload);
            [,$fwdMetaHtml]  = $this->buildMetaRowsForStaff($fwdPayload);
            [$fwdMetaPlain,] = $this->buildMetaRowsForStaff($fwdPayload);
            $fwdOnBehalf = trim($fwdPayload['on_behalf_of'] ?? '');
            $fwdEmpId    = trim($fwdPayload['requestor_id'] ?? '');
            $fwdIntroSuffix = $fwdOnBehalf
                ? " on behalf of <strong>" . htmlspecialchars($fwdOnBehalf, ENT_QUOTES) . "</strong>"
                  . ($fwdEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($fwdEmpId, ENT_QUOTES) . ')</span>' : '')
                : '';
            $fwdNotes = trim($reviewNotes ?? $fwdPayload['description'] ?? $fwdPayload['purpose'] ?? $fwdPayload['notes'] ?? '');
            $fwdNotesHtml = $fwdNotes
                ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($fwdNotes, ENT_QUOTES) . "</td></tr>\n"
                : '';
            $fwdNotesText = $fwdNotes ? "Reason / Notes: {$fwdNotes}\n" : '';

            $emailSubjectStaff = "📋 Action required: Please confirm your asset request";
            $emailTextStaff    = "Your asset request requires your confirmation before it can be processed.\n\n{$fwdMetaPlain}Request Type: {$action} Asset\nAssets:\n{$fwdPlainAssets}\n{$fwdNotesText}Submitted by: {$req['requested_by']}\n\nPlease log in to review and sign the accountability form:\nhttp://localhost/inventory/public/requests.html?tab=myrequests";
            $emailHtmlStaff    = "<p>Your asset request requires your confirmation before it can be processed{$fwdIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>{$action} Asset</td></tr>
  {$fwdMetaHtml}
  {$fwdHtmlAssetRows}
  {$fwdNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Action required</td><td style='padding:8px 12px;color:#f0a500;'>Review &amp; confirm</td></tr>
</table>
<p>Please log in to review and sign the accountability form.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html?tab=myrequests' style='background:#1f6feb;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Confirm My Request</a></p>";

        } elseif ($decision === 'approved') {
            $revPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
            [$revPlainAssets, $revHtmlAssetRows] = $this->buildAssetEmailParts($req, $revPayload);
            [,$revMetaHtml]  = $this->buildMetaRowsForStaff($revPayload);
            [$revMetaPlain,] = $this->buildMetaRowsForStaff($revPayload);
            $revOnBehalf = trim($revPayload['on_behalf_of'] ?? '');
            $revEmpId    = trim($revPayload['requestor_id'] ?? '');
            $revIntroSuffix = $revOnBehalf
                ? " on behalf of <strong>" . htmlspecialchars($revOnBehalf, ENT_QUOTES) . "</strong>"
                  . ($revEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($revEmpId, ENT_QUOTES) . ')</span>' : '')
                : '';
            $revNotes = trim($reviewNotes ?? $revPayload['description'] ?? $revPayload['purpose'] ?? $revPayload['notes'] ?? '');
            $revNotesHtml = $revNotes
                ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($revNotes, ENT_QUOTES) . "</td></tr>\n"
                : '';
            $revNotesText = $revNotes ? "Reason / Notes: {$revNotes}\n" : '';

            $emailSubjectStaff = "✅ Your request has been approved";
            $emailTextStaff    = "Your {$action} {$friendlyType} request has been approved.\n\n{$revMetaPlain}Request Type: {$action} {$friendlyType}\nAssets:\n{$revPlainAssets}\n{$revNotesText}Submitted by: {$req['requested_by']}\n\nView your requests:\nhttp://localhost/inventory/public/requests.html";
            $emailHtmlStaff    = "<p>Your request has been approved{$revIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>{$action} {$friendlyType}</td></tr>
  {$revMetaHtml}
  {$revHtmlAssetRows}
  {$revNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;'>Approved</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>View My Requests</a></p>";

        } else {
            $rejPayload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
            [$rejPlainAssets, $rejHtmlAssetRows] = $this->buildAssetEmailParts($req, $rejPayload);
            [,$rejMetaHtml]  = $this->buildMetaRowsForStaff($rejPayload);
            [$rejMetaPlain,] = $this->buildMetaRowsForStaff($rejPayload);
            $rejOnBehalf = trim($rejPayload['on_behalf_of'] ?? '');
            $rejEmpId    = trim($rejPayload['requestor_id'] ?? '');
            $rejIntroSuffix = $rejOnBehalf
                ? " on behalf of <strong>" . htmlspecialchars($rejOnBehalf, ENT_QUOTES) . "</strong>"
                  . ($rejEmpId ? ' <span style="color:#8b949e;">(' . htmlspecialchars($rejEmpId, ENT_QUOTES) . ')</span>' : '')
                : '';
            $rejNotes = trim($reviewNotes ?? $rejPayload['description'] ?? $rejPayload['purpose'] ?? $rejPayload['notes'] ?? '');
            $rejNotesHtml = $rejNotes
                ? "<tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;width:140px;'>Reason / Notes</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($rejNotes, ENT_QUOTES) . "</td></tr>\n"
                : '';
            $rejNotesText = $rejNotes ? "Reason / Notes: {$rejNotes}\n" : '';

            $emailSubjectStaff = "✖ Your request has been rejected";
            $emailTextStaff    = "Your {$action} {$friendlyType} request has been rejected.\n\n{$rejMetaPlain}Request Type: {$action} {$friendlyType}\nAssets:\n{$rejPlainAssets}\n{$rejNotesText}Submitted by: {$req['requested_by']}\n\nView your requests:\nhttp://localhost/inventory/public/requests.html";
            $emailHtmlStaff    = "<p>Your request has been reviewed and unfortunately was not approved{$rejIntroSuffix}.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Request Type</td><td style='padding:8px 12px;color:#e6edf3;'>{$action} {$friendlyType}</td></tr>
  {$rejMetaHtml}
  {$rejHtmlAssetRows}
  {$rejNotesHtml}
  <tr><td style='padding:8px 12px;color:#8b949e;'>Submitted by</td><td style='padding:8px 12px;color:#e6edf3;'>" . htmlspecialchars($req['requested_by'] ?? '', ENT_QUOTES) . "</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f85149;'>Rejected</td></tr>
</table>
<p>If you have questions, please contact the admin.</p>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/requests.html' style='background:#1f6feb;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>View My Requests</a></p>";
        }
        try {
            $this->emailUser($req['user_id'] ?? null, $emailSubjectStaff, $emailTextStaff, $emailHtmlStaff);
        } catch (\Throwable $e) {
            error_log('EmailService (review → staff): ' . $e->getMessage());
        }

        return [
            'request' => $this->model->findById($id),
            'result'  => $result,
        ];
    }

    // ── Execute approved action ───────────────────────────────────────────────

    private function execute(array $req, string $reviewedBy = 'Admin'): mixed {
        $payload      = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
        $resourceType = $req['resource_type'];
        $resourceId   = $req['resource_id'] ? (int)$req['resource_id'] : null;
        $actionType   = $req['action_type'];

        switch ($resourceType) {
            case 'Asset': case 'product': case 'products':
                require_once __DIR__ . '/ProductService.php';
                require_once __DIR__ . '/AssignmentService.php';
                $svc = new ProductService();
                if ($actionType === 'create') {
                    $product = $svc->create($payload);
                    // If the asset was created with an assigned employee, also create
                    // an assignment record so it appears in the employee's "My Assets".
                    $assigneeName = trim($payload['assigned_employee'] ?? '');
                    if ($assigneeName !== '' && !empty($product['id'])) {
                        try {
                            $assignSvc = new AssignmentService();
                            // Use deployed_date from the payload as assigned_at if provided
                            $deployedAt = !empty($payload['deployed_date'])
                                ? (new \DateTime($payload['deployed_date']))->format('Y-m-d H:i:s')
                                : null;
                            $assignSvc->create([
                                'product_id'    => (int)$product['id'],
                                'assignee_name' => $assigneeName,
                                'assigned_by'   => $reviewedBy,
                                'location_id'   => !empty($payload['location_id']) ? (int)$payload['location_id'] : null,
                                'notes'         => null,
                                ...($deployedAt ? ['assigned_at' => $deployedAt] : []),
                            ], skipAvailabilityCheck: true);
                        } catch (\Exception $e) {
                            // Non-fatal — the product was created; assignment is best-effort.
                        }
                    }
                    return $product;
                }
                return match($actionType) {
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Category': case 'category': case 'categories':
                require_once __DIR__ . '/../services/CategoryService.php';
                $svc = new CategoryService();
                return match($actionType) {
                    'create' => $svc->create($payload),
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Assignment': case 'assignment': case 'assignments':
                require_once __DIR__ . '/AssignmentService.php';
                require_once __DIR__ . '/../model/AssignmentModel.php';
                $svc = new AssignmentService();
                $assignmentPayload = $this->normalizeAssignmentPayload($payload, $req);

                // For delete (return), read the assignment BEFORE deleting so we keep product_id
                $preDeleteAssignment = null;
                if ($actionType === 'delete' && $resourceId) {
                    $am = new AssignmentModel();
                    $preDeleteAssignment = $am->findById($resourceId);
                }

                $result = match($actionType) {
                    'create' => $svc->create($assignmentPayload, skipAvailabilityCheck: true),
                    'update' => $svc->update($resourceId, $assignmentPayload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };

                // After a return approval: if condition is damaged/broken, auto-create damage record
                if ($actionType === 'delete') {
                    $condition = strtolower(trim($payload['condition'] ?? ''));
                    if (in_array($condition, ['damaged', 'broken'], true)) {
                        // Resolve product_id: prefer payload, fallback to pre-delete snapshot
                        $productId = (int)($payload['product_id'] ?? 0);
                        if (!$productId && $preDeleteAssignment) {
                            $productId = (int)($preDeleteAssignment['product_id'] ?? 0);
                        }
                        if ($productId) {
                            require_once __DIR__ . '/DamageService.php';
                            $dmgSvc     = new DamageService();
                            $issueLabel = $condition === 'broken' ? 'Broken / non-functional' : 'Damaged — needs repair';
                            $issueNote  = $payload['notes'] ?? '';
                            try {
                                $dmgSvc->create([
                                    'product_id'  => $productId,
                                    'reported_by' => $req['requested_by'] ?? 'System',
                                    'issue'       => $issueLabel . ($issueNote ? ': ' . $issueNote : ''),
                                    'status'      => 'damaged',
                                ]);
                            } catch (\Exception $e) {
                                // Non-fatal — return was already processed
                            }
                        }
                    }
                }
                return $result;
            case 'Damage': case 'damage': case 'damages':
                require_once __DIR__ . '/DamageService.php';
                $svc = new DamageService();
                return match($actionType) {
                    'create' => $svc->create($payload),
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Supplier': case 'supplier': case 'suppliers':
                require_once __DIR__ . '/SupplierService.php';
                $svc = new SupplierService();
                return match($actionType) {
                    'create' => $svc->createSupplier($payload),
                    'update' => $svc->updateSupplier($resourceId, $payload),
                    'delete' => $svc->deleteSupplier($resourceId),
                    default  => null,
                };
            case 'asset_request':
                // Request Form submission — create assignments for each requested asset.
                require_once __DIR__ . '/AssignmentService.php';
                require_once __DIR__ . '/../model/ProductModel.php';
                $assignSvc   = new AssignmentService();
                $productModel = new ProductModel();
                $assigneeName = trim($payload['assignee'] ?? $req['requested_by'] ?? 'Unknown');
                $assignedBy   = $req['reviewed_by'] ?? 'Admin';
                $dueBack      = null;
                if (!empty($payload['expected_return'])) {
                    // Normalise various date formats to Y-m-d
                    $parsed = date_create($payload['expected_return']);
                    $dueBack = $parsed ? date_format($parsed, 'Y-m-d') : null;
                }
                $notes    = trim($payload['purpose'] ?? $req['notes'] ?? '');
                $assets   = $payload['assets'] ?? [];
                $created  = [];

                foreach ($assets as $asset) {
                    $assetName      = trim($asset['name']       ?? '');
                    $assetTag       = trim($asset['tag']        ?? '');
                    $assetBrand     = trim($asset['brand']      ?? '');
                    $assetModel     = trim($asset['model']      ?? '');
                    $assetCatName   = trim($asset['category_name'] ?? '');
                    $assetBrandModel = trim($asset['brand_model'] ?? '');

                    // Reconstruct brand_model if stored split
                    if ($assetBrandModel === '' && $assetBrand !== '' && $assetModel !== '') {
                        $assetBrandModel = $assetBrand . ' ' . $assetModel;
                    }

                    // Skip rows that carry no identifying data.
                    if ($assetTag === '' && $assetBrand === '' && $assetName === '' && $assetCatName === '') continue;

                    // PDO fetch() returns false on no match; normalise to null.
                    $fetch = static function($r) { return ($r !== false && $r !== null) ? $r : null; };

                    // 1. Try serial / SKU tag (explicit tag takes highest priority)
                    $product = null;
                    if ($assetTag !== '') {
                        $product = $fetch($productModel->findBySku($assetTag))
                                ?? $fetch($productModel->findBySerial($assetTag));
                    }

                    // 2. Brand field as serial — only when it has no spaces.
                    if (!$product && $assetBrand !== '' && strpos($assetBrand, ' ') === false) {
                        $product = $fetch($productModel->findBySku($assetBrand))
                                ?? $fetch($productModel->findBySerial($assetBrand));
                    }

                    // 3. Exact name match — available products only.
                    if (!$product && $assetName !== '') {
                        $matches = $productModel->findByName($assetName);
                        foreach ($matches as $m) {
                            if ($m['asset_status'] === 'available') { $product = $m; break; }
                        }
                        if (!$product && $assetTag !== '' && !empty($matches)) {
                            $product = $matches[0];
                        }
                    }

                    // 4. Match by brand_model combined string (e.g. "Apple MacBook Neo")
                    if (!$product && $assetBrandModel !== '') {
                        $bmMatches = $productModel->findByBrandModel($assetBrandModel);
                        foreach ($bmMatches as $m) {
                            if ($m['asset_status'] === 'available') { $product = $m; break; }
                        }
                        if (!$product && !empty($bmMatches)) $product = $bmMatches[0];
                    }

                    // 5. Partial name match — available units only
                    if (!$product && $assetName !== '') {
                        $product = $productModel->findByPartialName($assetName);
                        if ($product && $product['asset_status'] !== 'available' && $assetTag === '') {
                            $product = null;
                        }
                    }

                    // 6. Category name fallback — first available product in that category
                    if (!$product && $assetCatName !== '') {
                        $catMatches = $productModel->findAvailableByCategoryName($assetCatName);
                        if (!empty($catMatches)) $product = $catMatches[0];
                    }

                    if (!$product) continue; // product not found in inventory — skip

                    try {
                        $assignment = $assignSvc->create([
                            'product_id'    => (int)$product['id'],
                            'assignee_name' => $assigneeName,
                            'assigned_by'   => $assignedBy,
                            'due_back'      => $dueBack,
                            'notes'         => $notes ?: null,
                            'location_id'   => $product['location_id'] ?? null,
                        ], skipAvailabilityCheck: true);
                        $created[] = $assignment['id'];
                    } catch (\Exception $e) {
                        // Non-fatal — continue with remaining assets
                    }
                }
                return ['assignments_created' => $created];
            default:
                throw new RuntimeException("Cannot execute action for resource type: $resourceType");
        }
    }

    /** Map approval payload fields to assignment create/update input */
    private function normalizeAssignmentPayload(array $payload, array $req): array {
        $due = $payload['due_back'] ?? $payload['date_needed'] ?? null;
        $notes = $payload['notes'] ?? $payload['reason'] ?? null;
        if (!empty($payload['station'])) {
            $stationNote = 'Station: ' . $payload['station'];
            $notes = $notes ? ($notes . ' | ' . $stationNote) : $stationNote;
        }

        return [
            'product_id'    => (int) ($payload['product_id'] ?? 0),
            'assignee_name' => trim($payload['assignee_name'] ?? ''),
            'assigned_by'   => trim($payload['assigned_by'] ?? $req['requested_by'] ?? 'Admin'),
            'due_back'      => $due ?: null,
            'notes'         => $notes,
            'location_id'   => $payload['location_id'] ?? null,
        ];
    }
}

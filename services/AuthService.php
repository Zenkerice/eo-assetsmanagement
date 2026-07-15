<?php
require_once __DIR__ . '/../model/UserModel.php';
require_once __DIR__ . '/../model/NotificationModel.php';
require_once __DIR__ . '/../services/EmailService.php';

class AuthService {
    private UserModel $model;
    private NotificationModel $notifModel;
    private EmailService $mailer;

    public function __construct() {
        $this->model      = new UserModel();
        $this->notifModel = new NotificationModel();
        $this->mailer     = new EmailService();
    }

    /** Verify credentials and return user array (without password) or throw with reason. */
    public function login(string $username, string $password): array|false {
        $user = $this->model->findByUsername($username);
        if (!$user) return false;
        if (!password_verify($password, $user['password'])) return false;

        // Check account status
        $status = $user['status'] ?? 'active';
        if ($status === 'pending') {
            throw new RuntimeException('Your account is pending admin approval. Please wait for an admin to activate your account.', 403);
        }
        if ($status === 'rejected') {
            throw new RuntimeException('Your account registration was rejected. Please contact an administrator.', 403);
        }
        if ($status === 'suspended') {
            throw new RuntimeException('Your account has been suspended. Please contact an administrator.', 403);
        }

        unset($user['password']);
        return $user;
    }

    /** Self-registration — creates account with status=pending, requires admin approval. */
    public function register(array $data): array {
        $this->validateUserData($data, isNew: true);

        // Registration only allows viewer, staff, or manager roles — not admin
        $role = $data['role'] ?? 'viewer';
        if (!in_array($role, ['viewer', 'staff', 'manager'])) {
            throw new InvalidArgumentException('Self-registration only allows viewer, staff, or manager roles');
        }
        $data['role'] = $role;

        if ($this->model->usernameExists($data['username'])) {
            throw new InvalidArgumentException('Username already taken');
        }

        // Self-registered accounts start as pending — admin must approve
        $createData = [
            'name'           => $data['name'],
            'username'       => $data['username'],
            'password'       => $data['password'],
            'role'           => $data['role'],
            'status'         => 'pending',
            'position'       => $data['position'] ?? null,
            'email'          => $data['email'] ?? null,
            'contact_number' => $data['contact_number'] ?? null,
            'employee_id'    => $data['employee_id'] ?? null,
        ];

        $id = $this->model->create($createData);
        $user = $this->model->findById($id);
        unset($user['password']);

        // Notify all admins that a new account is awaiting approval
        $roleLabel = ucfirst($user['role'] ?? 'user');
        $this->notifModel->create([
            'for_role' => 'admin',
            'type'     => 'submitted',
            'title'    => 'New Account Pending Approval',
            'body'     => "{$user['name']} ({$user['username']}) registered as {$roleLabel} and is awaiting your approval.",
            'link'     => 'users.html',
            'meta'     => ['user_id' => $user['id'], 'action' => 'registration'],
        ]);

        // Email all admins
        try {
            $admins = array_filter($this->model->findAll(), fn($u) => $u['role'] === 'admin' && !empty($u['email']));
            $name     = htmlspecialchars($user['name'],     ENT_QUOTES);
            $username = htmlspecialchars($user['username'], ENT_QUOTES);
            $role     = htmlspecialchars($roleLabel,        ENT_QUOTES);
            $pos      = htmlspecialchars($user['position'] ?? '—', ENT_QUOTES);
            $empId    = htmlspecialchars($user['employee_id'] ?? '—', ENT_QUOTES);
            $emailRow = htmlspecialchars($user['email'] ?? '—', ENT_QUOTES);

            $subject  = "New Account Pending Approval — {$user['name']}";
            $bodyText = "A new account is awaiting your approval.\n\nName: {$user['name']}\nUsername: {$user['username']}\nRole: {$roleLabel}\nPosition: " . ($user['position'] ?? '—') . "\nEmployee ID: " . ($user['employee_id'] ?? '—') . "\nEmail: " . ($user['email'] ?? '—') . "\n\nLog in to approve or reject:\nhttp://localhost/inventory/public/users.html";
            $bodyHtml = "<p>A new account registration is awaiting your approval.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$name}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Username</td><td style='padding:8px 12px;color:#e6edf3;'>{$username}</td></tr>
  <tr><td style='padding:8px 12px;color:#8b949e;'>Role</td><td style='padding:8px 12px;color:#e6edf3;'>{$role}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Position</td><td style='padding:8px 12px;color:#e6edf3;'>{$pos}</td></tr>
  <tr><td style='padding:8px 12px;color:#8b949e;'>Employee ID</td><td style='padding:8px 12px;color:#e6edf3;'>{$empId}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Email</td><td style='padding:8px 12px;color:#e6edf3;'>{$emailRow}</td></tr>
  <tr><td style='padding:8px 12px;color:#f0a500;font-weight:600;'>Status</td><td style='padding:8px 12px;color:#f0a500;'>Pending approval</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/users.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Review Account</a></p>";

            foreach ($admins as $admin) {
                $this->mailer->send($admin['email'], $admin['name'], $subject, $bodyText, $bodyHtml);
            }
        } catch (\Throwable $e) {
            error_log('EmailService (register → admins): ' . $e->getMessage());
        }

        return $user;
    }

    public function getAll(): array {
        return $this->model->findAll();
    }

    public function getById(int $id): array {
        $user = $this->model->findById($id);
        if (!$user) throw new RuntimeException('User not found', 404);
        return $user;
    }

    public function create(array $data): array {
        $this->validateUserData($data, isNew: true);

        if ($this->model->usernameExists($data['username'])) {
            throw new InvalidArgumentException('Username already taken');
        }

        // Admin-created accounts are immediately active
        $data['status'] = 'active';
        $id = $this->model->create($data);
        return $this->model->findById($id);
    }

    public function updateStatus(int $id, string $status): array {
        if (!in_array($status, ['active', 'pending', 'rejected', 'suspended'])) {
            throw new InvalidArgumentException('Status must be active, pending, rejected, or suspended');
        }
        $user = $this->model->findById($id);
        if (!$user) throw new RuntimeException('User not found', 404);
        $this->model->updateStatus($id, $status);

        // Notify the user of the decision
        if ($status === 'active') {
            $this->notifModel->create([
                'for_user_id' => $id,
                'for_role'    => 'staff',
                'type'        => 'approved',
                'title'       => 'Account Approved!',
                'body'        => 'Your account has been approved by an admin. You can now sign in.',
                'link'        => null,
                'meta'        => ['action' => 'account_approved'],
            ]);
            // Email the user
            try {
                if (!empty($user['email'])) {
                    $nameHtml = htmlspecialchars($user['name'], ENT_QUOTES);
                    $this->mailer->send(
                        $user['email'],
                        $user['name'],
                        '✅ Your account has been approved',
                        "Hi {$user['name']},\n\nGreat news! Your account registration has been approved by an admin. You can now sign in.\n\nLog in here:\nhttp://localhost/inventory/public/login.html",
                        "<p>Hi <strong>{$nameHtml}</strong>,</p>
<p>Great news! Your account registration has been approved. You can now sign in to the system.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$nameHtml}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;font-weight:600;'>Approved — Active</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/login.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Sign In Now</a></p>"
                    );
                }
            } catch (\Throwable $e) {
                error_log('EmailService (updateStatus approved → user): ' . $e->getMessage());
            }
        } elseif ($status === 'rejected') {
            $this->notifModel->create([
                'for_user_id' => $id,
                'for_role'    => 'staff',
                'type'        => 'rejected',
                'title'       => 'Account Registration Rejected',
                'body'        => 'Unfortunately, your account registration was not approved. Please contact your administrator.',
                'link'        => null,
                'meta'        => ['action' => 'account_rejected'],
            ]);
            // Email the user
            try {
                if (!empty($user['email'])) {
                    $nameHtml = htmlspecialchars($user['name'], ENT_QUOTES);
                    $this->mailer->send(
                        $user['email'],
                        $user['name'],
                        '✖ Your account registration was not approved',
                        "Hi {$user['name']},\n\nUnfortunately, your account registration was not approved. Please contact your administrator for more information.",
                        "<p>Hi <strong>{$nameHtml}</strong>,</p>
<p>Unfortunately, your account registration was reviewed and was not approved at this time.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$nameHtml}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f85149;font-weight:600;'>Rejected</td></tr>
</table>
<p>If you believe this is a mistake, please contact your administrator directly.</p>"
                    );
                }
            } catch (\Throwable $e) {
                error_log('EmailService (updateStatus rejected → user): ' . $e->getMessage());
            }
        } elseif ($status === 'suspended') {
            // Email the user
            try {
                if (!empty($user['email'])) {
                    $nameHtml = htmlspecialchars($user['name'], ENT_QUOTES);
                    $this->mailer->send(
                        $user['email'],
                        $user['name'],
                        '⚠️ Your account has been suspended',
                        "Hi {$user['name']},\n\nYour account has been suspended by an administrator. You will not be able to sign in until the suspension is lifted.\n\nIf you believe this is a mistake, please contact your administrator.",
                        "<p>Hi <strong>{$nameHtml}</strong>,</p>
<p>Your account has been suspended by an administrator.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$nameHtml}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f0a500;font-weight:600;'>Suspended</td></tr>
</table>
<p>You will not be able to sign in while your account is suspended. If you believe this is a mistake, please contact your administrator directly.</p>"
                    );
                }
            } catch (\Throwable $e) {
                error_log('EmailService (updateStatus suspended → user): ' . $e->getMessage());
            }
        }

        return $this->model->findById($id);
    }

    public function update(int $id, array $data): array {
        $existing = $this->model->findById($id);
        if (!$existing) throw new RuntimeException('User not found', 404);

        $this->validateUserData($data, isNew: false);

        if (isset($data['username']) && $this->model->usernameExists($data['username'], $id)) {
            throw new InvalidArgumentException('Username already taken');
        }

        $fields = array_filter([
            'name'           => $data['name']           ?? null,
            'username'       => $data['username']       ?? null,
            'role'           => $data['role']           ?? null,
            'status'         => $data['status']         ?? null,
            'position'       => array_key_exists('position', $data) ? ($data['position'] ?: null) : null,
            'email'          => array_key_exists('email', $data) ? ($data['email'] ?: null) : null,
            'contact_number' => array_key_exists('contact_number', $data) ? ($data['contact_number'] ?: null) : null,
            'employee_id'    => array_key_exists('employee_id', $data) ? ($data['employee_id'] ?: null) : null,
            'password'       => !empty($data['password']) ? $data['password'] : null,
        ], fn($v) => $v !== null);

        if (empty($fields)) throw new InvalidArgumentException('No fields to update');

        $this->model->update($id, $fields);

        // Send suspension email if the status changed to suspended
        $newStatus  = $data['status'] ?? null;
        $prevStatus = $existing['status'] ?? 'active';
        if ($newStatus === 'suspended' && $prevStatus !== 'suspended') {
            // Use the updated email in case it was changed in the same save
            $emailAddr = $data['email'] ?? $existing['email'] ?? null;
            $userName  = $data['name']  ?? $existing['name']  ?? '';
            try {
                if (!empty($emailAddr)) {
                    $nameHtml = htmlspecialchars($userName, ENT_QUOTES);
                    $this->mailer->send(
                        $emailAddr,
                        $userName,
                        '⚠️ Your account has been suspended',
                        "Hi {$userName},\n\nYour account has been suspended by an administrator. You will not be able to sign in until the suspension is lifted.\n\nIf you believe this is a mistake, please contact your administrator.",
                        "<p>Hi <strong>{$nameHtml}</strong>,</p>
<p>Your account has been suspended by an administrator.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$nameHtml}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#f0a500;font-weight:600;'>Suspended</td></tr>
</table>
<p>You will not be able to sign in while your account is suspended. If you believe this is a mistake, please contact your administrator directly.</p>"
                    );
                }
            } catch (\Throwable $e) {
                error_log('EmailService (update suspended → user): ' . $e->getMessage());
            }
        }

        // Send unsuspension email if the status changed from suspended to active
        if ($newStatus === 'active' && $prevStatus === 'suspended') {
            $emailAddr = $data['email'] ?? $existing['email'] ?? null;
            $userName  = $data['name']  ?? $existing['name']  ?? '';
            try {
                if (!empty($emailAddr)) {
                    $nameHtml = htmlspecialchars($userName, ENT_QUOTES);
                    $this->mailer->send(
                        $emailAddr,
                        $userName,
                        '✅ Your account suspension has been lifted',
                        "Hi {$userName},\n\nYour account suspension has been lifted by an administrator. You can now sign in again.\n\nLog in here:\nhttp://localhost/inventory/public/login.html",
                        "<p>Hi <strong>{$nameHtml}</strong>,</p>
<p>Your account suspension has been lifted. You can now sign in to the system again.</p>
<table style='width:100%;border-collapse:collapse;margin:16px 0;'>
  <tr><td style='padding:8px 12px;color:#8b949e;width:140px;'>Name</td><td style='padding:8px 12px;color:#e6edf3;'>{$nameHtml}</td></tr>
  <tr style='background:#1c2333;'><td style='padding:8px 12px;color:#8b949e;'>Status</td><td style='padding:8px 12px;color:#3fb950;font-weight:600;'>Active</td></tr>
</table>
<p style='margin-top:24px;'><a href='http://localhost/inventory/public/login.html' style='background:#238636;color:#fff;padding:10px 20px;border-radius:6px;text-decoration:none;font-weight:600;'>Sign In Now</a></p>"
                    );
                }
            } catch (\Throwable $e) {
                error_log('EmailService (update unsuspended → user): ' . $e->getMessage());
            }
        }

        return $this->model->findById($id);
    }

    public function delete(int $id, int $currentUserId): void {
        if ($id === $currentUserId) {
            throw new InvalidArgumentException('You cannot delete your own account');
        }
        $user = $this->model->findById($id);
        if (!$user) throw new RuntimeException('User not found', 404);
        $this->model->delete($id);
    }

    private function validateUserData(array $data, bool $isNew): void {
        if ($isNew) {
            if (empty($data['name']))     throw new InvalidArgumentException('Name is required');
            if (empty($data['username'])) throw new InvalidArgumentException('Username is required');
            if (empty($data['password'])) throw new InvalidArgumentException('Password is required');
        }
        if (isset($data['role']) && !in_array($data['role'], ['admin', 'staff', 'viewer', 'manager'])) {
            throw new InvalidArgumentException('Role must be admin, staff, viewer, or manager');
        }
        if (isset($data['username']) && strlen($data['username']) < 3) {
            throw new InvalidArgumentException('Username must be at least 3 characters');
        }
        if (isset($data['password']) && strlen($data['password']) < 6) {
            throw new InvalidArgumentException('Password must be at least 6 characters');
        }
    }
}

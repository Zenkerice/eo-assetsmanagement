<?php
require_once __DIR__ . '/../model/UserModel.php';
require_once __DIR__ . '/../model/NotificationModel.php';

class AuthService {
    private UserModel $model;
    private NotificationModel $notifModel;

    public function __construct() {
        $this->model      = new UserModel();
        $this->notifModel = new NotificationModel();
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

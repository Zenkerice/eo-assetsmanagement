<?php
require_once __DIR__ . '/../model/UserModel.php';

class AuthService {
    private UserModel $model;

    public function __construct() {
        $this->model = new UserModel();
    }

    /** Verify credentials and return user array (without password) or false. */
    public function login(string $username, string $password): array|false {
        $user = $this->model->findByUsername($username);
        if (!$user) return false;
        if (!password_verify($password, $user['password'])) return false;

        unset($user['password']);
        return $user;
    }

    /** Self-registration — anyone can register, role defaults to viewer */
    public function register(array $data): array {
        $this->validateUserData($data, isNew: true);

        // Registration only allows viewer or staff roles — not admin
        $role = $data['role'] ?? 'viewer';
        if (!in_array($role, ['viewer', 'staff'])) {
            throw new InvalidArgumentException('Self-registration only allows viewer or staff roles');
        }
        $data['role'] = $role;

        if ($this->model->usernameExists($data['username'])) {
            throw new InvalidArgumentException('Username already taken');
        }

        $id = $this->model->create($data);
        $user = $this->model->findById($id);
        unset($user['password']);
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

        $id = $this->model->create($data);
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
            'name'     => $data['name']     ?? null,
            'username' => $data['username'] ?? null,
            'role'     => $data['role']     ?? null,
            'password' => !empty($data['password']) ? $data['password'] : null,
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
        if (isset($data['role']) && !in_array($data['role'], ['admin', 'staff', 'viewer'])) {
            throw new InvalidArgumentException('Role must be admin, staff, or viewer');
        }
        if (isset($data['username']) && strlen($data['username']) < 3) {
            throw new InvalidArgumentException('Username must be at least 3 characters');
        }
        if (isset($data['password']) && strlen($data['password']) < 6) {
            throw new InvalidArgumentException('Password must be at least 6 characters');
        }
    }
}

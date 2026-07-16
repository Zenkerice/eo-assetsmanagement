<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/AuthService.php';

class AuthController extends BaseController {
    private AuthService $service;

    public function __construct() {
        $this->service = new AuthService();
    }

    public function handle(string $method, ?int $id, array $body, string $sub = ''): void {
        match (true) {
            $sub === 'login'    && $method === 'POST'   => $this->login($body),
            $sub === 'logout'   && $method === 'POST'   => $this->logout(),
            $sub === 'me'       && $method === 'GET'    => $this->me(),
            $sub === 'me'       && $method === 'PUT'    => $this->updateMe($body),
            $sub === 'register' && $method === 'POST'   => $this->register($body),
            $sub === 'users'    && $method === 'GET'    => $this->listUsers(),
            $sub === 'users'    && $method === 'POST'   => $this->createUser($body),
            $sub === 'users'    && $method === 'PUT'    => $this->updateUser($id, $body),
            $sub === 'users'    && $method === 'DELETE' => $this->deleteUser($id),
            default => $this->respond(['error' => 'Not found'], 404),
        };
    }

    // ── Auth endpoints ────────────────────────────────────────────────────────

    private function login(array $body): void {
        $username = trim($body['username'] ?? '');
        $password = $body['password'] ?? '';

        if (!$username || !$password) {
            $this->respond(['success' => false, 'error' => 'Username and password are required'], 400);
            return;
        }

        try {
            $user = $this->service->login($username, $password);
        } catch (RuntimeException $e) {
            // Status-specific error (pending/rejected) — use 200 to avoid browser console noise
            $this->respond(['success' => false, 'error' => $e->getMessage()], 200);
            return;
        }

        if (!$user) {
            $this->respond(['success' => false, 'error' => 'Invalid username or password'], 200);
            return;
        }

        $_SESSION['user'] = $user;
        $this->respond(['success' => true, 'data' => $user]);
    }

    private function logout(): void {
        $_SESSION = [];
        session_destroy();
        $this->respond(['success' => true, 'message' => 'Logged out']);
    }

    private function register(array $body): void {
        try {
            $user = $this->service->register($body);
            $this->respond(['success' => true, 'data' => $user, 'message' => 'Account created successfully'], 201);
        } catch (InvalidArgumentException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], 400);
        } catch (RuntimeException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], $e->getCode() ?: 500);
        }
    }

    private function me(): void {
        $user = $_SESSION['user'] ?? null;
        if (!$user) {
            $this->respond(['success' => false, 'error' => 'Not authenticated'], 200);
            return;
        }
        $this->respond(['success' => true, 'data' => $user]);
    }

    /** Self-update — any authenticated user can update their own name, email, contact, password. */
    private function updateMe(array $body): void {
        $user = $_SESSION['user'] ?? null;
        if (!$user) {
            $this->respond(['success' => false, 'error' => 'Not authenticated'], 401);
            return;
        }
        $id = (int) $user['id'];

        // Only allow safe self-editable fields — never role, status, or username
        $allowed = ['name', 'email', 'contact_number', 'password'];
        $fields  = [];
        foreach ($allowed as $f) {
            if (array_key_exists($f, $body)) {
                $fields[$f] = $body[$f];
            }
        }
        if (empty($fields)) {
            $this->respond(['error' => 'No updatable fields provided'], 400);
            return;
        }
        if (isset($fields['password']) && strlen($fields['password']) < 6) {
            $this->respond(['error' => 'Password must be at least 6 characters'], 400);
            return;
        }

        $updated = $this->service->update($id, $fields);
        unset($updated['password']);

        // Refresh the session with updated user data
        $_SESSION['user'] = array_merge($_SESSION['user'], $updated);

        $this->respond(['success' => true, 'data' => $updated]);
    }

    // ── User management (admin only) ──────────────────────────────────────────

    private function listUsers(): void {
        $this->requireAdmin();
        $this->respond(['success' => true, 'data' => $this->service->getAll()]);
    }

    private function createUser(array $body): void {
        $this->requireAdmin();
        $user = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $user], 201);
    }

    private function updateUser(?int $id, array $body): void {
        $this->requireAdmin();
        if ($id === null) { $this->respond(['error' => 'ID required'], 400); return; }
        // Status-only updates (approve/reject) use the dedicated updateStatus path
        if (isset($body['status']) && count($body) === 1) {
            $user = $this->service->updateStatus($id, $body['status']);
        } else {
            $user = $this->service->update($id, $body);
        }
        $this->respond(['success' => true, 'data' => $user]);
    }

    private function deleteUser(?int $id): void {
        $this->requireAdmin();
        if ($id === null) { $this->respond(['error' => 'ID required'], 400); return; }
        $currentUserId = (int) ($_SESSION['user']['id'] ?? 0);
        $this->service->delete($id, $currentUserId);
        $this->respond(['success' => true, 'message' => 'User deleted']);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private function requireAdmin(): void {
        $role = $_SESSION['user']['role'] ?? null;
        if ($role !== 'admin') {
            $this->respond(['success' => false, 'error' => 'Admin access required'], 403);
            exit;
        }
    }

}

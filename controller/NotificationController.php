<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../model/NotificationModel.php';

/**
 * GET  /api/notifications           — list for current user
 * GET  /api/notifications?unread=1  — count unread
 * PUT  /api/notifications/{id}      — mark single read
 * PUT  /api/notifications?all=1     — mark all read
 * DELETE /api/notifications?all=1   — clear all notifications
 */
class NotificationController extends BaseController {
    private NotificationModel $model;

    public function __construct() {
        $this->model = new NotificationModel();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        $user   = $_SESSION['user'] ?? [];
        $userId = (int)($user['id']   ?? 0);
        $role   = $user['role']        ?? 'staff';

        if (!$userId) {
            // Return empty result instead of 401 so the notification bell
            // doesn't spam the console when the session is briefly unavailable.
            if ($method === 'GET' && isset($query['unread'])) {
                $this->respond(['success' => true, 'data' => ['count' => 0]]);
            } else {
                $this->respond(['success' => true, 'data' => []]);
            }
            return;
        }

        try {
            // Count unread
            if ($method === 'GET' && isset($query['unread'])) {
                $count = $this->model->countUnread($userId, $role);
                $this->respond(['success' => true, 'data' => ['count' => $count]]);
                return;
            }

            // Clear all notifications
            if ($method === 'DELETE' && isset($query['all'])) {
                $this->model->deleteAll($userId, $role);
                $this->respond(['success' => true, 'message' => 'All notifications cleared']);
                return;
            }

            // Mark all read
            if ($method === 'PUT' && isset($query['all'])) {
                $this->model->markAllRead($userId, $role);
                $this->respond(['success' => true, 'message' => 'All notifications marked as read']);
                return;
            }

            // Mark single read
            if ($method === 'PUT' && $id) {
                $this->model->markRead($id);
                $this->respond(['success' => true]);
                return;
            }

            // List
            if ($method === 'GET') {
                $items = $this->model->findForUser($userId, $role);
                $this->respond(['success' => true, 'data' => $items]);
                return;
            }

            $this->respond(['error' => 'Method not allowed'], 405);
        } catch (\Throwable $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], 500);
        }
    }

}

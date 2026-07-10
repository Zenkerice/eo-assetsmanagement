<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../model/TeamStructureModel.php';

class TeamStructureController extends BaseController {
    private TeamStructureModel $model;

    public function __construct() {
        $this->model = new TeamStructureModel();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        match ($method) {
            'GET'    => $this->index($query),
            'POST'   => $this->assign($body),
            'DELETE' => $this->unassign($id, $query),
            default  => $this->respond(['error' => 'Method not allowed'], 405),
        };
    }

    /** GET /api/team_structure[?user_id=X] */
    private function index(array $query): void {
        if (isset($query['user_id'])) {
            $rows = $this->model->getByUser((int)$query['user_id']);
            $this->respond(['success' => true, 'data' => $rows]);
            return;
        }
        if (isset($query['unassigned'])) {
            // Return employee IDs already assigned so the frontend can exclude them
            $ids = $this->model->getAssignedEmployeeIds();
            $this->respond(['success' => true, 'data' => $ids]);
            return;
        }
        $this->respond(['success' => true, 'data' => $this->model->getAll()]);
    }

    /**
     * POST /api/team_structure
     * body: { user_id: int, employee_ids: int[] }
     */
    private function assign(array $body): void {
        $userId      = (int)($body['user_id'] ?? 0);
        $employeeIds = $body['employee_ids'] ?? [];

        if (!$userId) {
            $this->respond(['error' => 'user_id is required'], 400);
            return;
        }
        if (!is_array($employeeIds) || empty($employeeIds)) {
            $this->respond(['error' => 'employee_ids must be a non-empty array'], 400);
            return;
        }

        // Strip out any invalid IDs (0, negative, non-integer) before touching the DB
        $employeeIds = array_values(array_filter(
            array_map('intval', $employeeIds),
            fn($id) => $id > 0
        ));
        if (empty($employeeIds)) {
            $this->respond(['error' => 'No valid employee_ids provided'], 400);
            return;
        }

        $count = $this->model->assign($userId, $employeeIds);
        $this->respond([
            'success' => true,
            'message' => "$count agent(s) assigned",
            'data'    => $this->model->getByUser($userId),
        ], 201);
    }

    /**
     * DELETE /api/team_structure/{id}          — remove one assignment by row id
     * DELETE /api/team_structure?user_id=X     — remove all for a user
     */
    private function unassign(?int $id, array $query): void {
        if ($id) {
            $this->model->unassign($id);
            $this->respond(['success' => true, 'message' => 'Unassigned']);
            return;
        }
        if (isset($query['user_id'])) {
            $this->model->clearUser((int)$query['user_id']);
            $this->respond(['success' => true, 'message' => 'All agents unassigned']);
            return;
        }
        $this->respond(['error' => 'Provide an id or user_id'], 400);
    }
}

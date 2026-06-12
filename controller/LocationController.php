<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../model/LocationModel.php';

class LocationController extends BaseController {
    private LocationModel $model;

    public function __construct() {
        $this->model = new LocationModel();
    }

    public function handle(string $method, ?int $id, array $body): void {
        match ($method) {
            'GET'    => $id ? $this->show($id) : $this->index(),
            'POST'   => $this->store($body),
            'PUT'    => $this->update($id, $body),
            'DELETE' => $this->destroy($id),
            default  => $this->respond(['error' => 'Method not allowed'], 405),
        };
    }

    private function index(): void {
        $this->respond(['success' => true, 'data' => $this->model->findAll()]);
    }

    private function show(int $id): void {
        $loc = $this->model->findById($id);
        if (!$loc) { $this->respond(['error' => 'Location not found'], 404); return; }
        $this->respond(['success' => true, 'data' => $loc]);
    }

    private function store(array $body): void {
        if (empty($body['name'])) {
            $this->respond(['error' => 'Location name is required'], 400); return;
        }
        $id  = $this->model->create($body);
        $loc = $this->model->findById($id);
        $this->respond(['success' => true, 'data' => $loc], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $allowed = ['name', 'building', 'floor', 'room'];
        $fields  = array_intersect_key($body, array_flip($allowed));
        if (!empty($fields)) $this->model->update($id, $fields);
        $this->respond(['success' => true, 'data' => $this->model->findById($id)]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->model->delete($id);
        $this->respond(['success' => true, 'message' => 'Location deleted']);
    }

}

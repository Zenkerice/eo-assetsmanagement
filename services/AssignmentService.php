<?php
require_once __DIR__ . '/../model/AssignmentModel.php';
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/AuditLogService.php';
require_once __DIR__ . '/Validator.php';

class AssignmentService {
    private AssignmentModel $model;
    private ProductModel    $productModel;

    public function __construct() {
        $this->model        = new AssignmentModel();
        $this->productModel = new ProductModel();
    }

    public function getAll(): array {
        return $this->model->findAll();
    }

    public function getActive(): array {
        return $this->model->findActive();
    }

    public function getByProduct(int $productId): array {
        return $this->model->findByProduct($productId);
    }

    public function getByAssigneeName(string $name): array {
        return $this->model->findByAssigneeName($name);
    }

    public function getById(int $id): array {
        $a = $this->model->findById($id);
        if (!$a) throw new RuntimeException("Assignment not found", 404);
        return $a;
    }

    /** Check out an asset to an assignee */
    public function create(array $data, bool $skipAvailabilityCheck = false): array {
        Validator::required($data, ['product_id', 'assignee_name', 'assigned_by']);

        $productId = (int)$data['product_id'];
        if ($productId <= 0) {
            throw new InvalidArgumentException("Invalid product_id", 400);
        }

        $product = $this->productModel->findById($productId);
        if (!$product) throw new RuntimeException("Asset not found", 404);

        // Only available assets can be checked out (skip if approval flow override)
        if (!$skipAvailabilityCheck && $product['asset_status'] !== 'available') {
            throw new InvalidArgumentException(
                "Asset is currently '{$product['asset_status']}' and cannot be checked out", 409
            );
        }

        // Validate due_back date if provided
        if (!empty($data['due_back'])) {
            $d = \DateTime::createFromFormat('Y-m-d', $data['due_back']);
            if (!$d) throw new InvalidArgumentException("Invalid due_back date format (expected YYYY-MM-DD)", 400);
        }

        $id = $this->model->create($data);
        // Update product status to 'assigned'
        $this->productModel->update($productId, ['asset_status' => 'assigned']);
        $a = $this->getById($id);
        AuditLogService::log('assigned', 'Asset', $productId, $product['name'],
            "Assigned to {$data['assignee_name']} by {$data['assigned_by']}");
        return $a;
    }

    /** Update notes or due_back on an active assignment */
    public function update(int $id, array $data): array {
        $this->getById($id);

        $allowed = ['assignee_name', 'due_back', 'notes', 'location_id'];
        $fields  = array_intersect_key($data, array_flip($allowed));

        if (!empty($data['due_back'])) {
            $d = \DateTime::createFromFormat('Y-m-d', $data['due_back']);
            if (!$d) throw new InvalidArgumentException("Invalid due_back date format", 400);
        }

        // Sanitize location_id
        if (array_key_exists('location_id', $fields)) {
            $fields['location_id'] = !empty($fields['location_id']) ? (int)$fields['location_id'] : null;
        }

        if (!empty($fields)) $this->model->update($id, $fields);
        return $this->getById($id);
    }

    /** Return an asset — marks assignment returned, sets product back to available */
    public function returnAsset(int $id): array {
        $assignment = $this->getById($id);
        if ($assignment['status'] === 'returned') {
            throw new InvalidArgumentException("Assignment is already returned", 409);
        }

        $this->model->markReturned($id);
        $this->productModel->update((int)$assignment['product_id'], ['asset_status' => 'available']);
        AuditLogService::log('returned', 'Asset', (int)$assignment['product_id'],
            $assignment['product_name'] ?? null, "Returned by {$assignment['assignee_name']}");
        return $this->getById($id);
    }

    /** Delete an assignment record (admin only) */
    public function delete(int $id): void {
        $assignment = $this->getById($id);
        // If still active, free the product back to available
        // (DamageService will override this to under_repair if condition was damaged)
        if ($assignment['status'] === 'active') {
            $this->productModel->update((int)$assignment['product_id'], ['asset_status' => 'available']);
        }
        $this->model->delete($id);
    }

    public function getStats(): array {
        return [
            'active'  => $this->model->countActive(),
            'overdue' => $this->model->countOverdue(),
        ];
    }

    public function getRecent(int $limit = 10): array {
        return $this->model->findRecent($limit);
    }

    public function getDailyCount(int $days = 7, ?int $locationId = null): array {
        return $this->model->countByDay($days, $locationId);
    }

    public function getDeployedByCategoryByDays(int $days = 7, ?int $locationId = null): array {
        return $this->model->countDeployedByCategoryByDays($days, $locationId);
    }

}

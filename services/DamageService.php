<?php
require_once __DIR__ . '/../model/DamageModel.php';
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/AuditLogService.php';
require_once __DIR__ . '/Validator.php';

class DamageService {
    private DamageModel  $model;
    private ProductModel $productModel;

    public function __construct() {
        $this->model        = new DamageModel();
        $this->productModel = new ProductModel();
    }

    public function getAll(): array {
        return $this->model->findAll();
    }

    public function getById(int $id): array {
        $damage = $this->model->findById($id);
        if (!$damage) throw new RuntimeException("Damage report not found", 404);
        return $damage;
    }

    public function getByCategory(int $categoryId): array {
        return $this->model->findByCategory($categoryId);
    }

    public function create(array $data): array {
        Validator::required($data, ['product_id', 'reported_by', 'issue']);

        $product = $this->productModel->findById((int)$data['product_id']);
        if (!$product) throw new RuntimeException("Item not found", 404);

        // Auto-fill category from product if not provided
        if (empty($data['category_id']) && !empty($product['category_id'])) {
            $data['category_id'] = $product['category_id'];
        }

        // Copy location from product so location-based filtering works
        if (empty($data['location_id']) && !empty($product['location_id'])) {
            $data['location_id'] = $product['location_id'];
        }

        // Cache product name/SKU so the record survives product deletion
        $data['product_name_cache'] = $product['name'];
        $data['product_sku_cache']  = $product['sku'];

        $id = $this->model->create($data);
        $this->productModel->update((int)$data['product_id'], ['asset_status' => 'under_repair']);
        AuditLogService::log('reported', 'Asset', (int)$data['product_id'], $product['name'],
            "Damage reported: {$data['issue']}");
        return $this->getById($id);
    }

    public function update(int $id, array $data): array {
        $existing = $this->getById($id); // capture before any changes

        $allowed = ['reported_by', 'issue', 'status', 'disposal_reason', 'donated_to'];
        if (!empty($data['status']) && !in_array($data['status'], ['damaged', 'resolved', 'disposed', 'donated', 'open'])) {
            throw new InvalidArgumentException("Status must be 'damaged', 'resolved', 'disposed', or 'donated'", 400);
        }
        $fields = array_intersect_key($data, array_flip($allowed));

        // Set disposed_at timestamp when marking as disposed
        if (($data['status'] ?? '') === 'disposed') {
            $fields['disposed_at'] = date('Y-m-d H:i:s');
            if (!empty($data['disposal_reason'])) {
                $fields['disposal_reason'] = trim($data['disposal_reason']);
            }
        }

        // Set donated_at / donated_to BEFORE the update call
        if (($data['status'] ?? '') === 'donated') {
            $fields['donated_at'] = date('Y-m-d H:i:s');
            if (!empty($data['donated_to'])) {
                $fields['donated_to'] = trim($data['donated_to']);
            }
        }

        if (!empty($fields)) $this->model->update($id, $fields);

        $productId = (int)$existing['product_id'];

        // When resolved, free the asset back to available
        if (($data['status'] ?? '') === 'resolved') {
            $this->productModel->update($productId, ['asset_status' => 'available']);
            AuditLogService::log('updated', 'Asset', $productId, $existing['product_name'] ?? null, 'Damage resolved');
        }

        // When disposed or donated: first close any active assignments (avoids FK cascade
        // deleting the assignment row when we delete the product), then remove the product.
        if (in_array($data['status'] ?? '', ['disposed', 'donated'])) {
            // Mark all active assignments for this product as returned before deleting it
            $db = \Database::getConnection();
            $db->exec(
                "UPDATE assignments SET status = 'returned', returned_at = NOW()
                 WHERE product_id = $productId AND status = 'active'"
            );

            $this->productModel->delete($productId);

            if (($data['status'] ?? '') === 'disposed') {
                AuditLogService::log('disposed', 'Asset', $productId, $existing['product_name'] ?? null,
                    'Asset disposed: ' . ($data['disposal_reason'] ?? ''));
            } else {
                AuditLogService::log('updated', 'Asset', $productId, $existing['product_name'] ?? null,
                    'Asset donated to: ' . ($data['donated_to'] ?? 'unknown'));
            }
        }

        // Use a direct model fetch so we never throw even if the product was deleted
        $damage = $this->model->findById($id);
        if (!$damage) throw new RuntimeException("Damage report not found", 404);
        return $damage;
    }


    public function delete(int $id): void {
        $damage = $this->getById($id);
        $this->model->delete($id);

        // If the damage was still open, free the asset back to available
        if ($damage['status'] === 'damaged') {
            $this->productModel->update((int)$damage['product_id'], ['asset_status' => 'available']);
        }
    }

}

<?php
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/../model/CategoryModel.php';
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/AuditLogService.php';
require_once __DIR__ . '/Validator.php';

class ProductService {
    private ProductModel  $model;
    private CategoryModel $categoryModel;

    public function __construct() {
        $this->model         = new ProductModel();
        $this->categoryModel = new CategoryModel();
    }

    public function getAll(): array {
        // Auto-sync asset_status for any product that has an active assignment
        // but is still marked 'available' (can happen after imports or manual edits).
        $this->model->syncStatusFromAssignments();
        return $this->model->findAll();
    }

    public function getByPoId(int $poId): array {
        return $this->model->findByPoId($poId);
    }

    public function getByName(string $name): array {
        return $this->model->findByName($name);
    }

    public function getById(int $id): array {
        $product = $this->model->findById($id);
        if (!$product) throw new RuntimeException("Product not found", 404);
        return $product;
    }

    public function getLowStock(): array {
        return $this->model->findLowStock(LOW_STOCK_THRESHOLD);
    }

    public function create(array $data): array {
        Validator::required($data, ['name', 'sku']);

        if ($this->model->findBySku($data['sku'])) {
            throw new RuntimeException("SKU '{$data['sku']}' already exists", 409);
        }
        if (!empty($data['category_id']) && !$this->categoryModel->findById((int)$data['category_id'])) {
            throw new RuntimeException("Category not found", 404);
        }

        // Sanitize FK fields — empty string must become null
        $data['category_id'] = !empty($data['category_id']) ? (int)$data['category_id'] : null;
        $data['supplier_id']  = !empty($data['supplier_id'])  ? (int)$data['supplier_id']  : null;
        $data['location_id']  = !empty($data['location_id'])  ? (int)$data['location_id']  : null;

        // Build brand_model from brand + model if not explicitly provided
        if (empty($data['brand_model'])) {
            $parts = array_filter([$data['brand'] ?? null, $data['model'] ?? null], fn($v) => $v !== null && $v !== '');
            $data['brand_model'] = implode(' ', $parts) ?: null;
        }

        if (!empty($data['image'])) {
            $data['image_path'] = $this->handleImageUpload($data['image']);
        }

        $id = $this->model->create($data);
        AuditLogService::log('created', 'Asset', $id, $data['name'], 'Asset created: ' . $data['name']);
        return $this->getById($id);
    }

    public function update(int $id, array $data): array {
        $existing = $this->getById($id);

        if (isset($data['sku'])) {
            $found = $this->model->findBySku($data['sku']);
            if ($found && (int)$found['id'] !== $id) {
                throw new RuntimeException("SKU '{$data['sku']}' already exists", 409);
            }
        }
        if (!empty($data['category_id']) && !$this->categoryModel->findById((int)$data['category_id'])) {
            throw new RuntimeException("Category not found", 404);
        }

        if (!empty($data['image'])) {
            // Delete old image if exists
            if (!empty($existing['image_path'])) {
                $old = __DIR__ . '/../public/' . $existing['image_path'];
                if (file_exists($old)) unlink($old);
            }
            $data['image_path'] = $this->handleImageUpload($data['image']);
        }

        $allowed = ['name', 'sku', 'brand_model', 'brand', 'model', 'description', 'category_id', 'supplier_id', 'supplier_name', 'location_id', 'quantity', 'image_path', 'asset_status', 'serial_number', 'assigned_employee', 'assigned_employee_id', 'purchase_date', 'deployed_date', 'po_id', 'po_item_id', 'cost_price', 'cost_currency'];
        $fields  = array_intersect_key($data, array_flip($allowed));

        // Convert empty strings to null for nullable FK columns
        foreach (['category_id', 'supplier_id', 'location_id', 'po_id', 'po_item_id'] as $fk) {
            if (array_key_exists($fk, $fields)) {
                $fields[$fk] = !empty($fields[$fk]) ? (int)$fields[$fk] : null;
            }
        }
        // Convert empty string to null for optional text/date columns
        foreach (['purchase_date', 'deployed_date', 'assigned_employee', 'assigned_employee_id', 'supplier_name', 'brand', 'model'] as $col) {
            if (array_key_exists($col, $fields) && $fields[$col] === '') {
                $fields[$col] = null;
            }
        }

        // Normalize cost_price
        if (array_key_exists('cost_price', $fields)) {
            $fields['cost_price'] = ($fields['cost_price'] !== '' && $fields['cost_price'] !== null)
                ? (float)$fields['cost_price'] : null;
        }
        if (array_key_exists('cost_currency', $fields) && empty($fields['cost_currency'])) {
            $fields['cost_currency'] = 'PHP';
        }

        // Keep brand_model in sync with brand + model
        if (array_key_exists('brand', $fields) || array_key_exists('model', $fields)) {
            $currentBrand = $fields['brand'] ?? $existing['brand'] ?? null;
            $currentModel = $fields['model'] ?? $existing['model'] ?? null;
            $parts = array_filter([$currentBrand, $currentModel], fn($v) => $v !== null && $v !== '');
            $fields['brand_model'] = implode(' ', $parts) ?: null;
        }

        // Clearing image_path — delete the physical file and set to null
        if (array_key_exists('image_path', $fields) && empty($fields['image_path'])) {
            if (!empty($existing['image_path'])) {
                $old = __DIR__ . '/../public/' . $existing['image_path'];
                if (file_exists($old)) unlink($old);
            }
            $fields['image_path'] = null;
        }

        if (!empty($fields)) $this->model->update($id, $fields);
        AuditLogService::log('updated', 'Asset', $id, $existing['name'], 'Asset updated: ' . $existing['name']);
        return $this->getById($id);
    }

    public function delete(int $id): void {
        $product = $this->getById($id);
        if ((int)$product['quantity'] >= 1) {
            throw new RuntimeException("Product can only be deleted when its quantity is less than 1", 409);
        }
        // Remove image file if exists
        if (!empty($product['image_path'])) {
            $path = __DIR__ . '/../public/' . $product['image_path'];
            if (file_exists($path)) unlink($path);
        }
        $this->model->delete($id);
        AuditLogService::log('deleted', 'Asset', $id, $product['name'], 'Asset deleted: ' . $product['name']);
    }

    private function handleImageUpload(array $file): string {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException("Image upload failed (error code {$file['error']})", 400);
        }

        $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $mime    = mime_content_type($file['tmp_name']);
        if (!in_array($mime, $allowed)) {
            throw new InvalidArgumentException("Invalid image type. Allowed: JPG, PNG, GIF, WEBP", 400);
        }

        $maxSize = 5 * 1024 * 1024; // 5 MB
        if ($file['size'] > $maxSize) {
            throw new InvalidArgumentException("Image must be under 5 MB", 400);
        }

        $ext      = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = uniqid('product_', true) . '.' . strtolower($ext);
        $uploadDir = __DIR__ . '/../public/uploads/products/';

        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $dest = $uploadDir . $filename;
        if (!move_uploaded_file($file['tmp_name'], $dest)) {
            throw new RuntimeException("Failed to save image", 500);
        }

        return 'uploads/products/' . $filename;
    }

}

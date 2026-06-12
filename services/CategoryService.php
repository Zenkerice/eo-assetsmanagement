<?php
require_once __DIR__ . '/../model/CategoryModel.php';
require_once __DIR__ . '/AuditLogService.php';

class CategoryService {
    private CategoryModel $model;

    public function __construct() {
        $this->model = new CategoryModel();
    }

    public function getAll(): array { return $this->model->findAll(); }

    public function getById(int $id): array {
        $c = $this->model->findById($id);
        if (!$c) throw new RuntimeException("Category not found", 404);
        return $c;
    }

    public function create(array $data): array {
        $name = trim($data['name'] ?? '');
        if ($name === '') throw new InvalidArgumentException("Category name is required", 400);
        if ($this->model->findByName($name)) throw new RuntimeException("Category '$name' already exists", 409);
        $id = $this->model->create($name, trim($data['description'] ?? ''));
        AuditLogService::log('created', 'Category', $id, $name, "Category created: $name");
        return $this->getById($id);
    }

    public function update(int $id, array $data): array {
        $existing = $this->getById($id);
        $fields = [];
        if (isset($data['name'])) {
            $name = trim($data['name']);
            $dup  = $this->model->findByName($name);
            if ($dup && (int)$dup['id'] !== $id) throw new RuntimeException("Category '$name' already exists", 409);
            $fields['name'] = $name;
        }
        if (isset($data['description'])) $fields['description'] = trim($data['description']);
        if (!empty($fields)) $this->model->update($id, $fields);
        AuditLogService::log('updated', 'Category', $id, $existing['name'], "Category updated: {$existing['name']}");
        return $this->getById($id);
    }

    public function delete(int $id): void {
        $cat = $this->getById($id);
        $this->model->delete($id);
        AuditLogService::log('deleted', 'Category', $id, $cat['name'], "Category deleted: {$cat['name']}");
    }
}

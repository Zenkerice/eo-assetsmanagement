<?php
require_once __DIR__ . '/../model/AuditLogModel.php';

class AuditLogService {
    private static ?AuditLogModel $model = null;

    private static function model(): AuditLogModel {
        if (!self::$model) self::$model = new AuditLogModel();
        return self::$model;
    }

    /** Write a log entry. Call from any service/controller. */
    public static function log(
        string $action,
        string $entityType,
        ?int   $entityId   = null,
        ?string $entityName = null,
        ?string $description = null,
        ?array  $meta = null
    ): void {
        $userId   = $_SESSION['user']['id']   ?? null;
        $userName = $_SESSION['user']['name'] ?? 'System';
        try {
            self::model()->log([
                'user_id'     => $userId,
                'user_name'   => $userName,
                'action'      => $action,
                'entity_type' => $entityType,
                'entity_id'   => $entityId,
                'entity_name' => $entityName,
                'description' => $description,
                'meta'        => $meta,
            ]);
        } catch (\Throwable $e) {
            // Never let audit logging break the main flow
        }
    }

    public function getAll(array $filters, int $page, int $perPage): array {
        return [
            'items' => self::model()->findAll($filters, $page, $perPage),
            'total' => self::model()->count($filters),
        ];
    }

    public function getUsers(): array {
        return self::model()->getUsers();
    }
}

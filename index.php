<?php
error_reporting(0);

if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params(['lifetime'=>0,'path'=>'/','secure'=>false,'httponly'=>true,'samesite'=>'Lax']);
    session_start();
}

require_once __DIR__ . '/controller/ProductController.php';
require_once __DIR__ . '/controller/CategoryController.php';
require_once __DIR__ . '/controller/DamageController.php';
require_once __DIR__ . '/controller/AuthController.php';
require_once __DIR__ . '/controller/AssignmentController.php';
require_once __DIR__ . '/controller/SupplierController.php';
require_once __DIR__ . '/controller/PurchaseOrderController.php';
require_once __DIR__ . '/controller/AuditLogController.php';
require_once __DIR__ . '/controller/LocationController.php';
require_once __DIR__ . '/controller/ApprovalController.php';
require_once __DIR__ . '/controller/NotificationController.php';
require_once __DIR__ . '/controller/EmployeeController.php';

header('Content-Type: application/json');

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$isAllowed = $origin === ''
    || in_array($origin, ['http://localhost','http://127.0.0.1','null'], true)
    || preg_match('#^https?://(localhost|127\.0\.0\.1)(:\d+)?$#', $origin);

if ($isAllowed) {
    header("Access-Control-Allow-Origin: " . ($origin !== '' ? $origin : 'http://localhost'));
    header('Access-Control-Allow-Credentials: true');
}
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header("Content-Security-Policy: script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; default-src 'self'; connect-src *; img-src 'self' data: blob:;");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

$method = $_SERVER['REQUEST_METHOD'];
$query  = $_GET;

if ($method === 'POST' && isset($_POST['_method']) && strtoupper($_POST['_method']) === 'PUT') {
    $method = 'PUT';
}

$body = [];
if (in_array($method, ['POST', 'PUT'])) {
    $ct = $_SERVER['CONTENT_TYPE'] ?? '';
    if (strpos($ct, 'application/json') !== false) {
        $body = json_decode(file_get_contents('php://input'), true) ?? [];
    }
}

$uri = !empty($_SERVER['REDIRECT_URL'])
    ? $_SERVER['REDIRECT_URL']
    : (parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?? '');

if (strpos($uri, '/api') !== false) {
    $uri = substr($uri, strpos($uri, '/api'));
} else {
    $uri = '/api';
}
$uri = rtrim($uri, '/') ?: '/api';
unset($query['_uri']);

// Auth routes
if (preg_match('#^/api/auth(?:/([a-z]+)(?:/(\d+))?)?$#', $uri, $m)) {
    try {
        (new AuthController())->handle($method, isset($m[2]) ? (int)$m[2] : null, $body, $m[1] ?? '');
    } catch (InvalidArgumentException $e) {
        http_response_code(400); echo json_encode(['success'=>false,'error'=>$e->getMessage()]);
    } catch (RuntimeException $e) {
        http_response_code($e->getCode() ?: 500); echo json_encode(['success'=>false,'error'=>$e->getMessage()]);
    }
    exit;
}

if (!isset($_SESSION['user'])) {
    http_response_code(401); echo json_encode(['success'=>false,'error'=>'Authentication required']); exit;
}

// Match /api/{resource}[/{id}] — allow letters, underscores, hyphens
if (!preg_match('#^/api/([a-z][a-z0-9_-]*)(?:/(\d+))?$#', $uri, $matches)) {
    http_response_code(404); echo json_encode(['error'=>'Not found']); exit;
}

$resource = $matches[1];
$id       = isset($matches[2]) ? (int)$matches[2] : null;

$role = $_SESSION['user']['role'] ?? 'staff';
if ($role === 'staff' && $method === 'DELETE' && !in_array($resource, ['notifications', 'approvals'], true)) {
    http_response_code(403); echo json_encode(['success'=>false,'error'=>'Staff accounts cannot delete records']); exit;
}

try {
    switch ($resource) {
        case 'products':
            (new ProductController())->handle($method, $id, $body, $query); break;
        case 'categories':
            (new CategoryController())->handle($method, $id, $body); break;
        case 'damages':
            (new DamageController())->handle($method, $id, $body, $query); break;
        case 'assignments':
            (new AssignmentController())->handle($method, $id, $body, $query); break;
        case 'suppliers':
            (new SupplierController())->handle($method, $id, $body, $query); break;
        case 'purchase_orders':
        case 'purchase-orders':
            (new PurchaseOrderController())->handle($method, $id, $body, $query); break;
        case 'audit_logs':
            (new AuditLogController())->handle($method, $id, $body, $query); break;
        case 'locations':
            (new LocationController())->handle($method, $id, $body); break;
        case 'employees':
            (new EmployeeController())->handle($method, $id, $body, $query); break;
        case 'approvals':
            (new ApprovalController())->handle($method, $id, $body, $query); break;
        case 'notifications':
            (new NotificationController())->handle($method, $id, $body, $query); break;
        default:
            http_response_code(404); echo json_encode(['error'=>"Resource '$resource' not found"]);
    }
} catch (InvalidArgumentException $e) {
    http_response_code(400); echo json_encode(['success'=>false,'error'=>$e->getMessage()]);
} catch (RuntimeException $e) {
    http_response_code($e->getCode() ?: 500); echo json_encode(['success'=>false,'error'=>$e->getMessage()]);
} catch (PDOException $e) {
    http_response_code(500); echo json_encode(['success'=>false,'error'=>'Database error: '.$e->getMessage()]);
}

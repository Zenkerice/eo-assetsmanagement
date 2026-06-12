<?php
/**
 * Run once to create the default admin account.
 * Usage: php scripts/seed_admin.php
 */
require_once __DIR__ . '/../config/database.php';

$db = Database::getConnection();

// Create users table if it doesn't exist
$db->exec("
    CREATE TABLE IF NOT EXISTS users (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        name       VARCHAR(100)  NOT NULL,
        username   VARCHAR(60)   NOT NULL UNIQUE,
        password   VARCHAR(255)  NOT NULL,
        role       ENUM('admin','staff') NOT NULL DEFAULT 'staff',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
");

$name     = 'Administrator';
$username = 'admin';
$password = 'admin123';
$role     = 'admin';

$hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);

$stmt = $db->prepare("
    INSERT INTO users (name, username, password, role)
    VALUES (:name, :username, :password, :role)
    ON DUPLICATE KEY UPDATE password = VALUES(password), role = VALUES(role)
");
$stmt->execute([
    ':name'     => $name,
    ':username' => $username,
    ':password' => $hash,
    ':role'     => $role,
]);

echo "✅ Admin account created.\n";
echo "   Username : admin\n";
echo "   Password : admin123\n";
echo "   Role     : admin\n";
echo "\nChange the password after first login!\n";

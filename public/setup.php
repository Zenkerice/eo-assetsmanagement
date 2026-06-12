<?php
/**
 * One-time setup: creates the users table and seeds the default admin account.
 * Visit: http://localhost/inventory/public/setup.php
 * DELETE this file after running it.
 */
require_once __DIR__ . '/../config/database.php';

header('Content-Type: text/plain; charset=utf-8');

try {
    $db = Database::getConnection();

    // 1. Create users table
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
    echo "✅ users table ready.\n";

    // 2. Seed default admin (password: admin123)
    $hash = password_hash('admin123', PASSWORD_BCRYPT, ['cost' => 12]);
    $stmt = $db->prepare("
        INSERT INTO users (name, username, password, role)
        VALUES ('Administrator', 'admin', :hash, 'admin')
        ON DUPLICATE KEY UPDATE password = VALUES(password), role = VALUES(role)
    ");
    $stmt->execute([':hash' => $hash]);
    echo "✅ Admin account created/updated.\n\n";
    echo "   Username : admin\n";
    echo "   Password : admin123\n";
    echo "   Role     : admin\n\n";

    // 3. Verify the password hash works
    $row = $db->query("SELECT password FROM users WHERE username = 'admin'")->fetch(PDO::FETCH_ASSOC);
    if ($row && password_verify('admin123', $row['password'])) {
        echo "✅ Password hash verified OK.\n\n";
    } else {
        echo "❌ Password hash verification FAILED.\n\n";
    }

    echo "Now visit: http://localhost/inventory/public/login.html\n";
    echo "⚠️  Delete public/setup.php after logging in!\n";

} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}

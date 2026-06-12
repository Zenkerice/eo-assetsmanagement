-- Run once in phpMyAdmin to add the damages/issues table
CREATE TABLE IF NOT EXISTS damages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT NOT NULL,
    category_id INT,
    reported_by VARCHAR(150) NOT NULL,
    issue       TEXT NOT NULL,
    status      ENUM('open','in_progress','resolved') NOT NULL DEFAULT 'open',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id)  REFERENCES products(id)  ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Purchase Orders table
CREATE TABLE IF NOT EXISTS purchase_orders (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    po_number     VARCHAR(30)  NOT NULL UNIQUE,
    supplier_id   INT          NOT NULL,
    order_date    DATE         NOT NULL,
    expected_date DATE         DEFAULT NULL,
    total_amount  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status        ENUM('pending','received','cancelled') NOT NULL DEFAULT 'pending',
    notes         TEXT         DEFAULT NULL,
    created_by    VARCHAR(150) DEFAULT NULL,
    created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE
);

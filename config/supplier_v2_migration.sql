-- Add status column to suppliers (soft delete)
ALTER TABLE suppliers
    ADD COLUMN IF NOT EXISTS status ENUM('active','inactive') NOT NULL DEFAULT 'active';

-- Purchase order items table
CREATE TABLE IF NOT EXISTS purchase_order_items (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    po_id        INT            NOT NULL,
    product_name VARCHAR(200)   NOT NULL,
    sku          VARCHAR(100)   DEFAULT NULL,
    quantity     INT            NOT NULL DEFAULT 1,
    unit_price   DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    total_price  DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    created_at   DATETIME       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (po_id) REFERENCES purchase_orders(id) ON DELETE CASCADE
);

-- Add received_by / received_date to purchase_orders
ALTER TABLE purchase_orders
    ADD COLUMN IF NOT EXISTS received_by   VARCHAR(150) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS received_date DATETIME     DEFAULT NULL;

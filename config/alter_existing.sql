-- ============================================================
-- Inventory System — ALTER existing inventory_db
-- Run this if you already have the database with data.
-- Safe to run — uses IF NOT EXISTS / IF EXISTS guards.
-- ============================================================

USE `inventory_db`;

-- ------------------------------------------------------------
-- 1. Add brand_model to products (if missing)
-- ------------------------------------------------------------
ALTER TABLE `products`
  ADD COLUMN IF NOT EXISTS `brand_model` VARCHAR(150) DEFAULT NULL AFTER `sku`;

-- ------------------------------------------------------------
-- 2. Add image_path to products (if missing)
-- ------------------------------------------------------------
ALTER TABLE `products`
  ADD COLUMN IF NOT EXISTS `image_path` VARCHAR(255) DEFAULT NULL;

-- ------------------------------------------------------------
-- 3. Add parent_id to categories (if missing)
-- ------------------------------------------------------------
ALTER TABLE `categories`
  ADD COLUMN IF NOT EXISTS `parent_id` INT(11) DEFAULT NULL AFTER `id`;

-- Add FK only if it doesn't exist yet
SET @fk_exists = (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = 'inventory_db'
    AND TABLE_NAME = 'categories'
    AND CONSTRAINT_NAME = 'categories_ibfk_1'
);
SET @sql = IF(@fk_exists = 0,
  'ALTER TABLE `categories` ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ------------------------------------------------------------
-- 4. Create damages table (if missing)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `damages` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `product_id`  INT(11)      NOT NULL,
  `category_id` INT(11)      DEFAULT NULL,
  `reported_by` VARCHAR(150) NOT NULL,
  `issue`       TEXT         NOT NULL,
  `status`      ENUM('damaged','resolved') NOT NULL DEFAULT 'damaged',
  `created_at`  DATETIME     DEFAULT current_timestamp(),
  `updated_at`  DATETIME     DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `damages_ibfk_1`
    FOREIGN KEY (`product_id`)  REFERENCES `products` (`id`)   ON DELETE CASCADE,
  CONSTRAINT `damages_ibfk_2`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Update status ENUM if it has old values (open/in_progress)
ALTER TABLE `damages`
  MODIFY COLUMN `status` ENUM('damaged','resolved') NOT NULL DEFAULT 'damaged';

-- ------------------------------------------------------------
-- 5. Create users table (if missing)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `name`       VARCHAR(150) NOT NULL,
  `username`   VARCHAR(100) NOT NULL,
  `password`   VARCHAR(255) NOT NULL,
  `role`       ENUM('admin','staff') NOT NULL DEFAULT 'staff',
  `token`      VARCHAR(64)  DEFAULT NULL,
  `created_at` DATETIME     DEFAULT current_timestamp(),
  `updated_at` DATETIME     DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add token column if users table already existed without it
ALTER TABLE `users`
  ADD COLUMN IF NOT EXISTS `token` VARCHAR(64) DEFAULT NULL;

-- Insert default accounts only if table is empty
INSERT INTO `users` (`name`, `username`, `password`, `role`)
SELECT 'Administrator', 'admin',
       '$2y$10$a5GKG/CkKotbQlYDI8drLuS6T.vPymHZ3OjnTqJQxBk5nxjT4JFTG',
       'admin'
WHERE NOT EXISTS (SELECT 1 FROM `users` WHERE `username` = 'admin');

INSERT INTO `users` (`name`, `username`, `password`, `role`)
SELECT 'Staff User', 'staff',
       '$2y$10$a5GKG/CkKotbQlYDI8drLuS6T.vPymHZ3OjnTqJQxBk5nxjT4JFTG',
       'staff'
WHERE NOT EXISTS (SELECT 1 FROM `users` WHERE `username` = 'staff');

-- ------------------------------------------------------------
-- 6. Remove unused supplier_id from products (if exists)
-- ------------------------------------------------------------
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'inventory_db'
    AND TABLE_NAME   = 'products'
    AND COLUMN_NAME  = 'supplier_id'
);
SET @sql2 = IF(@col_exists > 0,
  'ALTER TABLE `products` DROP FOREIGN KEY IF EXISTS `products_ibfk_2`',
  'SELECT 1'
);
PREPARE stmt2 FROM @sql2; EXECUTE stmt2; DEALLOCATE PREPARE stmt2;

SET @sql3 = IF(@col_exists > 0,
  'ALTER TABLE `products` DROP COLUMN `supplier_id`',
  'SELECT 1'
);
PREPARE stmt3 FROM @sql3; EXECUTE stmt3; DEALLOCATE PREPARE stmt3;

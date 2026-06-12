-- ============================================================
-- Assignments — Standalone Schema
-- Run this against an existing inventory_db that already has
-- the products table.  Safe to re-run (uses IF NOT EXISTS /
-- IF NOT EXISTS column checks via ALTER IGNORE).
-- ============================================================

USE `inventory_db`;

-- ------------------------------------------------------------
-- 1. Add asset_status to products (skip if already present)
-- ------------------------------------------------------------
ALTER TABLE `products`
  ADD COLUMN IF NOT EXISTS `asset_status`
    ENUM('available','assigned','checked_out','under_repair')
    NOT NULL DEFAULT 'available'
    AFTER `quantity`;

-- ------------------------------------------------------------
-- 2. assignments table
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `assignments` (
  `id`            INT(11)      NOT NULL AUTO_INCREMENT,
  `product_id`    INT(11)      NOT NULL,
  `assignee_name` VARCHAR(150) NOT NULL,
  `assigned_by`   VARCHAR(150) NOT NULL,
  `assigned_at`   DATETIME     NOT NULL DEFAULT current_timestamp(),
  `due_back`      DATE         DEFAULT NULL,
  `returned_at`   DATETIME     DEFAULT NULL,
  `notes`         TEXT         DEFAULT NULL,
  `status`        ENUM('active','returned') NOT NULL DEFAULT 'active',
  `created_at`    DATETIME     DEFAULT current_timestamp(),
  `updated_at`    DATETIME     DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status`     (`status`),
  KEY `idx_due_back`   (`due_back`),
  CONSTRAINT `fk_assign_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

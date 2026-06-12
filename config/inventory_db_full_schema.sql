-- ============================================================
-- Inventory System — Full Database Schema
-- Import this into phpMyAdmin on a fresh MySQL instance
-- ============================================================

SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `inventory_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `inventory_db`;

-- ------------------------------------------------------------
-- users
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `name`       VARCHAR(100) NOT NULL,
  `username`   VARCHAR(60)  NOT NULL,
  `password`   VARCHAR(255) NOT NULL,
  `role`       ENUM('admin','staff','viewer') NOT NULL DEFAULT 'staff',
  `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default admin account — password: admin123
INSERT INTO `users` (`name`, `username`, `password`, `role`) VALUES
('Administrator', 'admin', '$2y$10$0sYMUYgekmLjpzaG12IIAeQBnKwtdTt4ywBDPkyh3uD2BjGw.6q2K', 'admin');

-- ------------------------------------------------------------
-- categories
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `parent_id`   INT(11)      DEFAULT NULL,
  `name`        VARCHAR(100) NOT NULL,
  `description` TEXT         DEFAULT NULL,
  `created_at`  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1`
    FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- suppliers
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id`           INT(11)      NOT NULL AUTO_INCREMENT,
  `name`         VARCHAR(150) NOT NULL,
  `contact_name` VARCHAR(150) DEFAULT NULL,
  `email`        VARCHAR(150) DEFAULT NULL,
  `phone`        VARCHAR(50)  DEFAULT NULL,
  `address`      TEXT         DEFAULT NULL,
  `status`       ENUM('active','inactive') NOT NULL DEFAULT 'active',
  `created_at`   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- products  (assets)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id`            INT(11)       NOT NULL AUTO_INCREMENT,
  `name`          VARCHAR(150)  NOT NULL,
  `sku`           VARCHAR(100)  NOT NULL,
  `brand_model`   VARCHAR(150)  DEFAULT NULL,
  `description`   TEXT          DEFAULT NULL,
  `category_id`   INT(11)       DEFAULT NULL,
  `supplier_id`   INT(11)       DEFAULT NULL,
  `quantity`      INT(11)       NOT NULL DEFAULT 0,
  `asset_status`  ENUM('available','assigned','checked_out','under_repair')
                                NOT NULL DEFAULT 'available',
  `image_path`    VARCHAR(255)  DEFAULT NULL,
  `serial_number` VARCHAR(150)  DEFAULT NULL,
  `po_id`         INT(11)       DEFAULT NULL,
  `po_item_id`    INT(11)       DEFAULT NULL,
  `created_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `category_id` (`category_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `products_ibfk_1`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_ibfk_2`
    FOREIGN KEY (`supplier_id`) REFERENCES `suppliers`  (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- damages  (asset status reports)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `damages`;
CREATE TABLE `damages` (
  `id`              INT(11)      NOT NULL AUTO_INCREMENT,
  `product_id`      INT(11)      NOT NULL,
  `category_id`     INT(11)      DEFAULT NULL,
  `reported_by`     VARCHAR(150) NOT NULL,
  `issue`           TEXT         NOT NULL,
  `status`          ENUM('damaged','resolved','disposed','donated') NOT NULL DEFAULT 'damaged',
  `disposal_reason` TEXT         DEFAULT NULL,
  `disposed_at`     DATETIME     DEFAULT NULL,
  `donated_to`      VARCHAR(255) DEFAULT NULL,
  `donated_at`      DATETIME     DEFAULT NULL,
  `created_at`      DATETIME     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id`  (`product_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `damages_ibfk_1`
    FOREIGN KEY (`product_id`)  REFERENCES `products`   (`id`) ON DELETE CASCADE,
  CONSTRAINT `damages_ibfk_2`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- assignments
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `assignments`;
CREATE TABLE `assignments` (
  `id`            INT(11)      NOT NULL AUTO_INCREMENT,
  `product_id`    INT(11)      NOT NULL,
  `assignee_name` VARCHAR(150) NOT NULL,
  `assigned_by`   VARCHAR(150) NOT NULL,
  `assigned_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_back`      DATE         DEFAULT NULL,
  `returned_at`   DATETIME     DEFAULT NULL,
  `notes`         TEXT         DEFAULT NULL,
  `status`        ENUM('active','returned') NOT NULL DEFAULT 'active',
  `created_at`    DATETIME     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status`     (`status`),
  KEY `idx_due_back`   (`due_back`),
  CONSTRAINT `fk_assign_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- purchase_orders
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `purchase_orders`;
CREATE TABLE `purchase_orders` (
  `id`            INT(11)       NOT NULL AUTO_INCREMENT,
  `po_number`     VARCHAR(30)   NOT NULL,
  `supplier_id`   INT(11)       NOT NULL,
  `order_date`    DATE          NOT NULL,
  `expected_date` DATE          DEFAULT NULL,
  `total_amount`  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `status`        ENUM('pending','pending_receive','received','cancelled') NOT NULL DEFAULT 'pending',
  `notes`         TEXT          DEFAULT NULL,
  `created_by`    VARCHAR(150)  DEFAULT NULL,
  `received_by`   VARCHAR(150)  DEFAULT NULL,
  `received_date` DATETIME      DEFAULT NULL,
  `created_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `po_number` (`po_number`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `fk_po_supplier`
    FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- purchase_order_items
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `purchase_order_items`;
CREATE TABLE `purchase_order_items` (
  `id`           INT(11)       NOT NULL AUTO_INCREMENT,
  `po_id`        INT(11)       NOT NULL,
  `product_name` VARCHAR(200)  NOT NULL,
  `sku`          VARCHAR(100)  DEFAULT NULL,
  `category_id`  INT(11)       DEFAULT NULL,
  `quantity`     INT(11)       NOT NULL DEFAULT 1,
  `unit_price`   DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `total_price`  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `created_at`   DATETIME      DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `po_id` (`po_id`),
  CONSTRAINT `fk_poi_po`
    FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- audit_logs
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `user_id`     INT(11)      DEFAULT NULL,
  `user_name`   VARCHAR(150) NOT NULL DEFAULT 'System',
  `action`      ENUM('created','updated','deleted','assigned','returned',
                     'imported','received','disposed','reported')
                             NOT NULL,
  `entity_type` VARCHAR(50)  NOT NULL,
  `entity_id`   INT(11)      DEFAULT NULL,
  `entity_name` VARCHAR(255) DEFAULT NULL,
  `description` TEXT         DEFAULT NULL,
  `meta`        JSON         DEFAULT NULL,
  `created_at`  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id`  (`user_id`),
  KEY `idx_action`   (`action`),
  KEY `idx_entity`   (`entity_type`),
  KEY `idx_created`  (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- transactions  (stock movement log)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id`         INT(11)   NOT NULL AUTO_INCREMENT,
  `product_id` INT(11)   NOT NULL,
  `type`       ENUM('IN','OUT') NOT NULL,
  `quantity`   INT(11)   NOT NULL,
  `note`       TEXT      DEFAULT NULL,
  `created_at` DATETIME  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `transactions_ibfk_1`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

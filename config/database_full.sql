-- ============================================================
-- Inventory System — Full Database
-- Run this in phpMyAdmin on a fresh inventory_db
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `inventory_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `inventory_db`;

-- ------------------------------------------------------------
-- users
-- ------------------------------------------------------------
CREATE TABLE `users` (
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

-- Default accounts — password: admin123
INSERT INTO `users` (`name`, `username`, `password`, `role`) VALUES
('Administrator', 'admin', '$2y$10$0sYMUYgekmLjpzaG12IIAeQBnKwtdTt4ywBDPkyh3uD2BjGw.6q2K', 'admin'),
('Staff User',    'staff', '$2y$10$0sYMUYgekmLjpzaG12IIAeQBnKwtdTt4ywBDPkyh3uD2BjGw.6q2K', 'staff');

-- ------------------------------------------------------------
-- categories
-- ------------------------------------------------------------
CREATE TABLE `categories` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `parent_id`   INT(11)      DEFAULT NULL,
  `name`        VARCHAR(100) NOT NULL,
  `description` TEXT         DEFAULT NULL,
  `created_at`  DATETIME     DEFAULT current_timestamp(),
  `updated_at`  DATETIME     DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1`
    FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`id`, `parent_id`, `name`, `description`) VALUES
(1,  NULL, 'Peripherals',            'e.g (Keyboard, Mouse, Webcam, Headset, etc.)'),
(2,  NULL, 'Furnitures',             'e.g (Chair, Table, etc.)'),
(3,  NULL, 'Computers',              'e.g (Desktop, Laptop, Workstation, etc.)'),
(4,  NULL, 'Networking',             'e.g (Router, Switches, Access Points, etc.)'),
(5,  NULL, 'Power Equipment',        'e.g (UPS, Power Strip, Generator, etc.)'),
(6,  NULL, 'Cabling and Accessories','e.g (Ethernet cables, HDMI/Display cables, Adapters, etc.)');

ALTER TABLE `categories` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

-- ------------------------------------------------------------
-- products (assets)
-- ------------------------------------------------------------
CREATE TABLE `products` (
  `id`           INT(11)       NOT NULL AUTO_INCREMENT,
  `name`         VARCHAR(150)  NOT NULL,
  `sku`          VARCHAR(100)  NOT NULL,
  `brand_model`  VARCHAR(150)  DEFAULT NULL,
  `description`  TEXT          DEFAULT NULL,
  `category_id`  INT(11)       DEFAULT NULL,
  `quantity`     INT(11)       NOT NULL DEFAULT 0,
  `asset_status` ENUM('available','assigned','checked_out','under_repair')
                               NOT NULL DEFAULT 'available',
  `image_path`   VARCHAR(255)  DEFAULT NULL,
  `created_at`   DATETIME      DEFAULT current_timestamp(),
  `updated_at`   DATETIME      DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `products` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- ------------------------------------------------------------
-- damages
-- ------------------------------------------------------------
CREATE TABLE `damages` (
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

ALTER TABLE `damages` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- ------------------------------------------------------------
-- assignments
-- ------------------------------------------------------------
CREATE TABLE `assignments` (
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

ALTER TABLE `assignments` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

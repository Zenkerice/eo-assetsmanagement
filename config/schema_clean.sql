-- ============================================================
-- Inventory System — Clean Schema
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `inventory_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `inventory_db`;

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

INSERT INTO `categories` (`id`, `parent_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(10, NULL, 'Peripherals',           'e.g (Keyboard, Mouse, Webcam, Headset, etc.)',              '2026-05-12 15:24:08', '2026-05-13 10:27:12'),
(12, NULL, 'Furnitures',            'e.g (Chair, Table, etc.)',                                  '2026-05-13 10:06:08', '2026-05-13 10:06:42'),
(13, NULL, 'Computers',             'e.g (Desktop, Laptop, Workstation, etc.)',                  '2026-05-13 10:29:20', '2026-05-13 10:29:20'),
(14, NULL, 'Networking',            'e.g (Router, Switches Access Points, etc.)',                '2026-05-13 10:30:19', '2026-05-13 10:30:19'),
(15, NULL, 'Power Equipment',       'e.g (UPS, Power Strip, Generator, etc.)',                   '2026-05-13 10:31:23', '2026-05-13 10:31:23'),
(16, NULL, 'Cabling and Accessories','e.g (Ethernet cables, HDMI/Display cables, Adapters, etc.)','2026-05-13 10:34:15', '2026-05-13 10:34:15');

ALTER TABLE `categories` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

-- ------------------------------------------------------------
-- products
-- ------------------------------------------------------------
CREATE TABLE `products` (
  `id`          INT(11)        NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(150)   NOT NULL,
  `sku`         VARCHAR(100)   NOT NULL,
  `brand_model` VARCHAR(150)   DEFAULT NULL,
  `description` TEXT           DEFAULT NULL,
  `category_id` INT(11)        DEFAULT NULL,
  `quantity`    INT(11)        NOT NULL DEFAULT 0,
  `image_path`  VARCHAR(255)   DEFAULT NULL,
  `created_at`  DATETIME       DEFAULT current_timestamp(),
  `updated_at`  DATETIME       DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `products` (`id`, `name`, `sku`, `brand_model`, `description`, `category_id`, `price`, `quantity`, `image_path`, `created_at`, `updated_at`) VALUES
(2, 'HP Monitor',      'VAR789',   'HP',       'HP P22vb G5 54.6 cm (21.5) FHD Monitor',                                                                                                                                 10, 5999.00, 0, 'uploads/products/product_6a02a111197598.16937043.jpg',  '2026-05-12 11:17:58', '2026-05-13 11:33:53'),
(3, 'Logitech M100R',  'VAR678',   'Logitech', 'Plug-and-Play USB: No software or downloads are required.\r\nAmbidextrous Design: Full-size, contoured shape provides comfort for both left- and right-handed users.', 10,  299.00, 0, 'uploads/products/product_6a02a2d93eae90.59272908.webp', '2026-05-12 11:47:37', '2026-05-13 11:34:10'),
(4, 'Logitech M100R',  'SN-9090',  'Logitech', '',                                                                                                                                                                        10,  299.00, 0, 'uploads/products/product_6a03ca20902090.59957898.webp', '2026-05-13 08:47:28', '2026-05-13 11:34:20'),
(5, 'Laptop',          'SS3452G6', 'Huawei',   '',                                                                                                                                                                        13,    0.00, 0, NULL,                                                     '2026-05-13 11:29:39', '2026-05-13 11:30:13');

ALTER TABLE `products` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
    FOREIGN KEY (`product_id`)  REFERENCES `products` (`id`)    ON DELETE CASCADE,
  CONSTRAINT `damages_ibfk_2`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)  ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `damages` (`id`, `product_id`, `category_id`, `reported_by`, `issue`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, NULL, 'raven', 'not working',  'damaged',  '2026-05-12 16:40:37', '2026-05-12 16:45:25'),
(2, 2, NULL, 'Zen',   'Screen Crack', 'resolved', '2026-05-12 16:46:02', '2026-05-13 08:24:55');

ALTER TABLE `damages` MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

COMMIT;

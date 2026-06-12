-- ============================================================
-- EmpireOne Inventory System — Full Database Export
-- Generated: 2026-06-01
-- ============================================================

SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `inventory_db`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `inventory_db`;

-- Drop all tables first (reverse dependency order)
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `audit_logs`;
DROP TABLE IF EXISTS `assignments`;
DROP TABLE IF EXISTS `damages`;
DROP TABLE IF EXISTS `purchase_order_items`;
DROP TABLE IF EXISTS `purchase_orders`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `suppliers`;
DROP TABLE IF EXISTS `locations`;
DROP TABLE IF EXISTS `users`;

-- ------------------------------------------------------------
-- 1. locations (no dependencies)
-- ------------------------------------------------------------
CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `building` varchar(100) DEFAULT NULL,
  `floor` varchar(50) DEFAULT NULL,
  `room` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `locations` (`id`, `name`, `building`, `floor`, `room`, `created_at`, `updated_at`) VALUES
(1, 'Dungganon', 'Dungganon', NULL, NULL, '2026-06-01 08:54:33', '2026-06-01 08:54:33'),
(2, 'Pantalan',  'Pantalan',  NULL, NULL, '2026-06-01 08:54:33', '2026-06-01 08:54:33');

-- ------------------------------------------------------------
-- 2. users (no dependencies)
-- ------------------------------------------------------------
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(60) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff','viewer') NOT NULL DEFAULT 'staff',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `users` (`id`, `name`, `username`, `password`, `role`, `created_at`) VALUES
(1, 'Administrator', 'admin',  '$2y$12$FdA5C5NYevN7TSiifC33PuO3tJlBRzEgp66xinQyBOiizYvCtBBo6', 'admin',  '2026-05-13 14:52:48'),
(3, 'Raven',         'raven',  '$2y$12$Bq0LXagE.Xsx2kMTqNHoQ.UIHfgbzlsDxmda/SkROkJczt48sJ6XC', 'admin',  '2026-05-14 13:00:59'),
(4, 'Zen P.',        'zen',    '$2y$12$ZxqhYXWm8Mjx5HaCs43o0uSppEHxb0HTJYFOU9gvtj4SgxahFsWNW', 'staff',  '2026-05-14 13:03:18'),
(5, 'Ven V',         'Vennn',  '$2y$12$ZWmGjYgKhKjJkRLwRpo6fuwjzvdhbehg8mdc1ycMe2.2BV6FFOa32', 'viewer', '2026-05-19 12:30:31');

-- ------------------------------------------------------------
-- 3. categories (self-referencing parent_id)
-- ------------------------------------------------------------
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `categories` (`id`, `parent_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(10, NULL, 'Keyboards',           'Is an input device used to enter text, numbers, and commands into a computer or other electronic device.', '2026-05-12 15:24:08', '2026-06-01 08:32:09'),
(13, NULL, 'Monitors',            'A monitor is an output device that displays visual information such as text, images, and videos from a computer.', '2026-05-13 10:29:20', '2026-05-22 13:21:12'),
(14, NULL, 'Mouse',               'Is an input device used to control the cursor on a computer screen and perform actions such as clicking, selecting, and dragging items.', '2026-05-13 10:30:19', '2026-06-01 08:29:45'),
(15, NULL, 'System Units',        'A system unit is the main computer case that contains the essential internal components that process data and run programs.', '2026-05-13 10:31:23', '2026-05-22 13:20:23'),
(16, NULL, 'Parts and Accessories','e.g (Ethernet cables, HDMI/Display cables, Adapters, etc.)', '2026-05-13 10:34:15', '2026-05-22 13:21:34'),
(20, NULL, 'Other Assets',        'Additional resources or items of value owned by a person or organization that are not classified under main asset categories.', '2026-05-22 13:22:21', '2026-05-22 13:22:21'),
(21, NULL, 'Headsets',            'Is an audio device that combines headphones and a microphone, allowing users to listen to sound and communicate hands-free.', '2026-06-01 08:32:59', '2026-06-01 08:32:59'),
(22, NULL, 'UPS',                 'A UPS (Uninterruptible Power Supply) is a device that provides temporary backup power during power outages or voltage fluctuations.', '2026-06-01 08:34:06', '2026-06-01 08:34:06');

-- ------------------------------------------------------------
-- 4. suppliers (no dependencies)
-- ------------------------------------------------------------
CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `contact_name` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `suppliers` (`id`, `name`, `contact_name`, `email`, `phone`, `address`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Empire One', 'Raven Carl', 'carl@mail.com', '0912345678', 'SCC., Neg. Occ.', 'active', '2026-05-12 11:09:45', '2026-05-12 11:09:45');

-- ------------------------------------------------------------
-- 5. products (depends on: categories, suppliers, locations)
-- ------------------------------------------------------------
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `brand_model` varchar(150) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `asset_status` enum('available','assigned','checked_out','under_repair') NOT NULL DEFAULT 'available',
  `image_path` varchar(255) DEFAULT NULL,
  `serial_number` varchar(150) DEFAULT NULL,
  `po_id` int(11) DEFAULT NULL,
  `po_item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `category_id` (`category_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `fk_product_location` (`location_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_product_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------------
-- 6. purchase_orders (depends on: suppliers, locations)
-- ------------------------------------------------------------
CREATE TABLE `purchase_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `po_number` varchar(30) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `order_date` date NOT NULL,
  `expected_date` date DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','pending_receive','received','cancelled') NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `created_by` varchar(150) DEFAULT NULL,
  `received_by` varchar(150) DEFAULT NULL,
  `received_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `po_number` (`po_number`),
  KEY `supplier_id` (`supplier_id`),
  KEY `fk_po_location` (`location_id`),
  CONSTRAINT `fk_po_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_po_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `purchase_orders` (`id`, `po_number`, `supplier_id`, `order_date`, `expected_date`, `total_amount`, `status`, `notes`, `location_id`, `created_by`, `received_by`, `received_date`, `created_at`, `updated_at`) VALUES
(1, 'PO-20260518-0001', 1, '2026-05-18', '2027-02-23', 10000.00, 'received', NULL,  NULL, 'Raven',         'Raven',         '2026-05-18 10:27:24', '2026-05-18 09:11:45', '2026-05-18 10:27:24'),
(2, 'PO-20260519-0001', 1, '2026-05-19', '2026-05-19',  2000.00, 'received', NULL,  NULL, 'Administrator', 'Administrator', '2026-05-19 09:01:05', '2026-05-19 09:00:44', '2026-05-19 09:01:05'),
(3, 'PO-20260519-0002', 1, '2026-05-19', NULL,          2000.00, 'received', NULL,  NULL, 'Administrator', 'Administrator', '2026-05-19 10:18:16', '2026-05-19 09:19:05', '2026-05-19 10:18:16'),
(4, 'PO-20260529-0001', 1, '2026-05-29', '2026-05-29',  1000.00, 'received', 'yg', NULL, 'Administrator', 'Administrator', '2026-05-29 10:24:59', '2026-05-29 10:23:47', '2026-05-29 10:24:59');

-- ------------------------------------------------------------
-- 7. purchase_order_items (depends on: purchase_orders)
-- ------------------------------------------------------------
CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `po_id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `po_id` (`po_id`),
  CONSTRAINT `fk_poi_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `purchase_order_items` (`id`, `po_id`, `product_name`, `sku`, `category_id`, `quantity`, `unit_price`, `total_price`, `created_at`) VALUES
(1, 2, 'Mouse FanTech',   NULL, NULL, 10, 200.00, 2000.00, '2026-05-19 09:00:44'),
(2, 3, 'The Best Headset',NULL, NULL, 10, 200.00, 2000.00, '2026-05-19 09:19:05'),
(3, 4, 'keyboard',        NULL,   10,  5, 200.00, 1000.00, '2026-05-29 10:23:47');

-- ------------------------------------------------------------
-- 8. assignments (depends on: products, locations)
-- ------------------------------------------------------------
CREATE TABLE `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `assignee_name` varchar(150) NOT NULL,
  `assigned_by` varchar(150) NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `due_back` date DEFAULT NULL,
  `returned_at` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `status` enum('active','returned') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status` (`status`),
  KEY `idx_due_back` (`due_back`),
  KEY `fk_assign_location` (`location_id`),
  CONSTRAINT `fk_assign_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assign_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 9. damages (depends on: products, categories, locations)
-- ------------------------------------------------------------
CREATE TABLE `damages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `reported_by` varchar(150) NOT NULL,
  `issue` text NOT NULL,
  `status` enum('damaged','resolved','disposed','donated') NOT NULL DEFAULT 'damaged',
  `disposal_reason` text DEFAULT NULL,
  `disposed_at` datetime DEFAULT NULL,
  `donated_to` varchar(255) DEFAULT NULL,
  `donated_at` datetime DEFAULT NULL,
  `product_name_cache` varchar(255) DEFAULT NULL,
  `product_sku_cache` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `category_id` (`category_id`),
  KEY `fk_damage_location` (`location_id`),
  CONSTRAINT `damages_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  CONSTRAINT `damages_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_damage_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------------
-- 10. transactions (depends on: products)
-- ------------------------------------------------------------
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `type` enum('IN','OUT') NOT NULL,
  `quantity` int(11) NOT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------------
-- 11. audit_logs (no FK dependencies)
-- ------------------------------------------------------------
CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(150) NOT NULL DEFAULT 'System',
  `action` enum('created','updated','deleted','assigned','returned','imported','received','disposed','reported') NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `entity_name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_entity` (`entity_type`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `audit_logs` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `entity_name`, `description`, `meta`, `created_at`) VALUES
(1,  1, 'Administrator', 'disposed', 'Asset',    7,  'Asus Monitor',      'Asset disposed: ',                              NULL, '2026-05-20 17:17:20'),
(2,  1, 'Administrator', 'updated',  'Asset',    2,  'HP Monitor',        'Asset donated to: ssss',                        NULL, '2026-05-22 10:17:11'),
(3,  1, 'Administrator', 'updated',  'Category', 14, 'Networking',        'Category updated: Networking',                  NULL, '2026-05-22 13:16:17'),
(4,  1, 'Administrator', 'updated',  'Category', 15, 'Power Equipment',   'Category updated: Power Equipment',             NULL, '2026-05-22 13:20:23'),
(5,  1, 'Administrator', 'updated',  'Category', 13, 'Computers',         'Category updated: Computers',                   NULL, '2026-05-22 13:21:12'),
(6,  1, 'Administrator', 'updated',  'Category', 16, 'Cabling and Accessories','Category updated: Cabling and Accessories', NULL, '2026-05-22 13:21:34'),
(7,  1, 'Administrator', 'created',  'Category', 20, 'Other Assets',      'Category created: Other Assets',                NULL, '2026-05-22 13:22:21'),
(8,  1, 'Administrator', 'reported', 'Asset',    27, 'RJ45',              'Damage reported: yes',                          NULL, '2026-05-22 13:23:10'),
(9,  1, 'Administrator', 'updated',  'Asset',    18, 'The Best Headset',  'Asset updated: The Best Headset',               NULL, '2026-05-22 14:33:25'),
(10, 1, 'Administrator', 'updated',  'Asset',    18, 'The Best Headset',  'Asset updated: The Best Headset',               NULL, '2026-05-22 14:33:44'),
(11, 1, 'Administrator', 'reported', 'Asset',    17, 'The Best Headset',  'Damage reported: sfad',                         NULL, '2026-05-22 14:34:48'),
(12, 1, 'Administrator', 'disposed', 'Asset',    17, 'The Best Headset',  'Asset disposed: ',                              NULL, '2026-05-22 16:20:45'),
(13, 1, 'Administrator', 'reported', 'Asset',    16, 'The Best Headset',  'Damage reported: not working',                  NULL, '2026-05-22 16:40:15'),
(14, 1, 'Administrator', 'disposed', 'Asset',    16, 'The Best Headset',  'Asset disposed: ',                              NULL, '2026-05-22 16:40:35'),
(15, 1, 'Administrator', 'reported', 'Asset',    18, 'The Best Headset',  'Damage reported: sxqsx',                        NULL, '2026-05-22 16:50:04'),
(16, 1, 'Administrator', 'assigned', 'Asset',    3,  'Logitech M100R',    'Assigned to Zen Kyuti by Administrator',        NULL, '2026-05-25 09:12:45'),
(17, 1, 'Administrator', 'reported', 'Asset',    9,  'Asus Monitor',      'Damage reported: [Disposed] oo',                NULL, '2026-05-26 09:44:52'),
(18, 1, 'Administrator', 'disposed', 'Asset',    9,  'Asus Monitor',      'Asset disposed: ',                              NULL, '2026-05-26 09:44:52'),
(19, 1, 'Administrator', 'reported', 'Asset',    5,  'Laptop',            'Damage reported: [Damaged] oo',                 NULL, '2026-05-26 09:47:47'),
(20, 1, 'Administrator', 'reported', 'Asset',    3,  'Logitech M100R',    'Damage reported: [Disposed] oko',               NULL, '2026-05-26 09:49:39'),
(21, 1, 'Administrator', 'returned', 'Asset',    3,  'Logitech M100R',    'Returned by Zen Kyuti',                         NULL, '2026-05-26 09:49:39'),
(22, 1, 'Administrator', 'deleted',  'Asset',    3,  'Logitech M100R',    'Asset deleted: Logitech M100R',                 NULL, '2026-05-26 09:49:40'),
(23, 1, 'Administrator', 'reported', 'Asset',    4,  'Logitech M100R',    'Damage reported: [For Donation] ok',            NULL, '2026-05-26 09:49:59'),
(24, 1, 'Administrator', 'returned', 'Asset',    4,  'Logitech M100R',    'Returned by Zen Kyuti',                         NULL, '2026-05-26 09:49:59'),
(25, 1, 'Administrator', 'deleted',  'Asset',    4,  'Logitech M100R',    'Asset deleted: Logitech M100R',                 NULL, '2026-05-26 09:49:59'),
(26, 1, 'Administrator', 'assigned', 'Asset',    14, 'HP Monitor',        'Assigned to Craig Dylan by Administrator',      NULL, '2026-05-26 09:56:41'),
(27, 1, 'Administrator', 'assigned', 'Asset',    19, 'The Best Headset',  'Assigned to Craig Dylan by Administrator',      NULL, '2026-05-26 09:57:00'),
(28, 1, 'Administrator', 'reported', 'Asset',    19, 'The Best Headset',  'Damage reported: [Disposed] koko',              NULL, '2026-05-26 09:57:23'),
(29, 1, 'Administrator', 'disposed', 'Asset',    19, 'The Best Headset',  'Asset disposed: koko',                          NULL, '2026-05-26 09:57:24'),
(30, 1, 'Administrator', 'assigned', 'Asset',    26, 'LAN Cable',         'Assigned to Craig Dylan by Administrator',      NULL, '2026-05-26 10:12:30'),
(31, 1, 'Administrator', 'reported', 'Asset',    26, 'LAN Cable',         'Damage reported: [Disposed] plopop',            NULL, '2026-05-26 10:12:48'),
(32, 1, 'Administrator', 'disposed', 'Asset',    26, 'LAN Cable',         'Asset disposed: plopop',                        NULL, '2026-05-26 10:12:48'),
(33, 1, 'Administrator', 'reported', 'Asset',    14, 'HP Monitor',        'Damage reported: [Disposed] asdasd',            NULL, '2026-05-26 10:19:11'),
(34, 1, 'Administrator', 'disposed', 'Asset',    14, 'HP Monitor',        'Asset disposed: asdasd',                        NULL, '2026-05-26 10:19:12'),
(35, 1, 'Administrator', 'returned', 'Asset',    5,  'Laptop',            'Returned by Craig Dylan',                       NULL, '2026-05-26 10:29:13'),
(36, 1, 'Administrator', 'assigned', 'Asset',    20, 'The Best Headset',  'Assigned to Maria Clara by Administrator',      NULL, '2026-05-26 10:29:55'),
(37, 1, 'Administrator', 'assigned', 'Asset',    8,  'Monitor',           'Assigned to Maria Clara by Administrator',      NULL, '2026-05-26 10:30:22'),
(38, 1, 'Administrator', 'assigned', 'Asset',    27, 'RJ45',              'Assigned to Maria Clara by Administrator',      NULL, '2026-05-26 10:30:31'),
(39, 1, 'Administrator', 'reported', 'Asset',    27, 'RJ45',              'Damage reported: [Damaged] asd',                NULL, '2026-05-26 10:30:42'),
(40, 1, 'Administrator', 'reported', 'Asset',    8,  'Monitor',           'Damage reported: [Disposed] asdasd',            NULL, '2026-05-26 10:30:57'),
(41, 1, 'Administrator', 'disposed', 'Asset',    8,  'Monitor',           'Asset disposed: asdasd',                        NULL, '2026-05-26 10:30:57'),
(42, 1, 'Administrator', 'reported', 'Asset',    20, 'The Best Headset',  'Damage reported: [Disposed] asdasd',            NULL, '2026-05-26 10:31:30'),
(43, 1, 'Administrator', 'disposed', 'Asset',    20, 'The Best Headset',  'Asset disposed: asdasd',                        NULL, '2026-05-26 10:31:30'),
(44, 1, 'Administrator', 'assigned', 'Asset',    21, 'The Best Headset',  'Assigned to Maria Clara by Administrator',      NULL, '2026-05-26 10:32:04'),
(45, 1, 'Administrator', 'reported', 'Asset',    21, 'The Best Headset',  'Damage reported: [For Donation] asdasd',        NULL, '2026-05-26 10:32:11'),
(46, 1, 'Administrator', 'updated',  'Asset',    21, 'The Best Headset',  'Asset donated to: Reported via Assignees',      NULL, '2026-05-26 10:32:11'),
(47, 1, 'Administrator', 'updated',  'Asset',    27, 'RJ45',              'Damage resolved',                               NULL, '2026-05-26 12:22:47'),
(48, 1, 'Administrator', 'updated',  'Asset',    27, 'RJ45',              'Damage resolved',                               NULL, '2026-05-26 12:23:52'),
(49, 1, 'Administrator', 'returned', 'Asset',    27, 'RJ45',              'Returned by Maria Clara',                       NULL, '2026-05-29 10:15:50'),
(50, 1, 'Administrator', 'assigned', 'Asset',    27, 'RJ45',              'Assigned to Rven by Administrator',             NULL, '2026-05-29 10:18:40'),
(51, 1, 'Administrator', 'updated',  'Asset',    22, 'The Best Headset',  'Asset updated: The Best Headset',               NULL, '2026-05-29 10:22:23'),
(52, 1, 'Administrator', 'updated',  'Category', 14, 'Devices',           'Category updated: Devices',                     NULL, '2026-06-01 08:29:46'),
(53, 1, 'Administrator', 'updated',  'Category', 10, 'Peripherals',       'Category updated: Peripherals',                 NULL, '2026-06-01 08:32:10'),
(54, 1, 'Administrator', 'created',  'Category', 21, 'Headsets',          'Category created: Headsets',                    NULL, '2026-06-01 08:32:59'),
(55, 1, 'Administrator', 'created',  'Category', 22, 'UPS',               'Category created: UPS',                         NULL, '2026-06-01 08:34:06');

SET FOREIGN_KEY_CHECKS = 1;

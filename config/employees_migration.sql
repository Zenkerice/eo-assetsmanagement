-- ============================================================
-- Employees table migration
-- Run once against inventory_db
-- ============================================================

USE `inventory_db`;

CREATE TABLE IF NOT EXISTS `employees` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(150) NOT NULL,
  `station`     VARCHAR(150) NOT NULL DEFAULT '',
  `seat_number` VARCHAR(50)  NOT NULL DEFAULT '',
  `location_id` INT(11)      DEFAULT NULL,
  `created_at`  DATETIME     NOT NULL DEFAULT current_timestamp(),
  `updated_at`  DATETIME     NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_station`     (`station`),
  KEY `idx_seat_number` (`seat_number`),
  KEY `idx_location_id` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- If the table already exists, add location_id column:
ALTER TABLE `employees`
  ADD COLUMN IF NOT EXISTS `location_id` INT(11) DEFAULT NULL,
  ADD KEY IF NOT EXISTS `idx_location_id` (`location_id`);

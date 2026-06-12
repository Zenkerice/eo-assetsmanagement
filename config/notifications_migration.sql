-- In-app notifications table
-- Run once in phpMyAdmin

CREATE TABLE IF NOT EXISTS `notifications` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT,
  `for_role`    ENUM('admin','staff','all') NOT NULL DEFAULT 'admin',
  `for_user_id` INT(11)       DEFAULT NULL,  -- NULL = broadcast to role
  `type`        ENUM('approval_submitted','approval_approved','approval_rejected') NOT NULL,
  `title`       VARCHAR(255)  NOT NULL,
  `body`        TEXT          DEFAULT NULL,
  `link`        VARCHAR(255)  DEFAULT NULL,
  `is_read`     TINYINT(1)    NOT NULL DEFAULT 0,
  `meta`        JSON          DEFAULT NULL,
  `created_at`  DATETIME      DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_for_role`    (`for_role`),
  KEY `idx_for_user_id` (`for_user_id`),
  KEY `idx_is_read`     (`is_read`),
  KEY `idx_created_at`  (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

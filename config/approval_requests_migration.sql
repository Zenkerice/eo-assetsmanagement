-- Approval workflow for staff-initiated actions
-- Run once in phpMyAdmin

ALTER TABLE `audit_logs`
  MODIFY COLUMN `action`
    ENUM('created','updated','deleted','assigned','returned',
         'imported','received','disposed','reported',
         'approved','rejected','pending')
    NOT NULL;

CREATE TABLE IF NOT EXISTS `approval_requests` (
  `id`            INT(11)       NOT NULL AUTO_INCREMENT,
  `requested_by`  VARCHAR(150)  NOT NULL,
  `user_id`       INT(11)       DEFAULT NULL,
  `action_type`   ENUM('create','update','delete') NOT NULL,
  `resource_type` VARCHAR(50)   NOT NULL,
  `resource_id`   INT(11)       DEFAULT NULL,
  `resource_name` VARCHAR(255)  DEFAULT NULL,
  `payload`       JSON          DEFAULT NULL,
  `notes`         TEXT          DEFAULT NULL,
  `status`        ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `reviewed_by`   VARCHAR(150)  DEFAULT NULL,
  `review_notes`  TEXT          DEFAULT NULL,
  `reviewed_at`   DATETIME      DEFAULT NULL,
  `created_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status`        (`status`),
  KEY `idx_resource_type` (`resource_type`),
  KEY `idx_requested_by`  (`requested_by`),
  KEY `idx_created_at`    (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

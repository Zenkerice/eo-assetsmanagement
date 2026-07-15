-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2026 at 09:54 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventory_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `approval_requests`
--

CREATE TABLE `approval_requests` (
  `id` int(11) NOT NULL,
  `requested_by` varchar(150) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action_type` enum('create','update','delete') NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_name` varchar(255) DEFAULT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `notes` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','forwarded','confirmed') NOT NULL DEFAULT 'pending',
  `reviewed_by` varchar(150) DEFAULT NULL,
  `review_notes` text DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `approval_requests`
--

INSERT INTO `approval_requests` (`id`, `requested_by`, `user_id`, `action_type`, `resource_type`, `resource_id`, `resource_name`, `payload`, `notes`, `status`, `reviewed_by`, `review_notes`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 'Zen', 2, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260713-XENJ\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS13\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ11\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Laptop\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 13 \\/ 2026\"}', NULL, 'approved', 'Zen', 'Confirmed by requestor', '2026-07-13 17:42:40', '2026-07-13 17:16:29', '2026-07-13 17:42:40'),
(2, 'Zen', 2, 'delete', 'Assignment', 2, 'Inplay Keboard · return by Zen', '{\"return_id\":\"RET-20260713-WYEE\",\"assignment_id\":\"2\",\"product_id\":16,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-13 17:43:29', '2026-07-13 17:42:52', '2026-07-13 17:43:29'),
(3, 'Zen', 2, 'delete', 'Assignment', 1, 'Apple MacBook Neo · return by Zen', '{\"return_id\":\"RET-20260713-85SN\",\"assignment_id\":\"1\",\"product_id\":1,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-13 17:43:24', '2026-07-13 17:42:56', '2026-07-13 17:43:24'),
(4, 'Zen', 2, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260713-GCRW\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ12\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 13 \\/ 2026\"}', NULL, 'approved', 'Zen', 'Confirmed by requestor', '2026-07-13 17:51:21', '2026-07-13 17:43:52', '2026-07-13 17:51:21'),
(5, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260714-AJER\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\"}],\"description\":\"\"}', NULL, 'rejected', 'Administrator', '', '2026-07-14 09:35:44', '2026-07-14 09:23:46', '2026-07-14 09:35:44'),
(6, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260714-9KM6\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\"},{\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\"}],\"description\":\"\"}', NULL, 'rejected', 'Administrator', '', '2026-07-14 09:37:33', '2026-07-14 09:36:52', '2026-07-14 09:37:33'),
(7, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260714-3Y16\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 14 \\/ 2026\"}', NULL, 'approved', 'Raven Ompar', 'Confirmed by requestor', '2026-07-14 10:22:10', '2026-07-14 09:40:46', '2026-07-14 10:22:10'),
(8, 'Raven Ompar', 5, 'delete', 'Assignment', 5, 'Secure UPS · return by Raven Ompar', '{\"return_id\":\"RET-20260714-RPT0\",\"assignment_id\":\"5\",\"product_id\":13,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-14 10:23:15', '2026-07-14 10:22:53', '2026-07-14 10:23:15'),
(9, 'Raven Ompar', 5, 'delete', 'Assignment', 6, 'Secure UPS · return by Raven Ompar', '{\"return_id\":\"RET-20260714-9L6T\",\"assignment_id\":\"6\",\"product_id\":14,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-14 10:23:13', '2026-07-14 10:22:56', '2026-07-14 10:23:13'),
(10, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260714-B3IC\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"category_name\":\"Laptop\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 14 \\/ 2026\"}', NULL, '', 'Raven Ompar', 'Assets confirmed by requestor — awaiting serial release', '2026-07-14 11:32:32', '2026-07-14 10:27:51', '2026-07-14 11:32:32'),
(11, 'Zen', 2, 'delete', 'Assignment', 4, 'Secure UPS · return by Zen', '{\"return_id\":\"RET-20260714-YV5P\",\"assignment_id\":\"4\",\"product_id\":12,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-14 13:15:08', '2026-07-14 13:14:49', '2026-07-14 13:15:08'),
(12, 'Zen', 2, 'delete', 'Assignment', 3, 'Secure UPS · return by Zen', '{\"return_id\":\"RET-20260714-5ALV\",\"assignment_id\":\"3\",\"product_id\":11,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-14 13:15:06', '2026-07-14 13:14:52', '2026-07-14 13:15:06'),
(13, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260714-7BK8\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC1\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ11\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS13\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS13\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 14 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-14 21:44:59', '2026-07-14 13:16:15', '2026-07-14 21:44:59'),
(14, 'Zen', 2, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260714-HLDY\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC1\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ11\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS13\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 14 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-14 21:44:15', '2026-07-14 21:26:56', '2026-07-14 21:44:15'),
(15, 'Zen', 2, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260714-6U21\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC2\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ12\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS14\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 14 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-14 21:48:27', '2026-07-14 21:45:56', '2026-07-14 21:48:27'),
(16, 'Zen', 2, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260715-IYLV\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ13\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS15\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-15 09:21:27', '2026-07-15 09:20:01', '2026-07-15 09:21:27'),
(17, 'Zen', 2, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260715-N8B8\",\"requestor_name\":\"Zen\",\"requestor_id\":\"asdgasc7a8sczen\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"category_name\":\"Laptop\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Zen\",\"admin_empid\":\"asdgasc7a8sczen\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'forwarded', 'Administrator', '', '2026-07-15 13:25:35', '2026-07-15 13:21:29', '2026-07-15 13:25:35'),
(18, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Inplay IP', '{\"request_id\":\"REQ-20260715-LLVK\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS16\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-15 13:49:55', '2026-07-15 13:45:47', '2026-07-15 13:49:55'),
(19, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260715-YS0J\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\"},{\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\"}],\"description\":\"\"}', NULL, 'rejected', 'Administrator', 'not available', '2026-07-15 13:55:51', '2026-07-15 13:54:16', '2026-07-15 13:55:51'),
(20, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260715-F28B\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC4\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC3\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'approved', 'Administrator', '', '2026-07-15 14:06:29', '2026-07-15 14:02:40', '2026-07-15 14:06:29'),
(21, 'Raven Ompar', 5, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260715-2VNN\",\"requestor_name\":\"Raven Ompar\",\"requestor_id\":\"RA2004\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"Laptop\",\"brand\":\"Apple MacBook Neo\",\"model\":\"\",\"category_name\":\"Laptop\",\"tag\":\"MC6\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ14\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"is this available?\",\"admin_assignee\":\"Raven Ompar\",\"admin_empid\":\"RA2004\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', 'is this available?', 'approved', 'Administrator', '', '2026-07-15 14:21:42', '2026-07-15 14:15:36', '2026-07-15 14:21:42'),
(22, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260715-9QNP\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Guy Daniel Palay\",\"admin_empid\":\"GUY123\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'forwarded', 'Administrator', 'yes', '2026-07-15 14:26:09', '2026-07-15 14:25:15', '2026-07-15 14:26:09'),
(23, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Inplay IP', '{\"request_id\":\"REQ-20260715-OHH9\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"assets\":[{\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\"},{\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\"}],\"description\":\"\"}', NULL, 'pending', NULL, NULL, NULL, '2026-07-15 14:31:06', '2026-07-15 14:31:06'),
(24, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260715-29UE\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"is this available?\",\"admin_assignee\":\"Guy Daniel Palay\",\"admin_empid\":\"GUY123\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', 'is this available?', 'confirmed', 'Guy Daniel Palay', 'Assets confirmed by requestor — awaiting serial release', '2026-07-15 14:47:21', '2026-07-15 14:32:51', '2026-07-15 14:47:21'),
(25, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Secure XPS 15', '{\"request_id\":\"REQ-20260715-TTFQ\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"22\",\"category_name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure\",\"model\":\"XPS 15\",\"category_name\":\"UPS\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"category_name\":\"Keyboards\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"is this available?\",\"admin_assignee\":\"Guy Daniel Palay\",\"admin_empid\":\"GUY123\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', 'is this available?', 'confirmed', 'Guy Daniel Palay', 'Assets confirmed by requestor — awaiting serial release', '2026-07-15 14:43:39', '2026-07-15 14:37:10', '2026-07-15 14:43:39'),
(26, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Inplay IP', '{\"request_id\":\"REQ-20260715-DM9R\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"\",\"requestor_location_id\":null,\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\",\"assets\":[{\"rowIndex\":0,\"originalType\":\"Laptop\",\"name\":\"UPS\",\"brand\":\"Secure XPS 15\",\"model\":\"\",\"category_name\":\"UPS\",\"tag\":\"KAKSDJ15\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":1,\"originalType\":\"Mobile Device\",\"name\":\"Mobile Device\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Mobile Device\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":2,\"originalType\":\"Keyboard\",\"name\":\"Keyboards\",\"brand\":\"Inplay IP\",\"model\":\"\",\"category_name\":\"Keyboards\",\"tag\":\"HAJS17\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":3,\"originalType\":\"Other Equipment\",\"name\":\"Other Equipment\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Other Equipment\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":4,\"originalType\":\"ID & Lanyard\",\"name\":\"ID & Lanyard\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"ID & Lanyard\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"rowIndex\":5,\"originalType\":\"Access Badge\\/RFID\",\"name\":\"Access Badge\\/RFID\",\"brand\":\"\",\"model\":\"\",\"category_name\":\"Access Badge\\/RFID\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}],\"description\":\"\",\"admin_assignee\":\"Guy Daniel Palay\",\"admin_empid\":\"GUY123\",\"admin_location\":\"\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', NULL, 'approved', 'Administrator', 'all goods', '2026-07-15 14:53:55', '2026-07-15 14:51:56', '2026-07-15 14:53:55'),
(27, 'Guy Daniel Palay', 6, 'create', 'Asset', NULL, 'Apple MacBook Neo', '{\"request_id\":\"REQ-20260715-G9ZP\",\"requestor_name\":\"Guy Daniel Palay\",\"requestor_id\":\"GUY123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":23,\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\",\"assets\":[{\"category_id\":\"23\",\"category_name\":\"Laptop\",\"brand\":\"Apple\",\"model\":\"MacBook Neo\"},{\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"Inplay\",\"model\":\"IP\"}],\"description\":\"heelop\",\"admin_assignee\":\"Guy Daniel Palay\",\"admin_empid\":\"GUY123\",\"admin_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"admin_dept\":\"\",\"admin_date\":\"07 \\/ 15 \\/ 2026\"}', 'heelop', 'pending', NULL, NULL, NULL, '2026-07-15 15:10:29', '2026-07-15 15:18:35');

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` int(11) NOT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`id`, `product_id`, `assignee_name`, `assigned_by`, `assigned_at`, `due_back`, `returned_at`, `notes`, `location_id`, `status`, `created_at`, `updated_at`) VALUES
(7, 1, 'Zen', 'Zen', '2026-07-14 15:44:15', NULL, '2026-07-14 21:44:59', NULL, 1, 'returned', '2026-07-14 21:44:15', '2026-07-14 21:44:59'),
(8, 11, 'Zen', 'Zen', '2026-07-14 15:44:15', NULL, '2026-07-14 21:44:59', NULL, 1, 'returned', '2026-07-14 21:44:15', '2026-07-14 21:44:59'),
(9, 16, 'Zen', 'Zen', '2026-07-14 15:44:15', NULL, '2026-07-14 21:44:59', NULL, 2, 'returned', '2026-07-14 21:44:15', '2026-07-14 21:44:59'),
(10, 1, 'Raven Ompar', 'Raven Ompar', '2026-07-14 15:44:59', NULL, NULL, NULL, 1, 'active', '2026-07-14 21:44:59', '2026-07-14 21:44:59'),
(11, 11, 'Raven Ompar', 'Raven Ompar', '2026-07-14 15:44:59', NULL, NULL, NULL, 1, 'active', '2026-07-14 21:44:59', '2026-07-14 21:44:59'),
(12, 16, 'Raven Ompar', 'Raven Ompar', '2026-07-14 15:44:59', NULL, '2026-07-14 21:44:59', NULL, 2, 'returned', '2026-07-14 21:44:59', '2026-07-14 21:44:59'),
(13, 16, 'Raven Ompar', 'Raven Ompar', '2026-07-14 15:44:59', NULL, NULL, NULL, 2, 'active', '2026-07-14 21:44:59', '2026-07-14 21:44:59'),
(14, 2, 'Zen', 'Zen', '2026-07-14 15:48:27', NULL, NULL, NULL, 1, 'active', '2026-07-14 21:48:27', '2026-07-14 21:48:27'),
(15, 12, 'Zen', 'Zen', '2026-07-14 15:48:27', NULL, NULL, NULL, 1, 'active', '2026-07-14 21:48:27', '2026-07-14 21:48:27'),
(16, 17, 'Zen', 'Zen', '2026-07-14 15:48:27', NULL, NULL, NULL, 2, 'active', '2026-07-14 21:48:27', '2026-07-14 21:48:27'),
(17, 13, 'Zen', 'Zen', '2026-07-15 03:21:27', NULL, NULL, NULL, 1, 'active', '2026-07-15 09:21:27', '2026-07-15 09:21:27'),
(18, 18, 'Zen', 'Zen', '2026-07-15 03:21:27', NULL, NULL, NULL, 2, 'active', '2026-07-15 09:21:27', '2026-07-15 09:21:27'),
(19, 19, 'Raven Ompar', 'Raven Ompar', '2026-07-15 07:49:55', NULL, NULL, NULL, 2, 'active', '2026-07-15 13:49:55', '2026-07-15 13:49:55'),
(20, 4, 'Raven Ompar', 'Raven Ompar', '2026-07-15 08:06:29', NULL, NULL, NULL, 1, 'active', '2026-07-15 14:06:29', '2026-07-15 14:06:29'),
(21, 3, 'Raven Ompar', 'Raven Ompar', '2026-07-15 08:06:29', NULL, NULL, NULL, 1, 'active', '2026-07-15 14:06:29', '2026-07-15 14:06:29'),
(22, 6, 'Raven Ompar', 'Administrator', '2026-07-15 08:21:42', NULL, NULL, 'is this available?', 2, 'active', '2026-07-15 14:21:42', '2026-07-15 14:21:42'),
(23, 14, 'Raven Ompar', 'Administrator', '2026-07-15 08:21:42', NULL, NULL, 'is this available?', 2, 'active', '2026-07-15 14:21:42', '2026-07-15 14:21:42'),
(24, 15, 'Guy Daniel Palay', 'Guy Daniel Palay', '2026-07-15 08:53:54', NULL, NULL, NULL, 2, 'active', '2026-07-15 14:53:54', '2026-07-15 14:53:54'),
(25, 20, 'Guy Daniel Palay', 'Guy Daniel Palay', '2026-07-15 08:53:55', NULL, NULL, NULL, 2, 'active', '2026-07-15 14:53:55', '2026-07-15 14:53:55');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(150) NOT NULL DEFAULT 'System',
  `action` enum('created','updated','deleted','assigned','returned','imported','received','disposed','reported','approved','rejected','pending') NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `entity_name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `entity_name`, `description`, `meta`, `created_at`) VALUES
(1, 1, 'Administrator', 'created', 'Asset', 1, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:56'),
(2, 1, 'Administrator', 'created', 'Asset', 2, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:56'),
(3, 1, 'Administrator', 'created', 'Asset', 3, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(4, 1, 'Administrator', 'created', 'Asset', 4, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(5, 1, 'Administrator', 'created', 'Asset', 5, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(6, 1, 'Administrator', 'created', 'Asset', 6, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(7, 1, 'Administrator', 'created', 'Asset', 7, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(8, 1, 'Administrator', 'created', 'Asset', 8, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(9, 1, 'Administrator', 'created', 'Asset', 9, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(10, 1, 'Administrator', 'created', 'Asset', 10, 'Apple MacBook Neo', 'Asset created: Apple MacBook Neo', NULL, '2026-07-13 17:06:57'),
(11, 1, 'Administrator', 'created', 'Asset', 11, 'Secure UPS', 'Asset created: Secure UPS', NULL, '2026-07-13 17:13:21'),
(12, 1, 'Administrator', 'created', 'Asset', 12, 'Secure UPS', 'Asset created: Secure UPS', NULL, '2026-07-13 17:13:21'),
(13, 1, 'Administrator', 'created', 'Asset', 13, 'Secure UPS', 'Asset created: Secure UPS', NULL, '2026-07-13 17:13:22'),
(14, 1, 'Administrator', 'created', 'Asset', 14, 'Secure UPS', 'Asset created: Secure UPS', NULL, '2026-07-13 17:13:22'),
(15, 1, 'Administrator', 'created', 'Asset', 15, 'Secure UPS', 'Asset created: Secure UPS', NULL, '2026-07-13 17:13:22'),
(16, 1, 'Administrator', 'created', 'Asset', 16, 'Inplay Keboard', 'Asset created: Inplay Keboard', NULL, '2026-07-13 17:13:22'),
(17, 1, 'Administrator', 'created', 'Asset', 17, 'Inplay Keboard', 'Asset created: Inplay Keboard', NULL, '2026-07-13 17:13:22'),
(18, 1, 'Administrator', 'created', 'Asset', 18, 'Inplay Keboard', 'Asset created: Inplay Keboard', NULL, '2026-07-13 17:13:22'),
(19, 1, 'Administrator', 'created', 'Asset', 19, 'Inplay Keboard', 'Asset created: Inplay Keboard', NULL, '2026-07-13 17:13:22'),
(20, 1, 'Administrator', 'created', 'Asset', 20, 'Inplay Keboard', 'Asset created: Inplay Keboard', NULL, '2026-07-13 17:13:22'),
(21, 2, 'Zen', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-13 17:16:29'),
(22, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-13 17:29:09'),
(23, 2, 'Zen', 'assigned', 'Asset', 16, 'Inplay Keboard', 'Assigned to Zen by Administrator', NULL, '2026-07-13 17:42:40'),
(24, 2, 'Zen', 'assigned', 'Asset', 11, 'Secure UPS', 'Assigned to Zen by Administrator', NULL, '2026-07-13 17:42:40'),
(25, 2, 'Zen', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Asset confirmed and assigned to Zen', NULL, '2026-07-13 17:42:40'),
(26, 2, 'Zen', 'pending', 'Assignment', 2, 'Inplay Keboard · return by Zen', 'Delete request submitted by Zen — awaiting approval', NULL, '2026-07-13 17:42:52'),
(27, 2, 'Zen', 'pending', 'Assignment', 1, 'Apple MacBook Neo · return by Zen', 'Delete request submitted by Zen — awaiting approval', NULL, '2026-07-13 17:42:56'),
(28, 1, 'Administrator', 'approved', 'Assignment', 1, 'Apple MacBook Neo · return by Zen', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-13 17:43:24'),
(29, 1, 'Administrator', 'approved', 'Assignment', 2, 'Inplay Keboard · return by Zen', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-13 17:43:29'),
(30, 2, 'Zen', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-13 17:43:52'),
(31, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-13 17:47:40'),
(32, 2, 'Zen', 'assigned', 'Asset', 12, 'Secure UPS', 'Assigned to Zen by Administrator', NULL, '2026-07-13 17:51:21'),
(33, 2, 'Zen', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Asset confirmed and assigned to Zen', NULL, '2026-07-13 17:51:21'),
(34, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 09:23:46'),
(35, 1, 'Administrator', 'rejected', 'Asset', NULL, 'Apple MacBook Neo', 'Rejected by Administrator: No reason given', NULL, '2026-07-14 09:35:44'),
(36, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 09:36:52'),
(37, 1, 'Administrator', 'rejected', 'Asset', NULL, 'Apple MacBook Neo', 'Rejected by Administrator: No reason given', NULL, '2026-07-14 09:37:33'),
(38, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 09:40:46'),
(39, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-14 10:21:35'),
(40, 5, 'Raven Ompar', 'assigned', 'Asset', 13, 'Secure UPS', 'Assigned to Raven Ompar by Administrator', NULL, '2026-07-14 10:22:10'),
(41, 5, 'Raven Ompar', 'assigned', 'Asset', 14, 'Secure UPS', 'Assigned to Raven Ompar by Administrator', NULL, '2026-07-14 10:22:10'),
(42, 5, 'Raven Ompar', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Asset confirmed and assigned to Raven Ompar', NULL, '2026-07-14 10:22:10'),
(43, 5, 'Raven Ompar', 'pending', 'Assignment', 5, 'Secure UPS · return by Raven Ompar', 'Delete request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 10:22:53'),
(44, 5, 'Raven Ompar', 'pending', 'Assignment', 6, 'Secure UPS · return by Raven Ompar', 'Delete request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 10:22:56'),
(45, 1, 'Administrator', 'approved', 'Assignment', 6, 'Secure UPS · return by Raven Ompar', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-14 10:23:13'),
(46, 1, 'Administrator', 'approved', 'Assignment', 5, 'Secure UPS · return by Raven Ompar', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-14 10:23:15'),
(47, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 10:27:51'),
(48, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-14 10:42:18'),
(49, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-14 11:32:32'),
(50, 2, 'Zen', 'pending', 'Assignment', 4, 'Secure UPS · return by Zen', 'Delete request submitted by Zen — awaiting approval', NULL, '2026-07-14 13:14:49'),
(51, 2, 'Zen', 'pending', 'Assignment', 3, 'Secure UPS · return by Zen', 'Delete request submitted by Zen — awaiting approval', NULL, '2026-07-14 13:14:52'),
(52, 1, 'Administrator', 'approved', 'Assignment', 3, 'Secure UPS · return by Zen', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-14 13:15:06'),
(53, 1, 'Administrator', 'approved', 'Assignment', 4, 'Secure UPS · return by Zen', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-14 13:15:08'),
(54, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-14 13:16:15'),
(55, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-14 13:20:47'),
(56, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-14 13:21:09'),
(57, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Re-forwarded with serial numbers by Administrator', NULL, '2026-07-14 13:49:23'),
(58, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-14 13:49:57'),
(59, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Re-forwarded with serial numbers by Administrator', NULL, '2026-07-14 14:11:59'),
(60, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-14 14:12:32'),
(61, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Re-forwarded with serial numbers by Administrator', NULL, '2026-07-14 20:21:28'),
(62, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Serial numbers updated and re-forwarded by Administrator', NULL, '2026-07-14 21:20:41'),
(63, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-14 21:25:11'),
(64, 2, 'Zen', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-14 21:26:56'),
(65, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-14 21:30:40'),
(66, 2, 'Zen', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Zen — pending admin serial release', NULL, '2026-07-14 21:31:09'),
(67, 1, 'Administrator', 'assigned', 'Asset', 1, 'Apple MacBook Neo', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:44:15'),
(68, 1, 'Administrator', 'assigned', 'Asset', 11, 'Secure UPS', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:44:15'),
(69, 1, 'Administrator', 'assigned', 'Asset', 16, 'Inplay Keboard', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:44:15'),
(70, 1, 'Administrator', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Serial released and asset deployed by Administrator', NULL, '2026-07-14 21:44:15'),
(71, 1, 'Administrator', 'assigned', 'Asset', 1, 'Apple MacBook Neo', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-14 21:44:59'),
(72, 1, 'Administrator', 'assigned', 'Asset', 11, 'Secure UPS', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-14 21:44:59'),
(73, 1, 'Administrator', 'assigned', 'Asset', 16, 'Inplay Keboard', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-14 21:44:59'),
(74, 1, 'Administrator', 'assigned', 'Asset', 16, 'Inplay Keboard', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-14 21:44:59'),
(75, 1, 'Administrator', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Serial released and asset deployed by Administrator', NULL, '2026-07-14 21:44:59'),
(76, 2, 'Zen', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-14 21:45:56'),
(77, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-14 21:46:22'),
(78, 2, 'Zen', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Zen — pending admin serial release', NULL, '2026-07-14 21:47:22'),
(79, 1, 'Administrator', 'assigned', 'Asset', 2, 'Apple MacBook Neo', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:48:27'),
(80, 1, 'Administrator', 'assigned', 'Asset', 12, 'Secure UPS', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:48:27'),
(81, 1, 'Administrator', 'assigned', 'Asset', 17, 'Inplay Keboard', 'Assigned to Zen by Zen', NULL, '2026-07-14 21:48:27'),
(82, 1, 'Administrator', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Serial released and asset deployed by Administrator', NULL, '2026-07-14 21:48:27'),
(83, 2, 'Zen', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-15 09:20:01'),
(84, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 09:20:36'),
(85, 2, 'Zen', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Zen — pending admin serial release', NULL, '2026-07-15 09:20:56'),
(86, 1, 'Administrator', 'assigned', 'Asset', 13, 'Secure UPS', 'Assigned to Zen by Zen', NULL, '2026-07-15 09:21:27'),
(87, 1, 'Administrator', 'assigned', 'Asset', 18, 'Inplay Keboard', 'Assigned to Zen by Zen', NULL, '2026-07-15 09:21:27'),
(88, 1, 'Administrator', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Serial released and asset deployed by Administrator', NULL, '2026-07-15 09:21:27'),
(89, 2, 'Zen', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-15 13:21:29'),
(90, 1, 'Administrator', 'updated', 'Asset', NULL, 'Apple MacBook Neo', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 13:25:35'),
(91, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Inplay IP', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-15 13:45:47'),
(92, 1, 'Administrator', 'updated', 'Asset', NULL, 'Inplay IP', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 13:46:41'),
(93, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Inplay IP', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-15 13:47:04'),
(94, 1, 'Administrator', 'assigned', 'Asset', 19, 'Inplay Keboard', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-15 13:49:55'),
(95, 1, 'Administrator', 'approved', 'Asset', NULL, 'Inplay IP', 'Serial released and asset deployed by Administrator', NULL, '2026-07-15 13:49:55'),
(96, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-15 13:54:16'),
(97, 1, 'Administrator', 'rejected', 'Asset', NULL, 'Apple MacBook Neo', 'Rejected by Administrator: not available', NULL, '2026-07-15 13:55:51'),
(98, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-15 14:02:40'),
(99, 1, 'Administrator', 'updated', 'Asset', NULL, 'Apple MacBook Neo', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:04:29'),
(100, 5, 'Raven Ompar', 'updated', 'Asset', NULL, 'Apple MacBook Neo', 'Assets confirmed by Raven Ompar — pending admin serial release', NULL, '2026-07-15 14:05:41'),
(101, 1, 'Administrator', 'assigned', 'Asset', 4, 'Apple MacBook Neo', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-15 14:06:29'),
(102, 1, 'Administrator', 'assigned', 'Asset', 3, 'Apple MacBook Neo', 'Assigned to Raven Ompar by Raven Ompar', NULL, '2026-07-15 14:06:29'),
(103, 1, 'Administrator', 'approved', 'Asset', NULL, 'Apple MacBook Neo', 'Serial released and asset deployed by Administrator', NULL, '2026-07-15 14:06:29'),
(104, 5, 'Raven Ompar', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-07-15 14:15:36'),
(105, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:16:25'),
(106, 1, 'Administrator', 'assigned', 'Asset', 6, 'Apple MacBook Neo', 'Assigned to Raven Ompar by Administrator', NULL, '2026-07-15 14:21:42'),
(107, 1, 'Administrator', 'assigned', 'Asset', 14, 'Secure UPS', 'Assigned to Raven Ompar by Administrator', NULL, '2026-07-15 14:21:42'),
(108, 1, 'Administrator', 'approved', 'Asset', NULL, 'Secure XPS 15', 'Assets released and deployed by Administrator', NULL, '2026-07-15 14:21:42'),
(109, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 14:25:15'),
(110, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:26:09'),
(111, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Inplay IP', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 14:31:06'),
(112, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 14:32:51'),
(113, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Secure XPS 15', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 14:37:10'),
(114, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:38:50'),
(115, 1, 'Administrator', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:42:54'),
(116, 6, 'Guy Daniel Palay', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Guy Daniel Palay — pending admin serial release', NULL, '2026-07-15 14:43:39'),
(117, 6, 'Guy Daniel Palay', 'updated', 'Asset', NULL, 'Secure XPS 15', 'Assets confirmed by Guy Daniel Palay — pending admin serial release', NULL, '2026-07-15 14:47:21'),
(118, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Inplay IP', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 14:51:56'),
(119, 1, 'Administrator', 'updated', 'Asset', NULL, 'Inplay IP', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 14:52:21'),
(120, 6, 'Guy Daniel Palay', 'updated', 'Asset', NULL, 'Inplay IP', 'Assets confirmed by Guy Daniel Palay — pending admin serial release', NULL, '2026-07-15 14:53:01'),
(121, 1, 'Administrator', 'assigned', 'Asset', 15, 'Secure UPS', 'Assigned to Guy Daniel Palay by Guy Daniel Palay', NULL, '2026-07-15 14:53:54'),
(122, 1, 'Administrator', 'assigned', 'Asset', 20, 'Inplay Keboard', 'Assigned to Guy Daniel Palay by Guy Daniel Palay', NULL, '2026-07-15 14:53:55'),
(123, 1, 'Administrator', 'approved', 'Asset', NULL, 'Inplay IP', 'Serial released and asset deployed by Administrator', NULL, '2026-07-15 14:53:55'),
(124, 6, 'Guy Daniel Palay', 'pending', 'Asset', NULL, 'Apple MacBook Neo', 'Create request submitted by Guy Daniel Palay — awaiting approval', NULL, '2026-07-15 15:10:29'),
(125, 1, 'Administrator', 'updated', 'Asset', NULL, 'Apple MacBook Neo', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 15:11:29'),
(126, 1, 'Administrator', 'updated', 'Asset', NULL, 'Apple MacBook Neo', 'Forwarded to requestor by Administrator', NULL, '2026-07-15 15:17:33');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `parent_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(10, NULL, 'Keyboards', 'Is an input device used to enter text, numbers, and commands into a computer or other electronic device.', '2026-05-12 15:24:08', '2026-06-01 08:32:09'),
(13, NULL, 'Monitors', 'A monitor is an output device that displays visual information such as text, images, and videos from a computer.', '2026-05-13 10:29:20', '2026-05-22 13:21:12'),
(14, NULL, 'Mouse', 'Is an input device used to control the cursor on a computer screen and perform actions such as clicking, selecting, and dragging items.', '2026-05-13 10:30:19', '2026-06-01 08:29:45'),
(15, NULL, 'System Units', 'A system unit is the main computer case that contains the essential internal components that process data and run programs.', '2026-05-13 10:31:23', '2026-05-22 13:20:23'),
(16, NULL, 'Parts and Accessories', 'e.g (Ethernet cables, HDMI/Display cables, Adapters, etc.)', '2026-05-13 10:34:15', '2026-05-22 13:21:34'),
(20, NULL, 'Other Equipment', 'Additional resources or items of value owned by a person or organization that are not classified under main asset categories.', '2026-05-22 13:22:21', '2026-07-02 08:46:40'),
(21, NULL, 'Headsets', 'Is an audio device that combines headphones and a microphone, allowing users to listen to sound and communicate hands-free.', '2026-06-01 08:32:59', '2026-06-01 08:32:59'),
(22, NULL, 'UPS', 'A UPS (Uninterruptible Power Supply) is a device that provides temporary backup power during power outages or voltage fluctuations.', '2026-06-01 08:34:06', '2026-06-01 08:34:06'),
(23, NULL, 'Laptop', 'Is a portable computer that combines a display, keyboard, touchpad, and internal components into a single device for work, study, and entertainment.', '2026-07-02 08:47:23', '2026-07-02 08:47:23'),
(24, NULL, 'Mobile Device', 'Is a portable electronic device, such as a smartphone or tablet, used for communication, internet access, and running various applications.', '2026-07-02 08:48:29', '2026-07-02 08:48:29'),
(25, NULL, 'ID & Lanyard', 'An ID and lanyard are identification accessories used to display and carry an identification card securely for easy recognition and access.', '2026-07-02 08:48:57', '2026-07-02 08:49:26'),
(26, NULL, 'Access Badge/RFID', 'An access badge or RFID card is a security credential used to authenticate users and grant authorized access to buildings, rooms, or systems through radio frequency identification technology.', '2026-07-02 08:50:09', '2026-07-02 08:50:09');

-- --------------------------------------------------------

--
-- Table structure for table `damages`
--

CREATE TABLE `damages` (
  `id` int(11) NOT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `employee_id` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(150) NOT NULL,
  `station` varchar(150) NOT NULL DEFAULT '',
  `seat_number` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `location_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `building` varchar(100) DEFAULT NULL,
  `floor` varchar(50) DEFAULT NULL,
  `room` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name`, `building`, `floor`, `room`, `created_at`, `updated_at`) VALUES
(1, 'Site 3 | San Carlos City, Dungganon Site', 'Dungganon', NULL, NULL, '2026-06-01 08:54:33', '2026-07-07 15:30:53'),
(2, 'Site 4 | San Carlos City, Pantalan Site', 'Pantalan', NULL, NULL, '2026-06-01 08:54:33', '2026-07-07 15:30:47');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `for_role` enum('admin','staff','all') NOT NULL DEFAULT 'admin',
  `for_user_id` int(11) DEFAULT NULL,
  `type` varchar(80) NOT NULL DEFAULT 'info',
  `title` varchar(255) NOT NULL,
  `body` text DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `for_role`, `for_user_id`, `type`, `title`, `body`, `link`, `is_read`, `meta`, `created_at`) VALUES
(2, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":1,\"decision\":\"forwarded\"}', '2026-07-13 17:29:09'),
(3, 'staff', 2, 'approval_approved', '✅ Asset assigned to you', 'You have confirmed receipt of \"Secure XPS 15\". It is now listed in your assets.', 'requests.html?tab=myassets', 0, '{\"approval_id\":1}', '2026-07-13 17:42:40'),
(7, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Apple MacBook Neo · return by Zen', 'requests.html', 0, '{\"approval_id\":3,\"decision\":\"approved\"}', '2026-07-13 17:43:24'),
(8, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Inplay Keboard · return by Zen', 'requests.html', 0, '{\"approval_id\":2,\"decision\":\"approved\"}', '2026-07-13 17:43:29'),
(10, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":4,\"decision\":\"forwarded\"}', '2026-07-13 17:47:40'),
(11, 'staff', 2, 'approval_approved', '✅ Asset assigned to you', 'You have confirmed receipt of \"Secure XPS 15\". It is now listed in your assets.', 'requests.html?tab=myassets', 1, '{\"approval_id\":4}', '2026-07-13 17:51:21'),
(33, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Secure UPS · return by Zen', 'requests.html', 0, '{\"approval_id\":12,\"decision\":\"approved\"}', '2026-07-14 13:15:06'),
(34, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Secure UPS · return by Zen', 'requests.html', 0, '{\"approval_id\":11,\"decision\":\"approved\"}', '2026-07-14 13:15:08'),
(50, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":14,\"decision\":\"forwarded\"}', '2026-07-14 21:30:40'),
(52, 'staff', 2, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Secure XPS 15\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":14}', '2026-07-14 21:31:09'),
(53, 'staff', 2, 'approval_approved', '✅ Asset assigned to you', '\"Secure XPS 15\" has been released by the admin and is now assigned to you.', 'requests.html?tab=myassets', 0, '{\"approval_id\":14}', '2026-07-14 21:44:15'),
(56, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":15,\"decision\":\"forwarded\"}', '2026-07-14 21:46:22'),
(58, 'staff', 2, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Secure XPS 15\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":15}', '2026-07-14 21:47:22'),
(59, 'staff', 2, 'approval_approved', '✅ Asset assigned to you', '\"Secure XPS 15\" has been released by the admin and is now assigned to you.', 'requests.html?tab=myassets', 1, '{\"approval_id\":15}', '2026-07-14 21:48:27'),
(61, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":16,\"decision\":\"forwarded\"}', '2026-07-15 09:20:36'),
(63, 'staff', 2, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Secure XPS 15\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":16}', '2026-07-15 09:20:56'),
(64, 'staff', 2, 'approval_approved', '✅ Asset assigned to you', '\"Secure XPS 15\" has been released by the admin and is now assigned to you.', 'requests.html?tab=myassets', 0, '{\"approval_id\":16}', '2026-07-15 09:21:27'),
(66, 'staff', 2, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Apple MacBook Neo\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":17,\"decision\":\"forwarded\"}', '2026-07-15 13:25:35'),
(80, 'staff', 5, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":21,\"decision\":\"forwarded\"}', '2026-07-15 14:16:25'),
(81, 'staff', 5, 'approval_approved', '✅ Asset assigned to you', '\"Secure XPS 15\" has been released by the admin and is now assigned to you.', 'requests.html?tab=myassets', 0, '{\"approval_id\":21}', '2026-07-15 14:21:42'),
(82, 'admin', NULL, 'submitted', 'New Account Pending Approval', 'Guy Daniel Palay (guy) registered as Viewer and is awaiting your approval.', 'users.html', 1, '{\"user_id\":6,\"action\":\"registration\"}', '2026-07-15 14:23:36'),
(83, 'staff', 6, 'approved', 'Account Approved!', 'Your account has been approved by an admin. You can now sign in.', NULL, 1, '{\"action\":\"account_approved\"}', '2026-07-15 14:24:23'),
(84, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Secure XPS 15', 'approvals.html', 1, '{\"approval_id\":22,\"action_type\":\"create\"}', '2026-07-15 14:25:15'),
(85, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":22,\"decision\":\"forwarded\"}', '2026-07-15 14:26:09'),
(86, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Inplay IP', 'approvals.html', 0, '{\"approval_id\":23,\"action_type\":\"create\"}', '2026-07-15 14:31:06'),
(87, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Secure XPS 15', 'approvals.html', 0, '{\"approval_id\":24,\"action_type\":\"create\"}', '2026-07-15 14:32:51'),
(88, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Secure XPS 15', 'approvals.html', 0, '{\"approval_id\":25,\"action_type\":\"create\"}', '2026-07-15 14:37:10'),
(89, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":25,\"decision\":\"forwarded\"}', '2026-07-15 14:38:50'),
(90, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Secure XPS 15\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":24,\"decision\":\"forwarded\"}', '2026-07-15 14:42:54'),
(91, 'admin', NULL, 'asset_confirmed', '✅ Assets confirmed — release serial', 'Guy Daniel Palay has confirmed the assets for \"Secure XPS 15\". Assets confirmed, you may now release serial.', 'approvals.html', 0, '{\"approval_id\":25,\"confirmed_by\":\"Guy Daniel Palay\"}', '2026-07-15 14:43:39'),
(92, 'staff', 6, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Secure XPS 15\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":25}', '2026-07-15 14:43:42'),
(93, 'admin', NULL, 'asset_confirmed', '✅ Assets confirmed — release serial', 'Guy Daniel Palay has confirmed the assets for \"Secure XPS 15\". Assets confirmed, you may now release serial.', 'approvals.html', 0, '{\"approval_id\":24,\"confirmed_by\":\"Guy Daniel Palay\"}', '2026-07-15 14:47:21'),
(94, 'staff', 6, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Secure XPS 15\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":24}', '2026-07-15 14:47:25'),
(95, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Inplay IP', 'approvals.html', 1, '{\"approval_id\":26,\"action_type\":\"create\"}', '2026-07-15 14:51:56'),
(96, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Inplay IP\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 0, '{\"approval_id\":26,\"decision\":\"forwarded\"}', '2026-07-15 14:52:21'),
(97, 'admin', NULL, 'asset_confirmed', '✅ Assets confirmed — release serial', 'Guy Daniel Palay has confirmed the assets for \"Inplay IP\". Assets confirmed, you may now release serial.', 'approvals.html', 1, '{\"approval_id\":26,\"confirmed_by\":\"Guy Daniel Palay\"}', '2026-07-15 14:53:01'),
(98, 'staff', 6, 'approval_forwarded', '⏳ Waiting for admin approval', 'Your confirmation for \"Inplay IP\" has been received. Waiting for the admin to release the serial number.', 'requests.html', 0, '{\"approval_id\":26}', '2026-07-15 14:53:05'),
(99, 'staff', 6, 'approval_approved', '✅ Asset assigned to you', '\"Inplay IP\" has been released by the admin and is now assigned to you.', 'requests.html?tab=myassets', 1, '{\"approval_id\":26}', '2026-07-15 14:53:55'),
(100, 'admin', NULL, 'approval_submitted', 'New approval request from Guy Daniel Palay', 'Create Asset: Apple MacBook Neo', 'approvals.html', 0, '{\"approval_id\":27,\"action_type\":\"create\"}', '2026-07-15 15:10:29'),
(101, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Apple MacBook Neo\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":27,\"decision\":\"forwarded\"}', '2026-07-15 15:11:29'),
(102, 'admin', NULL, 'asset_changed', '✏️ Asset request changes by Guy Daniel Palay', '\"Apple MacBook Neo\" — Guy Daniel Palay has updated their asset request details. Please review and re-approve.', 'approvals.html', 0, '{\"approval_id\":27,\"changed_by\":\"Guy Daniel Palay\"}', '2026-07-15 15:12:45'),
(103, 'staff', 6, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"Apple MacBook Neo\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":27,\"decision\":\"forwarded\"}', '2026-07-15 15:17:33'),
(104, 'admin', NULL, 'asset_changed', '✏️ Asset request changes by Guy Daniel Palay', '\"Apple MacBook Neo\" — Guy Daniel Palay has updated their asset request details. Please review and re-approve.', 'approvals.html', 0, '{\"approval_id\":27,\"changed_by\":\"Guy Daniel Palay\"}', '2026-07-15 15:18:35'),
(105, 'admin', NULL, 'submitted', 'New Account Pending Approval', 'Charles Godwin B. Dollente (chowk) registered as Manager and is awaiting your approval.', 'users.html', 1, '{\"user_id\":7,\"action\":\"registration\"}', '2026-07-15 15:26:11'),
(106, 'staff', 7, 'approved', 'Account Approved!', 'Your account has been approved by an admin. You can now sign in.', NULL, 0, '{\"action\":\"account_approved\"}', '2026-07-15 15:26:59');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `brand_model` varchar(150) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `assigned_employee` varchar(150) DEFAULT NULL,
  `assigned_employee_id` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier_name` varchar(150) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `deployed_date` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `asset_status` enum('available','assigned','checked_out','under_repair','damaged','spare','lost','disposed') NOT NULL DEFAULT 'available',
  `image_path` varchar(255) DEFAULT NULL,
  `serial_number` varchar(150) DEFAULT NULL,
  `po_id` int(11) DEFAULT NULL,
  `po_item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `brand_model`, `brand`, `model`, `assigned_employee`, `assigned_employee_id`, `description`, `category_id`, `supplier_id`, `supplier_name`, `purchase_date`, `deployed_date`, `location_id`, `quantity`, `asset_status`, `image_path`, `serial_number`, `po_id`, `po_item_id`, `created_at`, `updated_at`) VALUES
(1, 'Apple MacBook Neo', 'IMP-MRJ00KB0-GMGW6D', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-25', NULL, 1, 1, 'assigned', NULL, 'MC1', NULL, NULL, '2026-07-13 17:06:56', '2026-07-14 21:44:15'),
(2, 'Apple MacBook Neo', 'IMP-MRJ00KDF-XJ6RPX', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-26', NULL, 1, 1, 'assigned', NULL, 'MC2', NULL, NULL, '2026-07-13 17:06:56', '2026-07-14 21:48:27'),
(3, 'Apple MacBook Neo', 'IMP-MRJ00KFC-1C73K8', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-27', NULL, 1, 1, 'assigned', NULL, 'MC3', NULL, NULL, '2026-07-13 17:06:57', '2026-07-15 14:06:29'),
(4, 'Apple MacBook Neo', 'IMP-MRJ00KGW-YEO8MP', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-28', NULL, 1, 1, 'assigned', NULL, 'MC4', NULL, NULL, '2026-07-13 17:06:57', '2026-07-15 14:06:29'),
(5, 'Apple MacBook Neo', 'IMP-MRJ00KI8-6WYJV2', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-29', NULL, 1, 1, 'available', NULL, 'MC5', NULL, NULL, '2026-07-13 17:06:57', '2026-07-13 17:06:57'),
(6, 'Apple MacBook Neo', 'IMP-MRJ00KJV-2N5EIL', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-30', NULL, 2, 1, 'assigned', NULL, 'MC6', NULL, NULL, '2026-07-13 17:06:57', '2026-07-15 14:21:42'),
(7, 'Apple MacBook Neo', 'IMP-MRJ00KLW-GQCK06', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-03-31', NULL, 2, 1, 'available', NULL, 'MC7', NULL, NULL, '2026-07-13 17:06:57', '2026-07-13 17:06:57'),
(8, 'Apple MacBook Neo', 'IMP-MRJ00KNS-UCKWDB', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-04-01', NULL, 2, 1, 'available', NULL, 'MC8', NULL, NULL, '2026-07-13 17:06:57', '2026-07-13 17:06:57'),
(9, 'Apple MacBook Neo', 'IMP-MRJ00KPZ-FKM0WB', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-04-02', NULL, 2, 1, 'available', NULL, 'MC9', NULL, NULL, '2026-07-13 17:06:57', '2026-07-13 17:06:57'),
(10, 'Apple MacBook Neo', 'IMP-MRJ00KRG-7V0HK9', 'Apple MacBook Neo', 'Apple', 'MacBook Neo', '', '', 'Apple MacBook Neo', 23, 1, NULL, '2026-04-03', NULL, 2, 1, 'available', NULL, 'MC10', NULL, NULL, '2026-07-13 17:06:57', '2026-07-13 17:06:57'),
(11, 'Secure UPS', 'IMP-MRJ08T9V-2BUCQM', 'Secure XPS 15', 'Secure', 'XPS 15', '', '', 'Secure UPS', 22, 1, NULL, '2025-03-16', NULL, 1, 1, 'assigned', NULL, 'KAKSDJ11', NULL, NULL, '2026-07-13 17:13:21', '2026-07-14 21:44:15'),
(12, 'Secure UPS', 'IMP-MRJ08TDH-H38X7B', 'Secure XPS 15', 'Secure', 'XPS 15', '', '', 'Secure UPS', 22, 1, NULL, '2025-03-17', NULL, 1, 1, 'assigned', NULL, 'KAKSDJ12', NULL, NULL, '2026-07-13 17:13:21', '2026-07-14 21:48:27'),
(13, 'Secure UPS', 'IMP-MRJ08TG1-3UKN0N', 'Secure XPS 15', 'Secure', 'XPS 15', '', '', 'Secure UPS', 22, 1, NULL, '2025-03-18', NULL, 1, 1, 'assigned', NULL, 'KAKSDJ13', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 09:21:27'),
(14, 'Secure UPS', 'IMP-MRJ08TJ9-NK6Z5W', 'Secure XPS 15', 'Secure', 'XPS 15', '', '', 'Secure UPS', 22, 1, NULL, '2025-03-19', NULL, 2, 1, 'assigned', NULL, 'KAKSDJ14', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 14:21:42'),
(15, 'Secure UPS', 'IMP-MRJ08TLT-ZBPM4T', 'Secure XPS 15', 'Secure', 'XPS 15', '', '', 'Secure UPS', 22, 1, NULL, '2025-03-20', NULL, 2, 1, 'assigned', NULL, 'KAKSDJ15', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 14:53:54'),
(16, 'Inplay Keboard', 'IMP-MRJ08TNX-33VARV', 'Inplay IP', 'Inplay', 'IP', '', '', 'Inplay Keboard', 10, 1, NULL, '2025-03-21', NULL, 2, 1, 'assigned', NULL, 'HAJS13', NULL, NULL, '2026-07-13 17:13:22', '2026-07-14 21:44:15'),
(17, 'Inplay Keboard', 'IMP-MRJ08TQ7-BWUZFL', 'Inplay IP', 'Inplay', 'IP', '', '', 'Inplay Keboard', 10, 1, NULL, '2025-03-22', NULL, 2, 1, 'assigned', NULL, 'HAJS14', NULL, NULL, '2026-07-13 17:13:22', '2026-07-14 21:48:27'),
(18, 'Inplay Keboard', 'IMP-MRJ08TSW-6UKUD8', 'Inplay IP', 'Inplay', 'IP', '', '', 'Inplay Keboard', 10, 1, NULL, '2025-03-23', NULL, 2, 1, 'assigned', NULL, 'HAJS15', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 09:21:27'),
(19, 'Inplay Keboard', 'IMP-MRJ08TVJ-L8THDX', 'Inplay IP', 'Inplay', 'IP', '', '', 'Inplay Keboard', 10, 1, NULL, '2025-03-24', NULL, 2, 1, 'assigned', NULL, 'HAJS16', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 13:49:55'),
(20, 'Inplay Keboard', 'IMP-MRJ08TXK-LU8IUL', 'Inplay IP', 'Inplay', 'IP', '', '', 'Inplay Keboard', 10, 1, NULL, '2025-03-25', NULL, 2, 1, 'assigned', NULL, 'HAJS17', NULL, NULL, '2026-07-13 17:13:22', '2026-07-15 14:53:55');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` int(11) NOT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL,
  `po_id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `brand` varchar(200) DEFAULT NULL,
  `model` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `recurring_requests`
--

CREATE TABLE `recurring_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `station` varchar(150) NOT NULL DEFAULT '',
  `priority` varchar(20) NOT NULL DEFAULT 'normal',
  `cadence` varchar(50) NOT NULL,
  `reason` text DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `next_run` datetime DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_name` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_name`, `email`, `phone`, `address`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Eo', 'zen', 'zen@gmail.com', '09986789', 'dsasda', 'active', '2026-07-10 18:58:29', '2026-07-10 18:58:29');

-- --------------------------------------------------------

--
-- Table structure for table `team_structure`
--

CREATE TABLE `team_structure` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `type` enum('IN','OUT') NOT NULL,
  `quantity` int(11) NOT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `username` varchar(60) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','manager','staff','viewer') NOT NULL DEFAULT 'staff',
  `status` enum('pending','active','rejected','suspended') NOT NULL DEFAULT 'active',
  `position` varchar(100) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `employee_id`, `username`, `password`, `role`, `status`, `position`, `email`, `contact_number`, `created_at`) VALUES
(1, 'Administrator', NULL, 'admin', '$2y$12$FdA5C5NYevN7TSiifC33PuO3tJlBRzEgp66xinQyBOiizYvCtBBo6', 'admin', 'active', NULL, 'zenangelopalay90@gmail.com', NULL, '2026-05-12 22:52:48'),
(2, 'Zen', 'asdgasc7a8sczen', 'zen', '$2y$12$7Tw3S.JVmFtQzzmlVu9sXOjukjyvy9DydZbSf1clZATBF6OVIIwLC', 'viewer', 'active', 'Team Leader', 'zen@mail.com', '098788909876', '2026-07-10 11:01:43'),
(5, 'Raven Ompar', 'RA2004', 'raven', '$2y$12$sTm7SecOlKp4Os7MsWW4ru9Vm4vSUe8fkI1vnWIGV3xzo1n2pJmNS', 'viewer', 'active', 'Team Leader', 'carletsrapmo@gmail.com', '09631719419', '2026-07-14 01:20:12'),
(6, 'Guy Daniel Palay', 'GUY123', 'guy', '$2y$12$fEBrjcg920TEkEJOjBKs4uC2T5q2NKTa16xzMFkJDljNRqDTR72Yy', 'viewer', 'active', 'Team Leader', 'ompar@csr-scc.edu.ph', '09456789321', '2026-07-15 06:23:36'),
(7, 'Charles Godwin B. Dollente', 'CHOWK1234', 'chowk', '$2y$12$3E28MF4n.nypGo6SlwaZmekhoYfwSk/Fwja5DltUYyUNAOAfszQLm', 'manager', 'active', 'Account Manager', 'ventuss2004@gmail.com', '09876545678', '2026-07-15 07:26:11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approval_requests`
--
ALTER TABLE `approval_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_resource_type` (`resource_type`),
  ADD KEY `idx_requested_by` (`requested_by`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_due_back` (`due_back`),
  ADD KEY `fk_assign_location` (`location_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_entity` (`entity_type`),
  ADD KEY `idx_created` (`created_at`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `damages`
--
ALTER TABLE `damages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `fk_damage_location` (`location_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_station` (`station`),
  ADD KEY `idx_seat_number` (`seat_number`),
  ADD KEY `idx_location_id` (`location_id`),
  ADD KEY `idx_employee_id` (`employee_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_for_role` (`for_role`),
  ADD KEY `idx_for_user_id` (`for_user_id`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `fk_product_location` (`location_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `po_number` (`po_number`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `fk_po_location` (`location_id`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `po_id` (`po_id`);

--
-- Indexes for table `recurring_requests`
--
ALTER TABLE `recurring_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_next_run` (`next_run`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `team_structure`
--
ALTER TABLE `team_structure`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_emp` (`user_id`,`employee_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_employee_id` (`employee_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approval_requests`
--
ALTER TABLE `approval_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `damages`
--
ALTER TABLE `damages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recurring_requests`
--
ALTER TABLE `recurring_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `team_structure`
--
ALTER TABLE `team_structure`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

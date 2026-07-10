-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 10, 2026 at 04:34 AM
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
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
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
(1, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'Inplay Headset → Saratos', '{\"product_id\":\"79\",\"assignee_name\":\"Saratos\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-06-05\",\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Saratos (WEBY)', 'approved', 'Administrator', '', '2026-06-05 13:49:15', '2026-06-05 13:48:24', '2026-06-05 13:49:15'),
(2, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Carl P.', '{\"product_id\":\"83\",\"assignee_name\":\"Carl P.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Carl P. (JTV)', 'approved', 'Administrator', '', '2026-06-05 14:46:19', '2026-06-05 14:45:10', '2026-06-05 14:46:19'),
(3, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Carl P.', '{\"product_id\":\"86\",\"assignee_name\":\"Carl P.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Carl P. (JTV)', 'approved', 'Administrator', '', '2026-06-05 14:46:16', '2026-06-05 14:45:24', '2026-06-05 14:46:16'),
(4, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Bembang', '{\"product_id\":\"82\",\"assignee_name\":\"Bembang\",\"assigned_by\":\"Chowking\",\"due_back\":\"2026-06-05\",\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Bembang (WEBY)', 'rejected', 'Administrator', '', '2026-06-05 14:59:00', '2026-06-05 14:54:18', '2026-06-05 14:59:00'),
(5, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Bembang', '{\"product_id\":\"82\",\"assignee_name\":\"Bembang\",\"assigned_by\":\"Chowking\",\"due_back\":\"2026-06-05\",\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Bembang (WEBY)', 'approved', 'Administrator', '', '2026-06-05 15:00:22', '2026-06-05 15:00:02', '2026-06-05 15:00:22'),
(6, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Dasilay', '{\"product_id\":84,\"assignee_name\":\"Dasilay\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Dasilay', 'approved', 'Administrator', '', '2026-06-08 16:00:06', '2026-06-08 15:59:26', '2026-06-08 16:00:06'),
(7, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-20 16:21:36', '2026-06-08 16:06:40', '2026-06-20 16:21:36'),
(8, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-20 16:21:37', '2026-06-08 16:10:33', '2026-06-20 16:21:37'),
(9, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Bembang', '{\"product_id\":\"85\",\"assignee_name\":\"Bembang\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Bembang (WEBY)', 'rejected', 'Administrator', '', '2026-06-20 16:21:41', '2026-06-09 08:32:14', '2026-06-20 16:21:41'),
(10, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-20 16:21:49', '2026-06-09 08:49:54', '2026-06-20 16:21:49'),
(11, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Charles', '{\"product_id\":\"85\",\"assignee_name\":\"Charles\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Charles (WEBY)', 'rejected', 'Administrator', '', '2026-06-20 16:21:48', '2026-06-09 08:53:39', '2026-06-20 16:21:48'),
(12, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-20 16:21:46', '2026-06-09 08:59:00', '2026-06-20 16:21:46'),
(13, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Dasilay', '{\"product_id\":\"85\",\"assignee_name\":\"Dasilay\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Dasilay (JTV)', 'rejected', 'Administrator', '', '2026-06-20 16:21:44', '2026-06-09 09:32:23', '2026-06-20 16:21:44'),
(14, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"3001-03-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-20 16:21:43', '2026-06-09 09:45:47', '2026-06-20 16:21:43'),
(15, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-06-09\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-20 16:21:34', '2026-06-09 09:49:25', '2026-06-20 16:21:34'),
(16, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-03-23\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-20 16:21:32', '2026-06-09 09:53:21', '2026-06-20 16:21:32'),
(17, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-02-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-20 16:21:30', '2026-06-10 09:51:24', '2026-06-20 16:21:30'),
(18, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-03-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-20 16:21:29', '2026-06-10 10:02:35', '2026-06-20 16:21:29'),
(19, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-02-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-11 09:13:17', '2026-06-10 12:00:31', '2026-06-11 09:13:17'),
(20, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-03-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-11 09:13:13', '2026-06-10 12:04:37', '2026-06-11 09:13:13'),
(21, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-11 09:13:11', '2026-06-10 12:32:40', '2026-06-11 09:13:11'),
(22, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-11 09:13:08', '2026-06-10 12:32:58', '2026-06-11 09:13:08'),
(23, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech → Carl P.', '{\"product_id\":\"85\",\"assignee_name\":\"Carl P.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Carl P. (JTV)', 'rejected', 'Administrator', '', '2026-06-11 09:13:05', '2026-06-10 12:38:40', '2026-06-11 09:13:05'),
(24, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'approved', 'Administrator', '', '2026-06-10 16:11:37', '2026-06-10 12:49:41', '2026-06-10 16:11:37'),
(25, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech → Carl P.', '{\"product_id\":\"85\",\"assignee_name\":\"Carl P.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Carl P. (JTV)', 'approved', 'Administrator', '', '2026-06-10 16:11:33', '2026-06-10 13:04:48', '2026-06-10 16:11:33'),
(26, 'Raven Ompar', 11, 'create', 'Assignment', NULL, 'A4Tech ? Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Raven Ompar\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'rejected', 'Administrator', '', '2026-06-10 16:11:20', '2026-06-10 13:24:15', '2026-06-10 16:11:20'),
(27, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech ? Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-02-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-10 15:50:13', '2026-06-10 13:48:13', '2026-06-10 15:50:13'),
(28, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech ? Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-03-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'rejected', 'Administrator', '', '2026-06-10 15:50:10', '2026-06-10 13:50:37', '2026-06-10 15:50:10'),
(29, 'GayaxPalabs', 12, 'create', 'Assignment', NULL, 'Inplay → Bembang', '{\"product_id\":\"89\",\"assignee_name\":\"Bembang\",\"location_id\":\"2\",\"location_name\":\"Pantalan Site 4\",\"station\":\"WEBY\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay\",\"serial_number\":\"CVBDERGFD\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-11\",\"due_back\":\"2026-06-11\",\"reason\":\"please\"}', 'please', 'approved', 'Administrator', '', '2026-06-11 09:10:42', '2026-06-11 09:10:01', '2026-06-11 09:10:42'),
(30, 'GayaxPalabs', 12, 'create', 'Assignment', NULL, 'Inplay → Saratos', '{\"product_id\":\"91\",\"assignee_name\":\"Saratos\",\"assigned_by\":\"GayaxPalabs\",\"location_id\":\"2\",\"location_name\":\"Pantalan Site 4\",\"station\":\"WEBY\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay\",\"serial_number\":\"ERFDCSERF\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-11\",\"due_back\":\"2026-06-11\",\"notes\":\"Station: WEBY\",\"reason\":\"ss\"}', 'ss', 'approved', 'Administrator', '', '2026-06-11 09:17:56', '2026-06-11 09:17:19', '2026-06-11 09:17:56'),
(31, 'Juan Dela Cruz', 16, 'create', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', '{\"product_id\":\"94\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Juan Dela Cruz\",\"location_id\":\"1\",\"location_name\":\"Dungganon SIte 3\",\"station\":\"JTV\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF3\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-07-18\",\"due_back\":\"2026-07-18\",\"notes\":\"Station: JTV\",\"reason\":\"swap keyboard.\"}', 'swap keyboard.', 'approved', 'Administrator', '', '2026-06-11 14:53:24', '2026-06-11 14:52:59', '2026-06-11 14:53:24'),
(32, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', '{\"product_id\":\"92\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Zeno Sang\",\"location_id\":\"1\",\"location_name\":\"Dungganon SIte 3\",\"station\":\"JTV\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF1\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-17\",\"due_back\":\"2026-06-17\",\"notes\":\"Station: JTV\",\"reason\":\"REPLACE\"}', 'REPLACE', 'approved', 'Administrator', '', '2026-06-17 10:13:09', '2026-06-17 08:47:19', '2026-06-17 10:13:09'),
(33, 'guy danielo', 24, 'create', 'Assignment', NULL, 'Havit → Saratos', '{\"product_id\":\"102\",\"assignee_name\":\"Saratos\",\"assigned_by\":\"guy danielo\",\"location_id\":\"2\",\"location_name\":\"Pantalan Site 4\",\"station\":\"WEBY\",\"category_id\":\"14\",\"category_name\":\"Mouse\",\"asset_name\":\"Havit\",\"serial_number\":\"ererer\",\"quantity\":1,\"priority\":\"normal\",\"date_needed\":\"2026-06-18\",\"due_back\":\"2026-06-18\",\"notes\":\"Station: WEBY\",\"reason\":\"need\"}', 'need', 'rejected', 'Administrator', '', '2026-06-20 16:21:27', '2026-06-18 12:46:26', '2026-06-20 16:21:27'),
(34, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Zen P.', '{\"product_id\":\"101\",\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zeno Sang\",\"location_id\":\"1\",\"location_name\":\"Dungganon SIte 3\",\"station\":\"WEBY\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF10\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-19\",\"due_back\":\"2026-06-19\",\"notes\":\"Station: WEBY\",\"reason\":\"replacement\"}', 'replacement', 'approved', 'Administrator', '', '2026-06-19 08:24:29', '2026-06-19 08:24:01', '2026-06-19 08:24:29'),
(35, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', '{\"product_id\":\"96\",\"assignee_name\":\"Zeno Sang\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF5\",\"quantity\":1,\"priority\":\"normal\",\"date_needed\":\"2026-06-19\",\"due_back\":\"2026-06-19\",\"reason\":\"yes\"}', 'yes', 'approved', 'Administrator', '', '2026-06-19 10:59:12', '2026-06-19 10:58:26', '2026-06-19 10:59:12'),
(36, 'Zeno Sang', 13, 'create', 'Assignment', 100, 'Inplay Keyboard for Raven O.', '{\"product_id\":100,\"product_name\":\"Inplay Keyboard\",\"serial_number\":\"SF9\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"priority\":\"urgent\",\"date_needed\":\"2026-07-11\",\"due_back\":\"2026-07-11\",\"reason\":\"yes\",\"on_behalf_of\":\"Raven O.\"}', 'On behalf of Raven O.: yes', 'approved', 'Administrator', '', '2026-06-20 11:40:45', '2026-06-20 11:38:43', '2026-06-20 11:40:45'),
(37, 'Zeno Sang', 13, 'delete', 'Assignment', 46, 'Inplay Keyboard — return by Zeno Sang', '{\"assignment_id\":\"46\",\"condition\":\"damaged\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: damaged', 'approved', 'Administrator', '', '2026-06-20 11:53:48', '2026-06-20 11:52:57', '2026-06-20 11:53:48'),
(38, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', '{\"product_id\":\"93\",\"assignee_name\":\"Zeno Sang\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF2\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-20\",\"due_back\":\"2026-06-20\",\"reason\":\"needed\",\"bulk\":true}', 'needed', 'approved', 'Administrator', '', '2026-06-20 12:03:37', '2026-06-20 12:03:15', '2026-06-20 12:03:37'),
(39, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', '{\"product_id\":\"95\",\"assignee_name\":\"Zeno Sang\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF4\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-20\",\"due_back\":\"2026-06-20\",\"reason\":\"needed\",\"bulk\":true}', 'needed', 'approved', 'Administrator', '', '2026-06-20 12:03:39', '2026-06-20 12:03:15', '2026-06-20 12:03:39'),
(40, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Havit → Zeno Sang', '{\"product_id\":\"102\",\"assignee_name\":\"Zeno Sang\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"14\",\"category_name\":\"Mouse\",\"asset_name\":\"Havit\",\"serial_number\":\"ererer\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-20\",\"due_back\":\"2026-06-20\",\"reason\":\"needed\",\"bulk\":true}', 'needed', 'approved', 'Administrator', '', '2026-06-20 12:03:40', '2026-06-20 12:03:15', '2026-06-20 12:03:40'),
(41, 'Zeno Sang', 13, 'delete', 'Assignment', 50, 'Havit — return by Zeno Sang', '{\"assignment_id\":\"50\",\"product_id\":102,\"condition\":\"damaged\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: damaged', 'approved', 'Administrator', '', '2026-06-20 12:04:39', '2026-06-20 12:04:15', '2026-06-20 12:04:39'),
(42, 'Zeno Sang', 13, 'delete', 'Assignment', 49, 'Inplay Keyboard — return by Zeno Sang', '{\"assignment_id\":\"49\",\"product_id\":95,\"condition\":\"damaged\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: damaged', 'approved', 'Administrator', '', '2026-06-20 12:55:43', '2026-06-20 12:55:25', '2026-06-20 12:55:43'),
(43, 'Zeno Sang', 13, 'delete', 'Assignment', 48, 'Inplay Keyboard — return by Zeno Sang', '{\"assignment_id\":\"48\",\"product_id\":93,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-06-20 15:50:50', '2026-06-20 15:50:27', '2026-06-20 15:50:50'),
(44, 'Zeno Sang', 13, 'create', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', '{\"product_id\":\"99\",\"assignee_name\":\"Zeno Sang\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"asset_name\":\"Inplay Keyboard\",\"serial_number\":\"SF8\",\"quantity\":1,\"priority\":\"urgent\",\"date_needed\":\"2026-06-20\",\"due_back\":\"2026-06-20\",\"reason\":\"dd\"}', 'dd', 'approved', 'Administrator', '', '2026-06-20 16:21:18', '2026-06-20 16:21:00', '2026-06-20 16:21:18'),
(45, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:37', '2026-06-23 11:32:10', '2026-06-24 09:20:37'),
(46, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:41', '2026-06-23 11:32:13', '2026-06-24 09:20:41'),
(47, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:47', '2026-06-23 11:32:14', '2026-06-24 09:20:47'),
(48, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:43', '2026-06-23 11:32:14', '2026-06-24 09:20:43'),
(49, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:45', '2026-06-23 11:32:14', '2026-06-24 09:20:45'),
(50, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:39', '2026-06-23 11:32:14', '2026-06-24 09:20:39'),
(51, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'approved', 'Administrator', '', '2026-06-23 11:50:54', '2026-06-23 11:32:15', '2026-06-23 11:50:54'),
(52, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'approved', 'Administrator', '', '2026-06-23 11:51:05', '2026-06-23 11:32:15', '2026-06-23 11:51:05'),
(53, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'approved', 'Administrator', '', '2026-06-23 11:56:03', '2026-06-23 11:32:15', '2026-06-23 11:56:03'),
(54, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 08:57:32', '2026-06-23 11:32:15', '2026-06-24 08:57:32'),
(55, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:50', '2026-06-23 11:32:15', '2026-06-24 09:20:50'),
(56, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Leader\",\"purpose\":\"Replacement\",\"date_deployed\":\"June 23, 2026\",\"expected_return\":\"June 23, 2026\",\"remarks\":\"yes\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"}]}', 'Replacement', 'rejected', 'Administrator', '', '2026-06-24 09:20:55', '2026-06-23 11:32:15', '2026-06-24 09:20:55'),
(57, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"Dungganon SIte 3\",\"purpose\":\"project.\",\"date_deployed\":\"06 \\/ 23 \\/ 2026\",\"expected_return\":\"07\\/23\\/2026\",\"remarks\":\"\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"2222\",\"category\":\"Headsets\",\"condition\":\"\"},{\"name\":\"Inplay Keyboard\",\"tag\":\"SF2\",\"category\":\"Keyboards\",\"condition\":\"\"}]}', 'project.', 'approved', 'Administrator', '', '2026-06-23 13:05:16', '2026-06-23 13:04:38', '2026-06-23 13:05:16'),
(58, 'Gadwhen Dollente', 25, 'delete', 'Assignment', 53, 'Inplay Headset — return by Gadwhen Dollente', '{\"assignment_id\":\"53\",\"product_id\":78,\"condition\":\"broken\",\"return_method\":\"dropoff\",\"notes\":\"yes\"}', 'Return request: broken — yes', 'approved', 'Administrator', '', '2026-06-24 08:54:03', '2026-06-24 08:53:38', '2026-06-24 08:54:03'),
(59, 'Gadwhen Dollente', 25, 'delete', 'Assignment', 54, 'Inplay Keyboard — return by Gadwhen Dollente', '{\"assignment_id\":\"54\",\"product_id\":93,\"condition\":\"broken\",\"return_method\":\"dropoff\",\"notes\":\"not working\"}', 'Return request: broken — not working', 'approved', 'Administrator', '', '2026-06-24 08:57:37', '2026-06-24 08:56:56', '2026-06-24 08:57:37'),
(60, 'Gadwhen Dollente', 25, 'create', 'asset_request', NULL, 'Gadwhen Dollente', '{\"assignee\":\"Gadwhen Dollente\",\"department\":\"\",\"purpose\":\"borrow\",\"date_deployed\":\"\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"3333\",\"category\":\"Headsets\",\"condition\":\"\"},{\"name\":\"Inplay Keyboard\",\"tag\":\"hjhjhjgggg\",\"category\":\"Keyboards\",\"condition\":\"\"}]}', 'borrow', 'approved', 'Administrator', '', '2026-06-24 09:20:23', '2026-06-24 09:19:45', '2026-06-24 09:20:23'),
(61, 'ploy ploy', 26, 'create', 'asset_request', NULL, 'ploy ploy', '{\"assignee\":\"ploy ploy\",\"department\":\"JTV\",\"purpose\":\"borrow\",\"date_deployed\":\"6\\/25\\/2026\",\"expected_return\":\"7\\/25\\/2026\",\"remarks\":\"\",\"assets\":[{\"name\":\"Inplay Headset\",\"tag\":\"3333\",\"category\":\"Headsets\",\"condition\":\"\"},{\"name\":\"A4Tech Mouse\",\"tag\":\"wwwwww\",\"category\":\"Mouse\",\"condition\":\"\"}]}', 'borrow', 'approved', 'Administrator', '', '2026-06-25 12:58:36', '2026-06-25 12:58:11', '2026-06-25 12:58:36'),
(62, 'Zeno Sang', 13, 'create', 'Assignment', 81, 'Inplay Headset for Carl P.', '{\"product_id\":81,\"product_name\":\"Inplay Headset\",\"serial_number\":\"5555\",\"assignee_name\":\"Carl P.\",\"assigned_by\":\"Zeno Sang\",\"category_id\":\"21\",\"category_name\":\"Headsets\",\"priority\":\"urgent\",\"date_needed\":\"2026-07-01\",\"due_back\":\"2026-07-01\",\"reason\":\"replacement\",\"on_behalf_of\":\"Carl P.\"}', 'On behalf of Carl P.: replacement', 'approved', 'Raven Ompar', '', '2026-07-01 15:20:51', '2026-07-01 15:20:15', '2026-07-01 15:20:51'),
(63, 'ploy ploy', 26, 'create', 'asset_request', NULL, 'ploy ploy', '{\"assignee\":\"ploy ploy\",\"department\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"06 \\/ 25 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headset\",\"brand\":\"InPlay\",\"tag\":\"4444\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Raven Ompar', '', '2026-07-02 11:53:19', '2026-07-02 09:53:16', '2026-07-02 11:53:19'),
(64, 'ploy ploy', 26, 'create', 'asset_request', NULL, 'ploy ploy', '{\"assignee\":\"ploy ploy\",\"department\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Inplay Headset\",\"tag\":\"4444\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-02 12:48:12', '2026-07-02 11:54:22', '2026-07-02 12:48:12'),
(65, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"Agero\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"dsdsdsds\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Raven Ompar', '', '2026-07-02 15:10:18', '2026-07-02 15:09:23', '2026-07-02 15:10:18'),
(66, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Dasilay', '{\"assignee\":\"Dasilay\",\"empid\":\"333333333\",\"department\":\"JTV\",\"location\":\"Dungganon SIte 3\",\"date_deployed\":\"07 \\/ 03 \\/ 2026\",\"purpose\":\"Asset Accountability\",\"expected_return\":\"\",\"remarks\":\"\",\"on_behalf_of\":\"Dasilay\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"nmnmnmnm\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:38', '2026-07-03 08:28:20', '2026-07-03 11:58:38'),
(67, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"JTV\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"fgfgfgfg\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:34', '2026-07-03 08:29:25', '2026-07-03 11:58:34'),
(68, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"rtrtrtrt\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:36', '2026-07-03 08:33:52', '2026-07-03 11:58:36'),
(69, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"nmnmnmnm\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:30', '2026-07-03 08:35:24', '2026-07-03 11:58:30'),
(70, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"dsdsdsds\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:32', '2026-07-03 11:46:35', '2026-07-03 11:58:32'),
(71, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"department\":\"\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"dsdsdsds\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:28', '2026-07-03 11:48:40', '2026-07-03 11:58:28'),
(72, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Raven O.', '{\"assignee\":\"Raven O.\",\"empid\":\"\",\"department\":\"\",\"location\":\"Dungganon SIte 3\",\"date_deployed\":\"07 \\/ 02 \\/ 2026\",\"purpose\":\"Asset Accountability\",\"expected_return\":\"\",\"remarks\":\"\",\"on_behalf_of\":\"Raven O.\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"dsdsdsds\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-03 11:58:26', '2026-07-03 11:48:51', '2026-07-03 11:58:26'),
(73, 'Zeno Sang', 13, 'create', 'asset_request', NULL, 'Dasilay', '{\"assignee\":\"Dasilay\",\"department\":\"JTV\",\"location\":\"Dungganon SIte 3\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 03 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"hjhjhjhj\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-03 11:56:10', '2026-07-03 11:55:11', '2026-07-03 11:56:10'),
(74, 'Kina May', 0, 'create', 'asset_request', NULL, 'Kina May', '{\"assignee\":\"Kina May\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 09 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Laptop\",\"brand\":\"Huawei Ultra\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"nmnmnmnm\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-09 14:14:26', '2026-07-09 14:11:12', '2026-07-09 14:14:26'),
(75, 'Kina May', 0, 'delete', 'Assignment', 69, 'Poly · return by Kina May', '{\"assignment_id\":\"69\",\"product_id\":115,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"Whaaaa\"}', 'Return request: good · Whaaaa', 'approved', 'Administrator', '', '2026-07-09 14:15:26', '2026-07-09 14:14:58', '2026-07-09 14:15:26'),
(76, 'Kina May', 0, 'create', 'asset_request', NULL, 'Kina May', '{\"assignee\":\"Kina May\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 09 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"nmnmnmnm\",\"condition\":\"Good\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-09 14:16:42', '2026-07-09 14:16:13', '2026-07-09 14:16:42'),
(77, 'Kina May', 0, 'delete', 'Assignment', 70, 'Poly · return by Kina May', '{\"assignment_id\":\"70\",\"product_id\":115,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"adada\"}', 'Return request: good · adada', 'rejected', 'Administrator', '', '2026-07-09 14:17:19', '2026-07-09 14:17:02', '2026-07-09 14:17:19'),
(78, 'Kina May', 0, 'delete', 'Assignment', 70, 'Poly · return by Kina May', '{\"assignment_id\":\"70\",\"product_id\":115,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-09 14:17:51', '2026-07-09 14:17:37', '2026-07-09 14:17:51'),
(79, 'Kina May', 0, 'create', 'asset_request', NULL, 'Kina May', '{\"assignee\":\"Kina May\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 09 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Poly\",\"tag\":\"nmnmnmnm\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-09 14:18:37', '2026-07-09 14:18:18', '2026-07-09 14:18:37');

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
(1, 130, 'Ompar', 'Import', '2026-07-08 04:31:29', NULL, NULL, 'Employee ID: JJJ111', 2, 'active', '2026-07-08 10:31:29', '2026-07-08 10:31:29'),
(29, 79, 'Raven O.', 'Administrator', '2026-06-04 10:45:16', NULL, '2026-06-05 13:48:02', 'Station: JTV', 1, 'returned', '2026-06-04 16:45:16', '2026-06-05 13:48:02'),
(31, 80, 'Dasilay', 'Administrator', '2026-06-05 02:35:02', NULL, '2026-06-22 14:15:14', 'Station: JTV', 1, 'returned', '2026-06-05 08:35:02', '2026-06-22 14:15:14'),
(33, 81, 'Charles', 'Chowking', '2026-06-05 05:56:49', NULL, '2026-06-22 14:15:00', 'Station: WEBY', 2, 'returned', '2026-06-05 11:56:49', '2026-06-22 14:15:00'),
(34, 79, 'Saratos', 'Zen Angelo Palay', '2026-06-05 07:49:15', '2027-06-05', '2026-06-22 14:15:04', 'Station: WEBY', 2, 'returned', '2026-06-05 13:49:15', '2026-06-22 14:15:04'),
(35, 86, 'Carl P.', 'Chowking', '2026-06-05 08:46:17', NULL, '2026-06-22 14:15:11', 'Station: JTV', 1, 'returned', '2026-06-05 14:46:17', '2026-06-22 14:15:11'),
(36, 83, 'Carl P.', 'Chowking', '2026-06-05 08:46:19', NULL, '2026-06-22 14:15:11', 'Station: JTV', 1, 'returned', '2026-06-05 14:46:19', '2026-06-22 14:15:11'),
(37, 82, 'Bembang', 'Chowking', '2026-06-05 09:00:22', '2026-06-05', '2026-06-22 14:23:07', 'Station: WEBY', 2, 'returned', '2026-06-05 15:00:22', '2026-06-22 14:23:07'),
(38, 84, 'Dasilay', 'Chowking', '2026-06-08 10:00:07', NULL, '2026-06-22 14:15:14', 'Station: JTV', 1, 'returned', '2026-06-08 16:00:07', '2026-06-22 14:15:14'),
(39, 85, 'Carl P.', 'Raven Ompar', '2026-06-10 10:11:33', NULL, '2026-06-22 14:15:12', 'Station: JTV', 1, 'returned', '2026-06-10 16:11:33', '2026-06-22 14:15:12'),
(40, 91, 'Saratos', 'GayaxPalabs', '2026-06-11 03:17:56', '2026-06-11', '2026-06-22 14:15:03', 'Station: WEBY | Station: WEBY', 2, 'returned', '2026-06-11 09:17:56', '2026-06-22 14:15:03'),
(41, 94, 'Raven O.', 'Juan Dela Cruz', '2026-06-11 08:53:24', '2026-07-18', '2026-06-22 14:15:18', 'Station: JTV | Station: JTV', 1, 'returned', '2026-06-11 14:53:24', '2026-06-22 14:15:18'),
(42, 92, 'Raven O.', 'Zeno Sang', '2026-06-17 04:13:09', '2026-06-17', '2026-06-22 14:15:18', 'Station: JTV | Station: JTV', 1, 'returned', '2026-06-17 10:13:09', '2026-06-22 14:15:18'),
(44, 97, 'Raven O.', 'Admin', '2026-06-18 05:57:41', NULL, '2026-06-22 14:15:17', 'Station: JTV', 1, 'returned', '2026-06-18 11:57:41', '2026-06-22 14:15:17'),
(45, 101, 'Zen P.', 'Zeno Sang', '2026-06-19 02:24:29', '2026-06-19', '2026-06-22 14:15:06', 'Station: WEBY | Station: WEBY', 1, 'returned', '2026-06-19 08:24:29', '2026-06-22 14:15:06'),
(47, 100, 'Raven O.', 'Zeno Sang', '2026-06-20 05:40:45', '2026-07-11', '2026-06-22 14:15:17', 'yes', NULL, 'returned', '2026-06-20 11:40:45', '2026-06-22 14:15:17'),
(51, 99, 'Zeno Sang', 'Zeno Sang', '2026-06-20 10:21:18', '2026-06-20', '2026-06-22 14:23:11', 'dd', NULL, 'returned', '2026-06-20 16:21:18', '2026-06-22 14:23:11'),
(52, 93, 'Seat #2', 'Administrator', '2026-06-22 07:37:03', NULL, '2026-06-22 14:23:10', 'Deployed to cubicle Seat #2', NULL, 'returned', '2026-06-22 13:37:03', '2026-06-22 14:23:10'),
(55, 79, 'Gadwhen Dollente', 'Admin', '2026-06-24 03:20:23', NULL, NULL, 'borrow', 1, 'active', '2026-06-24 09:20:23', '2026-06-24 09:20:23'),
(56, 111, 'Gadwhen Dollente', 'Admin', '2026-06-24 03:20:23', NULL, NULL, 'borrow', 1, 'active', '2026-06-24 09:20:23', '2026-06-24 09:20:23'),
(57, 86, 'ploy ploy', 'Admin', '2026-06-25 06:58:35', '2026-07-25', NULL, 'borrow', 1, 'active', '2026-06-25 12:58:35', '2026-06-25 12:58:35'),
(58, 81, 'Carl P.', 'Zeno Sang', '2026-07-01 09:20:50', '2026-07-01', NULL, 'replacement', NULL, 'active', '2026-07-01 15:20:50', '2026-07-01 15:20:50'),
(59, 80, 'ploy ploy', 'Admin', '2026-07-02 05:53:18', NULL, NULL, 'Asset Accountability', 1, 'active', '2026-07-02 11:53:18', '2026-07-02 11:53:18'),
(60, 116, 'Raven O.', 'Admin', '2026-07-02 09:10:17', NULL, NULL, 'Asset Accountability', 1, 'active', '2026-07-02 15:10:17', '2026-07-02 15:10:17'),
(61, 114, 'Dasilay', 'Admin', '2026-07-03 05:56:10', NULL, NULL, 'Asset Accountability', 1, 'active', '2026-07-03 11:56:10', '2026-07-03 11:56:10'),
(62, 81, 'Carl P.', 'Zeno Sang', '2026-07-03 10:11:36', '2026-07-01', NULL, 'replacement', NULL, 'active', '2026-07-03 16:11:36', '2026-07-03 16:11:36'),
(63, 81, 'Carl P.', 'Zeno Sang', '2026-07-03 10:11:42', '2026-07-01', NULL, 'replacement', NULL, 'active', '2026-07-03 16:11:42', '2026-07-03 16:11:42'),
(64, 112, 'Seat #1', 'Admin', '2026-07-08 07:12:35', NULL, NULL, 'Deployed to cubicle Seat #1', 1, 'active', '2026-07-08 13:12:35', '2026-07-08 13:12:35'),
(65, 113, 'Seat #1', 'Admin', '2026-07-08 07:12:35', NULL, NULL, 'Deployed to cubicle Seat #1', 1, 'active', '2026-07-08 13:12:35', '2026-07-08 13:12:35'),
(66, 1, 'Seat #2', 'Admin', '2026-07-08 07:13:02', NULL, NULL, 'Deployed to cubicle Seat #2', 1, 'active', '2026-07-08 13:13:02', '2026-07-08 13:13:02'),
(67, 82, 'Seat #3', 'Admin', '2026-07-08 08:11:33', NULL, NULL, 'Deployed to cubicle Seat #3', 1, 'active', '2026-07-08 14:11:33', '2026-07-08 14:11:33'),
(68, 83, 'Seat #3', 'Admin', '2026-07-08 08:11:33', NULL, NULL, 'Deployed to cubicle Seat #3', 1, 'active', '2026-07-08 14:11:33', '2026-07-08 14:11:33'),
(71, 115, 'Kina May', 'Admin', '2026-07-09 08:18:37', NULL, '2026-07-10 10:27:34', 'Asset Accountability', 1, 'returned', '2026-07-09 14:18:37', '2026-07-10 10:27:34'),
(72, 141, 'Seat #25', 'Admin', '2026-07-09 12:00:28', NULL, NULL, 'Deployed to cubicle Seat #25', 1, 'active', '2026-07-09 18:00:28', '2026-07-09 18:00:28'),
(73, 124, 'Seat #25', 'Admin', '2026-07-09 12:00:28', NULL, NULL, 'Deployed to cubicle Seat #25', 1, 'active', '2026-07-09 18:00:28', '2026-07-09 18:00:28'),
(74, 134, 'Seat #25', 'Admin', '2026-07-09 12:00:28', NULL, NULL, 'Deployed to cubicle Seat #25', 1, 'active', '2026-07-09 18:00:28', '2026-07-09 18:00:28'),
(75, 146, 'Manolo Palay', 'Import', '2026-07-10 03:20:04', NULL, NULL, 'Employee ID: BAKS23', 1, 'active', '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(76, 147, 'Apolinario', 'Import', '2026-07-10 03:20:04', NULL, NULL, 'Employee ID: Apjasjd', 1, 'active', '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(77, 148, 'Mabini', 'Import', '2026-07-10 03:20:04', NULL, NULL, 'Employee ID: MB812738', 1, 'active', '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(78, 149, 'Rizal', 'Import', '2026-07-10 03:20:04', NULL, NULL, 'Employee ID: RIZZ912391293', 1, 'active', '2026-07-10 09:20:04', '2026-07-10 09:20:04');

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
(1, 1, 'Administrator', 'disposed', 'Asset', 7, 'Asus Monitor', 'Asset disposed: ', NULL, '2026-05-20 17:17:20'),
(2, 1, 'Administrator', 'updated', 'Asset', 2, 'HP Monitor', 'Asset donated to: ssss', NULL, '2026-05-22 10:17:11'),
(3, 1, 'Administrator', 'updated', 'Category', 14, 'Networking', 'Category updated: Networking', NULL, '2026-05-22 13:16:17'),
(4, 1, 'Administrator', 'updated', 'Category', 15, 'Power Equipment', 'Category updated: Power Equipment', NULL, '2026-05-22 13:20:23'),
(5, 1, 'Administrator', 'updated', 'Category', 13, 'Computers', 'Category updated: Computers', NULL, '2026-05-22 13:21:12'),
(6, 1, 'Administrator', 'updated', 'Category', 16, 'Cabling and Accessories', 'Category updated: Cabling and Accessories', NULL, '2026-05-22 13:21:34'),
(7, 1, 'Administrator', 'created', 'Category', 20, 'Other Assets', 'Category created: Other Assets', NULL, '2026-05-22 13:22:21'),
(8, 1, 'Administrator', 'reported', 'Asset', 27, 'RJ45', 'Damage reported: yes', NULL, '2026-05-22 13:23:10'),
(9, 1, 'Administrator', 'updated', 'Asset', 18, 'The Best Headset', 'Asset updated: The Best Headset', NULL, '2026-05-22 14:33:25'),
(10, 1, 'Administrator', 'updated', 'Asset', 18, 'The Best Headset', 'Asset updated: The Best Headset', NULL, '2026-05-22 14:33:44'),
(11, 1, 'Administrator', 'reported', 'Asset', 17, 'The Best Headset', 'Damage reported: sfad', NULL, '2026-05-22 14:34:48'),
(12, 1, 'Administrator', 'disposed', 'Asset', 17, 'The Best Headset', 'Asset disposed: ', NULL, '2026-05-22 16:20:45'),
(13, 1, 'Administrator', 'reported', 'Asset', 16, 'The Best Headset', 'Damage reported: not working', NULL, '2026-05-22 16:40:15'),
(14, 1, 'Administrator', 'disposed', 'Asset', 16, 'The Best Headset', 'Asset disposed: ', NULL, '2026-05-22 16:40:35'),
(15, 1, 'Administrator', 'reported', 'Asset', 18, 'The Best Headset', 'Damage reported: sxqsx', NULL, '2026-05-22 16:50:04'),
(16, 1, 'Administrator', 'assigned', 'Asset', 3, 'Logitech M100R', 'Assigned to Zen Kyuti by Administrator', NULL, '2026-05-25 09:12:45'),
(17, 1, 'Administrator', 'reported', 'Asset', 9, 'Asus Monitor', 'Damage reported: [Disposed] oo', NULL, '2026-05-26 09:44:52'),
(18, 1, 'Administrator', 'disposed', 'Asset', 9, 'Asus Monitor', 'Asset disposed: ', NULL, '2026-05-26 09:44:52'),
(19, 1, 'Administrator', 'reported', 'Asset', 5, 'Laptop', 'Damage reported: [Damaged] oo', NULL, '2026-05-26 09:47:47'),
(20, 1, 'Administrator', 'reported', 'Asset', 3, 'Logitech M100R', 'Damage reported: [Disposed] oko', NULL, '2026-05-26 09:49:39'),
(21, 1, 'Administrator', 'returned', 'Asset', 3, 'Logitech M100R', 'Returned by Zen Kyuti', NULL, '2026-05-26 09:49:39'),
(22, 1, 'Administrator', 'deleted', 'Asset', 3, 'Logitech M100R', 'Asset deleted: Logitech M100R', NULL, '2026-05-26 09:49:40'),
(23, 1, 'Administrator', 'reported', 'Asset', 4, 'Logitech M100R', 'Damage reported: [For Donation] ok', NULL, '2026-05-26 09:49:59'),
(24, 1, 'Administrator', 'returned', 'Asset', 4, 'Logitech M100R', 'Returned by Zen Kyuti', NULL, '2026-05-26 09:49:59'),
(25, 1, 'Administrator', 'deleted', 'Asset', 4, 'Logitech M100R', 'Asset deleted: Logitech M100R', NULL, '2026-05-26 09:49:59'),
(26, 1, 'Administrator', 'assigned', 'Asset', 14, 'HP Monitor', 'Assigned to Craig Dylan by Administrator', NULL, '2026-05-26 09:56:41'),
(27, 1, 'Administrator', 'assigned', 'Asset', 19, 'The Best Headset', 'Assigned to Craig Dylan by Administrator', NULL, '2026-05-26 09:57:00'),
(28, 1, 'Administrator', 'reported', 'Asset', 19, 'The Best Headset', 'Damage reported: [Disposed] koko', NULL, '2026-05-26 09:57:23'),
(29, 1, 'Administrator', 'disposed', 'Asset', 19, 'The Best Headset', 'Asset disposed: koko', NULL, '2026-05-26 09:57:24'),
(30, 1, 'Administrator', 'assigned', 'Asset', 26, 'LAN Cable', 'Assigned to Craig Dylan by Administrator', NULL, '2026-05-26 10:12:30'),
(31, 1, 'Administrator', 'reported', 'Asset', 26, 'LAN Cable', 'Damage reported: [Disposed] plopop', NULL, '2026-05-26 10:12:48'),
(32, 1, 'Administrator', 'disposed', 'Asset', 26, 'LAN Cable', 'Asset disposed: plopop', NULL, '2026-05-26 10:12:48'),
(33, 1, 'Administrator', 'reported', 'Asset', 14, 'HP Monitor', 'Damage reported: [Disposed] asdasd', NULL, '2026-05-26 10:19:11'),
(34, 1, 'Administrator', 'disposed', 'Asset', 14, 'HP Monitor', 'Asset disposed: asdasd', NULL, '2026-05-26 10:19:12'),
(35, 1, 'Administrator', 'returned', 'Asset', 5, 'Laptop', 'Returned by Craig Dylan', NULL, '2026-05-26 10:29:13'),
(36, 1, 'Administrator', 'assigned', 'Asset', 20, 'The Best Headset', 'Assigned to Maria Clara by Administrator', NULL, '2026-05-26 10:29:55'),
(37, 1, 'Administrator', 'assigned', 'Asset', 8, 'Monitor', 'Assigned to Maria Clara by Administrator', NULL, '2026-05-26 10:30:22'),
(38, 1, 'Administrator', 'assigned', 'Asset', 27, 'RJ45', 'Assigned to Maria Clara by Administrator', NULL, '2026-05-26 10:30:31'),
(39, 1, 'Administrator', 'reported', 'Asset', 27, 'RJ45', 'Damage reported: [Damaged] asd', NULL, '2026-05-26 10:30:42'),
(40, 1, 'Administrator', 'reported', 'Asset', 8, 'Monitor', 'Damage reported: [Disposed] asdasd', NULL, '2026-05-26 10:30:57'),
(41, 1, 'Administrator', 'disposed', 'Asset', 8, 'Monitor', 'Asset disposed: asdasd', NULL, '2026-05-26 10:30:57'),
(42, 1, 'Administrator', 'reported', 'Asset', 20, 'The Best Headset', 'Damage reported: [Disposed] asdasd', NULL, '2026-05-26 10:31:30'),
(43, 1, 'Administrator', 'disposed', 'Asset', 20, 'The Best Headset', 'Asset disposed: asdasd', NULL, '2026-05-26 10:31:30'),
(44, 1, 'Administrator', 'assigned', 'Asset', 21, 'The Best Headset', 'Assigned to Maria Clara by Administrator', NULL, '2026-05-26 10:32:04'),
(45, 1, 'Administrator', 'reported', 'Asset', 21, 'The Best Headset', 'Damage reported: [For Donation] asdasd', NULL, '2026-05-26 10:32:11'),
(46, 1, 'Administrator', 'updated', 'Asset', 21, 'The Best Headset', 'Asset donated to: Reported via Assignees', NULL, '2026-05-26 10:32:11'),
(47, 1, 'Administrator', 'updated', 'Asset', 27, 'RJ45', 'Damage resolved', NULL, '2026-05-26 12:22:47'),
(48, 1, 'Administrator', 'updated', 'Asset', 27, 'RJ45', 'Damage resolved', NULL, '2026-05-26 12:23:52'),
(49, 1, 'Administrator', 'returned', 'Asset', 27, 'RJ45', 'Returned by Maria Clara', NULL, '2026-05-29 10:15:50'),
(50, 1, 'Administrator', 'assigned', 'Asset', 27, 'RJ45', 'Assigned to Rven by Administrator', NULL, '2026-05-29 10:18:40'),
(51, 1, 'Administrator', 'updated', 'Asset', 22, 'The Best Headset', 'Asset updated: The Best Headset', NULL, '2026-05-29 10:22:23'),
(52, 1, 'Administrator', 'updated', 'Category', 14, 'Devices', 'Category updated: Devices', NULL, '2026-06-01 08:29:46'),
(53, 1, 'Administrator', 'updated', 'Category', 10, 'Peripherals', 'Category updated: Peripherals', NULL, '2026-06-01 08:32:10'),
(54, 1, 'Administrator', 'created', 'Category', 21, 'Headsets', 'Category created: Headsets', NULL, '2026-06-01 08:32:59'),
(55, 1, 'Administrator', 'created', 'Category', 22, 'UPS', 'Category created: UPS', NULL, '2026-06-01 08:34:06'),
(56, 1, 'Administrator', 'assigned', 'Asset', 44, 'Inplay Mouse', 'Assigned to Raven O. by Administrator', NULL, '2026-06-01 15:16:10'),
(57, 1, 'Administrator', 'created', 'Asset', 49, 'HP Monitor', 'Asset created: HP Monitor', NULL, '2026-06-02 09:10:00'),
(58, 1, 'Administrator', 'created', 'Asset', 50, 'HP Monitor', 'Asset created: HP Monitor', NULL, '2026-06-02 09:13:00'),
(59, 1, 'Administrator', 'created', 'Asset', 51, 'HP Monitor', 'Asset created: HP Monitor', NULL, '2026-06-02 09:37:03'),
(60, 1, 'Administrator', 'updated', 'Asset', 51, 'HP Monitor', 'Asset updated: HP Monitor', NULL, '2026-06-02 09:37:32'),
(61, 1, 'Administrator', 'received', 'PurchaseOrder', 8, 'PO-20260602-0001', 'Partial receive: 10 asset(s) added by Administrator', NULL, '2026-06-02 12:31:48'),
(62, 1, 'Administrator', 'received', 'PurchaseOrder', 8, 'PO-20260602-0001', 'Partial receive: 5 asset(s) added by Administrator', NULL, '2026-06-02 12:33:53'),
(63, 1, 'Administrator', 'assigned', 'Asset', 63, 'YES HEAD', 'Assigned to Raven Ompar by Administrator', NULL, '2026-06-04 09:06:18'),
(64, 1, 'Administrator', 'assigned', 'Asset', 52, 'dede', 'Assigned to Raven by Administrator', NULL, '2026-06-04 09:25:51'),
(65, 1, 'Administrator', 'assigned', 'Asset', 62, 'YES HEAD', 'Assigned to Raven by Administrator', NULL, '2026-06-04 12:46:11'),
(66, 1, 'Administrator', 'assigned', 'Asset', 39, 'Havit Keyboard', 'Assigned to Raven by Administrator', NULL, '2026-06-04 13:44:29'),
(67, 1, 'Administrator', 'reported', 'Asset', 45, 'Inplay Mouse', 'Damage reported: asfsdf', NULL, '2026-06-04 13:45:07'),
(68, 1, 'Administrator', 'disposed', 'Asset', 45, 'Inplay Mouse', 'Asset disposed: ', NULL, '2026-06-04 13:50:40'),
(69, 1, 'Administrator', 'reported', 'Asset', 49, 'HP Monitor', 'Damage reported: sdgsdg', NULL, '2026-06-04 14:00:32'),
(70, 1, 'Administrator', 'reported', 'Asset', 52, 'dede', 'Damage reported: oki', NULL, '2026-06-04 14:18:44'),
(71, 1, 'Administrator', 'assigned', 'Asset', 53, 'dede', 'Assigned to Raven by Administrator', NULL, '2026-06-04 16:16:22'),
(72, 1, 'Administrator', 'assigned', 'Asset', 55, 'dede', 'Assigned to Raven by Administrator', NULL, '2026-06-04 16:37:48'),
(73, 1, 'Administrator', 'assigned', 'Asset', 79, 'Inplay Headset', 'Assigned to Raven O. by Administrator', NULL, '2026-06-04 16:45:16'),
(74, 1, 'Administrator', 'assigned', 'Asset', 77, 'Inplay Headset', 'Assigned to Raven O. by Administrator', NULL, '2026-06-04 16:45:57'),
(75, 1, 'Administrator', 'reported', 'Asset', 77, 'Inplay Headset', 'Damage reported: [Damaged] not working', NULL, '2026-06-04 16:46:22'),
(76, 1, 'Administrator', 'updated', 'Asset', 77, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-04 16:47:29'),
(77, 1, 'Administrator', 'updated', 'Asset', 79, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-04 16:47:29'),
(78, 1, 'Administrator', 'updated', 'Asset', 78, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-04 16:47:29'),
(79, 1, 'Administrator', 'updated', 'Asset', 80, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-04 16:47:30'),
(80, 1, 'Administrator', 'updated', 'Asset', 81, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-04 16:47:30'),
(81, 1, 'Administrator', 'assigned', 'Asset', 80, 'Inplay Headset', 'Assigned to Dasilay by Administrator', NULL, '2026-06-05 08:35:02'),
(82, 1, 'Administrator', 'assigned', 'Asset', 78, 'Inplay Headset', 'Assigned to Zen P. by Administrator', NULL, '2026-06-05 08:48:30'),
(83, 8, 'Chowking', 'assigned', 'Asset', 81, 'Inplay Headset', 'Assigned to Charles by Chowking', NULL, '2026-06-05 11:56:49'),
(84, 8, 'Chowking', 'updated', 'Asset', 77, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-05 11:57:32'),
(85, 8, 'Chowking', 'updated', 'Asset', 78, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-05 11:57:32'),
(86, 8, 'Chowking', 'updated', 'Asset', 80, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-05 11:57:32'),
(87, 8, 'Chowking', 'updated', 'Asset', 79, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-05 11:57:33'),
(88, 8, 'Chowking', 'updated', 'Asset', 81, 'Inplay Headset', 'Asset updated: Inplay Headset', NULL, '2026-06-05 11:57:33'),
(89, 10, 'Zen Angelo Palay', 'returned', 'Asset', 79, 'Inplay Headset', 'Returned by Raven O.', NULL, '2026-06-05 13:48:02'),
(90, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'Inplay Headset → Saratos', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-05 13:48:24'),
(91, 1, 'Administrator', 'assigned', 'Asset', 79, 'Inplay Headset', 'Assigned to Saratos by Zen Angelo Palay', NULL, '2026-06-05 13:49:15'),
(92, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Headset → Saratos', 'Approved by Administrator: create on Assignment', NULL, '2026-06-05 13:49:15'),
(93, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Carl P.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-05 14:45:10'),
(94, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Carl P.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-05 14:45:24'),
(95, 1, 'Administrator', 'assigned', 'Asset', 86, 'A4Tech', 'Assigned to Carl P. by Chowking', NULL, '2026-06-05 14:46:17'),
(96, 1, 'Administrator', 'approved', 'Assignment', NULL, 'A4Tech → Carl P.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-05 14:46:17'),
(97, 1, 'Administrator', 'assigned', 'Asset', 83, 'A4Tech', 'Assigned to Carl P. by Chowking', NULL, '2026-06-05 14:46:19'),
(98, 1, 'Administrator', 'approved', 'Assignment', NULL, 'A4Tech → Carl P.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-05 14:46:19'),
(99, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Bembang', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-05 14:54:18'),
(100, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Bembang', 'Rejected by Administrator: No reason given', NULL, '2026-06-05 14:59:01'),
(101, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Bembang', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-05 15:00:02'),
(102, 1, 'Administrator', 'assigned', 'Asset', 82, 'A4Tech', 'Assigned to Bembang by Chowking', NULL, '2026-06-05 15:00:22'),
(103, 1, 'Administrator', 'approved', 'Assignment', NULL, 'A4Tech → Bembang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-05 15:00:22'),
(104, 1, 'Administrator', 'updated', 'Asset', 82, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-08 12:01:52'),
(105, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Dasilay', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-08 15:59:27'),
(106, 1, 'Administrator', 'assigned', 'Asset', 84, 'A4Tech', 'Assigned to Dasilay by Chowking', NULL, '2026-06-08 16:00:07'),
(107, 1, 'Administrator', 'approved', 'Assignment', NULL, 'A4Tech → Dasilay', 'Approved by Administrator: create on Assignment', NULL, '2026-06-08 16:00:07'),
(108, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-08 16:06:40'),
(109, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-08 16:10:33'),
(110, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Bembang', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-09 08:32:14'),
(111, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-09 08:49:54'),
(112, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Charles', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-09 08:53:39'),
(113, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-09 08:59:00'),
(114, 8, 'Chowking', 'pending', 'Assignment', NULL, 'A4Tech → Dasilay', 'Create request submitted by Chowking — awaiting approval', NULL, '2026-06-09 09:32:24'),
(115, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-09 09:45:47'),
(116, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-09 09:49:25'),
(117, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-09 09:53:21'),
(118, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 09:51:24'),
(119, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 10:02:35'),
(120, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 12:00:31'),
(121, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 12:04:37'),
(122, 1, 'Administrator', 'disposed', 'Asset', 77, 'Inplay Headset', 'Asset disposed: ', NULL, '2026-06-10 12:10:28'),
(123, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 12:32:40'),
(124, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 12:32:58'),
(125, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech → Carl P.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 12:38:40'),
(126, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech → Raven O.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 12:49:41'),
(127, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech → Carl P.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 13:04:48'),
(128, 11, 'Raven Ompar', 'pending', 'Assignment', NULL, 'A4Tech ? Raven O.', 'Create request submitted by Raven Ompar — awaiting approval', NULL, '2026-06-10 13:24:15'),
(129, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech ? Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 13:48:13'),
(130, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech ? Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-10 13:50:37'),
(131, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech ? Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-10 15:50:10'),
(132, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech ? Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-10 15:50:13'),
(133, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech ? Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-10 16:11:20'),
(134, 1, 'Administrator', 'assigned', 'Asset', 85, 'A4Tech', 'Assigned to Carl P. by Raven Ompar', NULL, '2026-06-10 16:11:33'),
(135, 1, 'Administrator', 'approved', 'Assignment', NULL, 'A4Tech → Carl P.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-10 16:11:33'),
(136, 12, 'GayaxPalabs', 'pending', 'Assignment', NULL, 'Inplay → Bembang', 'Create request submitted by GayaxPalabs — awaiting approval', NULL, '2026-06-11 09:10:01'),
(137, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Carl P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-11 09:13:05'),
(138, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-11 09:13:08'),
(139, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-11 09:13:11'),
(140, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-11 09:13:13'),
(141, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-11 09:13:17'),
(142, 12, 'GayaxPalabs', 'pending', 'Assignment', NULL, 'Inplay → Saratos', 'Create request submitted by GayaxPalabs — awaiting approval', NULL, '2026-06-11 09:17:19'),
(143, 1, 'Administrator', 'assigned', 'Asset', 91, 'Inplay', 'Assigned to Saratos by GayaxPalabs', NULL, '2026-06-11 09:17:56'),
(144, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay → Saratos', 'Approved by Administrator: create on Assignment', NULL, '2026-06-11 09:17:56'),
(145, 15, 'Guy Carl Batomalaque Rentuaya', 'received', 'PurchaseOrder', 16, 'PO-20260611-0001', 'Partial receive: 10 asset(s) added by Guy Carl Batomalaque Rentuaya', NULL, '2026-06-11 14:46:52'),
(146, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 92, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(147, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 93, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(148, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 94, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(149, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 95, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(150, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 96, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(151, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 97, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(152, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 98, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(153, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 99, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(154, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 100, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(155, 15, 'Guy Carl Batomalaque Rentuaya', 'updated', 'Asset', 101, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-11 14:47:21'),
(156, 16, 'Juan Dela Cruz', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', 'Create request submitted by Juan Dela Cruz — awaiting approval', NULL, '2026-06-11 14:52:59'),
(157, 1, 'Administrator', 'assigned', 'Asset', 94, 'Inplay Keyboard', 'Assigned to Raven O. by Juan Dela Cruz', NULL, '2026-06-11 14:53:24'),
(158, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-11 14:53:24'),
(159, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-17 08:47:19'),
(160, 1, 'Administrator', 'updated', 'Asset', 102, 'Havit', 'Asset updated: Havit', NULL, '2026-06-17 10:12:47'),
(161, 1, 'Administrator', 'updated', 'Asset', 103, 'Havit', 'Asset updated: Havit', NULL, '2026-06-17 10:12:47'),
(162, 1, 'Administrator', 'updated', 'Asset', 105, 'Havit', 'Asset updated: Havit', NULL, '2026-06-17 10:12:47'),
(163, 1, 'Administrator', 'updated', 'Asset', 104, 'Havit', 'Asset updated: Havit', NULL, '2026-06-17 10:12:47'),
(164, 1, 'Administrator', 'updated', 'Asset', 106, 'Havit', 'Asset updated: Havit', NULL, '2026-06-17 10:12:47'),
(165, 1, 'Administrator', 'assigned', 'Asset', 92, 'Inplay Keyboard', 'Assigned to Raven O. by Zeno Sang', NULL, '2026-06-17 10:13:09'),
(166, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Raven O.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-17 10:13:09'),
(167, 24, 'guy danielo', 'assigned', 'Asset', 95, 'Inplay Keyboard', 'Assigned to Raven O. by Admin', NULL, '2026-06-18 11:50:16'),
(168, 24, 'guy danielo', 'returned', 'Asset', 95, 'Inplay Keyboard', 'Returned by Raven O.', NULL, '2026-06-18 11:50:20'),
(169, 24, 'guy danielo', 'assigned', 'Asset', 97, 'Inplay Keyboard', 'Assigned to Raven O. by Admin', NULL, '2026-06-18 11:57:41'),
(170, 24, 'guy danielo', 'pending', 'Assignment', NULL, 'Havit → Saratos', 'Create request submitted by guy danielo — awaiting approval', NULL, '2026-06-18 12:46:26'),
(171, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Zen P.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-19 08:24:01'),
(172, 1, 'Administrator', 'assigned', 'Asset', 101, 'Inplay Keyboard', 'Assigned to Zen P. by Zeno Sang', NULL, '2026-06-19 08:24:29'),
(173, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Zen P.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-19 08:24:29'),
(174, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-19 10:58:26'),
(175, 1, 'Administrator', 'assigned', 'Asset', 96, 'Inplay Keyboard', 'Assigned to Zeno Sang by Zeno Sang', NULL, '2026-06-19 10:59:12'),
(176, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-19 10:59:12'),
(177, 13, 'Zeno Sang', 'pending', 'Assignment', 100, 'Inplay Keyboard for Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 11:38:43'),
(178, 1, 'Administrator', 'assigned', 'Asset', 100, 'Inplay Keyboard', 'Assigned to Raven O. by Zeno Sang', NULL, '2026-06-20 11:40:45'),
(179, 1, 'Administrator', 'approved', 'Assignment', 100, 'Inplay Keyboard for Raven O.', 'Approved by Administrator: create on Assignment', NULL, '2026-06-20 11:40:45'),
(180, 1, 'Administrator', 'updated', 'Asset', 100, 'Inplay Keyboard', 'Asset updated: Inplay Keyboard', NULL, '2026-06-20 11:42:27'),
(181, 13, 'Zeno Sang', 'pending', 'Assignment', 46, 'Inplay Keyboard — return by Zeno Sang', 'Delete request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 11:52:57'),
(182, 1, 'Administrator', 'approved', 'Assignment', 46, 'Inplay Keyboard — return by Zeno Sang', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-20 11:53:48'),
(183, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 12:03:15'),
(184, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 12:03:15'),
(185, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Havit → Zeno Sang', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 12:03:15'),
(186, 1, 'Administrator', 'assigned', 'Asset', 93, 'Inplay Keyboard', 'Assigned to Zeno Sang by Zeno Sang', NULL, '2026-06-20 12:03:37'),
(187, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-20 12:03:37'),
(188, 1, 'Administrator', 'assigned', 'Asset', 95, 'Inplay Keyboard', 'Assigned to Zeno Sang by Zeno Sang', NULL, '2026-06-20 12:03:39'),
(189, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-20 12:03:39'),
(190, 1, 'Administrator', 'assigned', 'Asset', 102, 'Havit', 'Assigned to Zeno Sang by Zeno Sang', NULL, '2026-06-20 12:03:40'),
(191, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Havit → Zeno Sang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-20 12:03:40'),
(192, 13, 'Zeno Sang', 'pending', 'Assignment', 50, 'Havit — return by Zeno Sang', 'Delete request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 12:04:15'),
(193, 1, 'Administrator', 'reported', 'Asset', 102, 'Havit', 'Damage reported: Damaged — needs repair', NULL, '2026-06-20 12:04:39'),
(194, 1, 'Administrator', 'approved', 'Assignment', 50, 'Havit — return by Zeno Sang', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-20 12:04:39'),
(195, 13, 'Zeno Sang', 'pending', 'Assignment', 49, 'Inplay Keyboard — return by Zeno Sang', 'Delete request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 12:55:25'),
(196, 1, 'Administrator', 'reported', 'Asset', 95, 'Inplay Keyboard', 'Damage reported: Damaged — needs repair', NULL, '2026-06-20 12:55:43'),
(197, 1, 'Administrator', 'approved', 'Assignment', 49, 'Inplay Keyboard — return by Zeno Sang', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-20 12:55:43'),
(198, 13, 'Zeno Sang', 'pending', 'Assignment', 48, 'Inplay Keyboard — return by Zeno Sang', 'Delete request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 15:50:27'),
(199, 1, 'Administrator', 'approved', 'Assignment', 48, 'Inplay Keyboard — return by Zeno Sang', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-20 15:50:50'),
(200, 13, 'Zeno Sang', 'pending', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-06-20 16:21:00'),
(201, 1, 'Administrator', 'assigned', 'Asset', 99, 'Inplay Keyboard', 'Assigned to Zeno Sang by Zeno Sang', NULL, '2026-06-20 16:21:18'),
(202, 1, 'Administrator', 'approved', 'Assignment', NULL, 'Inplay Keyboard → Zeno Sang', 'Approved by Administrator: create on Assignment', NULL, '2026-06-20 16:21:18'),
(203, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'Havit → Saratos', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:27'),
(204, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:29'),
(205, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:30'),
(206, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:32'),
(207, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:34'),
(208, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:36'),
(209, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:37'),
(210, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Bembang', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:41'),
(211, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Zen P.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:43'),
(212, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Dasilay', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:44'),
(213, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:46'),
(214, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Charles', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:48'),
(215, 1, 'Administrator', 'rejected', 'Assignment', NULL, 'A4Tech → Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-06-20 16:21:49'),
(216, 1, 'Administrator', 'disposed', 'Asset', 95, 'Inplay Keyboard', 'Asset disposed: not working', NULL, '2026-06-20 16:29:51'),
(217, 1, 'Administrator', 'disposed', 'Asset', 102, 'Havit', 'Asset disposed: not working', NULL, '2026-06-20 16:30:03'),
(218, 1, 'Administrator', 'reported', 'Asset', 84, 'A4Tech', 'Damage reported: not working', NULL, '2026-06-22 08:47:36'),
(219, 1, 'Administrator', 'updated', 'Asset', 84, 'A4Tech', 'Damage resolved', NULL, '2026-06-22 08:48:02'),
(220, 1, 'Administrator', 'assigned', 'Asset', 93, 'Inplay Keyboard', 'Assigned to Seat #2 by Administrator', NULL, '2026-06-22 13:37:03'),
(221, 1, 'Administrator', 'returned', 'Asset', 81, 'Inplay Headset', 'Returned by Charles', NULL, '2026-06-22 14:15:00'),
(222, 1, 'Administrator', 'returned', 'Asset', 91, 'Inplay', 'Returned by Saratos', NULL, '2026-06-22 14:15:03'),
(223, 1, 'Administrator', 'returned', 'Asset', 79, 'Inplay Headset', 'Returned by Saratos', NULL, '2026-06-22 14:15:04'),
(224, 1, 'Administrator', 'returned', 'Asset', 101, 'Inplay Keyboard', 'Returned by Zen P.', NULL, '2026-06-22 14:15:06'),
(225, 1, 'Administrator', 'returned', 'Asset', 78, 'Inplay Headset', 'Returned by Zen P.', NULL, '2026-06-22 14:15:06'),
(226, 1, 'Administrator', 'returned', 'Asset', 86, 'A4Tech', 'Returned by Carl P.', NULL, '2026-06-22 14:15:11'),
(227, 1, 'Administrator', 'returned', 'Asset', 83, 'A4Tech', 'Returned by Carl P.', NULL, '2026-06-22 14:15:11'),
(228, 1, 'Administrator', 'returned', 'Asset', 85, 'A4Tech', 'Returned by Carl P.', NULL, '2026-06-22 14:15:12'),
(229, 1, 'Administrator', 'returned', 'Asset', 84, 'A4Tech', 'Returned by Dasilay', NULL, '2026-06-22 14:15:14'),
(230, 1, 'Administrator', 'returned', 'Asset', 80, 'Inplay Headset', 'Returned by Dasilay', NULL, '2026-06-22 14:15:15'),
(231, 1, 'Administrator', 'returned', 'Asset', 100, 'Inplay Keyboard', 'Returned by Raven O.', NULL, '2026-06-22 14:15:17'),
(232, 1, 'Administrator', 'returned', 'Asset', 97, 'Inplay Keyboard', 'Returned by Raven O.', NULL, '2026-06-22 14:15:17'),
(233, 1, 'Administrator', 'returned', 'Asset', 92, 'Inplay Keyboard', 'Returned by Raven O.', NULL, '2026-06-22 14:15:18'),
(234, 1, 'Administrator', 'returned', 'Asset', 94, 'Inplay Keyboard', 'Returned by Raven O.', NULL, '2026-06-22 14:15:18'),
(235, 1, 'Administrator', 'returned', 'Asset', 82, 'A4Tech', 'Returned by Bembang', NULL, '2026-06-22 14:23:07'),
(236, 1, 'Administrator', 'returned', 'Asset', 93, 'Inplay Keyboard', 'Returned by Seat #2', NULL, '2026-06-22 14:23:10'),
(237, 1, 'Administrator', 'returned', 'Asset', 99, 'Inplay Keyboard', 'Returned by Zeno Sang', NULL, '2026-06-22 14:23:11'),
(238, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:10'),
(239, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:13'),
(240, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:14'),
(241, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:14'),
(242, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:14'),
(243, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:14'),
(244, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(245, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(246, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(247, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(248, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(249, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 11:32:15'),
(250, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Gadwhen Dollente', 'Approved by Administrator: create on asset_request', NULL, '2026-06-23 11:50:54'),
(251, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Gadwhen Dollente', 'Approved by Administrator: create on asset_request', NULL, '2026-06-23 11:51:05'),
(252, 1, 'Administrator', 'assigned', 'Asset', 78, 'Inplay Headset', 'Assigned to Gadwhen Dollente by Admin', NULL, '2026-06-23 11:56:03'),
(253, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Gadwhen Dollente', 'Approved by Administrator: create on asset_request', NULL, '2026-06-23 11:56:03'),
(254, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-23 13:04:38'),
(255, 1, 'Administrator', 'assigned', 'Asset', 93, 'Inplay Keyboard', 'Assigned to Gadwhen Dollente by Admin', NULL, '2026-06-23 13:05:16'),
(256, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Gadwhen Dollente', 'Approved by Administrator: create on asset_request', NULL, '2026-06-23 13:05:16'),
(257, 1, 'Administrator', 'received', 'PurchaseOrder', 16, 'PO-20260611-0001', 'Partial receive: 5 asset(s) added by Administrator', NULL, '2026-06-23 13:37:08'),
(258, 25, 'Gadwhen Dollente', 'pending', 'Assignment', 53, 'Inplay Headset — return by Gadwhen Dollente', 'Delete request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-24 08:53:38'),
(259, 25, 'Gadwhen Dollente', 'reported', 'Asset', 78, 'Inplay Headset', 'Damage reported: Broken / non-functional: yes', NULL, '2026-06-24 08:53:38'),
(260, 1, 'Administrator', 'reported', 'Asset', 78, 'Inplay Headset', 'Damage reported: Broken / non-functional: yes', NULL, '2026-06-24 08:54:03'),
(261, 1, 'Administrator', 'approved', 'Assignment', 53, 'Inplay Headset — return by Gadwhen Dollente', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-24 08:54:03'),
(262, 1, 'Administrator', 'disposed', 'Asset', 78, 'Inplay Headset', 'Asset disposed: ', NULL, '2026-06-24 08:55:49'),
(263, 25, 'Gadwhen Dollente', 'pending', 'Assignment', 54, 'Inplay Keyboard — return by Gadwhen Dollente', 'Delete request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-24 08:56:56'),
(264, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 08:57:32'),
(265, 1, 'Administrator', 'reported', 'Asset', 93, 'Inplay Keyboard', 'Damage reported: Broken / non-functional: not working', NULL, '2026-06-24 08:57:37'),
(266, 1, 'Administrator', 'approved', 'Assignment', 54, 'Inplay Keyboard — return by Gadwhen Dollente', 'Approved by Administrator: delete on Assignment', NULL, '2026-06-24 08:57:37'),
(267, 1, 'Administrator', 'updated', 'Asset', 93, 'Inplay Keyboard', 'Damage resolved', NULL, '2026-06-24 08:58:20'),
(268, 25, 'Gadwhen Dollente', 'pending', 'asset_request', NULL, 'Gadwhen Dollente', 'Create request submitted by Gadwhen Dollente — awaiting approval', NULL, '2026-06-24 09:19:45'),
(269, 1, 'Administrator', 'assigned', 'Asset', 79, 'Inplay Headset', 'Assigned to Gadwhen Dollente by Admin', NULL, '2026-06-24 09:20:23'),
(270, 1, 'Administrator', 'assigned', 'Asset', 111, 'Inplay Keyboard', 'Assigned to Gadwhen Dollente by Admin', NULL, '2026-06-24 09:20:23'),
(271, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Gadwhen Dollente', 'Approved by Administrator: create on asset_request', NULL, '2026-06-24 09:20:23'),
(272, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:37'),
(273, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:39'),
(274, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:41'),
(275, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:43'),
(276, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:45'),
(277, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:47'),
(278, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:50'),
(279, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Gadwhen Dollente', 'Rejected by Administrator: No reason given', NULL, '2026-06-24 09:20:55'),
(280, 1, 'Administrator', 'updated', 'Asset', 83, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-24 11:42:19'),
(281, 1, 'Administrator', 'updated', 'Asset', 82, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-24 11:42:19'),
(282, 1, 'Administrator', 'updated', 'Asset', 86, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-24 11:42:19'),
(283, 1, 'Administrator', 'updated', 'Asset', 85, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-24 11:42:20'),
(284, 1, 'Administrator', 'updated', 'Asset', 84, 'A4Tech', 'Asset updated: A4Tech', NULL, '2026-06-24 11:42:20'),
(285, 1, 'Administrator', 'disposed', 'Asset', 0, 'Inplay Headset', 'Asset disposed: ', NULL, '2026-06-24 13:21:35'),
(286, 1, 'Administrator', 'reported', 'Asset', 108, 'Inplay Keyboard', 'Damage reported: nmn', NULL, '2026-06-24 13:39:19'),
(287, 26, 'ploy ploy', 'pending', 'asset_request', NULL, 'ploy ploy', 'Create request submitted by ploy ploy — awaiting approval', NULL, '2026-06-25 12:58:11'),
(288, 1, 'Administrator', 'assigned', 'Asset', 86, 'A4Tech Mouse', 'Assigned to ploy ploy by Admin', NULL, '2026-06-25 12:58:35'),
(289, 1, 'Administrator', 'approved', 'asset_request', NULL, 'ploy ploy', 'Approved by Administrator: create on asset_request', NULL, '2026-06-25 12:58:36'),
(290, 13, 'Zeno Sang', 'pending', 'Assignment', 81, 'Inplay Headset for Carl P.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-01 15:20:15'),
(291, 27, 'Raven Ompar', 'assigned', 'Asset', 81, 'Inplay Headset', 'Assigned to Carl P. by Zeno Sang', NULL, '2026-07-01 15:20:51'),
(292, 27, 'Raven Ompar', 'approved', 'Assignment', 81, 'Inplay Headset for Carl P.', 'Approved by Raven Ompar: create on Assignment', NULL, '2026-07-01 15:20:51'),
(293, 1, 'Administrator', 'updated', 'Category', 20, 'Other Assets', 'Category updated: Other Assets', NULL, '2026-07-02 08:46:40'),
(294, 1, 'Administrator', 'created', 'Category', 23, 'Laptop', 'Category created: Laptop', NULL, '2026-07-02 08:47:24'),
(295, 1, 'Administrator', 'created', 'Category', 24, 'Mobile Device', 'Category created: Mobile Device', NULL, '2026-07-02 08:48:29'),
(296, 1, 'Administrator', 'created', 'Category', 25, 'ID & Lanyard', 'Category created: ID & Lanyard', NULL, '2026-07-02 08:48:57'),
(297, 1, 'Administrator', 'updated', 'Category', 25, 'ID & Lanyard', 'Category updated: ID & Lanyard', NULL, '2026-07-02 08:49:26'),
(298, 1, 'Administrator', 'created', 'Category', 26, 'Access Badge/RFID', 'Category created: Access Badge/RFID', NULL, '2026-07-02 08:50:09'),
(299, 1, 'Administrator', 'updated', 'Asset', 112, 'Poly', 'Asset updated: Poly', NULL, '2026-07-02 09:13:31'),
(300, 1, 'Administrator', 'updated', 'Asset', 113, 'Poly', 'Asset updated: Poly', NULL, '2026-07-02 09:13:31'),
(301, 1, 'Administrator', 'updated', 'Asset', 116, 'Poly', 'Asset updated: Poly', NULL, '2026-07-02 09:13:31'),
(302, 1, 'Administrator', 'updated', 'Asset', 115, 'Poly', 'Asset updated: Poly', NULL, '2026-07-02 09:13:31'),
(303, 1, 'Administrator', 'updated', 'Asset', 114, 'Poly', 'Asset updated: Poly', NULL, '2026-07-02 09:13:31'),
(304, 26, 'ploy ploy', 'pending', 'asset_request', NULL, 'ploy ploy', 'Create request submitted by ploy ploy — awaiting approval', NULL, '2026-07-02 09:53:16'),
(305, 27, 'Raven Ompar', 'assigned', 'Asset', 80, 'Inplay Headset', 'Assigned to ploy ploy by Admin', NULL, '2026-07-02 11:53:19'),
(306, 27, 'Raven Ompar', 'approved', 'asset_request', NULL, 'ploy ploy', 'Approved by Raven Ompar: create on asset_request', NULL, '2026-07-02 11:53:19'),
(307, 26, 'ploy ploy', 'pending', 'asset_request', NULL, 'ploy ploy', 'Create request submitted by ploy ploy — awaiting approval', NULL, '2026-07-02 11:54:22'),
(308, 1, 'Administrator', 'approved', 'asset_request', NULL, 'ploy ploy', 'Approved by Administrator: create on asset_request', NULL, '2026-07-02 12:48:12'),
(309, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-02 15:09:24'),
(310, 27, 'Raven Ompar', 'assigned', 'Asset', 116, 'Poly', 'Assigned to Raven O. by Admin', NULL, '2026-07-02 15:10:17'),
(311, 27, 'Raven Ompar', 'approved', 'asset_request', NULL, 'Raven O.', 'Approved by Raven Ompar: create on asset_request', NULL, '2026-07-02 15:10:18'),
(312, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Dasilay', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 08:28:20'),
(313, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 08:29:25'),
(314, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 08:33:52'),
(315, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 08:35:24'),
(316, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 11:46:35'),
(317, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 11:48:42'),
(318, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Raven O.', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 11:48:51'),
(319, 13, 'Zeno Sang', 'pending', 'asset_request', NULL, 'Dasilay', 'Create request submitted by Zeno Sang — awaiting approval', NULL, '2026-07-03 11:55:12'),
(320, 1, 'Administrator', 'assigned', 'Asset', 114, 'Poly', 'Assigned to Dasilay by Admin', NULL, '2026-07-03 11:56:10'),
(321, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Dasilay', 'Approved by Administrator: create on asset_request', NULL, '2026-07-03 11:56:11'),
(322, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:26'),
(323, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:28'),
(324, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:30'),
(325, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:32'),
(326, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:34'),
(327, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Raven O.', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:36'),
(328, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'Dasilay', 'Rejected by Administrator: No reason given', NULL, '2026-07-03 11:58:38'),
(329, 1, 'Administrator', 'assigned', 'Asset', 81, 'Inplay Headset', 'Assigned to Carl P. by Zeno Sang', NULL, '2026-07-03 16:11:37'),
(330, 1, 'Administrator', 'assigned', 'Asset', 81, 'Inplay Headset', 'Assigned to Carl P. by Zeno Sang', NULL, '2026-07-03 16:11:42'),
(331, 27, 'Raven Ompar', 'updated', 'Asset', 82, 'A4Tech Mouse', 'Asset updated: A4Tech Mouse', NULL, '2026-07-07 16:28:11'),
(332, 27, 'Raven Ompar', 'received', 'PurchaseOrder', 22, 'PO-20260709-5050', 'Partial receive: 5 asset(s) added by Raven Ompar', NULL, '2026-07-09 17:42:27'),
(333, 27, 'Raven Ompar', 'received', 'PurchaseOrder', 23, 'PO-20260709-5051', 'Partial receive: 5 asset(s) added by Raven Ompar', NULL, '2026-07-09 17:53:08'),
(334, 27, 'Raven Ompar', 'assigned', 'Asset', 141, 'Scenta', 'Assigned to Seat #25 by Admin', NULL, '2026-07-09 18:00:28'),
(335, 27, 'Raven Ompar', 'assigned', 'Asset', 124, 'Cherry Phone', 'Assigned to Seat #25 by Admin', NULL, '2026-07-09 18:00:28'),
(336, 27, 'Raven Ompar', 'assigned', 'Asset', 134, 'N-Vision Monitor', 'Assigned to Seat #25 by Admin', NULL, '2026-07-09 18:00:28'),
(337, 27, 'Raven Ompar', 'updated', 'Asset', 123, '4Tech Mouse', 'Asset updated: 4Tech Mouse', NULL, '2026-07-09 18:01:11'),
(338, 27, 'Raven Ompar', 'updated', 'Asset', 1, 'A4Tech Mouse', 'Asset updated: A4Tech Mouse', NULL, '2026-07-09 18:01:27'),
(339, 34, 'Fredrin Cici Yz', 'created', 'Asset', 146, 'HP Laptop', 'Asset created: HP Laptop', NULL, '2026-07-10 09:20:04'),
(340, 34, 'Fredrin Cici Yz', 'assigned', 'Asset', 146, 'HP Laptop', 'Assigned to Manolo Palay by Import', NULL, '2026-07-10 09:20:04'),
(341, 34, 'Fredrin Cici Yz', 'created', 'Asset', 147, 'HP Laptop', 'Asset created: HP Laptop', NULL, '2026-07-10 09:20:04'),
(342, 34, 'Fredrin Cici Yz', 'assigned', 'Asset', 147, 'HP Laptop', 'Assigned to Apolinario by Import', NULL, '2026-07-10 09:20:04'),
(343, 34, 'Fredrin Cici Yz', 'created', 'Asset', 148, 'HP Laptop', 'Asset created: HP Laptop', NULL, '2026-07-10 09:20:04'),
(344, 34, 'Fredrin Cici Yz', 'assigned', 'Asset', 148, 'HP Laptop', 'Assigned to Mabini by Import', NULL, '2026-07-10 09:20:04'),
(345, 34, 'Fredrin Cici Yz', 'created', 'Asset', 149, 'HP Laptop', 'Asset created: HP Laptop', NULL, '2026-07-10 09:20:04'),
(346, 34, 'Fredrin Cici Yz', 'assigned', 'Asset', 149, 'HP Laptop', 'Assigned to Rizal by Import', NULL, '2026-07-10 09:20:04'),
(347, 34, 'Fredrin Cici Yz', 'created', 'Asset', 150, 'HP Laptop', 'Asset created: HP Laptop', NULL, '2026-07-10 09:20:04'),
(348, 34, 'Fredrin Cici Yz', 'reported', 'Asset', 150, 'HP Laptop', 'Damage reported: not working.', NULL, '2026-07-10 09:47:18'),
(349, 34, 'Fredrin Cici Yz', 'returned', 'Asset', 115, 'Poly', 'Returned by Kina May', NULL, '2026-07-10 10:27:34');

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

--
-- Dumping data for table `damages`
--

INSERT INTO `damages` (`id`, `product_id`, `category_id`, `location_id`, `reported_by`, `issue`, `status`, `disposal_reason`, `disposed_at`, `donated_to`, `donated_at`, `product_name_cache`, `product_sku_cache`, `created_at`, `updated_at`) VALUES
(19, NULL, 21, 1, 'Administrator', '[Damaged] not working', 'disposed', '', '2026-06-10 06:10:28', NULL, NULL, 'Inplay Headset', '1111', '2026-06-04 16:46:22', '2026-06-10 12:10:28'),
(20, NULL, 14, 2, 'Zeno Sang', 'Damaged — needs repair', 'disposed', 'not working', '2026-06-20 10:30:03', NULL, NULL, 'Havit', 'ererer', '2026-06-20 12:04:39', '2026-06-20 16:30:03'),
(21, NULL, 10, 1, 'Zeno Sang', 'Damaged — needs repair', 'disposed', 'not working', '2026-06-20 10:29:50', NULL, NULL, 'Inplay Keyboard', 'SF4', '2026-06-20 12:55:43', '2026-06-20 16:29:50'),
(22, 84, 14, 1, 'Dasilay', 'not working', 'resolved', '', NULL, '', NULL, 'A4Tech', 'fggggggg', '2026-06-22 08:47:36', '2026-06-22 08:48:02'),
(23, NULL, 21, 1, 'Gadwhen Dollente', 'Broken / non-functional: yes', 'disposed', '', '2026-06-24 07:21:35', NULL, NULL, 'Inplay Headset', '2222', '2026-06-24 08:53:38', '2026-06-24 13:21:35'),
(24, NULL, 21, 1, 'Gadwhen Dollente', 'Broken / non-functional: yes', 'disposed', '', '2026-06-24 02:55:48', NULL, NULL, 'Inplay Headset', '2222', '2026-06-24 08:54:03', '2026-06-24 08:55:48'),
(25, 93, 10, 1, 'Gadwhen Dollente', 'Broken / non-functional: not working', 'resolved', '', NULL, '', NULL, 'Inplay Keyboard', 'SF2', '2026-06-24 08:57:37', '2026-06-24 08:58:18'),
(26, 108, 10, 1, 'Zen Kyuti', 'nmn', 'damaged', NULL, NULL, NULL, NULL, 'Inplay Keyboard', 'opopopop', '2026-06-24 13:39:17', '2026-06-24 13:39:17'),
(27, 150, 23, 1, 'Fred', 'not working.', 'damaged', NULL, NULL, NULL, NULL, 'HP Laptop', 'IMP-MRE90LYU-7KB3WG', '2026-07-10 09:47:18', '2026-07-10 09:47:18');

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

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `employee_id`, `name`, `station`, `seat_number`, `created_at`, `updated_at`, `location_id`) VALUES
(3, '', 'Raven O.', 'JTV', '1', '2026-06-04 16:42:27', '2026-06-04 16:42:27', 1),
(4, 'EMP-02', 'Zen P.', 'WEBY', '45', '2026-06-04 16:57:19', '2026-07-01 10:12:46', 1),
(5, '', 'Carl P.', 'JTV', '20', '2026-06-05 08:23:01', '2026-06-05 08:23:31', 1),
(6, 'EMP-001', 'Saratos', 'WEBY', '4', '2026-06-05 08:31:39', '2026-07-01 10:12:36', 2),
(7, '', 'Dasilay', 'JTV', '2', '2026-06-05 08:31:39', '2026-06-05 08:33:05', 1),
(8, '', 'Bembang', 'WEBY', '6', '2026-06-05 08:34:01', '2026-06-05 08:34:01', 2),
(9, '', 'Charles', 'WEBY', '8', '2026-06-05 11:56:49', '2026-06-05 11:56:49', 2),
(10, '', 'Sir James Vargas', 'AIFI', '', '2026-06-24 13:45:41', '2026-06-24 13:45:41', NULL),
(12, 'NJNJ1123', 'Jaime', '', '', '2026-07-09 16:42:21', '2026-07-09 16:42:21', NULL),
(13, 'JKB23', 'Bancod', '', '', '2026-07-09 17:10:38', '2026-07-09 17:10:38', NULL),
(14, 'LIZ909', 'Liez', '', '', '2026-07-09 17:10:38', '2026-07-09 17:10:38', NULL),
(15, 'SY5678', 'Sam', '', '', '2026-07-09 17:10:38', '2026-07-09 17:10:38', NULL),
(16, 'KOL123123', 'Ky Lee', '', '', '2026-07-09 17:11:30', '2026-07-09 17:11:30', NULL),
(17, 'MW22', 'Maws', '', '', '2026-07-09 18:01:11', '2026-07-09 18:01:11', NULL),
(18, 'KIKI123', 'Monica', '', '', '2026-07-09 18:01:27', '2026-07-09 18:01:27', NULL);

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
(2, 'staff', 10, 'approval_approved', '✅ Your request was approved', 'Create Assignment: Inplay Headset → Saratos', 'items.html', 1, '{\"approval_id\":1,\"decision\":\"approved\"}', '2026-06-05 13:49:15'),
(5, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Carl P.', 'items.html', 1, '{\"approval_id\":3,\"decision\":\"approved\"}', '2026-06-05 14:46:17'),
(6, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Carl P.', 'items.html', 1, '{\"approval_id\":2,\"decision\":\"approved\"}', '2026-06-05 14:46:19'),
(8, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Bembang', 'items.html', 1, '{\"approval_id\":4,\"decision\":\"rejected\"}', '2026-06-05 14:59:01'),
(10, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Bembang', 'items.html', 1, '{\"approval_id\":5,\"decision\":\"approved\"}', '2026-06-05 15:00:22'),
(13, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Dasilay', 'items.html', 1, '{\"approval_id\":6,\"decision\":\"approved\"}', '2026-06-08 16:00:07'),
(36, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech ? Zen P.', 'items.html', 0, '{\"approval_id\":28,\"decision\":\"rejected\"}', '2026-06-10 15:50:10'),
(37, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech ? Zen P.', 'items.html', 0, '{\"approval_id\":27,\"decision\":\"rejected\"}', '2026-06-10 15:50:13'),
(38, 'staff', 11, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech ? Raven O.', 'items.html', 0, '{\"approval_id\":26,\"decision\":\"rejected\"}', '2026-06-10 16:11:20'),
(39, 'staff', 11, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Carl P.', 'items.html', 0, '{\"approval_id\":25,\"decision\":\"approved\"}', '2026-06-10 16:11:33'),
(41, 'staff', 11, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Carl P.', 'requests.html', 0, '{\"approval_id\":23,\"decision\":\"rejected\"}', '2026-06-11 09:13:05'),
(42, 'staff', 11, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":22,\"decision\":\"rejected\"}', '2026-06-11 09:13:08'),
(43, 'staff', 11, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":21,\"decision\":\"rejected\"}', '2026-06-11 09:13:11'),
(44, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":20,\"decision\":\"rejected\"}', '2026-06-11 09:13:13'),
(45, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":19,\"decision\":\"rejected\"}', '2026-06-11 09:13:17'),
(47, 'staff', 12, 'approval_approved', '✅ Your request was approved', 'Create Assignment: Inplay → Saratos', 'requests.html', 1, '{\"approval_id\":30,\"decision\":\"approved\"}', '2026-06-11 09:17:56'),
(49, 'staff', 16, 'approval_approved', '✅ Your request was approved', 'Create Assignment: Inplay Keyboard → Raven O.', 'requests.html', 1, '{\"approval_id\":31,\"decision\":\"approved\"}', '2026-06-11 14:53:24'),
(77, 'staff', 24, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: Havit → Saratos', 'requests.html', 0, '{\"approval_id\":33,\"decision\":\"rejected\"}', '2026-06-20 16:21:27'),
(78, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":18,\"decision\":\"rejected\"}', '2026-06-20 16:21:29'),
(79, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":17,\"decision\":\"rejected\"}', '2026-06-20 16:21:30'),
(80, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":16,\"decision\":\"rejected\"}', '2026-06-20 16:21:32'),
(81, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":15,\"decision\":\"rejected\"}', '2026-06-20 16:21:34'),
(82, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":7,\"decision\":\"rejected\"}', '2026-06-20 16:21:36'),
(83, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":8,\"decision\":\"rejected\"}', '2026-06-20 16:21:37'),
(84, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Bembang', 'requests.html', 0, '{\"approval_id\":9,\"decision\":\"rejected\"}', '2026-06-20 16:21:41'),
(85, 'staff', 10, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Zen P.', 'requests.html', 0, '{\"approval_id\":14,\"decision\":\"rejected\"}', '2026-06-20 16:21:43'),
(86, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Dasilay', 'requests.html', 0, '{\"approval_id\":13,\"decision\":\"rejected\"}', '2026-06-20 16:21:44'),
(87, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":12,\"decision\":\"rejected\"}', '2026-06-20 16:21:46'),
(88, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Charles', 'requests.html', 0, '{\"approval_id\":11,\"decision\":\"rejected\"}', '2026-06-20 16:21:48'),
(89, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Raven O.', 'requests.html', 0, '{\"approval_id\":10,\"decision\":\"rejected\"}', '2026-06-20 16:21:49'),
(123, 'staff', 26, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: ploy ploy', 'requests.html', 1, '{\"approval_id\":61,\"decision\":\"approved\"}', '2026-06-25 12:58:36'),
(127, 'staff', 26, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: ploy ploy', 'requests.html', 1, '{\"approval_id\":63,\"decision\":\"approved\"}', '2026-07-02 11:53:19'),
(129, 'staff', 26, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: ploy ploy', 'requests.html', 1, '{\"approval_id\":64,\"decision\":\"approved\"}', '2026-07-02 12:48:12'),
(150, 'admin', NULL, 'submitted', 'New Account Pending Approval', 'Kina May (kinamay) registered as Viewer and is awaiting your approval.', 'users.html', 1, '{\"user_id\":0,\"action\":\"registration\"}', '2026-07-09 13:41:36'),
(151, 'staff', 0, 'approved', 'Account Approved!', 'Your account has been approved by an admin. You can now sign in.', NULL, 0, '{\"action\":\"account_approved\"}', '2026-07-09 13:44:48'),
(152, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Create asset_request: Kina May', 'approvals.html', 1, '{\"approval_id\":74,\"action_type\":\"create\"}', '2026-07-09 14:11:12'),
(153, 'staff', 0, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: Kina May', 'requests.html', 0, '{\"approval_id\":74,\"decision\":\"approved\"}', '2026-07-09 14:14:26'),
(154, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Delete Assignment: Poly · return by Kina May', 'approvals.html', 1, '{\"approval_id\":75,\"action_type\":\"delete\"}', '2026-07-09 14:14:58'),
(155, 'staff', 0, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Poly · return by Kina May', 'requests.html', 0, '{\"approval_id\":75,\"decision\":\"approved\"}', '2026-07-09 14:15:26'),
(156, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Create asset_request: Kina May', 'approvals.html', 1, '{\"approval_id\":76,\"action_type\":\"create\"}', '2026-07-09 14:16:13'),
(157, 'staff', 0, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: Kina May', 'requests.html', 0, '{\"approval_id\":76,\"decision\":\"approved\"}', '2026-07-09 14:16:42'),
(158, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Delete Assignment: Poly · return by Kina May', 'approvals.html', 1, '{\"approval_id\":77,\"action_type\":\"delete\"}', '2026-07-09 14:17:02'),
(159, 'staff', 0, 'approval_rejected', '✖ Your request was rejected', 'Delete Assignment: Poly · return by Kina May', 'requests.html', 0, '{\"approval_id\":77,\"decision\":\"rejected\"}', '2026-07-09 14:17:19'),
(160, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Delete Assignment: Poly · return by Kina May', 'approvals.html', 1, '{\"approval_id\":78,\"action_type\":\"delete\"}', '2026-07-09 14:17:37'),
(161, 'staff', 0, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: Poly · return by Kina May', 'requests.html', 0, '{\"approval_id\":78,\"decision\":\"approved\"}', '2026-07-09 14:17:51'),
(162, 'admin', NULL, 'approval_submitted', 'New approval request from Kina May', 'Create asset_request: Kina May', 'approvals.html', 1, '{\"approval_id\":79,\"action_type\":\"create\"}', '2026-07-09 14:18:18'),
(163, 'staff', 0, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: Kina May', 'requests.html', 0, '{\"approval_id\":79,\"decision\":\"approved\"}', '2026-07-09 14:18:37');

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
(1, 'A4Tech Mouse', 'KK0909', 'A4Tech Plus', 'A4Tech', 'Plus', 'Monica', 'KIKI123', '', 14, NULL, 'Empire One', '2025-03-22', NULL, 1, 1, 'assigned', NULL, NULL, NULL, NULL, '2026-07-07 16:49:56', '2026-07-08 13:13:02'),
(79, 'Inplay Headset', '3333', 'InPlay', 'InPlay', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, '3333', 10, 9, '2026-06-04 16:44:11', '2026-07-07 16:42:05'),
(80, 'Inplay Headset', '4444', 'InPlay', 'InPlay', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, '4444', 10, 9, '2026-06-04 16:44:11', '2026-07-07 16:42:05'),
(81, 'Inplay Headset', '5555', 'InPlay', 'InPlay', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, '5555', 10, 9, '2026-06-04 16:44:11', '2026-07-07 16:42:05'),
(82, 'A4Tech Mouse', 'ssssssss', 'A4Tech Plus', 'A4Tech', 'Plus', 'Ky Lee', 'KOL123123', '', 14, NULL, 'Empire One', NULL, NULL, 1, 1, 'assigned', NULL, 'ssssssss', 11, 10, '2026-06-05 14:44:45', '2026-07-08 14:11:33'),
(83, 'A4Tech Mouse', 'dddddddd', 'A4Tech Plus', 'A4Tech', 'Plus', NULL, NULL, '', 14, NULL, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'dddddddd', 11, 10, '2026-06-05 14:44:45', '2026-07-08 14:11:33'),
(84, 'A4Tech Mouse', 'fggggggg', 'A4Tech Plus', 'A4Tech', 'Plus', NULL, NULL, '', 14, NULL, NULL, NULL, NULL, 1, 1, 'available', NULL, 'fggggggg', 11, 10, '2026-06-05 14:44:45', '2026-07-07 23:07:54'),
(85, 'A4Tech Mouse', 'bbbbbbb', 'A4Tech Plus', 'A4Tech', 'Plus', NULL, NULL, '', 14, NULL, NULL, NULL, NULL, 1, 1, 'available', NULL, 'bbbbbbb', 11, 10, '2026-06-05 14:44:45', '2026-07-07 23:07:54'),
(86, 'A4Tech Mouse', 'wwwwww', 'A4Tech Plus', 'A4Tech', 'Plus', NULL, NULL, '', 14, NULL, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'wwwwww', 11, 10, '2026-06-05 14:44:46', '2026-07-07 23:07:54'),
(87, 'Inplay', 'ASDASDASD', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'ASDASDASD', 15, 14, '2026-06-10 16:17:50', '2026-06-10 16:17:50'),
(88, 'Inplay', 'DSVDFD', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'DSVDFD', 15, 14, '2026-06-10 16:17:50', '2026-06-10 16:17:50'),
(89, 'Inplay', 'CVBDERGFD', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'CVBDERGFD', 15, 14, '2026-06-10 16:17:50', '2026-06-10 16:17:50'),
(90, 'Inplay', 'RFDSERFCDD', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'RFDSERFCDD', 15, 14, '2026-06-10 16:17:50', '2026-06-10 16:17:50'),
(91, 'Inplay', 'ERFDCSERF', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'ERFDCSERF', 15, 14, '2026-06-10 16:17:50', '2026-06-22 14:15:03'),
(92, 'Inplay Keyboard', 'SF1', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF1', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(93, 'Inplay Keyboard', 'SF2', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF2', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(94, 'Inplay Keyboard', 'SF3', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF3', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(96, 'Inplay Keyboard', 'SF5', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF5', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(97, 'Inplay Keyboard', 'SF6', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF6', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(98, 'Inplay Keyboard', 'SF7', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF7', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(99, 'Inplay Keyboard', 'SF8', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF8', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(100, 'Inplay Keyboard', 'SF9', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF9', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(101, 'Inplay Keyboard', 'SF10', 'iNPLAY', 'iNPLAY', NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'SF10', 16, 15, '2026-06-11 14:46:52', '2026-07-07 16:42:05'),
(103, 'Havit', 'dfdfdf', 'Havit', 'Havit', NULL, NULL, NULL, '', 14, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'dfdfdf', 17, 16, '2026-06-17 10:11:27', '2026-07-07 16:42:05'),
(104, 'Havit', 'ghghgh', 'Havit', 'Havit', NULL, NULL, NULL, '', 14, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'ghghgh', 17, 16, '2026-06-17 10:11:27', '2026-07-07 16:42:05'),
(105, 'Havit', 'nbnbnb', 'Havit', 'Havit', NULL, NULL, NULL, '', 14, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'nbnbnb', 17, 16, '2026-06-17 10:11:27', '2026-07-07 16:42:05'),
(106, 'Havit', 'hhhjjj', 'Havit', 'Havit', NULL, NULL, NULL, '', 14, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'hhhjjj', 17, 16, '2026-06-17 10:11:27', '2026-07-07 16:42:05'),
(107, 'Inplay Keyboard', '090909', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, '090909', 16, 15, '2026-06-23 13:37:08', '2026-06-23 13:37:08'),
(108, 'Inplay Keyboard', 'opopopop', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'under_repair', NULL, 'opopopop', 16, 15, '2026-06-23 13:37:08', '2026-06-24 13:39:19'),
(109, 'Inplay Keyboard', 'kjkjkjk', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'kjkjkjk', 16, 15, '2026-06-23 13:37:08', '2026-06-23 13:37:08'),
(110, 'Inplay Keyboard', 'hjhjhj', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'hjhjhj', 16, 15, '2026-06-23 13:37:08', '2026-06-23 13:37:08'),
(111, 'Inplay Keyboard', 'hjhjhjgggg', NULL, NULL, NULL, NULL, NULL, '', 10, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'hjhjhjgggg', 16, 15, '2026-06-23 13:37:08', '2026-06-24 09:20:23'),
(112, 'Poly', 'rtrtrtrt', 'Poly', 'Poly', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'rtrtrtrt', 19, 18, '2026-07-02 09:13:05', '2026-07-08 13:12:35'),
(113, 'Poly', 'fgfgfgfg', 'Poly', 'Poly', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'fgfgfgfg', 19, 18, '2026-07-02 09:13:05', '2026-07-08 13:12:35'),
(114, 'Poly', 'hjhjhjhj', 'Poly', 'Poly', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'hjhjhjhj', 19, 18, '2026-07-02 09:13:05', '2026-07-07 16:42:05'),
(115, 'Poly', 'nmnmnmnm', 'Poly', 'Poly', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'available', NULL, 'nmnmnmnm', 19, 18, '2026-07-02 09:13:05', '2026-07-10 10:27:34'),
(116, 'Poly', 'dsdsdsds', 'Poly', 'Poly', NULL, NULL, NULL, '', 21, 1, NULL, NULL, NULL, 1, 1, 'assigned', NULL, 'dsdsdsds', 19, 18, '2026-07-02 09:13:05', '2026-07-07 16:42:05'),
(117, 'A4Tech Mouse', 'LK409', 'A4Tech Minus', 'A4Tech', 'Minus', 'Liez', 'LIZ909', '', 14, NULL, 'Empire One', NULL, NULL, 1, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-07 23:33:37', '2026-07-07 23:33:37'),
(118, 'Firewolf Keyboard', 'PO890', 'Firewolf Plus', 'Firewolf', 'Plus', 'JJ', 'J890', '', 10, 1, 'Empire One', '2025-02-07', NULL, 2, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-07 23:41:08', '2026-07-07 23:44:37'),
(119, 'Huawei Laptop', 'JI8989', 'Huawei Ultra', 'Huawei', 'Ultra', 'Whaaa', 'WHA789', '', 23, NULL, 'Empire One', '2025-12-04', NULL, 8, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-07 23:46:03', '2026-07-07 23:46:03'),
(120, 'Dell Headset', 'KS678', 'Dell HS', 'Dell', 'HS', 'Sam', 'SY5678', '', 21, NULL, 'Empire One', '2026-03-23', NULL, 1, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-07 23:50:27', '2026-07-08 09:08:26'),
(121, 'Dell Laptop', 'KO123123', 'Dell Pro', 'Dell', 'Pro', 'Fredericko Batomalaque', 'FD123123', '', 23, NULL, 'Empire One', '2026-04-24', NULL, 1, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-08 09:07:33', '2026-07-08 09:08:38'),
(122, 'inplay Headset', 'INK123', 'inplay Pro', 'inplay', 'Pro', 'Sampol', 'SMP123', '', 21, NULL, 'Empire One', '2026-07-08', NULL, 1, 1, 'available', NULL, NULL, NULL, NULL, '2026-07-08 09:11:10', '2026-07-08 09:11:10'),
(123, '4Tech Mouse', 'JAKSJD123', '4Tech Minus', '4Tech', 'Minus', 'Maws', 'MW22', '', 14, NULL, 'Empire One', '2026-07-08', NULL, 2, 1, 'spare', NULL, NULL, NULL, NULL, '2026-07-08 09:12:18', '2026-07-08 11:10:08'),
(124, 'Cherry Phone', 'OK12', 'Cherry Mobile Ultra Pro Max', 'Cherry Mobile', 'Ultra Pro Max', '', '', '', 24, NULL, 'Empire One', '2026-07-08', NULL, 1, 1, 'assigned', NULL, NULL, NULL, NULL, '2026-07-08 09:36:57', '2026-07-09 18:00:28'),
(125, 'Bassus RJMAH', 'INAY123-1783474963117-b55r', 'Bassus RJMAH', NULL, NULL, '', '', 'Bassus Headset', NULL, 1, NULL, '0000-00-00', NULL, NULL, 1, 'available', NULL, 'INAY123', NULL, NULL, '2026-07-08 09:42:43', '2026-07-08 09:42:43'),
(126, 'Msi Pro', 'JKKJK12-1783474963185-m1s2', 'Msi Pro', NULL, NULL, 'CRL123', '', 'Msi Mouse', 14, 1, NULL, '0000-00-00', NULL, NULL, 1, 'available', NULL, 'JKKJK12', NULL, NULL, '2026-07-08 09:42:43', '2026-07-08 09:42:43'),
(127, 'Bassus XR', 'HAHA122-1783476450161-uygx', 'Bassus XR', NULL, NULL, '', '', 'Bassus Laptop', 23, 1, NULL, '2024-01-15', NULL, 1, 1, 'available', NULL, 'HAHA122', NULL, NULL, '2026-07-08 10:07:30', '2026-07-08 10:07:30'),
(128, 'Pla Plo', 'IM12-1783476450215-fr6s', 'Pla Plo', NULL, NULL, 'Carl', 'RVN123', 'Pla Mouse', 14, NULL, NULL, '2024-01-15', NULL, 2, 1, 'available', NULL, 'IM12', NULL, NULL, '2026-07-08 10:07:30', '2026-07-08 10:07:30'),
(129, 'Kilo Mouse', 'IMP-MRBGOQGZ-XJQ8CG', 'Kilobolt Sniper', 'Kilobolt', 'Sniper', '', '', 'Kilo Mouse', 14, 1, NULL, '2024-01-15', NULL, 1, 1, 'available', NULL, 'yuiop1212', NULL, NULL, '2026-07-08 10:31:29', '2026-07-08 10:31:29'),
(130, 'Samsung Headset', 'IMP-MRBGOQIH-0MXWMZ', 'Samsung KKL', 'Samsung', 'KKL', 'Ompar', 'JJJ111', 'Samsung Headset', NULL, 1, NULL, '2024-01-15', NULL, 2, 1, 'assigned', NULL, 'LKJH678', NULL, NULL, '2026-07-08 10:31:29', '2026-07-08 10:31:29'),
(131, 'Bike Mouse', 'IMP-MRBGYGKO-MUAPKU', 'Bicycle Sniper', 'Bicycle', 'Sniper', '', '', 'Bike Mouse', 14, 1, NULL, '2024-01-15', NULL, 1, 1, 'available', NULL, 'YUIOIUY1', NULL, NULL, '2026-07-08 10:39:02', '2026-07-08 10:39:02'),
(132, 'Bike Mouse', 'IMP-MRBGYGMF-N8S9KY', 'Bicycle Sniper', 'Bicycle', 'Sniper', 'Bancod', 'JKB23', 'Bike Mouse', 14, 1, NULL, '2024-01-15', NULL, 2, 1, 'available', NULL, 'YUIOPOIUY2', NULL, NULL, '2026-07-08 10:39:02', '2026-07-08 10:39:02'),
(133, 'Bike Mouse', 'IMP-MRBGYGQ9-W91HLS', 'Bicycle Sniper', 'Bicycle', 'Sniper', '', '', 'Bike Mouse', 14, 1, NULL, '2024-01-15', NULL, 8, 1, 'available', NULL, 'YUIOPOIU3', NULL, NULL, '2026-07-08 10:39:03', '2026-07-08 10:39:03'),
(134, 'N-Vision Monitor', 'AHSDJ123123', 'N-Vision Awesome', 'N-Vision', 'Awesome', 'Jaime', 'NJNJ1123', '', 13, 1, 'Empire One', '2026-07-09', NULL, 1, 1, 'assigned', NULL, NULL, NULL, NULL, '2026-07-09 14:23:37', '2026-07-09 18:00:28'),
(135, 'N-Vision Monitor', 'MX12345', 'N-Vision Max', 'N-Vision', 'Max', NULL, NULL, '', 13, 1, 'Empire One', '2026-07-09', '2026-07-24 15:22:00', 2, 1, 'damaged', NULL, NULL, NULL, NULL, '2026-07-09 15:23:00', '2026-07-09 15:28:24'),
(136, 'Pliers', 'MMMM1111', NULL, NULL, NULL, NULL, NULL, '', 15, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'MMMM1111', 22, 20, '2026-07-09 17:42:27', '2026-07-09 17:42:27'),
(137, 'Pliers', 'MMMM2222', NULL, NULL, NULL, NULL, NULL, '', 15, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'MMMM2222', 22, 20, '2026-07-09 17:42:27', '2026-07-09 17:42:27'),
(138, 'Pliers', 'MMMM3333', NULL, NULL, NULL, NULL, NULL, '', 15, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'MMMM3333', 22, 20, '2026-07-09 17:42:27', '2026-07-09 17:42:27'),
(139, 'Pliers', 'MMMMM4444', NULL, NULL, NULL, NULL, NULL, '', 15, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'MMMMM4444', 22, 20, '2026-07-09 17:42:27', '2026-07-09 17:42:27'),
(140, 'Pliers', 'MMMM5555', NULL, NULL, NULL, NULL, NULL, '', 15, 1, NULL, NULL, NULL, 2, 1, 'available', NULL, 'MMMM5555', 22, 20, '2026-07-09 17:42:27', '2026-07-09 17:42:27'),
(141, 'Scenta', 'PHk', 'Scenta PH', 'Scenta', 'PH', NULL, NULL, 'Scenta Mouse', 14, 1, NULL, '2026-07-09', NULL, 1, 1, 'assigned', NULL, 'PHk', 23, 21, '2026-07-09 17:53:08', '2026-07-09 18:00:28'),
(142, 'Scenta', 'PHj', 'Scenta PH', 'Scenta', 'PH', NULL, NULL, 'Scenta Mouse', 14, 1, NULL, '2026-07-09', NULL, 1, 1, 'available', NULL, 'PHj', 23, 21, '2026-07-09 17:53:08', '2026-07-09 17:53:08'),
(143, 'Scenta', 'PHl', 'Scenta PH', 'Scenta', 'PH', NULL, NULL, 'Scenta Mouse', 14, 1, NULL, '2026-07-09', NULL, 1, 1, 'available', NULL, 'PHl', 23, 21, '2026-07-09 17:53:08', '2026-07-09 17:53:08'),
(144, 'Scenta', 'PHg', 'Scenta PH', 'Scenta', 'PH', NULL, NULL, 'Scenta Mouse', 14, 1, NULL, '2026-07-09', NULL, 1, 1, 'available', NULL, 'PHg', 23, 21, '2026-07-09 17:53:08', '2026-07-09 17:53:08'),
(145, 'Scenta', 'PHa', 'Scenta PH', 'Scenta', 'PH', NULL, NULL, 'Scenta Mouse', 14, 1, NULL, '2026-07-09', NULL, 1, 1, 'available', NULL, 'PHa', 23, 21, '2026-07-09 17:53:08', '2026-07-09 17:53:08'),
(146, 'HP Laptop', 'IMP-MRE90LQV-RSNH1X', 'HP 2006Pro', 'HP', '2006Pro', 'Manolo Palay', 'BAKS23', 'HP Laptop', 23, 1, NULL, '2025-03-02', NULL, 1, 1, 'assigned', NULL, 'ahsjdkjn1221', NULL, NULL, '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(147, 'HP Laptop', 'IMP-MRE90LTQ-P46VLQ', 'HP 2006Pro', 'HP', '2006Pro', 'Apolinario', 'Apjasjd', 'HP Laptop', 23, 1, NULL, '2025-03-03', NULL, 1, 1, 'assigned', NULL, 'uausdn1212', NULL, NULL, '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(148, 'HP Laptop', 'IMP-MRE90LVO-620F4I', 'HP 2006Pro', 'HP', '2006Pro', 'Mabini', 'MB812738', 'HP Laptop', 23, 1, NULL, '2025-03-04', NULL, 1, 1, 'assigned', NULL, 'asnsma1212', NULL, NULL, '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(149, 'HP Laptop', 'IMP-MRE90LXD-1ZBCD3', 'HP 2006Pro', 'HP', '2006Pro', 'Rizal', 'RIZZ912391293', 'HP Laptop', 23, 1, NULL, '2025-03-05', NULL, 1, 1, 'assigned', NULL, 'masid0ao098789', NULL, NULL, '2026-07-10 09:20:04', '2026-07-10 09:20:04'),
(150, 'HP Laptop', 'IMP-MRE90LYU-7KB3WG', 'HP 2006Pro', 'HP', '2006Pro', '', '', 'HP Laptop', 23, 1, NULL, '2025-03-06', NULL, 1, 1, 'under_repair', NULL, 'masmdk8282', NULL, NULL, '2026-07-10 09:20:04', '2026-07-10 09:47:18');

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

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`id`, `po_number`, `supplier_id`, `order_date`, `expected_date`, `total_amount`, `status`, `notes`, `location_id`, `created_by`, `received_by`, `received_date`, `created_at`, `updated_at`) VALUES
(10, 'PO-20260604-0001', 1, '2026-06-04', '2026-06-04', 1000.00, 'received', NULL, 1, 'Administrator', 'Administrator', '2026-06-04 16:44:10', '2026-06-04 16:43:44', '2026-06-04 16:44:10'),
(11, 'PO-20260605-0001', 1, '2026-06-05', '2026-06-05', 1250.00, 'received', NULL, 1, 'Administrator', 'Administrator', '2026-06-05 14:44:45', '2026-06-05 14:44:27', '2026-06-05 14:44:45'),
(12, 'PO-20260608-0001', 1, '2026-06-08', '2026-06-08', 30000.00, 'pending_receive', NULL, 1, 'Chowking', NULL, NULL, '2026-06-08 12:27:28', '2026-06-08 13:41:14'),
(13, 'PO-20260608-0002', 1, '2026-06-08', '2026-06-08', 10000.00, 'pending_receive', NULL, 1, 'Chowking', NULL, NULL, '2026-06-08 13:42:18', '2026-06-08 13:42:58'),
(14, 'PO-20260608-0003', 1, '2026-06-08', '2026-06-08', 9000.00, 'pending_receive', NULL, 1, 'Administrator', NULL, NULL, '2026-06-08 13:44:10', '2026-06-08 13:44:19'),
(15, 'PO-20260608-0004', 1, '2026-06-08', '2026-06-08', 1500.00, 'received', NULL, 2, 'Administrator', 'Administrator', '2026-06-10 16:17:50', '2026-06-08 13:47:29', '2026-06-10 16:17:50'),
(16, 'PO-20260611-0001', 1, '2026-06-11', '2026-07-17', 14000.00, 'pending_receive', NULL, 1, 'Guy Carl Batomalaque Rentuaya', NULL, NULL, '2026-06-11 14:45:04', '2026-06-11 14:45:56'),
(17, 'PO-20260617-0001', 1, '2026-06-17', '2026-06-17', 1500.00, 'received', NULL, 2, 'Zeno Sang', 'Administrator', '2026-06-17 10:11:27', '2026-06-17 10:10:21', '2026-06-17 10:11:27'),
(18, 'PO-20260618-0001', 1, '2026-06-18', '2026-06-30', 16000.00, 'pending_receive', NULL, 1, 'guy danielo', NULL, NULL, '2026-06-18 11:49:37', '2026-07-09 17:16:33'),
(19, 'PO-20260702-0001', 1, '2026-07-02', '2026-07-02', 15000.00, 'received', NULL, 1, 'Administrator', 'Administrator', '2026-07-02 09:13:05', '2026-07-02 09:12:38', '2026-07-02 09:13:05'),
(20, 'PO-20260709-0001', 1, '2026-07-09', '2026-07-09', 20000.00, 'pending_receive', NULL, 1, 'Raven Ompar', NULL, NULL, '2026-07-09 17:15:23', '2026-07-09 17:35:45'),
(22, 'PO-20260709-5050', 1, '2026-07-09', '2026-07-09', 400000.00, 'pending_receive', NULL, 2, 'Raven Ompar', NULL, NULL, '2026-07-09 17:41:41', '2026-07-09 17:41:53'),
(23, 'PO-20260709-5051', 1, '2026-07-09', '2026-07-09', 4000.00, 'pending_receive', NULL, 1, 'Raven Ompar', NULL, NULL, '2026-07-09 17:52:39', '2026-07-09 17:52:41');

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

--
-- Dumping data for table `purchase_order_items`
--

INSERT INTO `purchase_order_items` (`id`, `po_id`, `product_name`, `brand`, `model`, `description`, `sku`, `category_id`, `quantity`, `unit_price`, `total_price`, `created_at`) VALUES
(9, 10, 'Inplay Headset', NULL, NULL, NULL, NULL, 21, 5, 200.00, 1000.00, '2026-06-04 16:43:44'),
(10, 11, 'A4Tech', NULL, NULL, NULL, NULL, 14, 5, 250.00, 1250.00, '2026-06-05 14:44:27'),
(11, 12, 'Trendsonic', NULL, NULL, NULL, NULL, 15, 10, 3000.00, 30000.00, '2026-06-08 12:27:28'),
(12, 13, 'N Vision', NULL, NULL, NULL, NULL, 13, 5, 2000.00, 10000.00, '2026-06-08 13:42:19'),
(13, 14, 'Secure Comp', NULL, NULL, NULL, NULL, 22, 3, 3000.00, 9000.00, '2026-06-08 13:44:10'),
(14, 15, 'Inplay', NULL, NULL, NULL, NULL, 10, 5, 300.00, 1500.00, '2026-06-08 13:47:30'),
(15, 16, 'Inplay Keyboard', NULL, NULL, NULL, NULL, 10, 40, 350.00, 14000.00, '2026-06-11 14:45:04'),
(16, 17, 'Havit', NULL, NULL, NULL, NULL, NULL, 5, 300.00, 1500.00, '2026-06-17 10:10:21'),
(17, 18, 'A4Tech', NULL, NULL, NULL, NULL, 10, 20, 800.00, 16000.00, '2026-06-18 11:49:37'),
(18, 19, 'Poly', NULL, NULL, NULL, NULL, 21, 5, 3000.00, 15000.00, '2026-07-02 09:12:38'),
(19, 0, 'Secure', NULL, NULL, NULL, NULL, 22, 10, 2000.00, 20000.00, '2026-07-09 17:15:23'),
(20, 22, 'Pliers', NULL, NULL, NULL, NULL, 15, 10, 40000.00, 400000.00, '2026-07-09 17:41:41'),
(21, 23, 'Scenta', 'Scenta', 'PH', 'Scenta Mouse', NULL, 14, 10, 400.00, 4000.00, '2026-07-09 17:52:39');

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
(1, 'Empire One', 'Jaime Bayking', 'jaime@mail.com', '09123456789', 'SCC., Neg. Occ.', 'active', '2026-05-12 11:09:45', '2026-07-09 17:13:48'),
(2, 'JJSupplies', 'JJ Montenegro', 'jj@mail.com', '0956765567', 'San Carlos City, Neg. Occ.', 'inactive', '2026-07-09 17:14:31', '2026-07-09 17:14:34');

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

--
-- Dumping data for table `team_structure`
--

INSERT INTO `team_structure` (`id`, `user_id`, `employee_id`, `created_at`) VALUES
(1, 13, 5, '2026-06-20 09:47:54'),
(2, 13, 7, '2026-06-20 09:47:54'),
(3, 13, 3, '2026-06-20 09:47:54'),
(4, 7, 6, '2026-06-20 11:27:11'),
(5, 7, 4, '2026-06-20 11:27:11'),
(8, 23, 8, '2026-06-22 14:17:26'),
(9, 20, 10, '2026-06-24 13:45:54'),
(10, 32, 13, '2026-07-09 17:10:38'),
(11, 32, 14, '2026-07-09 17:10:38'),
(12, 32, 15, '2026-07-09 17:10:38'),
(13, 32, 9, '2026-07-09 17:10:48'),
(14, 32, 12, '2026-07-09 17:10:48'),
(15, 32, 16, '2026-07-09 17:11:30'),
(16, 23, 17, '2026-07-09 18:01:11'),
(17, 23, 18, '2026-07-09 18:01:27');

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
  `status` enum('pending','active','rejected') NOT NULL DEFAULT 'active',
  `position` varchar(100) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `employee_id`, `username`, `password`, `role`, `status`, `position`, `email`, `contact_number`, `created_at`) VALUES
(1, 'Administrator', NULL, 'admin', '$2y$12$FdA5C5NYevN7TSiifC33PuO3tJlBRzEgp66xinQyBOiizYvCtBBo6', 'admin', 'active', NULL, NULL, NULL, '2026-05-13 06:52:48'),
(3, 'Raven', NULL, 'raven', '$2y$12$Bq0LXagE.Xsx2kMTqNHoQ.UIHfgbzlsDxmda/SkROkJczt48sJ6XC', 'admin', 'active', NULL, NULL, NULL, '2026-05-14 05:00:59'),
(4, 'Zen P.', NULL, 'zen', '$2y$12$ZxqhYXWm8Mjx5HaCs43o0uSppEHxb0HTJYFOU9gvtj4SgxahFsWNW', 'staff', 'active', NULL, NULL, NULL, '2026-05-14 05:03:18'),
(5, 'Ven V', NULL, 'Vennn', '$2y$12$ZWmGjYgKhKjJkRLwRpo6fuwjzvdhbehg8mdc1ycMe2.2BV6FFOa32', 'viewer', 'active', NULL, NULL, NULL, '2026-05-19 04:30:31'),
(6, 'Carl V', NULL, 'carltzy', '$2y$12$v2Omp6kAZvuHb6FLdDkeVuMcfFG7jDJHLaOKq5TfmXctO/69XELgm', 'admin', 'active', NULL, NULL, NULL, '2026-06-02 07:04:29'),
(7, 'Gayo', NULL, 'gayo', '$2y$12$T6L6b59Tc0dd5OZlLMAED.Vq3UMcyYLqlC5aPMuf0I5Xjmxgs9Cwi', 'viewer', 'active', NULL, NULL, NULL, '2026-06-05 00:52:05'),
(8, 'Chowking', NULL, 'chowk', '$2y$12$IHuvEkz24Bu/GdDaunAReO9AOBkXYVlJWIf3WmxPz1CSqh/BgAJ9S', 'staff', 'active', NULL, NULL, NULL, '2026-06-05 00:52:32'),
(9, 'Zen Angelo Palay', NULL, 'zenzen', '$2y$12$bsPdLk4v2SeklATADcvPiezLmi8lee4tXUz7nZ.yJVp8Pqn.zkZUa', 'viewer', 'active', NULL, NULL, NULL, '2026-06-05 05:05:38'),
(10, 'Zen Angelo Palay', NULL, 'zenstaff', '$2y$12$WXE41KE.cq8M4qATJ87y9.1QRduXV9LWJ79FbFjDBXIgwIyPsrdgO', 'staff', 'active', NULL, NULL, NULL, '2026-06-05 05:11:20'),
(11, 'Raven Ompar', NULL, 'ven', '$2y$12$ANcfAkj7vMNIx/gQmpPot.nsrA69G3BCCNidMLLFUEKmqWUsouFz.', 'staff', 'active', NULL, NULL, NULL, '2026-06-10 04:32:14'),
(12, 'GayaxPalabs', NULL, 'gayax', '$2y$12$Yv3A.hCDtGZYgiDJpssJte1NVA.ATnhFy1jo0l5pWYj0g5eNP1y96', 'staff', 'active', NULL, NULL, NULL, '2026-06-11 00:54:22'),
(13, 'Zeno Sang', NULL, 'zeno', '$2y$12$a9p5crxSMBeN/c7sXOJMROpDVqh/nLhFdK9BsrXYdwvK5vPy5xrIW', 'viewer', 'active', NULL, NULL, NULL, '2026-06-11 03:32:59'),
(14, 'Zen Angelo Palay', NULL, 'zenadmin', '$2y$12$kAjRgYRuhU4f87GWvptU7e3yOi221kpCQhRFZk3iAwbc0lQN7rWD.', 'viewer', 'active', NULL, NULL, NULL, '2026-06-11 06:40:27'),
(15, 'Guy Carl Batomalaque Rentuaya', NULL, 'guyadmin', '$2y$12$nJThXrcoplk0vIKkBJ4pW.LNZK6mHEO4EELOThQuaXt54N00ljO1i', 'admin', 'active', NULL, NULL, NULL, '2026-06-11 06:41:32'),
(16, 'Juan Dela Cruz', NULL, 'juan', '$2y$12$gFg8xAcHv7JhYU7VZmZk1.Q9xOBVp8Wtlfto8V6Z1nXUdwECOPMeu', 'staff', 'active', NULL, NULL, NULL, '2026-06-11 06:51:08'),
(20, 'Ompar Kah', NULL, 'ompar', '$2y$12$OvVUVy4GF1JuQ4u3XJ6lUO7uj/B4zI.qtwQIGxXAY.EEWMdQrsXNW', 'viewer', 'active', NULL, NULL, NULL, '2026-06-17 06:13:01'),
(21, 'Bembem', '243234234234234', 'bembemm', '$2y$12$Pxa70GqELK42wQk0oD4IDuYH.PINsGLEKIAQ0VL5vJTexyHzWbIM.', 'staff', 'active', 'HR', NULL, NULL, '2026-06-18 02:58:09'),
(22, 'guy dan', NULL, 'guystaff', '$2y$12$vtHRpVewzH5kVqQVetHHTemuaISvKjaTR7zLArs4O1CEIpYGFtVt6', 'staff', 'active', NULL, NULL, NULL, '2026-06-18 03:28:54'),
(23, 'guy daniel', NULL, 'guysv', '$2y$12$1Xd3nutDTVYuYhMZMcBpFeDF4PsJQKR1YbD0MxSLylvVNzVlOUBDO', 'viewer', 'active', NULL, NULL, NULL, '2026-06-18 03:29:18'),
(24, 'guy danielo', NULL, 'guymanager', '$2y$12$nAj/MuQpqE02oxGhV7ZAGOuBPNhgdVUWcPzQd7pGkMGaQCgWu94Ia', 'manager', 'active', NULL, NULL, NULL, '2026-06-18 03:29:38'),
(25, 'Gadwhen Dollente', NULL, 'gadwhen', '$2y$12$6z8yhq/vBRPMmKA5d8ZV2eQMW7f2/A5xLwroAW8R.IDyejs8DsENK', 'staff', 'active', NULL, 'gadwhen@mail.com', '0945678909876', '2026-06-23 03:02:22'),
(26, 'ploy ploy', NULL, 'ploy', '$2y$12$x.tOhS/opf.Ym3qHByQQP.TsJ3zf0KJB1QKPcNBJNlpiLXrzAwV2i', 'viewer', 'active', 'Team Leader', 'ploy@mail.com', '09456781123', '2026-06-25 04:42:46'),
(27, 'Raven Ompar', NULL, 'qwerty', '$2y$12$qv0ekfRlW5I2t562Qa2k9eSOHp6oKV5aP8fEYDa5OQSrsemu6cTnq', 'admin', 'active', 'IT Staff', 'rayvenompar@gmail.com', '09631719419', '2026-06-30 05:33:46'),
(28, 'Nilo Butay', '0961616161', 'nilo', '$2y$12$JORmVmRwvs/I8WB.LnsQoeA/ns0rD.6XjEztS0iJt9ByIa7EnJEjG', 'viewer', 'active', 'Team Leader', 'rayvenompar@gmail.com', '09631719419', '2026-07-02 07:12:23'),
(29, 'Ronnette Malinis', '123123123', 'mebmeb', '$2y$12$3OqhI24M8eNr0ESEMcjCVOlCnf8SLb0S7IAC.hoI9eo5jAD67Vmjq', 'viewer', 'active', 'Team Leader', 'eogs.rmalinis@gmail.com', '09712388192', '2026-07-06 06:08:03'),
(30, 'qwerty', '123123', 'haha', '$2y$12$9guY2Cnwyd1yzda4LDJSlOyeuZEcPW12nzTFD8MosWZ9aRjGhOlaa', 'viewer', 'active', 'Team Leader', 'asfasfas@gmail.com', '09374238482', '2026-07-06 06:40:19'),
(31, 'Tataki Oriental', 'EMP098y', 'tataki', '$2y$12$PTfYfh9YMfYUsdgUAnx.ReN62cG3XQdAqR8w7i1TaVSNc5037LKSe', 'staff', 'active', 'HR', 'tataki@mail.com', '09123456789', '2026-07-06 07:10:13'),
(32, 'Kina May', 'JKJNJKMKJNMKOLKM12', 'kinamay', '$2y$12$US6rMjHOZ6uH8Z.uuVyiuuek8IxXkFXYSxsMCD0ABRbirNgCZlKnm', 'viewer', 'active', 'Team Leader', 'kinamay@mail.com', '0923456543', '2026-07-09 05:41:36'),
(34, 'Fredrin Cici Yz', 'IAHSDkjsan123', 'fred', '$2y$12$PXtEw1OZRYwjarMVe.UVFe43GlSH8s7do/xNn17bYZ5EfVxdxjSyq', 'admin', 'active', 'IT Staff', 'fred@mail.com', '09678767811', '2026-07-10 01:11:22');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=350;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `damages`
--
ALTER TABLE `damages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=164;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `recurring_requests`
--
ALTER TABLE `recurring_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `team_structure`
--
ALTER TABLE `team_structure`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

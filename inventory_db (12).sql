-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2026 at 03:15 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
(7, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'pending', NULL, NULL, NULL, '2026-06-08 16:06:40', '2026-06-08 16:06:40'),
(8, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'pending', NULL, NULL, NULL, '2026-06-08 16:10:33', '2026-06-08 16:10:33'),
(9, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Bembang', '{\"product_id\":\"85\",\"assignee_name\":\"Bembang\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Bembang (WEBY)', 'pending', NULL, NULL, NULL, '2026-06-09 08:32:14', '2026-06-09 08:32:14'),
(10, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'pending', NULL, NULL, NULL, '2026-06-09 08:49:54', '2026-06-09 08:49:54'),
(11, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Charles', '{\"product_id\":\"85\",\"assignee_name\":\"Charles\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":2,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Charles (WEBY)', 'pending', NULL, NULL, NULL, '2026-06-09 08:53:39', '2026-06-09 08:53:39'),
(12, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Raven O.', '{\"product_id\":\"85\",\"assignee_name\":\"Raven O.\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Raven O. (JTV)', 'pending', NULL, NULL, NULL, '2026-06-09 08:59:00', '2026-06-09 08:59:00'),
(13, 'Chowking', 8, 'create', 'Assignment', NULL, 'A4Tech → Dasilay', '{\"product_id\":\"85\",\"assignee_name\":\"Dasilay\",\"assigned_by\":\"Chowking\",\"due_back\":null,\"location_id\":1,\"notes\":\"Station: JTV\"}', 'Deploy asset to Dasilay (JTV)', 'pending', NULL, NULL, NULL, '2026-06-09 09:32:23', '2026-06-09 09:32:23'),
(14, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"3001-03-03\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'pending', NULL, NULL, NULL, '2026-06-09 09:45:47', '2026-06-09 09:45:47'),
(15, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-06-09\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'pending', NULL, NULL, NULL, '2026-06-09 09:49:25', '2026-06-09 09:49:25'),
(16, 'Zen Angelo Palay', 10, 'create', 'Assignment', NULL, 'A4Tech → Zen P.', '{\"product_id\":85,\"assignee_name\":\"Zen P.\",\"assigned_by\":\"Zen Angelo Palay\",\"due_back\":\"2027-03-23\",\"location_id\":1,\"notes\":\"Station: WEBY\"}', 'Deploy asset to Zen P.', 'pending', NULL, NULL, NULL, '2026-06-09 09:53:21', '2026-06-09 09:53:21');

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
(29, 79, 'Raven O.', 'Administrator', '2026-06-04 10:45:16', NULL, '2026-06-05 13:48:02', 'Station: JTV', 1, 'returned', '2026-06-04 16:45:16', '2026-06-05 13:48:02'),
(30, 77, 'Raven O.', 'Administrator', '2026-06-04 10:45:57', NULL, NULL, 'Station: JTV', 1, 'active', '2026-06-04 16:45:57', '2026-06-04 16:45:57'),
(31, 80, 'Dasilay', 'Administrator', '2026-06-05 02:35:02', NULL, NULL, 'Station: JTV', 1, 'active', '2026-06-05 08:35:02', '2026-06-05 08:35:02'),
(32, 78, 'Zen P.', 'Administrator', '2026-06-05 02:48:30', '2027-06-12', NULL, 'Station: WEBY', 1, 'active', '2026-06-05 08:48:30', '2026-06-05 08:48:30'),
(33, 81, 'Charles', 'Chowking', '2026-06-05 05:56:49', NULL, NULL, 'Station: WEBY', 2, 'active', '2026-06-05 11:56:49', '2026-06-05 11:56:49'),
(34, 79, 'Saratos', 'Zen Angelo Palay', '2026-06-05 07:49:15', '2027-06-05', NULL, 'Station: WEBY', 2, 'active', '2026-06-05 13:49:15', '2026-06-05 13:49:15'),
(35, 86, 'Carl P.', 'Chowking', '2026-06-05 08:46:17', NULL, NULL, 'Station: JTV', 1, 'active', '2026-06-05 14:46:17', '2026-06-05 14:46:17'),
(36, 83, 'Carl P.', 'Chowking', '2026-06-05 08:46:19', NULL, NULL, 'Station: JTV', 1, 'active', '2026-06-05 14:46:19', '2026-06-05 14:46:19'),
(37, 82, 'Bembang', 'Chowking', '2026-06-05 09:00:22', '2026-06-05', NULL, 'Station: WEBY', 2, 'active', '2026-06-05 15:00:22', '2026-06-05 15:00:22'),
(38, 84, 'Dasilay', 'Chowking', '2026-06-08 10:00:07', NULL, NULL, 'Station: JTV', 1, 'active', '2026-06-08 16:00:07', '2026-06-08 16:00:07');

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
(117, 10, 'Zen Angelo Palay', 'pending', 'Assignment', NULL, 'A4Tech → Zen P.', 'Create request submitted by Zen Angelo Palay — awaiting approval', NULL, '2026-06-09 09:53:21');

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
(20, NULL, 'Other Assets', 'Additional resources or items of value owned by a person or organization that are not classified under main asset categories.', '2026-05-22 13:22:21', '2026-05-22 13:22:21'),
(21, NULL, 'Headsets', 'Is an audio device that combines headphones and a microphone, allowing users to listen to sound and communicate hands-free.', '2026-06-01 08:32:59', '2026-06-01 08:32:59'),
(22, NULL, 'UPS', 'A UPS (Uninterruptible Power Supply) is a device that provides temporary backup power during power outages or voltage fluctuations.', '2026-06-01 08:34:06', '2026-06-01 08:34:06');

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
(19, 77, 21, 1, 'Administrator', '[Damaged] not working', 'damaged', NULL, NULL, NULL, NULL, 'Inplay Headset', '1111', '2026-06-04 16:46:22', '2026-06-04 16:46:22');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
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

INSERT INTO `employees` (`id`, `name`, `station`, `seat_number`, `created_at`, `updated_at`, `location_id`) VALUES
(3, 'Raven O.', 'JTV', '1', '2026-06-04 16:42:27', '2026-06-04 16:42:27', 1),
(4, 'Zen P.', 'WEBY', '45', '2026-06-04 16:57:19', '2026-06-04 16:57:33', 1),
(5, 'Carl P.', 'JTV', '20', '2026-06-05 08:23:01', '2026-06-05 08:23:31', 1),
(6, 'Saratos', 'WEBY', '4', '2026-06-05 08:31:39', '2026-06-05 08:33:10', 2),
(7, 'Dasilay', 'JTV', '2', '2026-06-05 08:31:39', '2026-06-05 08:33:05', 1),
(8, 'Bembang', 'WEBY', '6', '2026-06-05 08:34:01', '2026-06-05 08:34:01', 2),
(9, 'Charles', 'WEBY', '8', '2026-06-05 11:56:49', '2026-06-05 11:56:49', 2);

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
(1, 'Dungganon SIte 3', 'Dungganon', NULL, NULL, '2026-06-01 08:54:33', '2026-06-01 12:41:52'),
(2, 'Pantalan Site 4', 'Pantalan', NULL, NULL, '2026-06-01 08:54:33', '2026-06-05 08:32:53'),
(8, 'Carcar Site 1', NULL, NULL, NULL, '2026-06-09 12:39:47', '2026-06-09 12:39:47');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `for_role` enum('admin','staff','all') NOT NULL DEFAULT 'admin',
  `for_user_id` int(11) DEFAULT NULL,
  `type` enum('approval_submitted','approval_approved','approval_rejected') NOT NULL,
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
(2, 'staff', 10, 'approval_approved', '✅ Your request was approved', 'Create Assignment: Inplay Headset → Saratos', 'items.html', 0, '{\"approval_id\":1,\"decision\":\"approved\"}', '2026-06-05 13:49:15'),
(5, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Carl P.', 'items.html', 1, '{\"approval_id\":3,\"decision\":\"approved\"}', '2026-06-05 14:46:17'),
(6, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Carl P.', 'items.html', 1, '{\"approval_id\":2,\"decision\":\"approved\"}', '2026-06-05 14:46:19'),
(8, 'staff', 8, 'approval_rejected', '✖ Your request was rejected', 'Create Assignment: A4Tech → Bembang', 'items.html', 1, '{\"approval_id\":4,\"decision\":\"rejected\"}', '2026-06-05 14:59:01'),
(10, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Bembang', 'items.html', 1, '{\"approval_id\":5,\"decision\":\"approved\"}', '2026-06-05 15:00:22'),
(11, 'admin', NULL, '', 'New PO created by Chowking', 'PO PO-20260608-0002 — Empire One · 5 item(s) · ₱10,000.00', 'suppliers.html', 1, '{\"po_id\":13,\"created_by\":\"Chowking\"}', '2026-06-08 13:42:19'),
(12, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Dasilay', 'approvals.html', 1, '{\"approval_id\":6,\"action_type\":\"create\"}', '2026-06-08 15:59:27'),
(13, 'staff', 8, 'approval_approved', '✅ Your request was approved', 'Create Assignment: A4Tech → Dasilay', 'items.html', 1, '{\"approval_id\":6,\"decision\":\"approved\"}', '2026-06-08 16:00:07'),
(14, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Raven O.', 'approvals.html', 1, '{\"approval_id\":7,\"action_type\":\"create\"}', '2026-06-08 16:06:40'),
(15, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Raven O.', 'approvals.html', 1, '{\"approval_id\":8,\"action_type\":\"create\"}', '2026-06-08 16:10:33'),
(16, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Bembang', 'approvals.html', 1, '{\"approval_id\":9,\"action_type\":\"create\"}', '2026-06-09 08:32:14'),
(17, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Raven O.', 'approvals.html', 1, '{\"approval_id\":10,\"action_type\":\"create\"}', '2026-06-09 08:49:54'),
(18, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Charles', 'approvals.html', 1, '{\"approval_id\":11,\"action_type\":\"create\"}', '2026-06-09 08:53:39'),
(19, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Raven O.', 'approvals.html', 1, '{\"approval_id\":12,\"action_type\":\"create\"}', '2026-06-09 08:59:00'),
(20, 'admin', NULL, 'approval_submitted', 'New approval request from Chowking', 'Create Assignment: A4Tech → Dasilay', 'approvals.html', 1, '{\"approval_id\":13,\"action_type\":\"create\"}', '2026-06-09 09:32:24'),
(21, 'admin', NULL, 'approval_submitted', 'New approval request from Zen Angelo Palay', 'Create Assignment: A4Tech → Zen P.', 'approvals.html', 1, '{\"approval_id\":14,\"action_type\":\"create\"}', '2026-06-09 09:45:47'),
(22, 'admin', NULL, 'approval_submitted', 'New approval request from Zen Angelo Palay', 'Create Assignment: A4Tech → Zen P.', 'approvals.html', 1, '{\"approval_id\":15,\"action_type\":\"create\"}', '2026-06-09 09:49:25'),
(23, 'admin', NULL, 'approval_submitted', 'New approval request from Zen Angelo Palay', 'Create Assignment: A4Tech → Zen P.', 'approvals.html', 1, '{\"approval_id\":16,\"action_type\":\"create\"}', '2026-06-09 09:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `brand_model`, `description`, `category_id`, `supplier_id`, `location_id`, `quantity`, `asset_status`, `image_path`, `serial_number`, `po_id`, `po_item_id`, `created_at`, `updated_at`) VALUES
(77, 'Inplay Headset', '1111', 'InPlay', '', 21, 1, 1, 1, 'under_repair', NULL, '1111', 10, 9, '2026-06-04 16:44:10', '2026-06-05 11:57:32'),
(78, 'Inplay Headset', '2222', 'InPlay', '', 21, 1, 1, 1, 'assigned', NULL, '2222', 10, 9, '2026-06-04 16:44:10', '2026-06-05 11:57:32'),
(79, 'Inplay Headset', '3333', 'InPlay', '', 21, 1, 1, 1, 'assigned', NULL, '3333', 10, 9, '2026-06-04 16:44:11', '2026-06-05 13:49:15'),
(80, 'Inplay Headset', '4444', 'InPlay', '', 21, 1, 1, 1, 'assigned', NULL, '4444', 10, 9, '2026-06-04 16:44:11', '2026-06-05 11:57:32'),
(81, 'Inplay Headset', '5555', 'InPlay', '', 21, 1, 1, 1, 'assigned', NULL, '5555', 10, 9, '2026-06-04 16:44:11', '2026-06-05 11:57:33'),
(82, 'A4Tech', 'ssssssss', NULL, '', 14, 1, 1, 1, 'assigned', 'uploads/products/product_6a263eaea82c87.91189128.png', 'ssssssss', 11, 10, '2026-06-05 14:44:45', '2026-06-08 12:01:51'),
(83, 'A4Tech', 'dddddddd', NULL, '', 14, 1, 1, 1, 'assigned', NULL, 'dddddddd', 11, 10, '2026-06-05 14:44:45', '2026-06-05 14:46:19'),
(84, 'A4Tech', 'fggggggg', NULL, '', 14, 1, 1, 1, 'assigned', NULL, 'fggggggg', 11, 10, '2026-06-05 14:44:45', '2026-06-08 16:00:07'),
(85, 'A4Tech', 'bbbbbbb', NULL, '', 14, 1, 1, 1, 'available', NULL, 'bbbbbbb', 11, 10, '2026-06-05 14:44:45', '2026-06-05 14:44:45'),
(86, 'A4Tech', 'wwwwww', NULL, '', 14, 1, 1, 1, 'assigned', NULL, 'wwwwww', 11, 10, '2026-06-05 14:44:46', '2026-06-05 14:46:17');

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
(15, 'PO-20260608-0004', 1, '2026-06-08', '2026-06-08', 1500.00, 'pending_receive', NULL, 2, 'Administrator', NULL, NULL, '2026-06-08 13:47:29', '2026-06-08 13:47:45');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL,
  `po_id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL,
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

INSERT INTO `purchase_order_items` (`id`, `po_id`, `product_name`, `sku`, `category_id`, `quantity`, `unit_price`, `total_price`, `created_at`) VALUES
(9, 10, 'Inplay Headset', NULL, 21, 5, 200.00, 1000.00, '2026-06-04 16:43:44'),
(10, 11, 'A4Tech', NULL, 14, 5, 250.00, 1250.00, '2026-06-05 14:44:27'),
(11, 12, 'Trendsonic', NULL, 15, 10, 3000.00, 30000.00, '2026-06-08 12:27:28'),
(12, 13, 'N Vision', NULL, 13, 5, 2000.00, 10000.00, '2026-06-08 13:42:19'),
(13, 14, 'Secure Comp', NULL, 22, 3, 3000.00, 9000.00, '2026-06-08 13:44:10'),
(14, 15, 'Inplay', NULL, 10, 5, 300.00, 1500.00, '2026-06-08 13:47:30');

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
(1, 'Empire One', 'Raven Carl', 'carl@mail.com', '0912345678', 'SCC., Neg. Occ.', 'active', '2026-05-12 11:09:45', '2026-05-12 11:09:45');

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
  `username` varchar(60) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff','viewer') NOT NULL DEFAULT 'staff',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`, `role`, `created_at`) VALUES
(1, 'Administrator', 'admin', '$2y$12$FdA5C5NYevN7TSiifC33PuO3tJlBRzEgp66xinQyBOiizYvCtBBo6', 'admin', '2026-05-13 06:52:48'),
(3, 'Raven', 'raven', '$2y$12$Bq0LXagE.Xsx2kMTqNHoQ.UIHfgbzlsDxmda/SkROkJczt48sJ6XC', 'admin', '2026-05-14 05:00:59'),
(4, 'Zen P.', 'zen', '$2y$12$ZxqhYXWm8Mjx5HaCs43o0uSppEHxb0HTJYFOU9gvtj4SgxahFsWNW', 'staff', '2026-05-14 05:03:18'),
(5, 'Ven V', 'Vennn', '$2y$12$ZWmGjYgKhKjJkRLwRpo6fuwjzvdhbehg8mdc1ycMe2.2BV6FFOa32', 'viewer', '2026-05-19 04:30:31'),
(6, 'Carl V', 'carltzy', '$2y$12$v2Omp6kAZvuHb6FLdDkeVuMcfFG7jDJHLaOKq5TfmXctO/69XELgm', 'admin', '2026-06-02 07:04:29'),
(7, 'Gayo', 'gayo', '$2y$12$T6L6b59Tc0dd5OZlLMAED.Vq3UMcyYLqlC5aPMuf0I5Xjmxgs9Cwi', 'viewer', '2026-06-05 00:52:05'),
(8, 'Chowking', 'chowk', '$2y$12$IHuvEkz24Bu/GdDaunAReO9AOBkXYVlJWIf3WmxPz1CSqh/BgAJ9S', 'staff', '2026-06-05 00:52:32'),
(9, 'Zen Angelo Palay', 'zenzen', '$2y$12$bsPdLk4v2SeklATADcvPiezLmi8lee4tXUz7nZ.yJVp8Pqn.zkZUa', 'viewer', '2026-06-05 05:05:38'),
(10, 'Zen Angelo Palay', 'zenstaff', '$2y$12$WXE41KE.cq8M4qATJ87y9.1QRduXV9LWJ79FbFjDBXIgwIyPsrdgO', 'staff', '2026-06-05 05:11:20');

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
  ADD KEY `idx_location_id` (`location_id`);

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
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approval_requests`
--
ALTER TABLE `approval_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `damages`
--
ALTER TABLE `damages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `fk_assign_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_assign_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `damages`
--
ALTER TABLE `damages`
  ADD CONSTRAINT `damages_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `damages_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_damage_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `fk_po_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_po_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `fk_poi_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

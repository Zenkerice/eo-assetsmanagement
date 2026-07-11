-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 11, 2026 at 12:51 PM
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
  `status` enum('pending','approved','rejected','forwarded') NOT NULL DEFAULT 'pending',
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
(1, 'Zen', 2, 'create', 'asset_request', NULL, 'Zen', '{\"assignee\":\"Zen\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 10 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"Keytech qawdq\",\"tag\":\"\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-10 19:03:59', '2026-07-10 19:02:57', '2026-07-10 19:03:59'),
(2, 'Zen', 2, 'create', 'asset_request', NULL, 'Zen', '{\"assignee\":\"Zen\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 10 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Keyboards\",\"brand\":\"HAvit asda\",\"tag\":\"121233123\",\"condition\":\"New\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-10 19:12:45', '2026-07-10 19:10:07', '2026-07-10 19:12:45'),
(3, 'Zen', 2, 'delete', 'Assignment', 1, 'HAvit · return by Zen', '{\"assignment_id\":\"1\",\"product_id\":5,\"condition\":\"good\",\"return_method\":\"dropoff\",\"notes\":\"\"}', 'Return request: good', 'approved', 'Administrator', '', '2026-07-10 19:14:52', '2026-07-10 19:14:19', '2026-07-10 19:14:52'),
(4, 'qwerty', 3, 'create', 'asset_request', NULL, 'qwerty', '{\"assignee\":\"qwerty\",\"department\":\"\",\"location\":\"\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 11 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"SY SY-202\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-11 12:36:58', '2026-07-11 12:36:43', '2026-07-11 12:36:58'),
(5, 'qwerty', 3, 'create', 'asset_request', NULL, 'qwerty', '{\"assignee\":\"qwerty\",\"department\":\"\",\"location\":\"Site 3 | San Carlos City, Dungganon Site\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 11 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Headsets\",\"brand\":\"SY SY-202\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'rejected', 'Administrator', '', '2026-07-11 13:02:50', '2026-07-11 13:02:18', '2026-07-11 13:02:50'),
(6, 'qwerty', 3, 'create', 'asset_request', NULL, 'qwerty', '{\"assignee\":\"qwerty\",\"department\":\"\",\"location\":\"Site 3 | San Carlos City, Dungganon Site\",\"purpose\":\"Asset Accountability\",\"date_deployed\":\"07 \\/ 11 \\/ 2026\",\"expected_return\":\"\",\"remarks\":\"\",\"assets\":[{\"name\":\"Keyboards\",\"brand\":\"HAvit asda\",\"tag\":\"21412312\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"},{\"name\":\"Headsets\",\"brand\":\"SY Headset\",\"tag\":\"\",\"condition\":\"\",\"value\":\"\",\"remarks\":\"\"}]}', 'Asset Accountability', 'approved', 'Administrator', '', '2026-07-11 13:03:59', '2026-07-11 13:03:40', '2026-07-11 13:03:59'),
(7, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"for work.\"}', 'for work.', 'rejected', 'Administrator', '', '2026-07-11 15:06:14', '2026-07-11 13:50:48', '2026-07-11 15:06:14'),
(8, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"\",\"requestor_location_id\":null,\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"for work\"}', 'for work', 'approved', 'Administrator', '', '2026-07-11 15:16:29', '2026-07-11 15:06:46', '2026-07-11 15:16:29'),
(9, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"ASDasdadasd\"}', 'ASDasdadasd', 'forwarded', 'Administrator', '', '2026-07-11 15:30:17', '2026-07-11 15:28:47', '2026-07-11 15:30:17'),
(10, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"\",\"requestor_location_id\":null,\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"aaasa\"}', 'aaasa', 'forwarded', 'Administrator', '', '2026-07-11 16:06:26', '2026-07-11 15:31:04', '2026-07-11 16:06:26'),
(11, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"aaaaaaa\"}', 'aaaaaaa', 'forwarded', 'Administrator', '', '2026-07-11 16:56:41', '2026-07-11 16:56:04', '2026-07-11 16:56:41'),
(12, 'qwerty', 3, 'create', 'Asset', NULL, 'HAvit asda', '{\"requestor_name\":\"qwerty\",\"requestor_id\":\"qwerty123\",\"requestor_location\":\"Site 3 | San Carlos City, Dungganon Site\",\"requestor_location_id\":\"1\",\"category_id\":\"10\",\"category_name\":\"Keyboards\",\"brand\":\"HAvit\",\"model\":\"asda\",\"description\":\"Ork\"}', 'Ork', 'rejected', 'Administrator', '', '2026-07-11 18:40:37', '2026-07-11 18:39:45', '2026-07-11 18:40:37');

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
(2, 13, 'qwerty', 'Administrator (recovery fix)', '2026-07-11 12:53:23', NULL, NULL, NULL, NULL, 'active', '2026-07-11 12:53:23', '2026-07-11 12:53:23'),
(3, 1, 'Raven', 'System (recovery fix)', '2026-07-11 13:00:03', NULL, NULL, NULL, NULL, 'active', '2026-07-11 13:00:03', '2026-07-11 13:00:03'),
(4, 4, 'qwerty', 'Admin', '2026-07-11 07:03:59', NULL, NULL, 'Asset Accountability', 2, 'active', '2026-07-11 13:03:59', '2026-07-11 13:03:59');

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
(1, 1, 'Administrator', 'created', 'Asset', 1, 'Headset Keytech', 'Asset created: Headset Keytech', NULL, '2026-07-10 19:00:15'),
(2, 2, 'Zen', 'pending', 'asset_request', NULL, 'Zen', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-10 19:02:57'),
(3, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Zen', 'Approved by Administrator: create on asset_request', NULL, '2026-07-10 19:03:59'),
(4, 2, 'Zen', 'pending', 'asset_request', NULL, 'Zen', 'Create request submitted by Zen — awaiting approval', NULL, '2026-07-10 19:10:07'),
(5, 1, 'Administrator', 'assigned', 'Asset', 5, 'HAvit', 'Assigned to Zen by Admin', NULL, '2026-07-10 19:12:45'),
(6, 1, 'Administrator', 'approved', 'asset_request', NULL, 'Zen', 'Approved by Administrator: create on asset_request', NULL, '2026-07-10 19:12:45'),
(7, 2, 'Zen', 'pending', 'Assignment', 1, 'HAvit · return by Zen', 'Delete request submitted by Zen — awaiting approval', NULL, '2026-07-10 19:14:19'),
(8, 1, 'Administrator', 'approved', 'Assignment', 1, 'HAvit · return by Zen', 'Approved by Administrator: delete on Assignment', NULL, '2026-07-10 19:14:52'),
(9, 1, 'Administrator', 'created', 'Asset', 12, 'SY Speaker', 'Asset created: SY Speaker', NULL, '2026-07-11 12:27:23'),
(10, 1, 'Administrator', 'created', 'Asset', 13, 'SY Headset', 'Asset created: SY Headset', NULL, '2026-07-11 12:35:51'),
(11, 3, 'qwerty', 'pending', 'asset_request', NULL, 'qwerty', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 12:36:43'),
(12, 1, 'Administrator', 'approved', 'asset_request', NULL, 'qwerty', 'Approved by Administrator: create on asset_request', NULL, '2026-07-11 12:36:58'),
(13, 3, 'qwerty', 'pending', 'asset_request', NULL, 'qwerty', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 13:02:18'),
(14, 1, 'Administrator', 'rejected', 'asset_request', NULL, 'qwerty', 'Rejected by Administrator: No reason given', NULL, '2026-07-11 13:02:50'),
(15, 3, 'qwerty', 'pending', 'asset_request', NULL, 'qwerty', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 13:03:40'),
(16, 1, 'Administrator', 'assigned', 'Asset', 4, 'HAvit', 'Assigned to qwerty by Admin', NULL, '2026-07-11 13:03:59'),
(17, 1, 'Administrator', 'approved', 'asset_request', NULL, 'qwerty', 'Approved by Administrator: create on asset_request', NULL, '2026-07-11 13:03:59'),
(18, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 13:50:48'),
(19, 1, 'Administrator', 'rejected', 'Asset', NULL, 'HAvit asda', 'Rejected by Administrator: No reason given', NULL, '2026-07-11 15:06:14'),
(20, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 15:06:46'),
(21, 1, 'Administrator', 'approved', 'Asset', NULL, 'HAvit asda', 'Forwarded to requestor by Administrator: create on Asset', NULL, '2026-07-11 15:16:29'),
(22, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 15:28:47'),
(23, 1, 'Administrator', 'updated', 'Asset', NULL, 'HAvit asda', 'Forwarded to requestor by Administrator', NULL, '2026-07-11 15:30:17'),
(24, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 15:31:04'),
(25, 1, 'Administrator', 'updated', 'Asset', NULL, 'HAvit asda', 'Forwarded to requestor by Administrator', NULL, '2026-07-11 16:06:26'),
(26, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 16:56:04'),
(27, 1, 'Administrator', 'updated', 'Asset', NULL, 'HAvit asda', 'Forwarded to requestor by Administrator', NULL, '2026-07-11 16:56:41'),
(28, 3, 'qwerty', 'pending', 'Asset', NULL, 'HAvit asda', 'Create request submitted by qwerty — awaiting approval', NULL, '2026-07-11 18:39:45'),
(29, 1, 'Administrator', 'rejected', 'Asset', NULL, 'HAvit asda', 'Rejected by Administrator: No reason given', NULL, '2026-07-11 18:40:37');

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
(1, 'admin', NULL, 'submitted', 'New Account Pending Approval', 'Zen (zen) registered as Viewer and is awaiting your approval.', 'users.html', 1, '{\"user_id\":2,\"action\":\"registration\"}', '2026-07-10 19:01:43'),
(2, 'staff', 2, 'approved', 'Account Approved!', 'Your account has been approved by an admin. You can now sign in.', NULL, 1, '{\"action\":\"account_approved\"}', '2026-07-10 19:01:58'),
(3, 'admin', NULL, 'approval_submitted', 'New approval request from Zen', 'Create asset_request: Zen', 'approvals.html', 1, '{\"approval_id\":1,\"action_type\":\"create\"}', '2026-07-10 19:02:57'),
(4, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: Zen', 'requests.html', 1, '{\"approval_id\":1,\"decision\":\"approved\"}', '2026-07-10 19:03:59'),
(5, 'admin', NULL, 'approval_submitted', 'New approval request from Zen', 'Create asset_request: Zen', 'approvals.html', 1, '{\"approval_id\":2,\"action_type\":\"create\"}', '2026-07-10 19:10:07'),
(6, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: Zen', 'requests.html', 1, '{\"approval_id\":2,\"decision\":\"approved\"}', '2026-07-10 19:12:45'),
(7, 'admin', NULL, 'approval_submitted', 'New approval request from Zen', 'Delete Assignment: HAvit · return by Zen', 'approvals.html', 1, '{\"approval_id\":3,\"action_type\":\"delete\"}', '2026-07-10 19:14:19'),
(8, 'staff', 2, 'approval_approved', '✅ Your request was approved', 'Delete Assignment: HAvit · return by Zen', 'requests.html', 1, '{\"approval_id\":3,\"decision\":\"approved\"}', '2026-07-10 19:14:52'),
(9, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create asset_request: qwerty', 'approvals.html', 1, '{\"approval_id\":4,\"action_type\":\"create\"}', '2026-07-11 12:36:43'),
(10, 'staff', 3, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: qwerty', 'requests.html', 1, '{\"approval_id\":4,\"decision\":\"approved\"}', '2026-07-11 12:36:58'),
(11, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create asset_request: qwerty', 'approvals.html', 1, '{\"approval_id\":5,\"action_type\":\"create\"}', '2026-07-11 13:02:18'),
(12, 'staff', 3, 'approval_rejected', '✖ Your request was rejected', 'Create Asset Request: qwerty', 'requests.html', 1, '{\"approval_id\":5,\"decision\":\"rejected\"}', '2026-07-11 13:02:50'),
(13, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create asset_request: qwerty', 'approvals.html', 1, '{\"approval_id\":6,\"action_type\":\"create\"}', '2026-07-11 13:03:40'),
(14, 'staff', 3, 'approval_approved', '✅ Your request was approved', 'Create Asset Request: qwerty', 'requests.html', 1, '{\"approval_id\":6,\"decision\":\"approved\"}', '2026-07-11 13:03:59'),
(15, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":7,\"action_type\":\"create\"}', '2026-07-11 13:50:48'),
(16, 'admin', NULL, 'approval_request', 'New Asset Request', 'qwerty has requested: HAvit asda', 'approvals.html', 1, '{\"approval_id\":7,\"resource_type\":\"Asset\"}', '2026-07-11 13:50:48'),
(17, 'staff', 3, 'approval_rejected', '✖ Your request was rejected', 'Create Asset: HAvit asda', 'requests.html', 1, '{\"approval_id\":7,\"decision\":\"rejected\"}', '2026-07-11 15:06:14'),
(18, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":8,\"action_type\":\"create\"}', '2026-07-11 15:06:46'),
(19, 'staff', 3, 'approval_approved', '📋 Asset Form Confirmation', 'Your asset request for \"HAvit asda\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":8,\"decision\":\"approved\"}', '2026-07-11 15:16:29'),
(20, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":9,\"action_type\":\"create\"}', '2026-07-11 15:28:47'),
(21, 'staff', 3, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"HAvit asda\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":9,\"decision\":\"forwarded\"}', '2026-07-11 15:30:17'),
(22, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":10,\"action_type\":\"create\"}', '2026-07-11 15:31:04'),
(23, 'staff', 3, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"HAvit asda\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":10,\"decision\":\"forwarded\"}', '2026-07-11 16:06:26'),
(24, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":11,\"action_type\":\"create\"}', '2026-07-11 16:56:04'),
(25, 'staff', 3, 'approval_forwarded', '📋 Asset Form Confirmation', 'Your asset request for \"HAvit asda\" requires your confirmation. Please review and sign the accountability form.', 'requests.html?tab=myrequests', 1, '{\"approval_id\":11,\"decision\":\"forwarded\"}', '2026-07-11 16:56:41'),
(26, 'admin', NULL, 'approval_submitted', 'New approval request from qwerty', 'Create Asset: HAvit asda', 'approvals.html', 1, '{\"approval_id\":12,\"action_type\":\"create\"}', '2026-07-11 18:39:45'),
(27, 'staff', 3, 'approval_rejected', '✖ Your request was rejected', 'Create Asset: HAvit asda', 'requests.html', 1, '{\"approval_id\":12,\"decision\":\"rejected\"}', '2026-07-11 18:40:37');

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
(1, 'Headset Keytech', '1212qdqad', 'Keytech qawdq', 'Keytech', 'qawdq', 'Raven', '12312', '', 21, NULL, 'Eo', '2026-07-10', '2026-07-10 19:00:00', 2, 1, 'assigned', NULL, NULL, NULL, NULL, '2026-07-10 19:00:15', '2026-07-11 13:00:03'),
(2, 'HAvit', 'qwdcxzasdzasdd', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'qwdcxzasdzasdd', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(3, 'HAvit', 'asdascasd', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'asdascasd', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(4, 'HAvit', '21412312', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'assigned', NULL, '21412312', 1, 1, '2026-07-10 19:07:23', '2026-07-11 13:03:59'),
(5, 'HAvit', '121233123', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, '121233123', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:14:52'),
(6, 'HAvit', 'sdfsdfqww', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'sdfsdfqww', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(7, 'HAvit', 'wedfwer', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'wedfwer', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(8, 'HAvit', 'werwerwersd', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'werwerwersd', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(9, 'HAvit', 'werwerwddfsdfv', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'werwerwddfsdfv', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(10, 'HAvit', 'cvbvfefv', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'cvbvfefv', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(11, 'HAvit', 'swsdfvcxdefd', 'HAvit asda', 'HAvit', 'asda', NULL, NULL, 'HAvit Keyboard', 10, 1, NULL, '2026-07-10', NULL, 2, 1, 'available', NULL, 'swsdfvcxdefd', 1, 1, '2026-07-10 19:07:23', '2026-07-10 19:07:23'),
(13, 'SY Headset', 'ASD1233', 'SY SY-202', 'SY', 'SY-202', '', '', '', 21, NULL, 'Eo', '2026-07-10', '2026-07-11 12:35:00', 1, 1, 'assigned', NULL, NULL, NULL, NULL, '2026-07-11 12:35:51', '2026-07-11 12:53:23');

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
(1, 'PO-20260710-0001', 1, '2026-07-10', '2026-07-10', 12000.00, 'received', NULL, 2, 'Administrator', 'Administrator', '2026-07-10 19:07:22', '2026-07-10 19:06:36', '2026-07-10 19:07:22');

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
(1, 1, 'HAvit', 'HAvit', 'asda', 'HAvit Keyboard', NULL, 10, 10, 1200.00, 12000.00, '2026-07-10 19:06:36');

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
(1, 'Administrator', NULL, 'admin', '$2y$12$FdA5C5NYevN7TSiifC33PuO3tJlBRzEgp66xinQyBOiizYvCtBBo6', 'admin', 'active', NULL, NULL, NULL, '2026-05-12 22:52:48'),
(2, 'Zen', 'asdgasc7a8sczen', 'zen', '$2y$12$7Tw3S.JVmFtQzzmlVu9sXOjukjyvy9DydZbSf1clZATBF6OVIIwLC', 'viewer', 'active', 'Team Leader', 'zen@mail.com', '098788909876', '2026-07-10 11:01:43'),
(3, 'qwerty', 'qwerty123', 'qwerty', '$2y$12$L8enlSEALS/w1E6oNYRVee9Us/nGBbeFjxMQvzvXUBe39GDOuhC7y', 'viewer', 'active', 'Team Leader', 'qwerty@mail.com', '0956789467', '2026-07-11 03:33:34');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

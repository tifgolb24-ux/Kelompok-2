-- =============================================================
-- BisaGym - Database Gabungan (Laravel + AI Biometrik)
-- File ini berisi SEMUA tabel untuk u777561646_bisagym
-- Import ke phpMyAdmin Niagahoster: pilih DB lalu klik Import
-- =============================================================

-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: website_bisagym_local
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_logs_user_id_foreign` (`user_id`),
  CONSTRAINT `activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,1,'REQUEST_OTP','Auth','Masa verifikasi OTP 24 jam telah berakhir. Meminta kode OTP baru.','2026-11-03 02:41:39','2026-11-03 02:41:39'),(2,NULL,'REQUEST_OTP','Auth','Masa verifikasi OTP 24 jam telah berakhir. Meminta kode OTP baru.','2026-11-03 02:42:01','2026-11-03 02:42:01'),(3,1,'LOGIN_SUCCESS','Auth','Berhasil login setelah verifikasi OTP.','2026-11-03 02:52:06','2026-11-03 02:52:06'),(4,5,'REQUEST_OTP','Auth','Meminta kode OTP via email.','2026-11-04 04:43:10','2026-11-04 04:43:10'),(5,5,'LOGIN_SUCCESS','Auth','Berhasil login setelah verifikasi OTP.','2026-11-04 04:50:09','2026-11-04 04:50:09'),(6,5,'REQUEST_OTP','Auth','Meminta kode OTP via email.','2026-11-06 08:35:12','2026-11-06 08:35:12'),(7,5,'LOGIN_SUCCESS','Auth','Berhasil login setelah verifikasi OTP.','2026-11-06 08:35:33','2026-11-06 08:35:33'),(8,5,'REQUEST_OTP','Auth','Meminta kode OTP via email.','2026-11-16 14:37:53','2026-11-16 14:37:53'),(9,5,'LOGIN_SUCCESS','Auth','Berhasil login setelah verifikasi OTP.','2026-11-16 14:38:16','2026-11-16 14:38:16');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_gym_package`
--

DROP TABLE IF EXISTS `discount_gym_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_gym_package` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `discount_id` bigint unsigned NOT NULL,
  `gym_package_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `discount_gym_package_discount_id_foreign` (`discount_id`),
  KEY `discount_gym_package_gym_package_id_foreign` (`gym_package_id`),
  CONSTRAINT `discount_gym_package_discount_id_foreign` FOREIGN KEY (`discount_id`) REFERENCES `discounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `discount_gym_package_gym_package_id_foreign` FOREIGN KEY (`gym_package_id`) REFERENCES `gym_packages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_gym_package`
--

LOCK TABLES `discount_gym_package` WRITE;
/*!40000 ALTER TABLE `discount_gym_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `discount_gym_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` int NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discounts`
--

LOCK TABLES `discounts` WRITE;
/*!40000 ALTER TABLE `discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_attendances`
--

DROP TABLE IF EXISTS `employee_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_attendances` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `date` date NOT NULL,
  `status` enum('Hadir','Izin','Sakit','Alpa','Libur') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Hadir',
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_attendances_employee_id_date_unique` (`employee_id`,`date`),
  CONSTRAINT `employee_attendances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_attendances`
--

LOCK TABLES `employee_attendances` WRITE;
/*!40000 ALTER TABLE `employee_attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_payrolls`
--

DROP TABLE IF EXISTS `employee_payrolls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_payrolls` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `month` int NOT NULL,
  `year` int NOT NULL,
  `base_salary` decimal(15,2) NOT NULL DEFAULT '0.00',
  `allowances` decimal(15,2) NOT NULL DEFAULT '0.00',
  `deductions` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total_salary` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` enum('unpaid','paid') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unpaid',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_payrolls_employee_id_foreign` (`employee_id`),
  CONSTRAINT `employee_payrolls_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_payrolls`
--

LOCK TABLES `employee_payrolls` WRITE;
/*!40000 ALTER TABLE `employee_payrolls` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_payrolls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_shifts`
--

DROP TABLE IF EXISTS `employee_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_shifts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint unsigned NOT NULL,
  `date` date NOT NULL,
  `shift_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pagi',
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_day_off` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_shifts_employee_id_foreign` (`employee_id`),
  CONSTRAINT `employee_shifts_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_shifts`
--

LOCK TABLES `employee_shifts` WRITE;
/*!40000 ALTER TABLE `employee_shifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_salary` decimal(15,2) NOT NULL DEFAULT '0.00',
  `join_date` date DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_user_id_foreign` (`user_id`),
  CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,NULL,'Jane Doe','08123456780','Penjaga / Kasir',2000000.00,NULL,'active','2026-07-29 07:24:46','2026-07-29 07:24:46');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Operasional',
  `amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gym_packages`
--

DROP TABLE IF EXISTS `gym_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gym_packages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int NOT NULL,
  `duration_unit` enum('hari','bulan','tahun') COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `admin_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `category` enum('member','non-member','couple') COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_members` tinyint unsigned NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gym_packages`
--

LOCK TABLES `gym_packages` WRITE;
/*!40000 ALTER TABLE `gym_packages` DISABLE KEYS */;
INSERT INTO `gym_packages` VALUES (1,'Non Member',1,'hari',50000.00,0.00,'non-member',1,1,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(2,'Basic Plan',1,'bulan',250000.00,30000.00,'member',1,1,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(3,'Pro Plan',3,'bulan',675000.00,30000.00,'member',1,1,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(4,'Elite Plan',6,'bulan',1200000.00,30000.00,'member',1,1,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(5,'Power Couple',1,'bulan',450000.00,30000.00,'couple',2,1,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(6,'Member VVIP',1,'tahun',2500000.00,30000.00,'member',1,1,'2026-11-03 03:18:19','2026-11-03 03:18:19');
/*!40000 ALTER TABLE `gym_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_attendances`
--

DROP TABLE IF EXISTS `member_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_attendances` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `attendance_time` datetime NOT NULL,
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_attendances_member_id_foreign` (`member_id`),
  KEY `member_attendances_user_id_foreign` (`user_id`),
  CONSTRAINT `member_attendances_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `member_attendances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_attendances`
--

LOCK TABLES `member_attendances` WRITE;
/*!40000 ALTER TABLE `member_attendances` DISABLE KEYS */;
INSERT INTO `member_attendances` VALUES (1,4,1,'2026-07-29 06:12:29',NULL,'2026-07-28 23:12:29','2026-07-28 23:12:29'),(2,1,1,'2026-07-29 13:20:37',NULL,'2026-07-29 06:20:37','2026-07-29 06:20:37');
/*!40000 ALTER TABLE `member_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_transactions`
--

DROP TABLE IF EXISTS `member_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `gym_package_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `discount_percentage` int NOT NULL DEFAULT '0',
  `admin_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `transaction_date` datetime NOT NULL,
  `transaction_type` enum('new','renewal') COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_status` enum('unpaid','paid') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_transactions_transaction_code_unique` (`transaction_code`),
  KEY `member_transactions_member_id_foreign` (`member_id`),
  KEY `member_transactions_gym_package_id_foreign` (`gym_package_id`),
  KEY `member_transactions_user_id_foreign` (`user_id`),
  CONSTRAINT `member_transactions_gym_package_id_foreign` FOREIGN KEY (`gym_package_id`) REFERENCES `gym_packages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `member_transactions_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `member_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_transactions`
--

LOCK TABLES `member_transactions` WRITE;
/*!40000 ALTER TABLE `member_transactions` DISABLE KEYS */;
INSERT INTO `member_transactions` VALUES (1,'TRX-1785298737-485',4,6,1,2280000.00,10,30000.00,'2026-07-29 05:02:04','new','cash','paid','2026-07-28 21:18:57','2026-07-28 22:02:04'),(4,'RNW-1785304956-584',4,6,1,2500000.00,0,0.00,'2026-07-29 06:03:07','renewal','transfer','paid','2026-07-28 23:02:36','2026-07-28 23:03:07');
/*!40000 ALTER TABLE `member_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `member_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `place_of_birth` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('L','P') COLLATE utf8mb4_unicode_ci NOT NULL,
  `nik` char(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_date` datetime NOT NULL,
  `activation_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `status` enum('active','pending','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `extension_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `locked_package_id` bigint unsigned DEFAULT NULL,
  `locked_price` decimal(12,2) DEFAULT NULL,
  `linked_member_id` bigint unsigned DEFAULT NULL,
  `face_api_member_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_enrollment_session_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_enrollment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NOT_ENROLLED',
  `face_enrolled_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_member_id_unique` (`member_id`),
  UNIQUE KEY `members_face_api_member_id_unique` (`face_api_member_id`),
  KEY `members_locked_package_id_foreign` (`locked_package_id`),
  KEY `members_linked_member_id_foreign` (`linked_member_id`),
  CONSTRAINT `members_linked_member_id_foreign` FOREIGN KEY (`linked_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `members_locked_package_id_foreign` FOREIGN KEY (`locked_package_id`) REFERENCES `gym_packages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'VIP-20251201-143000-1234','Reguler','Reza Rahadian','Jakarta','1990-05-15','L','3171234567890123','Wiraswasta','Jl. Sudirman No. 10, Jakarta','081234567890','reza@example.com',NULL,'2026-07-28 12:04:08','2026-07-28','2026-10-28','active',0,'2026-07-28 05:04:08','2026-07-28 05:04:08',NULL,NULL,NULL,NULL,NULL,'NOT_ENROLLED',NULL),(2,'VIP-20251201-143000-1235','Reguler','Anya Geraldine','Bandung','1995-12-05','P','3271234567890124','Model','Jl. Braga No. 5, Bandung','089876543210','anya@example.com',NULL,'2026-07-28 12:04:08','2026-07-28','2026-08-28','active',0,'2026-07-28 05:04:08','2026-07-28 05:04:08',NULL,NULL,NULL,NULL,NULL,'NOT_ENROLLED',NULL),(4,'VIP-20260729-041857-6460','member','Anugrah Tejo Maliki','Sidoarjo','2005-07-01','L','1234567890123456','Mahasiswa','Desa Kemuning RT 22/RW 04, Kec. Tarik, Kab. Sidoarjo','081231333063','anugrahtejomalaiki@gmail.com','members/member_1785298737_586.jpeg','2026-07-29 04:18:57','2026-07-29','2028-07-29','active',1,'2026-07-28 21:18:57','2026-11-17 02:17:47',NULL,NULL,NULL,'8f0d767e-0158-4c60-9713-5352f35c2b76','545ff2bf-42a9-4ebc-80aa-04324977de17','IN_PROGRESS',NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_07_27_143913_create_permission_tables',1),(5,'2026_07_27_143930_create_gym_packages_table',1),(6,'2026_07_27_143931_create_members_table',1),(7,'2026_07_27_143932_create_member_attendances_table',1),(8,'2026_07_27_143933_create_member_transactions_table',1),(9,'2026_07_27_143935_create_snacks_table',1),(10,'2026_07_27_143936_create_snack_transactions_table',1),(11,'2026_07_27_143937_create_snack_transaction_details_table',1),(12,'2026_07_28_052548_add_max_members_to_gym_packages_table',1),(13,'2026_07_28_073058_add_payment_method_to_member_transactions_table',1),(14,'2026_07_28_083054_add_payment_status_to_member_transactions_table',1),(15,'2026_07_28_094753_add_admin_fee_to_gym_packages_table',1),(16,'2026_07_28_094802_add_discount_and_admin_fee_to_member_transactions_table',1),(17,'2026_07_29_061043_add_user_id_to_member_attendances_table',1),(18,'2026_07_29_135123_create_employees_table',1),(19,'2026_07_29_135125_create_employee_shifts_table',1),(20,'2026_07_29_135127_create_employee_payrolls_table',1),(21,'2026_07_29_143249_create_expenses_table',1),(22,'2026_07_29_153117_create_employee_attendances_table',1),(23,'2026_07_29_170951_create_activity_logs_table',1),(24,'2026_07_30_014900_add_two_factor_columns_to_users_table',1),(25,'2026_07_30_204500_add_payment_method_to_snack_transactions_table',1),(26,'2026_07_31_094113_add_last_session_id_to_users_table',1),(27,'2026_08_01_210000_create_shift_reconciliations_table',1),(28,'2026_08_05_000000_add_stock_gudang_and_kulkas_to_snacks_table',1),(29,'2026_08_05_000001_create_snack_restocks_table',1),(30,'2026_08_06_000000_add_geofencing_to_users_table',1),(31,'2026_08_14_074358_add_developer_kasir_to_users_role_enum',1),(32,'2026_08_14_164637_add_discount_percentage_to_gym_packages_table',1),(33,'2026_08_14_164638_add_locked_package_and_price_to_members_table',1),(34,'2026_08_14_170419_create_discounts_tables',1),(35,'2026_08_15_090011_add_linked_member_id_to_members_table',1),(36,'2026_09_02_081631_modify_payment_method_on_snack_transactions_table',1),(37,'2026_11_03_000000_add_face_enrollment_fields_to_members_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (1,'App\\Models\\User',1),(2,'App\\Models\\User',1),(3,'App\\Models\\User',1),(4,'App\\Models\\User',1),(1,'App\\Models\\User',3),(2,'App\\Models\\User',4),(4,'App\\Models\\User',4),(3,'App\\Models\\User',5);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','web','2026-11-03 03:18:18','2026-11-03 03:18:18'),(2,'penjaga','web','2026-11-03 03:18:18','2026-11-03 03:18:18'),(3,'developer','web','2026-11-03 03:18:18','2026-11-03 03:18:18'),(4,'kasir','web','2026-11-03 03:18:18','2026-11-03 03:18:18');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_reconciliations`
--

DROP TABLE IF EXISTS `shift_reconciliations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_reconciliations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `shift_type` enum('pagi','malam') COLLATE utf8mb4_unicode_ci NOT NULL,
  `system_cash` decimal(12,2) NOT NULL DEFAULT '0.00',
  `system_transfer` decimal(12,2) NOT NULL DEFAULT '0.00',
  `real_cash` decimal(12,2) DEFAULT NULL,
  `real_transfer` decimal(12,2) DEFAULT NULL,
  `difference_cash` decimal(12,2) DEFAULT NULL,
  `difference_transfer` decimal(12,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shift_reconciliations_date_shift_type_unique` (`date`,`shift_type`),
  KEY `shift_reconciliations_user_id_foreign` (`user_id`),
  CONSTRAINT `shift_reconciliations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_reconciliations`
--

LOCK TABLES `shift_reconciliations` WRITE;
/*!40000 ALTER TABLE `shift_reconciliations` DISABLE KEYS */;
/*!40000 ALTER TABLE `shift_reconciliations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snack_restocks`
--

DROP TABLE IF EXISTS `snack_restocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snack_restocks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `snack_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `expense_id` bigint unsigned DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'incoming_supplier',
  `qty_gudang` int NOT NULL DEFAULT '0',
  `qty_kulkas` int NOT NULL DEFAULT '0',
  `capital_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `supplier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `restock_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `snack_restocks_snack_id_foreign` (`snack_id`),
  KEY `snack_restocks_user_id_foreign` (`user_id`),
  KEY `snack_restocks_expense_id_foreign` (`expense_id`),
  CONSTRAINT `snack_restocks_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `snack_restocks_snack_id_foreign` FOREIGN KEY (`snack_id`) REFERENCES `snacks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `snack_restocks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snack_restocks`
--

LOCK TABLES `snack_restocks` WRITE;
/*!40000 ALTER TABLE `snack_restocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `snack_restocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snack_transaction_details`
--

DROP TABLE IF EXISTS `snack_transaction_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snack_transaction_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `snack_transaction_id` bigint unsigned NOT NULL,
  `snack_id` bigint unsigned DEFAULT NULL,
  `quantity` int NOT NULL,
  `price_at_time` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `snack_transaction_details_snack_transaction_id_foreign` (`snack_transaction_id`),
  KEY `snack_transaction_details_snack_id_foreign` (`snack_id`),
  CONSTRAINT `snack_transaction_details_snack_id_foreign` FOREIGN KEY (`snack_id`) REFERENCES `snacks` (`id`) ON DELETE SET NULL,
  CONSTRAINT `snack_transaction_details_snack_transaction_id_foreign` FOREIGN KEY (`snack_transaction_id`) REFERENCES `snack_transactions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snack_transaction_details`
--

LOCK TABLES `snack_transaction_details` WRITE;
/*!40000 ALTER TABLE `snack_transaction_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `snack_transaction_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snack_transactions`
--

DROP TABLE IF EXISTS `snack_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snack_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cash',
  `transaction_date` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `snack_transactions_transaction_code_unique` (`transaction_code`),
  KEY `snack_transactions_user_id_foreign` (`user_id`),
  CONSTRAINT `snack_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snack_transactions`
--

LOCK TABLES `snack_transactions` WRITE;
/*!40000 ALTER TABLE `snack_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `snack_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snacks`
--

DROP TABLE IF EXISTS `snacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snacks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `snack_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock_gudang` int NOT NULL DEFAULT '0',
  `stock_kulkas` int NOT NULL DEFAULT '0',
  `stock` int NOT NULL DEFAULT '0',
  `capital_price` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `snacks_snack_code_unique` (`snack_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snacks`
--

LOCK TABLES `snacks` WRITE;
/*!40000 ALTER TABLE `snacks` DISABLE KEYS */;
INSERT INTO `snacks` VALUES (1,'SNK-001','Whey Protein Isolate','Suplemen',30,20,50,15000.00,25000.00,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(2,'SNK-002','Air Mineral 600ml','Minuman',50,50,100,2500.00,5000.00,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(3,'SNK-003','Pocari Sweat 500ml','Minuman',30,30,60,5500.00,8000.00,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(4,'SNK-004','Fitbar Multigrain','Makanan',40,40,80,4000.00,7000.00,'2026-11-03 03:18:19','2026-11-03 03:18:19');
/*!40000 ALTER TABLE `snacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_expires_at` timestamp NULL DEFAULT NULL,
  `two_factor_verified_at` timestamp NULL DEFAULT NULL,
  `role` enum('admin','penjaga','developer','kasir') COLLATE utf8mb4_unicode_ci DEFAULT 'penjaga',
  `last_login_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_location_restricted` tinyint(1) NOT NULL DEFAULT '0',
  `allowed_latitude` decimal(10,7) DEFAULT NULL,
  `allowed_longitude` decimal(10,7) DEFAULT NULL,
  `allowed_radius_meters` int DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_session_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unique` (`username`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Anugrah Tejo Maliki','anugrah-tejo-maliki','anugrahtejomaliki@gmail.com',NULL,'$2y$12$7JHuFtPaRBAPVV//RLTFDOG0ztuRCnsg9B3NnhrutDK24Uk22d9Xe',NULL,NULL,'2026-11-03 03:18:19','penjaga',NULL,1,0,NULL,NULL,NULL,NULL,'aNDkX1g4Ax7NVA4a7Zv5c4rfCK3QbJpZnSK8ZZdo','2026-11-03 02:41:28','2026-11-03 03:18:19'),(3,'Budi Santoso (Admin)','admin','admin@bisagym.com',NULL,'$2y$12$NG7LQAOETn4PEU32Qdfr/u0V2wPMw6USmZR3W/R4R.tN/GMEqw6qi',NULL,NULL,'2026-11-03 03:18:18','admin',NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-11-03 03:18:18','2026-11-03 03:18:18'),(4,'Andi Pratama (Kasir)','kasir','kasir@bisagym.com',NULL,'$2y$12$UHi6MFsCgAQdcQ6pEyZYiuNCX0ra72PyeqONyN7q18fKj/3US2ati',NULL,NULL,'2026-11-03 03:18:19','penjaga',NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-11-03 03:18:19','2026-11-03 03:18:19'),(5,'Tejo (Developer)','developer','developer@bisagym.com',NULL,'$2y$12$QtHOMGvWCuZRqKCa.ACtQ.cJSDVARKJMDAtqu42zvoJ.zW/WWLxpe',NULL,NULL,'2026-11-16 14:38:16','developer',NULL,1,0,NULL,NULL,NULL,NULL,'TXBxY7IZkNaXlr9Pq0dXr9SQft2zNOuOJXZ4WtWs','2026-11-03 03:18:19','2026-11-17 02:10:07');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 19:47:48


-- =============================================================
-- BAGIAN 2: TABEL AI BIOMETRIK (bisagym-api / Python FastAPI)
-- Tabel tambahan untuk fitur Face Recognition & Absensi Wajah
-- (members & users dari Laravel dipakai bersama)
-- =============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Tabel AI: audit_logs
CREATE TABLE IF NOT EXISTS audit_logs (
	id VARCHAR(36) NOT NULL, 
	actor_type VARCHAR(30) NOT NULL, 
	actor_id VARCHAR(36), 
	action VARCHAR(100) NOT NULL, 
	resource_type VARCHAR(100) NOT NULL, 
	resource_id VARCHAR(36), 
	before_data JSON, 
	after_data JSON, 
	ip_address VARCHAR(64), 
	user_agent VARCHAR(500), 
	correlation_id VARCHAR(36) NOT NULL, 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_audit_logs PRIMARY KEY (id)
);

-- Tabel AI: branches
CREATE TABLE IF NOT EXISTS branches (
	id VARCHAR(36) NOT NULL, 
	code VARCHAR(50) NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	address TEXT, 
	timezone VARCHAR(64) NOT NULL, 
	is_active BOOL NOT NULL, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL, 
	CONSTRAINT pk_branches PRIMARY KEY (id)
);

-- Tabel AI: devices
CREATE TABLE IF NOT EXISTS devices (
	id VARCHAR(36) NOT NULL, 
	branch_id VARCHAR(36) NOT NULL, 
	device_code VARCHAR(80) NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	device_type VARCHAR(50) NOT NULL, 
	credential_hash VARCHAR(64) NOT NULL, 
	public_key TEXT, 
	capabilities JSON NOT NULL, 
	is_active BOOL NOT NULL, 
	last_seen_at DATETIME, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL, 
	CONSTRAINT pk_devices PRIMARY KEY (id), 
	CONSTRAINT fk_devices_branch_id_branches FOREIGN KEY(branch_id) REFERENCES branches (id)
);

-- [SKIP] Tabel `members` sudah ada di Laravel (skema berbeda)

-- Tabel AI: membership_plans
CREATE TABLE IF NOT EXISTS membership_plans (
	id VARCHAR(36) NOT NULL, 
	branch_id VARCHAR(36), 
	name VARCHAR(150) NOT NULL, 
	duration_days INTEGER NOT NULL, 
	price NUMERIC(12, 2) NOT NULL, 
	description TEXT, 
	is_active BOOL NOT NULL, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL, 
	CONSTRAINT pk_membership_plans PRIMARY KEY (id), 
	CONSTRAINT fk_membership_plans_branch_id_branches FOREIGN KEY(branch_id) REFERENCES branches (id)
);

-- [SKIP] Tabel `users` sudah ada di Laravel (skema berbeda)

-- Tabel AI: auth_sessions
CREATE TABLE IF NOT EXISTS auth_sessions (
	id VARCHAR(36) NOT NULL, 
	user_id VARCHAR(36) NOT NULL, 
	jti_hash VARCHAR(64) NOT NULL, 
	expires_at DATETIME NOT NULL, 
	revoked_at DATETIME, 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_auth_sessions PRIMARY KEY (id), 
	CONSTRAINT fk_auth_sessions_user_id_users FOREIGN KEY(user_id) REFERENCES users (id)
);

-- Tabel AI: biometric_consents
CREATE TABLE IF NOT EXISTS biometric_consents (
	id VARCHAR(36) NOT NULL, 
	member_id VARCHAR(36) NOT NULL, 
	consent_version VARCHAR(50) NOT NULL, 
	consented_at DATETIME NOT NULL, 
	revoked_at DATETIME, 
	capture_purpose VARCHAR(255) NOT NULL, 
	retention_policy VARCHAR(255) NOT NULL, 
	operator_user_id VARCHAR(36) NOT NULL, 
	signature_reference VARCHAR(500), 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_biometric_consents PRIMARY KEY (id), 
	CONSTRAINT fk_biometric_consents_member_id_members FOREIGN KEY(member_id) REFERENCES members (id), 
	CONSTRAINT fk_biometric_consents_operator_user_id_users FOREIGN KEY(operator_user_id) REFERENCES users (id)
);

-- Tabel AI: enrollment_sessions
CREATE TABLE IF NOT EXISTS enrollment_sessions (
	id VARCHAR(36) NOT NULL, 
	member_id VARCHAR(36) NOT NULL, 
	operator_user_id VARCHAR(36) NOT NULL, 
	status VARCHAR(30) NOT NULL, 
	expires_at DATETIME NOT NULL, 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_enrollment_sessions PRIMARY KEY (id), 
	CONSTRAINT fk_enrollment_sessions_member_id_members FOREIGN KEY(member_id) REFERENCES members (id), 
	CONSTRAINT fk_enrollment_sessions_operator_user_id_users FOREIGN KEY(operator_user_id) REFERENCES users (id)
);

-- Tabel AI: face_profiles
CREATE TABLE IF NOT EXISTS face_profiles (
	id VARCHAR(36) NOT NULL, 
	member_id VARCHAR(36) NOT NULL, 
	model_name VARCHAR(150) NOT NULL, 
	model_version VARCHAR(50) NOT NULL, 
	embedding_dimension INTEGER NOT NULL, 
	embedding JSON NOT NULL, 
	quality_score NUMERIC(5, 4) NOT NULL, 
	enrollment_status VARCHAR(30) NOT NULL, 
	is_primary BOOL NOT NULL, 
	created_by VARCHAR(36) NOT NULL, 
	created_at DATETIME NOT NULL, 
	revoked_at DATETIME, 
	revocation_reason TEXT, 
	CONSTRAINT pk_face_profiles PRIMARY KEY (id), 
	CONSTRAINT fk_face_profiles_member_id_members FOREIGN KEY(member_id) REFERENCES members (id), 
	CONSTRAINT fk_face_profiles_created_by_users FOREIGN KEY(created_by) REFERENCES users (id)
);

-- Tabel AI: kiosk_sessions
CREATE TABLE IF NOT EXISTS kiosk_sessions (
	id VARCHAR(36) NOT NULL, 
	device_id VARCHAR(36) NOT NULL, 
	jti_hash VARCHAR(64) NOT NULL, 
	challenge VARCHAR(30) NOT NULL, 
	expires_at DATETIME NOT NULL, 
	used_at DATETIME, 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_kiosk_sessions PRIMARY KEY (id), 
	CONSTRAINT fk_kiosk_sessions_device_id_devices FOREIGN KEY(device_id) REFERENCES devices (id)
);

-- Tabel AI: memberships
CREATE TABLE IF NOT EXISTS memberships (
	id VARCHAR(36) NOT NULL, 
	member_id VARCHAR(36) NOT NULL, 
	plan_id VARCHAR(36) NOT NULL, 
	start_at DATETIME NOT NULL, 
	end_at DATETIME NOT NULL, 
	status VARCHAR(9) NOT NULL, 
	price_paid NUMERIC(12, 2) NOT NULL, 
	payment_reference VARCHAR(200), 
	created_by VARCHAR(36) NOT NULL, 
	suspended_at DATETIME, 
	suspension_reason TEXT, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL, 
	CONSTRAINT pk_memberships PRIMARY KEY (id), 
	CONSTRAINT fk_memberships_member_id_members FOREIGN KEY(member_id) REFERENCES members (id), 
	CONSTRAINT fk_memberships_plan_id_membership_plans FOREIGN KEY(plan_id) REFERENCES membership_plans (id), 
	CONSTRAINT fk_memberships_created_by_users FOREIGN KEY(created_by) REFERENCES users (id)
);

-- Tabel AI: system_settings
CREATE TABLE IF NOT EXISTS system_settings (
	id VARCHAR(36) NOT NULL, 
	scope_type VARCHAR(30) NOT NULL, 
	scope_id VARCHAR(36), 
	`key` VARCHAR(100) NOT NULL, 
	value JSON NOT NULL, 
	updated_by VARCHAR(36) NOT NULL, 
	updated_at DATETIME NOT NULL, 
	CONSTRAINT pk_system_settings PRIMARY KEY (id), 
	CONSTRAINT uq_system_settings_scope_type UNIQUE (scope_type, scope_id, `key`), 
	CONSTRAINT fk_system_settings_updated_by_users FOREIGN KEY(updated_by) REFERENCES users (id)
);

-- Tabel AI: checkin_attempts
CREATE TABLE IF NOT EXISTS checkin_attempts (
	id VARCHAR(36) NOT NULL, 
	branch_id VARCHAR(36) NOT NULL, 
	device_id VARCHAR(36), 
	member_id VARCHAR(36), 
	attempted_at DATETIME NOT NULL, 
	decision VARCHAR(5) NOT NULL, 
	reason_code VARCHAR(50) NOT NULL, 
	match_score NUMERIC(5, 4), 
	match_threshold NUMERIC(5, 4), 
	quality_score NUMERIC(5, 4), 
	liveness_score NUMERIC(5, 4), 
	depth_score NUMERIC(5, 4), 
	membership_id VARCHAR(36), 
	processing_time_ms INTEGER NOT NULL, 
	manual_override BOOL NOT NULL, 
	operator_user_id VARCHAR(36), 
	correlation_id VARCHAR(36) NOT NULL, 
	idempotency_key VARCHAR(100), 
	metadata JSON NOT NULL, 
	created_at DATETIME NOT NULL, 
	CONSTRAINT pk_checkin_attempts PRIMARY KEY (id), 
	CONSTRAINT fk_checkin_attempts_branch_id_branches FOREIGN KEY(branch_id) REFERENCES branches (id), 
	CONSTRAINT fk_checkin_attempts_device_id_devices FOREIGN KEY(device_id) REFERENCES devices (id), 
	CONSTRAINT fk_checkin_attempts_member_id_members FOREIGN KEY(member_id) REFERENCES members (id), 
	CONSTRAINT fk_checkin_attempts_membership_id_memberships FOREIGN KEY(membership_id) REFERENCES memberships (id), 
	CONSTRAINT fk_checkin_attempts_operator_user_id_users FOREIGN KEY(operator_user_id) REFERENCES users (id)
);

-- Tabel AI: face_enrollment_samples
CREATE TABLE IF NOT EXISTS face_enrollment_samples (
	id VARCHAR(36) NOT NULL, 
	face_profile_id VARCHAR(36), 
	enrollment_session_id VARCHAR(36), 
	sample_tag VARCHAR(255), 
	embedding JSON, 
	pose_type VARCHAR(30) NOT NULL, 
	quality_score NUMERIC(5, 4) NOT NULL, 
	liveness_passed BOOL NOT NULL, 
	depth_available BOOL NOT NULL, 
	depth_quality_score NUMERIC(5, 4), 
	storage_reference VARCHAR(500), 
	created_at DATETIME NOT NULL, 
	purge_after DATETIME, 
	CONSTRAINT pk_face_enrollment_samples PRIMARY KEY (id), 
	CONSTRAINT fk_face_enrollment_samples_face_profile_id_face_profiles FOREIGN KEY(face_profile_id) REFERENCES face_profiles (id), 
	CONSTRAINT fk_face_enrollment_samples_enrollment_session_id_enrollm_3ea6 FOREIGN KEY(enrollment_session_id) REFERENCES enrollment_sessions (id)
);

-- Tabel AI: access_events
CREATE TABLE IF NOT EXISTS access_events (
	id VARCHAR(36) NOT NULL, 
	checkin_attempt_id VARCHAR(36) NOT NULL, 
	event_type VARCHAR(50) NOT NULL, 
	door_action VARCHAR(50) NOT NULL, 
	door_result VARCHAR(50) NOT NULL, 
	occurred_at DATETIME NOT NULL, 
	metadata JSON NOT NULL, 
	CONSTRAINT pk_access_events PRIMARY KEY (id), 
	CONSTRAINT fk_access_events_checkin_attempt_id_checkin_attempts FOREIGN KEY(checkin_attempt_id) REFERENCES checkin_attempts (id)
);

-- Data untuk tabel `branches` (1 baris)
INSERT INTO `branches` (`id`, `code`, `name`, `address`, `timezone`, `is_active`, `created_at`, `updated_at`) VALUES ('7a10682c-a453-43af-8696-a60405d55116', 'GYM-001', 'Demo Fitness Center', 'Jakarta', 'Asia/Jakarta', 1, '2026-07-27 14:34:27.323540', '2026-07-27 14:34:27.323547');

-- Data untuk tabel `membership_plans` (4 baris)
INSERT INTO `membership_plans` (`id`, `branch_id`, `name`, `duration_days`, `price`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('565def9a-5e53-4c2e-8690-6936c6d6cab3', '7a10682c-a453-43af-8696-a60405d55116', 'Daily Pass', 1, 75000, NULL, 1, '2026-07-27 14:34:27.713275', '2026-07-27 14:34:27.713284');

INSERT INTO `membership_plans` (`id`, `branch_id`, `name`, `duration_days`, `price`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('416bcc19-a289-49c9-90b8-e6f2766900a6', '7a10682c-a453-43af-8696-a60405d55116', 'Monthly', 30, 500000, NULL, 1, '2026-07-27 14:34:27.716893', '2026-07-27 14:34:27.716903');

INSERT INTO `membership_plans` (`id`, `branch_id`, `name`, `duration_days`, `price`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('d76e02b0-7744-48ff-b03d-ad110386646d', '7a10682c-a453-43af-8696-a60405d55116', 'Quarterly', 90, 1350000, NULL, 1, '2026-07-27 14:34:27.719134', '2026-07-27 14:34:27.719142');

INSERT INTO `membership_plans` (`id`, `branch_id`, `name`, `duration_days`, `price`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('48ca40b1-5eba-4205-837d-f22fa5f8230f', '7a10682c-a453-43af-8696-a60405d55116', 'Annual', 365, 4800000, NULL, 1, '2026-07-27 14:34:27.721458', '2026-07-27 14:34:27.721465');

-- Data untuk tabel `memberships` (8 baris)
INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('b090f143-367b-4cb7-8722-d178144ecc0e', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-07-26 14:34:27.722044', '2026-08-25 14:34:27.722044', 'ACTIVE', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 14:34:27.774739', '2026-07-27 14:34:27.774747');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('cf76111f-e5cb-4d6c-b581-49750b7780e6', '6aefc458-df5e-41c6-8f8e-9e154573f3af', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-05-28 14:34:27.722044', '2026-06-27 14:34:27.722044', 'EXPIRED', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 14:34:27.785817', '2026-07-27 14:34:27.785821');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('670e65c2-1a82-4469-954b-b3674219476a', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-07-26 14:34:27.722044', '2026-08-25 14:34:27.722044', 'SUSPENDED', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 14:34:27.722044', 'Demo suspension', '2026-07-27 14:34:27.794253', '2026-07-27 14:34:27.794261');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('b5c73568-6f10-4300-aa5d-b319ec74be9d', '8afabe91-70e2-4333-91fb-8deb4bfc0283', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-07-26 14:34:27.722044', '2026-08-25 14:34:27.722044', 'ACTIVE', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 14:34:27.803977', '2026-07-27 14:34:27.803980');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('74bd00e7-aeff-495d-8939-c7e321e90514', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-07-27 00:00:00.000000', '2026-08-26 00:00:00.000000', 'ACTIVE', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 15:00:40.770024', '2026-07-27 15:00:40.770028');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('a6757076-e655-4921-96f0-465a397609a6', 'b666a39f-0558-4a46-a759-eb38effff0a2', '416bcc19-a289-49c9-90b8-e6f2766900a6', '2026-07-27 00:00:00.000000', '2026-08-26 00:00:00.000000', 'ACTIVE', 500000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 17:14:10.537447', '2026-07-27 17:14:10.537451');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('702da523-c32e-4c1e-a9cf-e2855785ca78', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', '48ca40b1-5eba-4205-837d-f22fa5f8230f', '2026-07-27 00:00:00.000000', '2027-07-27 00:00:00.000000', 'ACTIVE', 4800000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-07-27 17:35:00.840520', '2026-07-27 17:35:00.840529');

INSERT INTO `memberships` (`id`, `member_id`, `plan_id`, `start_at`, `end_at`, `status`, `price_paid`, `payment_reference`, `created_by`, `suspended_at`, `suspension_reason`, `created_at`, `updated_at`) VALUES ('0d6443f5-1071-4ab2-aefc-9c05d45c4a41', 'd321faf5-2972-4324-b4c5-481737ce063e', '48ca40b1-5eba-4205-837d-f22fa5f8230f', '2026-11-03 00:00:00.000000', '2027-11-03 00:00:00.000000', 'ACTIVE', 4800000, NULL, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, NULL, '2026-11-03 01:55:16.373351', '2026-11-03 01:55:16.373369');

-- Data untuk tabel `biometric_consents` (23 baris)
INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('29c83865-7e63-4bdc-b11f-999467d1eacd', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', 'v1-demo', '2026-07-27 14:34:27.767249', NULL, 'Gym access control demo', 'Retain until consent is revoked', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 14:34:27.767254');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('e7760d29-49b4-4b18-b5c2-b51ea7a9eb7b', '6aefc458-df5e-41c6-8f8e-9e154573f3af', 'v1-demo', '2026-07-27 14:34:27.783176', NULL, 'Gym access control demo', 'Retain until consent is revoked', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 14:34:27.783182');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('9f0c48b1-8701-44a2-8955-c011537a0e86', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', 'v1-demo', '2026-07-27 14:34:27.791856', '2026-10-08 04:20:43.694676', 'Gym access control demo', 'Retain until consent is revoked', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 14:34:27.791866');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('66e4ea53-4734-4973-8cad-fffe3dd5d37e', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-07-27 15:00:53.467522', '2026-07-27 15:20:56.906123', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 15:00:53.467530');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('a2fe867f-56e5-4a4c-8ddc-bed5ac551fde', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-07-27 15:20:56.921277', '2026-07-27 17:01:48.751521', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 15:20:56.921287');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('18e4bfb7-d1d6-43eb-ac34-1a533a8cd22b', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-07-27 17:01:48.771306', '2026-07-27 17:05:40.456960', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 17:01:48.771310');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('b3d1db02-c67b-4b9d-bd6b-29acdc9283b3', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-07-27 17:05:40.463214', '2026-07-27 17:31:05.459787', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 17:05:40.463226');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('d750a399-d3f2-4e61-851b-4701c793a5e5', 'b666a39f-0558-4a46-a759-eb38effff0a2', 'v2.1', '2026-07-27 17:14:25.527765', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 17:14:25.527784');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('775ad0bc-190a-4de9-bf09-1f2b71c0b0ef', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-07-27 17:31:05.463268', '2026-08-01 13:15:18.224398', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 17:31:05.463276');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('30823e09-4a15-43aa-8fed-abdd93399359', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', 'v2.1', '2026-07-27 17:35:22.982746', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-07-27 17:35:22.982760');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('af7efc57-5206-4ae5-bd3d-77372f253439', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-08-01 13:15:18.232308', '2026-08-01 13:17:40.000855', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-08-01 13:15:18.232317');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('31a32a25-0051-43f8-a013-c03b23a6ad45', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-08-01 13:17:40.170180', '2026-08-01 13:20:44.362447', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-08-01 13:17:40.170188');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('ef558ec9-91ea-45f7-9058-0d653d1e4008', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'v2.1', '2026-08-01 13:20:44.530254', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-08-01 13:20:44.530267');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('56476059-57f5-4b4b-8d22-9f73dc3fb2cc', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', 'v2.1', '2026-10-08 04:20:43.705008', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-10-08 04:20:43.705015');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('33ea1f42-5b0d-4234-a949-28e29e4c1596', '8afabe91-70e2-4333-91fb-8deb4bfc0283', 'v2.1', '2026-10-08 04:25:40.336801', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-10-08 04:25:40.336807');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('f5d99ddf-05c8-4920-bfea-a9b560a703ed', 'd321faf5-2972-4324-b4c5-481737ce063e', 'v2.1', '2026-11-03 01:55:37.721147', NULL, 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-11-03 01:55:37.721150');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('637f7949-5507-449d-84dd-8564d5e19b73', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-03 03:42:55.415509', '2026-11-03 04:03:01.742128', 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 1', '2026-11-03 03:42:55.415515');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('a4f46961-6c0f-4738-aa27-fce35363cd84', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-03 04:03:01.764338', '2026-11-03 04:06:03.978513', 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 1', '2026-11-03 04:03:01.764350');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('f8ce4bb5-fcce-44a3-baf0-5da70215483e', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-03 04:06:03.984828', '2026-11-03 04:22:26.326650', 'Kontrol akses gym', 'Template sampai persetujuan dicabut; gambar mentah tidak disimpan.', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', NULL, '2026-11-03 04:06:03.984839');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('5a40c101-cd4c-46eb-bdd4-d92fd7fc127c', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-03 04:22:26.333558', '2026-11-03 04:31:41.599023', 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 1', '2026-11-03 04:22:26.333566');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('fff03575-f668-48f5-b9fe-adb29328b706', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-03 04:31:41.616515', '2026-11-04 08:00:04.239605', 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 1', '2026-11-03 04:31:41.616520');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('6fe20a07-a33f-4eef-9c91-24159bb04400', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-04 08:00:04.252539', '2026-11-06 08:46:22.542655', 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 5', '2026-11-04 08:00:04.252545');

INSERT INTO `biometric_consents` (`id`, `member_id`, `consent_version`, `consented_at`, `revoked_at`, `capture_purpose`, `retention_policy`, `operator_user_id`, `signature_reference`, `created_at`) VALUES ('c85df728-363a-4b57-a72b-0cd772c08095', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'v2.1', '2026-11-06 08:46:22.566806', NULL, 'Kontrol akses gym', 'Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.', '249da968-8c47-45db-8708-eea1364c8386', 'Website-BisaGym operator user ID: 5', '2026-11-06 08:46:22.566813');

-- Data untuk tabel `devices` (1 baris)
INSERT INTO `devices` (`id`, `branch_id`, `device_code`, `name`, `device_type`, `credential_hash`, `public_key`, `capabilities`, `is_active`, `last_seen_at`, `created_at`, `updated_at`) VALUES ('0302e9bd-6b55-4e31-92f2-edad88c82623', '7a10682c-a453-43af-8696-a60405d55116', 'KIOSK-001', 'Demo Front Door Kiosk', 'KIOSK', 'aef3e19dad91537f89dffc30cfd418ca34c23e11fba63226d355cb39144cf44b', NULL, '{"rgb": true, "depth": false, "active_liveness": true, "demo_mode": true}', 1, NULL, '2026-07-27 14:34:27.802927', '2026-11-03 04:05:20.179549');

-- Data untuk tabel `enrollment_sessions` (18 baris)
INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('bca91925-a47b-4426-a9e4-34be09ce74d5', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 15:10:53.509972', '2026-07-27 15:00:53.511390');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('82524f1a-dbb4-4b7d-8371-31b68a548eca', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 15:30:56.984350', '2026-07-27 15:20:56.984853');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('a0aade5a-c063-47ea-8102-211685e9c7aa', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 17:09:45.177919', '2026-07-27 16:59:45.179009');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('a3a3e626-4a31-4758-b4ca-875e4ce6c50c', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'OPEN', '2026-07-27 17:11:48.798996', '2026-07-27 17:01:48.799291');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('3acb240c-7a46-4f26-8fee-b656b1743a90', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 17:15:40.516588', '2026-07-27 17:05:40.517660');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('881195d5-e66b-4802-a7da-72df126b5f52', 'b666a39f-0558-4a46-a759-eb38effff0a2', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 17:24:25.570223', '2026-07-27 17:14:25.570662');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('2ed287d4-f12a-4d33-af5c-a2e8d056f048', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 17:41:05.515807', '2026-07-27 17:31:05.516437');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('cfbbdfb1-61d4-4e21-8e6d-0e9c3bafe220', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'COMPLETED', '2026-07-27 17:45:23.022240', '2026-07-27 17:35:23.023289');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('a630909c-47e6-43dd-a025-62e62743889e', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'OPEN', '2026-10-08 04:30:43.760742', '2026-10-08 04:20:43.762951');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('1ed61d62-92bc-46bc-b9b8-8a1413ae85b8', '8afabe91-70e2-4333-91fb-8deb4bfc0283', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'OPEN', '2026-10-08 04:35:40.368500', '2026-10-08 04:25:40.369556');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('2f7224ff-9e8a-4e30-9467-947dd76897b8', 'd321faf5-2972-4324-b4c5-481737ce063e', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'OPEN', '2026-11-03 02:05:37.785158', '2026-11-03 01:55:37.817427');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('6989ca62-06ba-4323-9843-9d7f3a6f7002', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-03 03:52:55.462055', '2026-11-03 03:42:55.463034');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('3870690f-4e58-45c7-b392-75cdc86e41c2', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-03 04:13:01.813164', '2026-11-03 04:03:01.814438');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('b68d1a17-4ae4-474d-bf14-a1b67ab4cc3a', '8f0d767e-0158-4c60-9713-5352f35c2b76', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'OPEN', '2026-11-03 04:16:04.022324', '2026-11-03 04:06:04.023147');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('21a1c2ae-815a-4d17-99dd-0df935f9a5b9', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-03 04:32:26.376945', '2026-11-03 04:22:26.378711');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('a758e175-c89c-4547-bc5a-8e34e34892cb', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-03 04:41:41.657034', '2026-11-03 04:31:41.658601');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('aa51ffb2-83e6-4fe6-a888-75118765852b', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-04 08:10:04.352497', '2026-11-04 08:00:04.354469');

INSERT INTO `enrollment_sessions` (`id`, `member_id`, `operator_user_id`, `status`, `expires_at`, `created_at`) VALUES ('84383201-f9ac-4fa5-80de-bdf47b71547c', '8f0d767e-0158-4c60-9713-5352f35c2b76', '249da968-8c47-45db-8708-eea1364c8386', 'OPEN', '2026-11-06 08:56:22.646648', '2026-11-06 08:46:22.659147');

-- Data untuk tabel `face_profiles` (10 baris)
INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('ff7691b0-3d72-4870-a858-3436c9af553f', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', 'replaceable-embedding-model', 'dev', 16, '[-0.15255755, 0.03457971, 0.08746633, -0.0101705, 0.09967094, 0.07526173, 0.47394547, -0.19730777, 0.09967094, -0.31528561, 0.16476216, 0.12001194, 0.40071784, -0.13628475, -0.46580907, -0.37630864]', 0.95, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 14:34:27.769636', '2026-07-27 16:57:20.739741', 'Engine upgraded to OpenCV SFace; real re-enrollment required');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('bb55f9b3-bd8e-4979-af6c-072697f2ebf4', '6aefc458-df5e-41c6-8f8e-9e154573f3af', 'replaceable-embedding-model', 'dev', 16, '[-0.15962849, 0.14910353, 0.34556937, -0.16664513, 0.10700371, -0.35960264, 0.27189468, -0.03683734, 0.39468582, 0.44380228, 0.16664513, 0.06490389, -0.15612017, -0.17366176, -0.352586, -0.15962849]', 0.95, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 14:34:27.784292', '2026-07-27 16:57:20.739741', 'Engine upgraded to OpenCV SFace; real re-enrollment required');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('894ff22d-5a06-4a38-9b23-631b54089719', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', 'replaceable-embedding-model', 'dev', 16, '[0.31826805, -0.18040078, -0.35053485, 0.20973424, -0.24200105, 0.08066702, -0.01320006, 0.36813493, 0.2772012, 0.04546686, -0.29186793, 0.29480128, -0.30360132, 0.32413474, 0.16573405, -0.15106732]', 0.95, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 14:34:27.792702', '2026-07-27 16:57:20.739741', 'Engine upgraded to OpenCV SFace; real re-enrollment required');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('ceae3be0-9433-42f4-8b89-fc960dde46e7', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'replaceable-embedding-model', 'dev', 16, '[0.2954691, 0.64915917, 0.08536263, -0.17156123, 0.14456219, 0.30965566, 0.25092517, -0.09496326, 0.00880099, -0.11330501, 0.07464459, 0.00105914, 0.3852662, -0.06145191, -0.30826779, -0.00895522]', 0.95, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 15:01:22.565103', '2026-07-27 15:21:27.586824', 'Re-enrolled');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('d0d91918-0f0e-49d4-aaed-a93aed625603', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'replaceable-embedding-model', 'dev', 16, '[0.2954691, 0.64915917, 0.08536263, -0.17156123, 0.14456219, 0.30965566, 0.25092517, -0.09496326, 0.00880099, -0.11330501, 0.07464459, 0.00105914, 0.3852662, -0.06145191, -0.30826779, -0.00895522]', 0.95, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 15:21:27.590880', '2026-07-27 16:57:20.739741', 'Engine upgraded to OpenCV SFace; real re-enrollment required');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('141bb184-7db2-474e-bf44-cf0cd5353b36', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', 'opencv_sface', '2021dec', 128, '[0.0008727984716540777, -0.13764361639717745, 0.04521990809396332, 0.046177259244249376, -0.10505491936830562, -0.03955019523735906, -0.08262110262948448, -0.13213112568778948, -0.09521418534947221, 0.06502421012509432, 0.022574127931215878, 0.06051387463111823, -0.11646709254836184, -0.09573927990303881, -0.015729531191563867, -0.08541806540596489, -0.10406339613109854, -0.03240295405995411, -0.22942236893493315, 0.07032558863936461, -0.02407484059551956, -0.1764488616297742, 0.05011285696757508, -0.0524476490671032, -0.08865456772148794, 0.010068230040210631, 0.0005191195373463715, -0.015440403037946025, -0.09742662774326094, 0.03344962276785692, -0.04021898540945883, 0.04445550089853399, 0.020893029265288958, -0.1848703867457453, 0.09368470040637919, 0.038948497541597196, 0.06546898742214535, -0.0010074653837483546, -0.03602176428131716, -0.11637466064814549, 0.010398711708914989, -0.023968870990749524, 0.10181418512312572, 0.14607764358702918, 0.09235086770411167, 0.027610185690155744, 0.0006299461638257564, 0.06594702411002065, 0.12019100438188045, -0.019382761231645645, -0.06729958757136795, 0.09187241378373501, 0.0834138071292038, 0.0019090691961422095, -0.00881487850722709, 0.016754425578300935, 0.14456785797846558, 0.0047757233045299516, -0.04878505178483643, 0.14522116956982223, -0.17084244890409353, 0.08581662675290774, -0.0026259537959289103, 0.0716065222209215, 0.014826712701737146, -0.07226878195931664, -0.10186525885164281, 0.05850201303707754, 0.15503119974690233, 0.11048709282117802, -0.0426609243054573, -0.05629634694614603, 0.006007143588498453, 0.1308034620660781, -0.052625986159121445, -0.01735390486375412, 0.03519560667568366, -0.04582046585092677, -0.08168779822738062, -0.19438526963158162, -0.01271993443892279, -0.0889727820095937, 0.008562952964100562, 0.07227830380104455, -0.20354353793802452, 0.07616631466747184, 0.09554116897068732, 0.15131781558346316, -0.043961914849401935, -0.024909620385299883, -0.01483564967290509, -0.0805569416864539, 0.12856493519037274, 0.09992052326155175, 0.10717821556782638, -0.03671552134827628, 0.15119133453090208, 0.0723694616520156, -0.00788199785688244, 0.07416137093731563, 0.10724061417852376, -0.09995998153525365, -0.0939335870440325, -0.010610194570406675, 0.07627523470207305, 0.07759665473742453, -0.0026269468185954195, -0.028458113891664808, 0.09622427543299068, -0.12127942241695255, 0.04047281923248564, -0.1897092555816559, 0.11183135633598001, 0.018849741123197927, -0.0400184791155146, -0.15697344684314585, -0.026665900995214233, -0.0030064379393898418, 0.16308992630176308, -0.010019375653324761, -0.015578930747661885, 0.033812376625484954, 0.06543636878123393, 0.030735964930625182, 0.020419569096413178, 0.1766194501181954, -0.11298074247031623, 0.08112296972863799]', 0.9090000000000001, 'ACTIVE', 1, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 16:59:45.695715', NULL, NULL);

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('3ad82792-9c7b-45bd-b9ce-5924cdfa4b74', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'opencv_sface', '2021dec', 128, '[-0.012578292069107077, -0.06900799116517782, -0.12020095388128862, 0.009440426542105676, 0.10712578921411567, -0.06941053765624039, 0.22219049596598023, 0.135881372538073, -0.17095237665502463, 0.03019914511490213, -0.019473248371309714, -0.03898638817534514, 0.0047363865349717045, 0.04938696851793393, 0.042196202954173215, -0.02282729345088178, -0.0707899782762374, -0.07589529148842855, -0.1129565253774636, 0.16783349607469042, 0.12565583083689674, 0.015779279771116678, -0.08608333508859642, -0.06454531861981833, -0.06274223062213094, -0.06802880379692786, 0.04866742586963673, -0.07678912552213377, 0.09145879132211629, -0.06536747123689256, 0.12131267499028779, 0.013889452066907658, 0.04779074821010307, -0.0430405361816062, -0.056392626848832, 0.0027234693194800466, 0.05930423098675442, 0.039458043020911535, -0.009168462660593714, 0.038229776800647444, -0.05698521779394185, 0.0006253042269322842, 0.04672034296439143, 0.006623445686701022, -0.03818546453634754, -0.006070887846141822, 0.0004546612682493017, 0.008302932645605268, -0.1417306370288985, -0.10214832719545604, 0.14158812422658615, -0.14344655007739254, -0.03806284044111082, 0.16423947803678055, 0.0538692571621322, 0.11136823969778355, -0.03367758107463877, 0.10957589830439846, 0.03026437384096896, 0.07709643501503927, 0.08716672451514966, 0.022562493217772667, -0.16182914838303522, 0.18924313272122212, -0.04212776624148091, -0.05656223568702235, -0.1861952107797232, 0.13504610630743663, -0.11721685769564216, 0.04847531149801454, 0.16216513963030438, 0.18893675407088714, 0.05319288367931539, 0.13333675610144635, 0.17478558636049807, 0.12369808381555966, -0.0838855218905373, -0.055041198017976765, -0.05449388471748402, 0.004042044034982722, 0.023622815621022204, 0.0034117177514297824, -0.06417227071759413, 0.08572031453371709, -0.012858787025535817, 0.005934930174020942, 0.18212879147853728, -0.20854974115928368, 0.1246255758893519, -0.012796494007936227, -0.06545023843191089, -0.07059131816332578, -0.10176373228503335, 0.006371631814000076, -0.07375966953897761, -0.016108005014185175, 0.005088561734418692, 0.06808409101703962, 0.05044980932648822, 0.05298384245864395, 0.010930895035995494, -0.14789660259718118, 0.018999836124478118, 0.005181477232246053, -0.004250350574072013, -0.044301302086172036, -0.0019113075000964403, 0.08246440359920752, 0.09208668353282358, 0.009048125271212256, 0.015450318443268881, 0.060268707286829086, -0.0466863682165206, -0.04420152488325809, 0.1601245342074723, 0.07583049716673856, 0.03984997535825372, -0.02762132511972629, 0.014856916720364398, -0.039165793662145294, -0.01352857955868066, 0.06661275484204669, 0.006912422007163583, -0.006363443685495049, 0.02497549133159593, -0.13367693614028292, 0.1308920858679698, 0.17592770605165667]', 0.7447666666666667, 'REVOKED', 0, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 17:07:46.354594', '2026-07-27 17:31:30.752394', 'Re-enrolled');

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('2b6202c1-3afa-4596-a606-d1d35a7ed02b', 'b666a39f-0558-4a46-a759-eb38effff0a2', 'opencv_sface', '2021dec', 128, '[-0.027776841648583517, -0.025442435989965265, 0.059350777551900186, -0.07033959527324747, 0.09012862486298939, 0.04571209686343236, 0.09280877262561951, -0.08870643968404805, -0.04193192973877762, 0.14384015051923082, 0.04626885061225555, 0.036564331483796335, -0.0554373996553313, -0.03916088572855715, 0.007803302109868832, -0.07272733863331164, -0.14304567498181894, -0.19656092340105102, -0.04184452212733301, 0.046353496293869756, 0.14169384622288958, 0.025292151820750675, -0.10533881233097202, -0.04654153661144449, -0.09900196618416034, 0.17631835197159007, 0.0359558564106493, 0.039079347196567915, 0.05072657106374686, -0.06769991463963047, -0.032393312320699925, 0.08038740483644485, -0.08583706123214875, -0.2793807236752885, 0.045256761342596444, 0.04965963878772737, -0.044300755692839845, 0.13184998947494653, -0.05969241157036465, 0.019024349975799736, 0.12620154032037248, -0.026668560074726563, -0.04098761562846987, -0.024258375906184973, -0.047085030627857835, 0.05998406849684121, -0.007225715913286261, 0.10712036972992194, -0.13225449705038803, -0.09269943539077637, 0.031547044082960475, -0.0026113606715935924, 0.026052224553054625, 0.008686960860064685, 0.06765979909637983, -0.0004226159033616414, 0.07725260984914441, 0.06993397009534053, -0.04308474659521462, -0.004991355748486454, 0.15203900549543312, 0.009446533928191244, -0.1203018236263634, 0.12852426243451168, 0.0027038678305759934, 0.0689612453990623, -0.014660273126449137, 0.05798732432124439, 0.051579649858295246, 0.14497662179926296, 0.07773732124673985, 0.09071487760681995, 0.08743200326149009, 0.1704812493088364, 0.09647788983428962, 0.051327253334815776, 0.016357492124982838, -0.10135577857093936, 0.019264860272670662, 0.03266459287707689, -0.01656778735191179, -0.021447481365599742, -0.061326151280430306, 0.008486711955698853, -0.04626422527574067, -0.034529234859411916, 0.09119040349146107, -0.004395732299908165, 0.19194625393346812, 0.03532714270379904, 0.1566260855011676, -0.03372410633555666, -0.13348032405664736, 0.010164615278703555, 0.14434698753487285, 0.12274063355916415, -0.06403674183031875, 0.2741870568668045, -0.06359598673373808, -0.02219002638055074, 0.1456225762619233, -0.04298579969169486, -0.030380762411349797, 0.03436704663030497, 0.0968505121841706, -0.015956995323660236, -0.00482531278649397, 0.06515593574486683, 0.1480233505439349, 0.06241107271002139, 0.018690785303917896, 0.011559253221240141, -0.07437008929591889, -0.17381691291783222, -0.010281618596425431, 0.011273415989740713, -0.0956325496560724, -0.12335372951050512, -0.126305944594555, -0.1262395471635493, -0.10873062883531903, 0.06713855621689528, -0.1194758627404857, -0.013229723794452142, -0.023908387422939235, -0.006922849910564386, -0.009346472037182758, 0.09873863168464427]', 0.7379666666666665, 'ACTIVE', 1, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 17:15:44.633469', NULL, NULL);

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('33d0ab34-32c6-4605-abf5-2f0409fc7ede', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'opencv_sface', '2021dec', 128, '[-0.0068722565396159485, -0.08684123826795766, -0.09877800196660444, -0.02141150806918938, 0.11566923226553763, -0.044532466670343517, 0.1869747946364917, 0.11721474597997955, -0.13832408434989416, 0.04103145050599975, -0.0120291748872832, -0.04849100100837835, -0.09018243505142293, 0.06414892559999781, 0.02997358967742341, -0.0243285172379661, -0.03611403915711806, -0.05696324774208857, -0.11473631900588337, 0.19949345626055745, 0.11281123040154833, -0.0075965124620846385, -0.10874505057328834, 0.006686761419989051, -0.07554535395224664, -0.09707921326593734, 0.06581821702616916, -0.0781848074083279, 0.06520304929961761, -0.08832433988714394, 0.10711710890575382, 0.01637423688415256, 0.05481870175875316, -0.053670230606766414, -0.028695013818307268, -0.001897646523533634, 0.049670913807333364, 0.04407459385195862, -0.07662743617456229, 0.07262033313660948, -0.09513996572815554, 0.03409037745455085, 0.0997105312096664, 0.03256253186014295, -0.01562869805259766, 0.025057703317509204, -0.02846449409594898, 0.017204366290212967, -0.1580505064643204, -0.072542984675715, 0.0923206568926285, -0.09195330339792097, 0.0016939878638655818, 0.16979353782029974, 0.042999114600253775, 0.05678834815718854, -0.0335327786489598, 0.06545594369501742, 0.014412020857462318, 0.09608735883022702, 0.1339894977357071, -0.007401058800288526, -0.17520234438702556, 0.16923827668214642, -0.01699872574071713, -0.0631827667395573, -0.19520997406424134, 0.12849379935868205, -0.08487702293809983, -0.0354143944938381, 0.12885078709082828, 0.16672254101912173, 0.0493081607911201, 0.11469020076149315, 0.19013273762794086, 0.1390407291323177, -0.11596618182318058, -0.04736424194660895, -0.09135928343825288, -0.010306490626182895, 0.024279968636818628, -0.015950895054259794, -0.04201189058926168, 0.06584099417813916, -0.09362120561721539, -0.019427513702915834, 0.1908341936142383, -0.20839424654541594, 0.058880385289593704, -0.025640074550091763, -0.07938681525985121, -0.10230330113819185, -0.10224479097376561, 0.01618690224448564, -0.09891633857311775, -0.013795837366742676, -0.013567609659499949, 0.04100325549756152, 0.07531683454009246, -0.04305719001862311, -0.0014871448708070833, -0.07640064483707346, 0.0030134456711959747, 0.04706328304090796, 0.032009058547488374, -0.07572321607074398, 0.029817972659935594, 0.013758113778768672, 0.11993272411560861, -0.0011847502667098964, -0.017293643434345075, 0.0955098059317055, -0.10117018901870758, -0.02917818461086664, 0.18560594466709035, 0.09360688152977965, 0.049097925805349114, -0.03993121745747898, 0.01671761787454291, -0.0410731639726591, -0.002649284817930176, 0.11309449231883509, -0.009226327700081444, 0.031183673290465484, 0.017345568922657255, -0.14110464107748322, 0.13600406824826627, 0.15603146001011636]', 0.7166333333333333, 'ACTIVE', 1, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 17:31:30.757693', NULL, NULL);

INSERT INTO `face_profiles` (`id`, `member_id`, `model_name`, `model_version`, `embedding_dimension`, `embedding`, `quality_score`, `enrollment_status`, `is_primary`, `created_by`, `created_at`, `revoked_at`, `revocation_reason`) VALUES ('21ec80e9-0929-41f5-8be7-8e126f521953', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', 'opencv_sface', '2021dec', 128, '[-0.07357375965033401, -0.02539742061447008, 0.11193160657549107, 0.1269605476002402, 0.0842743939920837, -0.04467227826772305, 0.13948763429715105, 0.055511454436169054, -0.0908233675424571, -0.019768248704509304, 0.09858716104588659, -0.023524226670075844, -0.0032035935407899777, 0.08161974199033865, 0.06510407266486505, 0.10513107004483067, -0.09796844692241181, 0.03466187091808094, -0.10301575475995822, 0.09794943388332443, -0.010732899722046416, -0.02513781740586457, -0.125066020019371, -0.058054780021641765, -0.03935676743625846, 0.0021270532740870663, -0.003882902059930663, -0.028928981542982696, 0.06374470066239546, 0.06024220487210307, 0.08544319782930633, 0.09014422351638171, -0.03926719342565927, -0.15660342740831534, 0.05203661445207713, 0.08871713935257931, -0.012506509335325803, -0.03642943115142941, 0.0780698453278502, -0.09081757293017215, 0.18084114897503062, -0.1656899588012617, -0.21179186006201037, -0.000743869262035901, -0.04330280141037656, 0.059866553828289225, 0.05547540948363749, 0.018505087778451588, -0.19848610906845568, -0.08270455475091996, -0.07767155322260003, -0.08739835060733177, 0.00878910458398148, 0.09395412932101288, -0.14856441931213973, -0.08768793966579354, 0.02814497056636522, -0.0990003132318381, 0.10740554252833424, 0.09029961769038718, 0.07449149595251818, 0.013305160522431796, 0.018821607497389637, 0.14014050530733596, 0.006486471428360345, 0.15595514909694208, -0.06934743473572505, -0.0005169548467005038, -0.1254480187915938, 0.1060985461664225, 0.17632465698250327, 0.02541252088126079, 0.024591859244081398, 0.13138046709035758, 0.09967658223370017, -0.08519792326817566, 0.11932843636607812, 0.011071871597536042, -0.02323255228518445, -0.050919343474209164, -0.013173175808743501, 0.04936604135659195, -0.00789047769842023, 0.05835891655844567, -0.016426418566685037, -0.02598256176884903, 0.07261328529730725, -0.09413945467939717, 0.14369225530205038, 0.00747280101110568, 0.005313974689053824, -0.17662287570106097, -0.09416220059697078, -0.11361895677897245, -0.10153090076268716, -0.01971435334627157, 0.016835298725191496, 0.08003878799862613, -0.11722991903439359, 0.07116851190315028, 0.09582477067381587, -0.09709241845952171, -0.08766752155446697, -0.1107120196002951, 0.13579178313441337, -0.08443324710791678, 0.12861925372842753, -0.1633467046238253, 0.12567149081271073, -0.06710160632751555, -0.03851569473277422, -0.10991868461934784, -0.03533356131117477, 0.02475125818526019, -0.12228176452127962, -0.10392587457447267, -0.011740878328867053, -0.06671907541039619, -0.0043581710215908264, 0.06343240254984585, 0.05973580019118736, -0.0360089675436325, -0.07243235078967042, -0.004065370580087964, -0.05617693112010435, -0.12004686081187016, -0.07497160468026343, -0.11519883730597986]', 0.7219000000000001, 'ACTIVE', 1, '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '2026-07-27 17:36:45.312306', NULL, NULL);

-- Data untuk tabel `face_enrollment_samples` (24 baris)
INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('6009bd5a-d60a-4553-8b98-c21609db4573', 'ceae3be0-9433-42f4-8b89-fc960dde46e7', 'bca91925-a47b-4426-a9e4-34be09ce74d5', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:front', 'FRONT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:01:06.467067', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('31bbba65-3736-4e1c-937b-ac2d34fef78c', 'ceae3be0-9433-42f4-8b89-fc960dde46e7', 'bca91925-a47b-4426-a9e4-34be09ce74d5', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:left', 'LEFT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:01:14.797459', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('cfa41366-a7a6-45b7-ad99-e6cb14c6d2a9', 'ceae3be0-9433-42f4-8b89-fc960dde46e7', 'bca91925-a47b-4426-a9e4-34be09ce74d5', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:right', 'RIGHT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:01:17.048065', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('2cee644e-5c1f-4217-8e69-935c1d56fb64', 'ceae3be0-9433-42f4-8b89-fc960dde46e7', 'bca91925-a47b-4426-a9e4-34be09ce74d5', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:up', 'UP', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:01:22.526840', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('ad03905b-1513-45dd-a648-1991a0d3aafd', 'd0d91918-0f0e-49d4-aaed-a93aed625603', '82524f1a-dbb4-4b7d-8371-31b68a548eca', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:front', 'FRONT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:21:14.949479', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('9c953cca-a5c4-4694-bcf8-ad1871819cb4', 'd0d91918-0f0e-49d4-aaed-a93aed625603', '82524f1a-dbb4-4b7d-8371-31b68a548eca', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:left', 'LEFT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:21:20.348675', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('d18ede9a-33c5-4eac-a011-38fbb58850e9', 'd0d91918-0f0e-49d4-aaed-a93aed625603', '82524f1a-dbb4-4b7d-8371-31b68a548eca', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:right', 'RIGHT', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:21:23.962363', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('66b6f7ce-65d3-4961-84e5-d564af164047', 'd0d91918-0f0e-49d4-aaed-a93aed625603', '82524f1a-dbb4-4b7d-8371-31b68a548eca', 'ui-enrollment:f77fb14e-8c03-4a53-be63-6be4736c4c52:up', 'UP', 0.95, 1, 0, NULL, NULL, '2026-07-27 15:21:27.535595', NULL, NULL);

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('339eef1f-3447-46f2-8d00-110b5eb97d3e', '141bb184-7db2-474e-bf44-cf0cd5353b36', 'a0aade5a-c063-47ea-8102-211685e9c7aa', NULL, 'FRONT', 0.9089785814285278, 0, 0, NULL, NULL, '2026-07-27 16:59:45.317749', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('49bea064-3377-477f-a125-655cd5e414b1', '141bb184-7db2-474e-bf44-cf0cd5353b36', 'a0aade5a-c063-47ea-8102-211685e9c7aa', NULL, 'LEFT', 0.9089785814285278, 0, 0, NULL, NULL, '2026-07-27 16:59:45.544566', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('af2da378-e3f2-4bd5-b9a7-f05597c082ff', '141bb184-7db2-474e-bf44-cf0cd5353b36', 'a0aade5a-c063-47ea-8102-211685e9c7aa', NULL, 'RIGHT', 0.9089785814285278, 0, 0, NULL, NULL, '2026-07-27 16:59:45.665723', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('0f3d9c24-fab2-411e-a2c9-ef8b65a82deb', '3ad82792-9c7b-45bd-b9ce-5924cdfa4b74', '3acb240c-7a46-4f26-8fee-b656b1743a90', NULL, 'FRONT', 0.759181585986941, 0, 0, NULL, NULL, '2026-07-27 17:07:35.539819', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('d65cd7d5-dab7-43a7-943e-f41b60c9c779', '3ad82792-9c7b-45bd-b9ce-5924cdfa4b74', '3acb240c-7a46-4f26-8fee-b656b1743a90', NULL, 'LEFT', 0.7286649024407347, 0, 0, NULL, NULL, '2026-07-27 17:07:41.510877', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('7b33d88a-115c-4e33-b949-a8e87c4c6956', '3ad82792-9c7b-45bd-b9ce-5924cdfa4b74', '3acb240c-7a46-4f26-8fee-b656b1743a90', NULL, 'RIGHT', 0.7464094935334404, 0, 0, NULL, NULL, '2026-07-27 17:07:46.330129', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('c65da7dd-2007-4921-90b7-5be03e86a8ae', '2b6202c1-3afa-4596-a606-d1d35a7ed02b', '881195d5-e66b-4802-a7da-72df126b5f52', NULL, 'FRONT', 0.7591876602034617, 0, 0, NULL, NULL, '2026-07-27 17:15:32.484143', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('7b01a447-2a6b-49cf-9ab2-315b77e5811b', '2b6202c1-3afa-4596-a606-d1d35a7ed02b', '881195d5-e66b-4802-a7da-72df126b5f52', NULL, 'LEFT', 0.7267969609564199, 0, 0, NULL, NULL, '2026-07-27 17:15:40.764520', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('b1852c61-919b-4069-896a-d1231665b632', '2b6202c1-3afa-4596-a606-d1d35a7ed02b', '881195d5-e66b-4802-a7da-72df126b5f52', NULL, 'RIGHT', 0.7278811176242135, 0, 0, NULL, NULL, '2026-07-27 17:15:44.605612', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('02874b5d-752b-4d0f-a443-af9b9e0fd243', '33d0ab34-32c6-4605-abf5-2f0409fc7ede', '2ed287d4-f12a-4d33-af5c-a2e8d056f048', NULL, 'FRONT', 0.7116987041784271, 0, 0, NULL, NULL, '2026-07-27 17:31:17.760590', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('34d67d28-d9f5-45c3-86c1-92d267c5a3e0', '33d0ab34-32c6-4605-abf5-2f0409fc7ede', '2ed287d4-f12a-4d33-af5c-a2e8d056f048', NULL, 'LEFT', 0.7319365155696559, 0, 0, NULL, NULL, '2026-07-27 17:31:24.552807', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('b2a46c31-e413-4641-9a95-fd6efaed7298', '33d0ab34-32c6-4605-abf5-2f0409fc7ede', '2ed287d4-f12a-4d33-af5c-a2e8d056f048', NULL, 'RIGHT', 0.7062532823677711, 0, 0, NULL, NULL, '2026-07-27 17:31:30.693797', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('b0bed9ad-a243-4204-b214-46f4cfe9f7d5', '21ec80e9-0929-41f5-8be7-8e126f521953', 'cfbbdfb1-61d4-4e21-8e6d-0e9c3bafe220', NULL, 'FRONT', 0.7444483433551665, 0, 0, NULL, NULL, '2026-07-27 17:36:01.677379', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('e8b342db-25ff-43c4-8055-4a52818e38e4', '21ec80e9-0929-41f5-8be7-8e126f521953', 'cfbbdfb1-61d4-4e21-8e6d-0e9c3bafe220', NULL, 'LEFT', 0.700882239803557, 0, 0, NULL, NULL, '2026-07-27 17:36:07.457023', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('a2d43806-6a42-41d2-b7de-aa56925aa6fd', '21ec80e9-0929-41f5-8be7-8e126f521953', 'cfbbdfb1-61d4-4e21-8e6d-0e9c3bafe220', NULL, 'RIGHT', 0.7203739124417574, 0, 0, NULL, NULL, '2026-07-27 17:36:45.270748', NULL, 'null');

INSERT INTO `face_enrollment_samples` (`id`, `face_profile_id`, `enrollment_session_id`, `sample_tag`, `pose_type`, `quality_score`, `liveness_passed`, `depth_available`, `depth_quality_score`, `storage_reference`, `created_at`, `purge_after`, `embedding`) VALUES ('da09ae21-3223-4e8a-b10b-33899b8f3b58', NULL, 'a630909c-47e6-43dd-a025-62e62743889e', NULL, 'FRONT', 0.7610764409669728, 0, 0, NULL, NULL, '2026-10-08 04:22:01.612555', NULL, '[-0.016374101862311363, 0.0836021676659584, 0.10113354027271271, 0.10193606466054916, 0.07047316431999207, 0.05985341966152191, -0.17562901973724365, -0.06663717329502106, -0.02071288228034973, -0.11643807590007782, 0.26909226179122925, -0.004420168232172728, -0.010553919710218906, -0.024586718529462814, -0.0022703814320266247, -0.04486039653420448, 0.06058192998170853, -0.1876593381166458, 0.05415292829275131, -0.01771901175379753, -0.023715447634458542, 0.023676762357354164, 0.01761581376194954, -0.007446670904755592, 0.0324837788939476, 0.14909963309764862, -0.08701051771640778, -0.003556017531082034, 0.10274578630924225, -0.008806956931948662, 0.11590209603309631, -0.04403182119131088, -0.16871194541454315, 0.04381079971790314, -0.0707281306385994, -0.0956566259264946, -0.03539487347006798, -0.074089415371418, 0.08020850270986557, -0.22291144728660583, 0.2004738599061966, -0.003646554658189416, 0.05234084278345108, -0.04040330648422241, -0.10297306627035141, -0.09019967168569565, -0.026363352313637733, -0.06627554446458817, 0.11602799594402313, -0.05029384791851044, 0.007499913219362497, -0.031493183225393295, 0.04333804175257683, -0.02731611765921116, 0.15228420495986938, -0.05593724548816681, 0.020016714930534363, -0.017758456990122795, 0.10254372656345367, 0.08016272634267807, 0.013362838886678219, 0.018630148842930794, 0.1317208856344223, -0.09128249436616898, -0.04092686250805855, 0.05665343254804611, -0.024661317467689514, -0.0024636583402752876, -0.0955575630068779, 0.0041856407187879086, -0.13600288331508636, 0.04889553412795067, -0.05669954791665077, -0.0313345305621624, 0.07210935652256012, -0.08928758651018143, 0.042102061212062836, -0.06574416160583496, -0.06086215004324913, -0.08017831295728683, -0.024905435740947723, 0.2673214077949524, -0.18440736830234528, 0.07411117106676102, -0.07811198383569717, -0.0704631581902504, -0.15441343188285828, 0.03956589102745056, -0.12010987848043442, -0.13891714811325073, -0.048762548714876175, 0.00026348308892920613, -0.011704460717737675, -0.04204564169049263, 0.0689803883433342, -0.03954582288861275, -0.07782123237848282, 0.06776108592748642, 0.08791300654411316, -0.04097806289792061, 0.04505803436040878, -0.03803425654768944, -0.010602972470223904, 0.10207205265760422, -0.04855618253350258, -0.15007148683071136, -0.03122728317975998, 0.05929862707853317, -0.01118454895913601, -0.055270154029130936, 0.057644907385110855, 0.08283908665180206, -0.1001693606376648, 0.04674064740538597, 0.08436930179595947, 0.04355773702263832, 0.15369382500648499, 0.038783542811870575, -0.029696328565478325, 0.04609537869691849, -0.09498681873083115, 0.19189833104610443, 0.13056905567646027, 0.07149476557970047, 0.08364297449588776, 0.030213911086320877, -0.080140121281147, 0.05447922646999359]');

-- Data untuk tabel `checkin_attempts` (77 baris)
INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('c686d716-57f0-4eb2-bf7f-c8a1baf2bf93', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 14:35:56.482758', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 14, 0, NULL, '2f09aa82-55d2-4bf2-92f9-d67d1b1107fa', '0a32f960-dcaf-48bf-b0e6-342bc51d5af8', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 14:35:56.482778');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('d92f7325-4cea-4605-a84a-91537c3e7544', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 14:58:44.971414', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 11, 0, NULL, '13f9cc99-fff4-4d8e-9acc-799fc06aed9c', '22a3a1c8-3f20-41eb-95d6-a0bcf4ac7df1', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 14:58:44.971419');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('f9199085-299d-492f-8c53-09cc4077d8c2', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 14:58:54.802672', 'DENY', 'DUPLICATE_CHECKIN', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 15, 0, NULL, '89dceb46-e11c-4f0e-9285-fb3bae66ff5f', '5d109649-ce62-4be5-9ad7-bd0bb78e0e4c', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 14:58:54.802679');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('45fffeb1-c8f7-4513-bba3-521dfebbe4e7', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 14:59:25.639537', 'DENY', 'DUPLICATE_CHECKIN', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 6, 0, NULL, '1166ffab-bfed-4c0e-88e5-9aa586cc633d', '38513971-f21b-45be-8632-fa7522196866', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 14:59:25.639555');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('5a3cce3e-2bf6-487a-8d97-94b9348c7f2c', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:01:52.598960', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 4, 0, NULL, '46489c49-6d8d-42fb-b73f-668b9039eeb3', '2985af30-43bf-4934-a2ba-bdf65804d380', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:01:52.598963');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('4ae881a4-3b25-4c86-b7a7-03678f7d063d', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:02:09.532623', 'DENY', 'DUPLICATE_CHECKIN', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 7, 0, NULL, 'd9fe7b6e-b028-4255-a2d4-273f317b2ab6', 'c3dd973c-4ee5-430a-b572-15e4cadc9043', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:02:09.532635');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('9c332a24-e448-42a6-a26b-e90bdd19c3f7', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:03:13.855328', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 13, 0, NULL, '0e259ddf-ac11-4a90-946d-8f53acddb3a2', 'd13527f9-1eda-4586-8d0f-6149ac4570e4', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:03:13.855335');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('8c099ec0-b09b-4e4e-bcc9-9ede0d6ab934', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:05:16.227672', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 6, 0, NULL, 'a2189acd-f7d8-4024-af38-5df748cb1a8a', 'db02ef36-1e98-4928-96e0-1bfd2d5b6bbd', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:05:16.227676');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('764f240d-5aef-44e6-ba87-872bb005b691', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:13:44.385782', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 4, 0, NULL, 'eadbfbb2-5c15-47a1-a5f4-f471c9975eae', '35b4f4db-e8fb-443d-903a-fcea12f0ae91', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:13:44.385785');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('3d9f4ba0-269a-4587-b71f-2b939709b7db', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:14:05.476088', 'DENY', 'DUPLICATE_CHECKIN', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 7, 0, NULL, '0ab6be8a-514c-4dd2-8e13-ff5bc006490b', '06e9afc1-c0fa-48c3-844c-6a42d2e88e5a', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:14:05.476098');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('8378d8ff-4b7f-4749-9009-e9ffa0b730d3', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:15:03.771034', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 16, 0, NULL, 'd015e8dd-4b6b-469b-a0e9-5d7b177b4dad', '8e50c12e-a54d-4411-b910-10b16de8185a', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:15:03.771054');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('d20b793a-2c61-4b6c-9f07-5741d5b5642e', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:18:59.830311', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 1, 0, NULL, '9ff7cea0-628b-455b-8d43-190e19113013', '7c791288-09b2-4e6f-90f8-4fa71b160bc7', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:18:59.830313');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('c1edcc70-4715-40cd-b8b4-6943bc703a3d', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:20:35.974965', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 5, 0, NULL, '4e102259-2fd1-4a5d-be49-09782ef23513', '6d2cc804-da7c-40da-9629-88e381c12f70', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:20:35.974980');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('9b2ea4f6-0ff6-4c1d-a96a-11f42773abad', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:20:45.779117', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 5, 0, NULL, 'b558c25f-a4cf-45ed-8399-8f60c215ba0c', '3819a47a-566e-41eb-9419-edd878721a2b', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:20:45.779128');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('50768fa7-1270-4f57-b26d-0ecfe0d35fe9', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:21:50.445222', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 4, 0, NULL, '2bb65182-a465-4113-afee-e8c1d3e9cde6', '539ddc01-adc6-4b55-b446-f541919bb2e7', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:21:50.445241');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('87daaaf9-f5f4-4068-bc39-d833e64fd620', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:22:00.064516', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 2, 0, NULL, 'c90a82f0-ddd4-4aae-9ab1-46d0e5f6ad0e', 'e5fa5edf-c877-4e74-a076-87fe0268425e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:22:00.064522');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('07aad138-ec11-47da-9411-91a07b5d9b47', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 15:22:18.273708', 'DENY', 'IDENTITY_NOT_FOUND', NULL, 0.45, 0.95, 0.95, NULL, NULL, 3, 0, NULL, '1019fddb-a6c1-4b7d-a51b-01cad7a2089a', 'c6809e90-c8b5-401f-9fb2-2ccdd75950c0', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:22:18.273718');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('8f04fe63-a15a-4901-9829-a03eece08c7a', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c0c1ecb5-5488-475a-90c2-e1333eb27aa8', '2026-07-27 15:22:21.734841', 'DENY', 'MEMBERSHIP_SUSPENDED', 1, 0.45, 0.95, 0.95, NULL, '670e65c2-1a82-4469-954b-b3674219476a', 5, 0, NULL, 'a0a91faa-ceac-449b-a41d-b0389b11c3c1', 'ccb5d50b-7ae5-465b-986b-f1abc124b419', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "ACCESS_DENIED", "result": "MEMBERSHIP_SUSPENDED"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:22:21.734846');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('e1432640-0634-4b67-a000-bdf056e023df', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '6aefc458-df5e-41c6-8f8e-9e154573f3af', '2026-07-27 15:22:22.936451', 'DENY', 'MEMBERSHIP_EXPIRED', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'cf76111f-e5cb-4d6c-b581-49750b7780e6', 9, 0, NULL, '08f3cf45-51fd-4288-ad4b-823d86390c34', '2a86db96-7ffd-4385-8a6d-b81b22ad6d0e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "ACCESS_DENIED", "result": "MEMBERSHIP_EXPIRED"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:22:22.936460');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('8ac0d11c-4d57-41bb-90cd-746aec35990f', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 15:22:23.758816', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1.0000000000000002, 0.45, 0.95, 0.95, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 8, 0, NULL, '07ed2c87-1959-421f-8c1a-debf0298a65e', 'f017ceb4-c0ec-4b3c-88e9-3eac11ee5c9c', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "LIVENESS_VALIDATED", "result": "OK"}, {"from": "LIVENESS_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "mock"}', '2026-07-27 15:22:23.758824');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('433af47f-66f1-46d5-a43f-ef160dd1bd6f', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0', '2026-07-27 16:59:45.941393', 'ALLOW', 'MEMBERSHIP_ACTIVE', 1, 0.5, 0.9089785814285278, NULL, NULL, 'b090f143-367b-4cb7-8722-d178144ecc0e', 139, 0, NULL, '47a9ef68-636c-4657-8f20-259fac3046bc', '84331201-2454-4ae3-b023-254674a42745', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 16:59:45.941396');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('3eb60c9b-550c-41d3-8f69-457886323094', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-07-27 17:08:03.571156', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.8494133536064544, 0.5, 0.7074063216819156, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 195, 0, NULL, 'd7ba4146-8a61-4fa3-8430-4ba63ddde396', 'bb894b38-b36b-4ffd-817d-526d2befdf0d', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:08:03.571161');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('59d87088-5188-4e53-8d75-c7215b98895d', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:08:23.144575', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 176, 0, NULL, '5e5aa4fd-5925-4b74-84a4-e5287888beb5', '92dfca63-23a2-4331-8508-ffb467bd3a27', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:08:23.144581');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('0940942f-a1c6-43b7-8f69-87467ecc12e1', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:08:32.543129', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 77, 0, NULL, 'd072364e-55d6-4d1a-bafd-f8c560e7d04f', 'c9ed085f-df1f-42ee-823f-d346ea125c9c', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:08:32.543137');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('1172f16a-ec9b-4308-a116-0c8cdcf22e52', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:08:46.300454', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 147, 0, NULL, 'ea5002c7-0a65-42d2-9f79-5afd73680ca8', 'd433483c-d7b2-4573-90f0-9285429aed76', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:08:46.300465');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('d9aea15f-3f9c-48be-9d3c-b0c479f52be2', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:08:59.796642', 'DENY', 'IDENTITY_NOT_FOUND', 0.14538423876968262, 0.5, 0.713299508715898, NULL, NULL, NULL, 161, 0, NULL, 'a35c644f-654f-4107-a56a-d94957be002e', '755639b4-f189-4271-8531-d8bea541f1d6', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:08:59.796648');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('84112c56-4a57-4d0c-ac8c-e3b018c5e0ad', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:09:08.954434', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 60, 0, NULL, '5a6de9fb-6df2-45e2-9b9f-6d3a8664ed38', 'ceaacea3-e58b-434d-a9c6-eb241cd089fc', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:09:08.954441');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('4554b605-9cb3-4eb2-80d6-dcff9b502a3a', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-07-27 17:09:22.524701', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.880708820880573, 0.5, 0.7729257592884472, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 233, 0, NULL, 'f38bdf08-db47-42fd-923f-fe946e043340', 'ecb5854d-3980-444b-a3da-b8f63c938af8', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:09:22.524705');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('804f2a01-5b54-4001-9f6f-e6ed14ae4d32', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:10:36.268656', 'DENY', 'IDENTITY_NOT_FOUND', 0.25127578854431226, 0.5, 0.7138623025011442, NULL, NULL, NULL, 159, 0, NULL, 'c417c6aa-8874-490e-84ef-2238674dfb83', '3b051708-df31-4d58-8e67-e33fcc6abb7a', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:10:36.268663');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('89c13f02-4ab6-4a09-b368-45d11e6f2b23', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:10:56.428266', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 113, 0, NULL, 'c6d411d1-fbd1-4e0c-ae6c-085cef76e1b1', '226e4464-4810-40f6-993e-5bf163f4076a', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:10:56.428272');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('20ebb907-0179-4c14-bbe8-4dccf3c5b5e3', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:11:04.567167', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 101, 0, NULL, 'a47d5cba-3806-4104-b790-4f93f8aaaf53', '12c73d7b-f844-487b-ab98-59214394d9f2', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:11:04.567175');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('9b29abe3-2b88-4608-8d72-5d5db0b46fa8', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-07-27 17:11:17.653686', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.8105715585686217, 0.5, 0.7268835993387222, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 175, 0, NULL, 'be6f5212-ba64-42cf-ae60-b4b6fbcec19b', '2db0c09a-06a4-472d-bbc6-3f35e0ee7608', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:11:17.653690');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('65f3dd09-584f-4961-81c1-329c018cf293', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b666a39f-0558-4a46-a759-eb38effff0a2', '2026-07-27 17:16:31.870117', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.8697648571463014, 0.5, 0.7842966576457634, NULL, NULL, 'a6757076-e655-4921-96f0-465a397609a6', 175, 0, NULL, 'a77d6912-c336-4358-a0ee-d88a52152938', '3a90e40a-b947-4874-8d20-6d60d3820434', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:16:31.870122');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('1f4844d4-65ff-4f72-8170-3ea2c5e23a7c', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:17:11.383659', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 135, 0, NULL, '92618441-0332-4573-b8f2-d5784b02c80e', '164c8659-ed4f-45ef-b920-18c41f24e4fa', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:17:11.383667');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('119129b4-cbf9-41a6-9074-a86d785e933b', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:17:15.634217', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 95, 0, NULL, '6a06e77b-184e-41a7-af15-8acfb38323e1', '4b57ad89-4924-457b-bc20-908cc93fb471', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:17:15.634228');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('777f7c4a-45e4-46a1-a1a1-a93e9ab47709', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:17:34.044235', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 127, 0, NULL, 'a82179ca-ec01-41b2-8302-6ed15c847b2f', 'c8a74103-80fe-4546-bfaa-99fae48f389e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:17:34.044241');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('fe95698e-cd39-4ac4-a332-0ac17fa4c1a6', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:17:40.693464', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 54, 0, NULL, '56a54b4c-7414-4778-903a-aac534e74e78', 'b66ef794-1243-49d4-9456-d2aced73b095', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:17:40.693472');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('a9e2bdc7-3402-49d5-9c14-046c16564326', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:17:53.922506', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 125, 0, NULL, '983f5514-79cd-4726-b638-b95b2d4e6c18', 'd248afaa-c2fd-4871-8d15-1a069707968f', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:17:53.922514');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('f2bfd2f0-05b1-43b1-adeb-faf31db1aae9', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:18:02.673349', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 170, 0, NULL, '40b32400-9196-4ca2-aabf-36b78af20b75', '11b1996d-fa82-496e-a4a4-497de2112b2e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:18:02.673356');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('3faabd18-600f-417c-bc5e-8377102d0105', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:30:26.011698', 'DENY', 'MULTIPLE_FACES', NULL, 0.5, NULL, NULL, NULL, NULL, 267, 0, NULL, '35cd97e4-3b05-428a-bba7-27e3c4467cd6', 'e9af6e68-fcba-47a9-8f01-49d3c11e1dc7', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "MULTIPLE_FACES"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:30:26.011710');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('6ab17c15-4e02-41d5-8057-b4cddb6ac3ae', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:30:35.849547', 'DENY', 'IDENTITY_NOT_FOUND', 0.23861177495765287, 0.5, 0.8131789494308475, NULL, NULL, NULL, 509, 0, NULL, '2d63d8b7-621b-4cf6-9576-e181f517dfdc', '9a131c4d-5b85-4d6e-a499-0fada4173970', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:30:35.849556');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('4e08a145-30d4-41a0-9fcb-7099d721afc8', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:30:50.770597', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 284, 0, NULL, 'd7e01b40-96f9-40ca-93ce-72ce7d199975', '19d1dd57-3c1d-43b3-af06-fc22b96a7a99', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:30:50.770607');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('2ed871e6-3d9c-458c-ab04-35a36eeb844d', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-07-27 17:31:50.080191', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.9211250686541272, 0.5, 0.7569379073354967, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 372, 0, NULL, '69b142bd-4fa0-4eb5-bfe8-3e6b7535e4c8', 'd6ead662-942a-401a-ad53-12125026acc1', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:31:50.080199');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('1aa5dcb2-c1fd-49e2-919e-19a344d58865', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:32:14.386007', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 307, 0, NULL, 'fc6c42cb-4d17-4333-a80b-647bba8e6e4a', '76e97347-fca7-4058-8d6a-b0a13cf66e6f', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:32:14.386016');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('a96c0e6c-1d3f-48dd-a850-ba6d6f9aa070', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:32:23.342739', 'DENY', 'IDENTITY_NOT_FOUND', 0.33732365214954674, 0.5, 0.7426981691887887, NULL, NULL, NULL, 193, 0, NULL, '7fc0356d-c072-4b6f-91e7-109e17ce4519', 'b1c70306-c2d3-486c-8361-bd1e68fcb3d0', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "ACCESS_DENIED", "result": "IDENTITY_NOT_FOUND"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:32:23.342744');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('fc78b570-6907-4545-bb50-f0cfa74769c4', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-07-27 17:37:01.148616', 'DENY', 'MULTIPLE_FACES', NULL, 0.5, NULL, NULL, NULL, NULL, 129, 0, NULL, '1fec1294-3971-4a36-b8fb-d8c43474f5bd', '12fdd0cc-22f7-4839-a594-a9a9b24af284', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "MULTIPLE_FACES"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:37:01.148625');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('9106c074-9fd8-41a3-88f2-bd89f87e07b8', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', '2026-07-27 17:37:11.026754', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.93278301502898, 0.5, 0.7349773945975268, NULL, NULL, '702da523-c32e-4c1e-a9cf-e2855785ca78', 218, 0, NULL, '8ad75939-d33a-4c9d-9cfa-286417f8421a', '60668140-060c-44d9-854c-011e7b18c3e4', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-07-27 17:37:11.026761');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('858bb4ee-fbda-4466-890c-b5a8e1976e25', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:25:59.872107', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 291, 0, NULL, 'e0d6c107-2f71-4f03-b241-9254e9431dde', 'f98c70f7-fcce-439f-b7cf-34f633b32ae8', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:25:59.872114');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('7547a53d-f3b1-4384-86e8-e09a18a94ba4', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:26:09.831028', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 126, 0, NULL, 'b11cfcc7-949f-417b-b9ac-b40b5c6595ab', 'ae2c8aa3-f8f6-4320-b3c4-a152ef61ab89', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:26:09.831035');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('def0a774-c77e-4360-877a-0c7bfec9f60c', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-08-01 13:26:26.805929', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.6814968044407298, 0.5, 0.7130595976093637, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 364, 0, NULL, 'd88563fb-06ea-4325-a03e-82b6ec70893a', '5a65fe69-6af0-4b8e-819c-e572f6703cfe', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:26:26.805939');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('ab09facd-6a3d-4164-a675-62b0b4f27562', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:26:43.351121', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 196, 0, NULL, '342665bd-2c5e-45f2-88c4-70d6785c886a', 'ea466103-7f70-4f22-831b-a397d74a69a3', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:26:43.351128');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('2330b9da-18d9-4aa5-8323-01cf1a64030a', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:26:55.891627', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 125, 0, NULL, 'eae96722-dcab-42db-9336-3ba86e96dd67', '466484b8-d55d-401e-9c57-cfd5380c132d', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:26:55.891633');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('4a7d0a0f-cdbd-4bd2-a397-390e4bf5258f', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:27:09.756299', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 184, 0, NULL, '7a67a37e-3dcf-49b6-a3ca-c21d6ffeb81b', 'a11d9f74-150d-4e94-89c1-10ea74a1a1d2', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:27:09.756308');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('a4f40522-fe2e-428a-975c-1624ddd3764b', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:27:18.225071', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 198, 0, NULL, 'e9d2942a-f4a5-4d85-aee3-e562d48e993d', '2fc01a73-19bc-4aa9-b469-c6c90123a34d', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:27:18.225078');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('f7a88fed-9864-45b8-a9b8-22da91860cda', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:27:25.410997', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 277, 0, NULL, '1b55e845-7dda-42bd-8ea9-a44960fd5f73', 'dd211007-dca6-4381-9876-e7a67eefa1e6', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:27:25.411006');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('f6d3c567-b86f-4169-95dd-c5e4cf8e4231', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:27:45.054889', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 118, 0, NULL, '90b5ebc3-3690-47ed-ba27-a836aa5f44d9', '74726f9a-a06a-4f67-8018-26fa61b8789e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:27:45.054895');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('428f1f83-0e9a-43ba-84d4-0179fe5e1cf2', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:27:59.207540', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 172, 0, NULL, 'ed8c8418-f6e6-4e2f-8bdd-54aa6ccbf648', '18b519b6-09e4-48f5-a55f-b7041ccb11cb', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:27:59.207549');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('117fcd79-7769-4401-81d1-e14295df0eb8', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:28:07.514914', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 149, 0, NULL, 'ebeac810-57b2-46e6-8a0c-1fa3fffadb81', '66c39640-d3ca-46fd-a05b-053327bd1489', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:28:07.514920');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('2604d4a9-433b-4c08-b0a5-88acf3a477cf', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:28:19.167855', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 111, 0, NULL, '975d8758-0156-42d0-9398-870eb7080b63', 'af1649bf-12f5-4c21-a91c-5b60381bbc72', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:28:19.167861');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('2ace6a71-d95e-4009-85de-81fc97424ea6', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:28:26.627967', 'DENY', 'MULTIPLE_FACES', NULL, 0.5, NULL, NULL, NULL, NULL, 154, 0, NULL, '043c9222-e0fc-4e56-af36-2f5f2c34f7e5', 'c5ea8db0-fba4-4ea9-b0c8-1c6fd6821da7', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "MULTIPLE_FACES"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:28:26.627974');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('b3414e01-18ff-4b7b-a9da-366d571894a1', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:28:32.798260', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 130, 0, NULL, '2068b6d7-bad6-4228-8dcd-9770e8b7edca', '58cdc1d8-e548-4e79-a0d2-1cf837b5173d', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:28:32.798268');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('873b8b54-22c9-4ab6-8ab0-6d21495ab03b', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-08-01 13:28:49.753656', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.6817688015965143, 0.5, 0.7016047958152624, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 210, 0, NULL, '3d441ee4-272b-4d72-b495-35d5076e84fa', 'fe5050d4-846f-4b62-9fb0-4e395e6d7677', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:28:49.753662');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('b6fe9c54-567a-4ccb-941c-98cac8344ded', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:29:05.244066', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 199, 0, NULL, '44f77866-ec64-4ad0-b416-6703fc214a92', '41508388-5996-40d9-8a05-77df015e2ec2', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:05.244080');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('eab25755-33a0-4e93-bbe8-b0c454cf6563', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:29:12.625701', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 107, 0, NULL, '79d04d43-ee4f-4c15-b373-e98e613074aa', '51d2fffd-90e9-49aa-a464-8555baad488f', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:12.625708');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('f8006189-fbf1-4f8f-b42c-990ccacdc1dd', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:29:18.900966', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 186, 0, NULL, 'caf544b2-e2a1-4945-a1bf-ecd964222182', '1c97f4ed-a9d3-4301-b321-9d713fe2429e', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:18.900972');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('87a94a18-ce58-4a7f-a7d2-a3e837dde2f8', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', '2026-08-01 13:29:25.866839', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.7196336469259881, 0.5, 0.7153081728398776, NULL, NULL, '702da523-c32e-4c1e-a9cf-e2855785ca78', 201, 0, NULL, '34fb67f1-6b8f-42f0-b07c-90f0362f320b', 'e141534d-088b-4e1c-9c67-d4642080e7d9', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:25.866843');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('ab81b6af-03eb-4493-bdf4-f6f832d75886', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:29:37.075874', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 58, 0, NULL, '4bf20d9b-8e10-4a46-864d-07826a9cee31', 'c87284b7-c3ce-4c5e-bd05-f6feb8c28cfd', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:37.075881');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('128602aa-2de8-4ce5-a627-5826e6a7a55d', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:29:48.825210', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 98, 0, NULL, 'd9b708de-577a-4796-9d65-a42057b4f9a3', '87cb9052-31a3-4bb9-a891-45f874c61447', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:48.825225');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('482cc574-b951-4996-a0c0-542f98669a61', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', '2026-08-01 13:29:58.451621', 'DENY', 'DUPLICATE_CHECKIN', 0.7037947637674052, 0.5, 0.7381396266141527, NULL, NULL, '702da523-c32e-4c1e-a9cf-e2855785ca78', 221, 0, NULL, 'b3ea01ad-9678-488b-ab05-dccd3c8dc412', '6aa949a7-eb0f-4de9-af6f-0e19af1eeea8', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:29:58.451625');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('ff2ff2dc-6d17-4fa0-bbf5-4b1508b0a19a', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:30:07.623038', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 187, 0, NULL, '2078d885-ebfd-4070-b2e8-6beb5bc7478b', 'd993c1be-293a-448f-b706-532df60595ba', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:30:07.623045');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('3e224661-b6cb-4cc9-accf-3f1284fd141b', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:30:20.592303', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 113, 0, NULL, '2f63f6d8-f0d0-473a-b5b8-bddf5d7e9c73', '005ab752-a863-41fe-b6b0-c7427ab4d6ae', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:30:20.592317');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('322d2cdb-9551-4176-bb14-1a8a5c939bfd', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:30:29.478260', 'DENY', 'IMAGE_TOO_BLURRY', NULL, 0.5, 0.7, NULL, NULL, NULL, 203, 0, NULL, '22be5b31-2cf6-4e53-9e42-beb3ca0c2b30', '9aaab72d-2a9e-42ac-bba3-54c384e52bb4', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "ACCESS_DENIED", "result": "IMAGE_TOO_BLURRY"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:30:29.478267');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('c904b00f-f55f-4cb4-be02-1345525bebd7', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', '2026-08-01 13:54:08.487189', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.7394051382711464, 0.5, 0.8189999640791694, NULL, NULL, '74bd00e7-aeff-495d-8939-c7e321e90514', 278, 0, NULL, 'e3654d73-6841-4bd7-9897-805ebe2acd97', '918ea363-13cb-4dd3-8259-2bcc9bdc3fa7', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:54:08.487193');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('1b92e32f-108d-49d9-a0eb-f0db6ffc5734', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b666a39f-0558-4a46-a759-eb38effff0a2', '2026-08-01 13:55:16.435868', 'ALLOW', 'MEMBERSHIP_ACTIVE', 0.6600650417143981, 0.5, 0.8151290385232383, NULL, NULL, 'a6757076-e655-4921-96f0-465a397609a6', 104, 0, NULL, '0d434066-36f2-4357-8f5c-562215877532', 'f4d34d96-0ea4-4782-a091-8f9fd970360f', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_GRANTED", "result": "OK"}, {"from": "ACCESS_GRANTED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:55:16.435872');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('807970cd-0b80-4d9a-bbd8-b86a1c25e3d1', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b666a39f-0558-4a46-a759-eb38effff0a2', '2026-08-01 13:55:28.513756', 'DENY', 'DUPLICATE_CHECKIN', 0.6378882855169234, 0.5, 0.817393233823583, NULL, NULL, 'a6757076-e655-4921-96f0-465a397609a6', 243, 0, NULL, '4fb26e58-7266-45cf-ae5c-3174cfa510ef', 'ea96345d-7177-4d26-bee5-82d3ebf34620', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:55:28.513759');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('ed187fbf-8dd7-4ac3-888f-137f6161a20f', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', NULL, '2026-08-01 13:55:45.112953', 'DENY', 'NO_FACE', NULL, 0.5, NULL, NULL, NULL, NULL, 145, 0, NULL, '9daeab5c-d324-4fc7-bb8f-ab90f9a73578', '3ce308eb-38fe-4362-aac5-babe78c3c8b4', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "ACCESS_DENIED", "result": "NO_FACE"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:55:45.112958');

INSERT INTO `checkin_attempts` (`id`, `branch_id`, `device_id`, `member_id`, `attempted_at`, `decision`, `reason_code`, `match_score`, `match_threshold`, `quality_score`, `liveness_score`, `depth_score`, `membership_id`, `processing_time_ms`, `manual_override`, `operator_user_id`, `correlation_id`, `idempotency_key`, `metadata`, `created_at`) VALUES ('6e0b37c3-cb17-4d1c-9bfc-87ddaa562103', '7a10682c-a453-43af-8696-a60405d55116', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b666a39f-0558-4a46-a759-eb38effff0a2', '2026-08-01 13:55:54.442977', 'DENY', 'DUPLICATE_CHECKIN', 0.5321487370248489, 0.5, 0.8658094815193912, NULL, NULL, 'a6757076-e655-4921-96f0-465a397609a6', 230, 0, NULL, 'b918e007-b9fb-49f2-8de6-dddc596272a1', 'e2c64435-da53-4b8f-8a28-32a0f3aa6d88', '{"state_transitions": [{"from": "IDLE", "to": "CAMERA_READY", "result": "OK"}, {"from": "CAMERA_READY", "to": "FACE_DETECTED", "result": "OK"}, {"from": "FACE_DETECTED", "to": "QUALITY_VALIDATED", "result": "OK"}, {"from": "QUALITY_VALIDATED", "to": "EMBEDDING_EXTRACTED", "result": "OK"}, {"from": "EMBEDDING_EXTRACTED", "to": "IDENTITY_MATCHED", "result": "OK"}, {"from": "IDENTITY_MATCHED", "to": "MEMBERSHIP_VALIDATED", "result": "OK"}, {"from": "MEMBERSHIP_VALIDATED", "to": "ACCESS_DENIED", "result": "DUPLICATE_CHECKIN"}, {"from": "ACCESS_DENIED", "to": "COOLDOWN", "result": "OK"}, {"from": "COOLDOWN", "to": "IDLE", "result": "OK"}], "engine": "opencv_sface", "model_name": "opencv_sface", "model_version": "2021dec", "liveness_mode": "none"}', '2026-08-01 13:55:54.442980');

-- Data untuk tabel `access_events` (77 baris)
INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('b067d30a-f0f7-45d3-bbdd-ba7f512ea41b', 'c686d716-57f0-4eb2-bf7f-c8a1baf2bf93', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 14:35:56.492346', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('51fe1bb9-09c0-4982-a0a6-0418713cac7d', 'd92f7325-4cea-4605-a84a-91537c3e7544', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 14:58:44.973765', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('a41e99b8-de0a-4f95-96ca-58d41820a091', 'f9199085-299d-492f-8c53-09cc4077d8c2', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 14:58:54.809399', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('512d31a2-1e3d-44e7-b107-945866571c88', '45fffeb1-c8f7-4513-bba3-521dfebbe4e7', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 14:59:25.643305', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('d318b6a0-6bd6-4333-b81c-7f1782060223', '5a3cce3e-2bf6-487a-8d97-94b9348c7f2c', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:01:52.602928', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('dc0e2859-2f82-4356-a58d-c00eb3989bf5', '4ae881a4-3b25-4c86-b7a7-03678f7d063d', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:02:09.540563', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('d34ff76c-a238-4c47-bc44-0d16361645dd', '9c332a24-e448-42a6-a26b-e90bdd19c3f7', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:03:13.859768', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('5335f68f-4bea-4ebc-bd7c-9f8602228177', '8c099ec0-b09b-4e4e-bcc9-9ede0d6ab934', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:05:16.230472', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('66b75044-bb13-4994-89c6-25cb5938008b', '764f240d-5aef-44e6-ba87-872bb005b691', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:13:44.387490', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('a096d518-294d-417c-b031-e3c908d70fe5', '3d9f4ba0-269a-4587-b71f-2b939709b7db', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:14:05.481506', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('af0d6759-3b35-4915-80af-e3b43d67a6f4', '8378d8ff-4b7f-4749-9009-e9ffa0b730d3', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:15:03.780972', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('62f3519e-b4d2-48e5-8ca1-57ea62e6ab0a', 'd20b793a-2c61-4b6c-9f07-5741d5b5642e', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:18:59.831654', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('f7c2d74b-0ed3-42ea-8032-d8ac9e1c2572', 'c1edcc70-4715-40cd-b8b4-6943bc703a3d', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:20:35.985402', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('26583e92-bfa7-40e0-b5c4-24746a04426e', '9b2ea4f6-0ff6-4c1d-a96a-11f42773abad', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:20:45.790018', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('c362341a-ee8b-48be-95eb-e1174b6e8731', '50768fa7-1270-4f57-b26d-0ecfe0d35fe9', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:21:50.454375', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('f7fc96b0-8f43-4a95-82c9-796582f4ea9b', '87daaaf9-f5f4-4068-bc39-d833e64fd620', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:22:00.069259', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('5ae9d852-c397-4512-ba9b-2b27dddd25e2', '07aad138-ec11-47da-9411-91a07b5d9b47', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:22:18.279087', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('cf6d0e20-f73b-4c8f-941d-72c70f6d3cd4', '8f04fe63-a15a-4901-9829-a03eece08c7a', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:22:21.737872', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('82f2cc3a-4f06-4173-b39f-469a36e8b518', 'e1432640-0634-4b67-a000-bdf056e023df', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 15:22:22.946220', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('f9d6ce76-64da-42e3-b385-a06e18d737de', '8ac0d11c-4d57-41bb-90cd-746aec35990f', 'ACCESS_DECISION', 'UNLOCK', 'MOCK_SUCCESS', '2026-07-27 15:22:23.762868', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('64bbc35a-c56d-4bb6-a340-326555e8136d', '433af47f-66f1-46d5-a43f-ef160dd1bd6f', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 16:59:45.945196', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0b8988a6-28dd-4f56-934a-cf5432bb35b6', '3eb60c9b-550c-41d3-8f69-457886323094', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:08:03.573800', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('5a675203-2734-4113-a1f9-6eb42b143e43', '59d87088-5188-4e53-8d75-c7215b98895d', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:08:23.147324', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0d3f3a0f-515c-42c6-a5d8-19ca557f4e39', '0940942f-a1c6-43b7-8f69-87467ecc12e1', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:08:32.546416', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('8a82cd2b-224c-48ce-b22c-22c8f58db9b8', '1172f16a-ec9b-4308-a116-0c8cdcf22e52', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:08:46.303434', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('9df915a2-785f-4df0-ba6f-c978841b2658', 'd9aea15f-3f9c-48be-9d3c-b0c479f52be2', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:08:59.799343', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('28f55f86-22cb-4cd8-ba27-b19efa788e42', '84112c56-4a57-4d0c-ac8c-e3b018c5e0ad', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:09:08.957567', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('50b8eee9-be6c-4e11-80dc-5ac0025968d9', '4554b605-9cb3-4eb2-80d6-dcff9b502a3a', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:09:22.527615', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0ffe9484-d958-4e47-bcb9-5c3c346dc7f4', '804f2a01-5b54-4001-9f6f-e6ed14ae4d32', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:10:36.271673', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('05fb66fc-5ad7-4147-a8d0-71d9d0888bdf', '89c13f02-4ab6-4a09-b368-45d11e6f2b23', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:10:56.431160', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('60cd9f64-8dd2-49ef-b110-7883c81d01d5', '20ebb907-0179-4c14-bbe8-4dccf3c5b5e3', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:11:04.570574', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0f1cfedd-48e2-4daa-9d6e-20e36d3eb2dd', '9b29abe3-2b88-4608-8d72-5d5db0b46fa8', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:11:17.656052', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('aac14b30-7734-4625-9934-7456ee17293b', '65f3dd09-584f-4961-81c1-329c018cf293', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:16:31.872808', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('373f76e5-21f8-4d42-b976-ed8583b01777', '1f4844d4-65ff-4f72-8170-3ea2c5e23a7c', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:17:11.387220', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('7a3a2dbe-bfd4-4767-a0b6-438052b5a06b', '119129b4-cbf9-41a6-9074-a86d785e933b', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:17:15.638765', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('e9d2a898-83c6-4809-894b-39506b3df50e', '777f7c4a-45e4-46a1-a1a1-a93e9ab47709', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:17:34.046964', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('e2565d07-cda5-43c5-bf9d-1250701c7406', 'fe95698e-cd39-4ac4-a332-0ac17fa4c1a6', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:17:40.696228', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('45d6fde9-e528-4c52-891a-8311305cc943', 'a9e2bdc7-3402-49d5-9c14-046c16564326', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:17:53.926039', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('c0ef4b64-e221-4592-af4c-e4920e740b18', 'f2bfd2f0-05b1-43b1-adeb-faf31db1aae9', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:18:02.676478', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('ab236f96-2cc6-4cc3-b2ca-0e469c38a2b6', '3faabd18-600f-417c-bc5e-8377102d0105', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:30:26.016735', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('31f14958-478d-415e-a7d6-f94e8e999f81', '6ab17c15-4e02-41d5-8057-b4cddb6ac3ae', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:30:35.856949', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('2a12032c-9df7-4b9d-b87f-ca58eb741a07', '4e08a145-30d4-41a0-9fcb-7099d721afc8', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:30:50.775921', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('d69a05b2-9bf1-4368-8c51-3bcf3ba90d2f', '2ed871e6-3d9c-458c-ab04-35a36eeb844d', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:31:50.085555', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('cd24b5ea-2ad4-4bd6-b311-b910238f4489', '1aa5dcb2-c1fd-49e2-919e-19a344d58865', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:32:14.391302', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('ec70a612-a28a-498d-b354-567eccf5ea0e', 'a96c0e6c-1d3f-48dd-a850-ba6d6f9aa070', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:32:23.345651', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('12960489-2bfb-40e0-99a7-eeb11bfa507b', 'fc78b570-6907-4545-bb50-f0cfa74769c4', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-07-27 17:37:01.152362', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('84700dfe-e670-4902-bebe-c09fd21f6f7c', '9106c074-9fd8-41a3-88f2-bd89f87e07b8', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-07-27 17:37:11.029927', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('c5ba8ed6-3f8d-430d-acbf-5ce9b6ed7bde', '858bb4ee-fbda-4466-890c-b5a8e1976e25', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:25:59.879758', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('47814e08-5ffb-4ca5-b60f-df71f388b4ef', '7547a53d-f3b1-4384-86e8-e09a18a94ba4', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:26:09.834317', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('2a0a65d9-e880-437b-a458-21989b872282', 'def0a774-c77e-4360-877a-0c7bfec9f60c', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-08-01 13:26:26.813077', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('e925ff12-3c76-4c78-848e-c9bb908b11a8', 'ab09facd-6a3d-4164-a675-62b0b4f27562', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:26:43.354141', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('a4b5bd07-edfe-4615-8e06-f3609937153e', '2330b9da-18d9-4aa5-8323-01cf1a64030a', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:26:55.894304', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('20f530e0-d624-40b9-813f-a9901b21eb71', '4a7d0a0f-cdbd-4bd2-a397-390e4bf5258f', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:27:09.759668', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('c8d175c4-9898-4d79-aa00-95acb593af54', 'a4f40522-fe2e-428a-975c-1624ddd3764b', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:27:18.228354', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('5ded4bd8-d92c-44c6-9596-6287ddefbd1a', 'f7a88fed-9864-45b8-a9b8-22da91860cda', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:27:25.415923', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('1523ac31-afc8-44c8-93b0-186c047ebe94', 'f6d3c567-b86f-4169-95dd-c5e4cf8e4231', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:27:45.057616', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0e53a0d9-f3ab-435e-aec0-f5ca3b15fd6a', '428f1f83-0e9a-43ba-84d4-0179fe5e1cf2', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:27:59.211139', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('76acd048-e3cc-4b58-9007-9e4c1dff3cfa', '117fcd79-7769-4401-81d1-e14295df0eb8', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:28:07.518045', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('43ad9237-b4eb-438a-872a-098da46b63a1', '2604d4a9-433b-4c08-b0a5-88acf3a477cf', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:28:19.171636', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('232d966c-3452-4abd-b6af-fb5d966de849', '2ace6a71-d95e-4009-85de-81fc97424ea6', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:28:26.630635', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('f03e00ca-14ab-43f6-a56f-7e233a0fa89d', 'b3414e01-18ff-4b7b-a9da-366d571894a1', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:28:32.801317', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('a31cd589-466d-40da-829a-9c0688ba724e', '873b8b54-22c9-4ab6-8ab0-6d21495ab03b', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-08-01 13:28:49.756278', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('cb79666e-35a0-4506-a8b6-87839d581dc1', 'b6fe9c54-567a-4ccb-941c-98cac8344ded', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:05.247646', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('f7affb44-7a1a-4a73-a5d1-6f90403d56aa', 'eab25755-33a0-4e93-bbe8-b0c454cf6563', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:12.629176', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('17e1bd93-9372-4024-b15d-cd80187dda5e', 'f8006189-fbf1-4f8f-b42c-990ccacdc1dd', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:18.904184', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('c1758dfe-92cd-46bf-8e61-f9fafe37d49d', '87a94a18-ce58-4a7f-a7d2-a3e837dde2f8', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-08-01 13:29:25.869410', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('6b0a9e0f-dd91-4af0-9bd0-b163f8c295f9', 'ab81b6af-03eb-4493-bdf4-f6f832d75886', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:37.079091', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('b8477c2d-e58a-4281-889a-45069c0fabc4', '128602aa-2de8-4ce5-a627-5826e6a7a55d', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:48.829251', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('b968b0f7-80ad-445f-a216-762e22ca0119', '482cc574-b951-4996-a0c0-542f98669a61', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:29:58.454140', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('b78b450b-c537-45bf-9e2a-bca493b2e454', 'ff2ff2dc-6d17-4fa0-bbf5-4b1508b0a19a', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:30:07.626619', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('8b14587a-6e09-497b-9fa6-4d3b5aa4efab', '3e224661-b6cb-4cc9-accf-3f1284fd141b', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:30:20.595829', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('2ffc5a25-b987-4b42-ab79-c169a3b25651', '322d2cdb-9551-4176-bb14-1a8a5c939bfd', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:30:29.481408', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('3cb5827e-c5e2-43a8-a065-74e2c0966007', 'c904b00f-f55f-4cb4-be02-1345525bebd7', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-08-01 13:54:08.490871', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('da96f5a1-2d41-428c-a1fe-7215a868640d', '1b92e32f-108d-49d9-a0eb-f0db6ffc5734', 'ACCESS_DECISION', 'UNLOCK', 'SUCCESS', '2026-08-01 13:55:16.438113', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('a94cd5d5-83d9-4c1b-b73b-8bbf84ca24ee', '807970cd-0b80-4d9a-bbd8-b86a1c25e3d1', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:55:28.515708', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('0cc9aae6-f900-4b78-97d0-b2e78aea594a', 'ed187fbf-8dd7-4ac3-888f-137f6161a20f', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:55:45.115139', '{}');

INSERT INTO `access_events` (`id`, `checkin_attempt_id`, `event_type`, `door_action`, `door_result`, `occurred_at`, `metadata`) VALUES ('86c872a6-94f5-47c9-9b96-c7c2a33a1711', '6e0b37c3-cb17-4d1c-9bfc-87ddaa562103', 'ACCESS_DECISION', 'NONE', 'NOT_TRIGGERED', '2026-08-01 13:55:54.445306', '{}');

-- Data untuk tabel `audit_logs` (102 baris)
INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('0afb5e4f-ebb0-4d83-85b3-41409327d999', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8894', 'feefe012-43dd-4a81-a9f4-cfa780843731', '2026-07-27 14:35:56.347751');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('38679042-2caf-4079-ae7a-c826310368a5', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8894', '1597b870-9ad6-43d5-b0af-2707c89b62ab', '2026-07-27 14:56:34.372323');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5d295147-186a-45e2-a3f6-356b65637384', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '4a81894d-169a-43cf-abf8-6932aa424342', '2026-07-27 14:57:57.841508');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5aa9198d-ad21-4ffa-86f1-57280dce04fc', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBER_CREATED', 'member', 'f77fb14e-8c03-4a53-be63-6be4736c4c52', 'null', '{"id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "branch_id": "7a10682c-a453-43af-8696-a60405d55116", "member_code": "BG-BEFD2F82", "full_name": "Adi Sucipto", "email": "assi@gmail.com", "phone": "089574884075", "date_of_birth": null, "gender": null, "address": "DSSD", "photo_url": null, "status": "PENDING", "plan": null, "valid_until": null, "face_enrolled": false, "joined_at": "2026-07-27T15:00:40.674650+00:00", "emergency_contact_name": "ds", "emergency_contact_phone": "789", "notes": "dsvsd", "created_at": "2026-07-27T15:00:40.674650+00:00", "updated_at": "2026-07-27T15:00:40.674654+00:00"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '95fc7371-c43b-4ad4-8265-0efe4a085bed', '2026-07-27 15:00:40.713324');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4eb1fe35-e3dd-4ce0-8363-9e32eb7b7eed', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBERSHIP_CREATED', 'membership', '74bd00e7-aeff-495d-8939-c7e321e90514', 'null', '{"id": "74bd00e7-aeff-495d-8939-c7e321e90514", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "plan_id": "416bcc19-a289-49c9-90b8-e6f2766900a6", "start_at": "2026-07-27T00:00:00+00:00", "end_at": "2026-08-26T00:00:00+00:00", "status": "ACTIVE", "derived_status": "ACTIVE", "price_paid": "500000.00", "payment_reference": null, "created_by": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "suspended_at": null, "suspension_reason": null, "created_at": "2026-07-27T15:00:40.770024+00:00", "updated_at": "2026-07-27T15:00:40.770028+00:00"}', NULL, NULL, '6c8f4752-1bb8-46eb-b081-b41c9eaa895c', '2026-07-27 15:00:40.775689');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('904fef4b-1345-409e-95b2-2613d306d566', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '66e4ea53-4734-4973-8cad-fffe3dd5d37e', 'null', '{"id": "66e4ea53-4734-4973-8cad-fffe3dd5d37e", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-07-27T15:00:53.467522+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T15:00:53.467530+00:00"}', NULL, NULL, 'd87cfca3-d470-466e-8eed-7752cbe6f983', '2026-07-27 15:00:53.472312');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('f2410662-3d22-43c6-b9ff-80851c68ab3f', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'bca91925-a47b-4426-a9e4-34be09ce74d5', 'null', 'null', NULL, NULL, '6da76f6e-d4e4-4268-9f95-ba5ab87416df', '2026-07-27 15:00:53.513661');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('420ff7bb-a71d-4666-b91f-e784d43a03ac', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', 'ceae3be0-9433-42f4-8b89-fc960dde46e7', 'null', '{"member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "model_name": "replaceable-embedding-model", "model_version": "dev", "sample_count": 4}', NULL, NULL, '1d2afcc5-c29d-4a3a-8333-2d6b447e682a', '2026-07-27 15:01:22.567215');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('09469f91-14be-443d-b99f-aec6d4d48967', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'ea15017f-5d77-4206-83c2-21ce132117e5', '2026-07-27 15:14:27.347418');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('0e334e0c-3f60-451d-a644-f35162ffc03e', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '3e8b83a8-e801-4e09-9795-1e4d173f572f', '2026-07-27 15:20:08.205417');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('8b0efa87-89b6-48c2-aa75-30f6d910ee31', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'a2fe867f-56e5-4a4c-8ddc-bed5ac551fde', 'null', '{"id": "a2fe867f-56e5-4a4c-8ddc-bed5ac551fde", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-07-27T15:20:56.921277+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T15:20:56.921287+00:00"}', NULL, NULL, 'dfb72266-ba76-43c0-9ae3-615afdb0cdb7', '2026-07-27 15:20:56.923295');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4c85c9e5-6ea4-46da-bc4f-dbe2a40b4066', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '82524f1a-dbb4-4b7d-8371-31b68a548eca', 'null', 'null', NULL, NULL, 'ef2306d3-f094-4e22-bcaa-bccdc62d67c5', '2026-07-27 15:20:56.987235');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('f2128bf6-ee3c-498b-92e3-b9ac33cdff08', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', 'd0d91918-0f0e-49d4-aaed-a93aed625603', 'null', '{"member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "model_name": "replaceable-embedding-model", "model_version": "dev", "sample_count": 4}', NULL, NULL, '510a7e40-8fd7-4b79-8576-67c696fd76ca', '2026-07-27 15:21:27.592011');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('c2018a7c-14d4-4554-959f-370412f0b19e', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8894', '6fef570d-838b-4ee6-aae8-128abb68452c', '2026-07-27 16:59:45.119481');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('bf13da81-b6a9-4a23-af39-0486d854f5d3', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'a0aade5a-c063-47ea-8102-211685e9c7aa', 'null', 'null', NULL, NULL, '64b692a1-0b05-443a-8385-634b4fe5830e', '2026-07-27 16:59:45.181090');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('7950a8be-2da1-4234-a57e-307f2ee3688f', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', '141bb184-7db2-474e-bf44-cf0cd5353b36', 'null', '{"member_id": "5f50e458-f0ec-4b0d-bdf0-d70a71c05bd0", "model_name": "opencv_sface", "model_version": "2021dec", "sample_count": 3}', NULL, NULL, '441be225-0483-4674-b0f6-4d28b32af9c5', '2026-07-27 16:59:45.698160');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('153e9dc5-36a2-4678-b042-62dfcdcbd9a5', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '81fcdf09-19ba-4e4e-80e5-3cd60add4810', '2026-07-27 17:01:26.575839');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('88c27fe6-4a5f-4f89-a59c-a77eb62e5de7', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '18e4bfb7-d1d6-43eb-ac34-1a533a8cd22b', 'null', '{"id": "18e4bfb7-d1d6-43eb-ac34-1a533a8cd22b", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-07-27T17:01:48.771306+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T17:01:48.771310+00:00"}', NULL, NULL, 'e3c09e9c-b8f2-4731-8d81-24d2e1eeb1b8', '2026-07-27 17:01:48.776177');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('80e54af3-685a-4f6f-b81c-59598c556ec2', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'a3a3e626-4a31-4758-b4ca-875e4ce6c50c', 'null', 'null', NULL, NULL, '88f31ac4-8c6c-4096-a3db-2c3da87830ec', '2026-07-27 17:01:48.800889');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('c22dc4b2-eb0c-49f8-b317-ee3e93337c93', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'd4d6b0de-98b1-49f1-8eae-3bfdf1c29c2c', '2026-07-27 17:05:27.660169');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('3251f0a5-a107-4932-ad3f-34cb98fcb5b3', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'b3d1db02-c67b-4b9d-bd6b-29acdc9283b3', 'null', '{"id": "b3d1db02-c67b-4b9d-bd6b-29acdc9283b3", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-07-27T17:05:40.463214+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T17:05:40.463226+00:00"}', NULL, NULL, 'bd63a646-e31f-4479-a591-b9c6cba97fc9', '2026-07-27 17:05:40.466033');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('f189f78e-99fd-44aa-8097-ec752ecfcc77', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '3acb240c-7a46-4f26-8fee-b656b1743a90', 'null', 'null', NULL, NULL, 'c5f1ffec-238b-4bfc-9273-eda5472d2dda', '2026-07-27 17:05:40.524074');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('841e9d3f-2318-4dc8-be67-54ed505fd589', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', '3ad82792-9c7b-45bd-b9ce-5924cdfa4b74', 'null', '{"member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "model_name": "opencv_sface", "model_version": "2021dec", "sample_count": 3}', NULL, NULL, '287f843e-d8cb-47fb-af04-e171c0923207', '2026-07-27 17:07:46.356908');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('a83f38ff-902b-4ae7-b454-dad528d307da', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBER_CREATED', 'member', 'b666a39f-0558-4a46-a759-eb38effff0a2', 'null', '{"id": "b666a39f-0558-4a46-a759-eb38effff0a2", "branch_id": "7a10682c-a453-43af-8696-a60405d55116", "member_code": "BG-F11C6C5C", "full_name": "tejo", "email": "master.chess76@gmail.com", "phone": "08974884075", "date_of_birth": null, "gender": null, "address": "Jl. Dr. Ir. H. Soekarno, no 678", "photo_url": null, "status": "PENDING", "plan": null, "valid_until": null, "face_enrolled": false, "joined_at": "2026-07-27T17:14:10.277637+00:00", "emergency_contact_name": "tejo", "emergency_contact_phone": "0607088606", "notes": "oke", "created_at": "2026-07-27T17:14:10.277637+00:00", "updated_at": "2026-07-27T17:14:10.277641+00:00"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '434bb15b-4606-4169-acdb-334deb7d0606', '2026-07-27 17:14:10.461621');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('79b41abc-c080-496e-a924-719b873e850b', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBERSHIP_CREATED', 'membership', 'a6757076-e655-4921-96f0-465a397609a6', 'null', '{"id": "a6757076-e655-4921-96f0-465a397609a6", "member_id": "b666a39f-0558-4a46-a759-eb38effff0a2", "plan_id": "416bcc19-a289-49c9-90b8-e6f2766900a6", "start_at": "2026-07-27T00:00:00+00:00", "end_at": "2026-08-26T00:00:00+00:00", "status": "ACTIVE", "derived_status": "ACTIVE", "price_paid": "500000.00", "payment_reference": null, "created_by": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "suspended_at": null, "suspension_reason": null, "created_at": "2026-07-27T17:14:10.537447+00:00", "updated_at": "2026-07-27T17:14:10.537451+00:00"}', NULL, NULL, 'efeb39f4-3599-48af-947d-6e262b3c47fb', '2026-07-27 17:14:10.541021');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4078c54e-4474-4a77-9d34-ff534e02f3cc', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'd750a399-d3f2-4e61-851b-4701c793a5e5', 'null', '{"id": "d750a399-d3f2-4e61-851b-4701c793a5e5", "member_id": "b666a39f-0558-4a46-a759-eb38effff0a2", "consent_version": "v2.1", "consented_at": "2026-07-27T17:14:25.527765+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T17:14:25.527784+00:00"}', NULL, NULL, '83f620c1-1715-43cc-a181-0a9693dcf358', '2026-07-27 17:14:25.531208');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('06c930e4-fd29-487d-98c1-66bdeb099504', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '881195d5-e66b-4802-a7da-72df126b5f52', 'null', 'null', NULL, NULL, '3b3f50d9-deff-485d-a399-ce1c98d31449', '2026-07-27 17:14:25.572779');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('b984ca4a-afe8-42eb-8304-9743bd7cc52c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', '2b6202c1-3afa-4596-a606-d1d35a7ed02b', 'null', '{"member_id": "b666a39f-0558-4a46-a759-eb38effff0a2", "model_name": "opencv_sface", "model_version": "2021dec", "sample_count": 3}', NULL, NULL, 'c43b828b-e176-49a4-8360-ed56a8d6381b', '2026-07-27 17:15:44.635777');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('c824ef24-34cb-46eb-b9f0-30fd787baf4b', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGOUT', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '677ba4e8-6463-4300-9752-6af6189952a1', '2026-07-27 17:18:46.933788');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('a515940d-987b-401e-8a98-4145f05947d5', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '07e78349-ee16-40a6-8a41-78b907664dda', '2026-07-27 17:29:31.047129');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('b8e0a008-d89b-4564-9081-2eeaf928bff8', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '775ad0bc-190a-4de9-bf09-1f2b71c0b0ef', 'null', '{"id": "775ad0bc-190a-4de9-bf09-1f2b71c0b0ef", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-07-27T17:31:05.463268+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T17:31:05.463276+00:00"}', NULL, NULL, 'e9137563-a37f-4d67-a8cb-bd45e790fb6f', '2026-07-27 17:31:05.465899');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('36f15e0d-52fa-46b4-9b6d-d4294423970d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '2ed287d4-f12a-4d33-af5c-a2e8d056f048', 'null', 'null', NULL, NULL, '79f56098-c666-4eda-b232-8925457b0fd4', '2026-07-27 17:31:05.519939');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('79ec0347-fc0c-4fe4-b415-112be31b3273', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', '33d0ab34-32c6-4605-abf5-2f0409fc7ede', 'null', '{"member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "model_name": "opencv_sface", "model_version": "2021dec", "sample_count": 3}', NULL, NULL, '8981bc16-13fb-4c63-8719-770b6d579c86', '2026-07-27 17:31:30.762104');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('0da36ea4-c965-4d6f-a9b8-6d5129e77168', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBER_CREATED', 'member', 'a1989808-0afd-45e3-bf57-9f425b0f4e3a', 'null', '{"id": "a1989808-0afd-45e3-bf57-9f425b0f4e3a", "branch_id": "7a10682c-a453-43af-8696-a60405d55116", "member_code": "BG-7F7D3520", "full_name": "bagoes", "email": "master.chess76@gmail.com", "phone": "08974884075", "date_of_birth": null, "gender": null, "address": "Jl. Dr. Ir. H. Soekarno, no 678", "photo_url": null, "status": "PENDING", "plan": null, "valid_until": null, "face_enrolled": false, "joined_at": "2026-07-27T17:35:00.573028+00:00", "emergency_contact_name": "rww4tey5ryr", "emergency_contact_phone": "hdhrhdfhtr", "notes": "dhrturthfd", "created_at": "2026-07-27T17:35:00.573028+00:00", "updated_at": "2026-07-27T17:35:00.573045+00:00"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '9381f964-d423-422e-b437-dbfb21ea337f', '2026-07-27 17:35:00.769570');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('b49d1219-5dc3-4a53-ab62-b5dbc78b7465', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBERSHIP_CREATED', 'membership', '702da523-c32e-4c1e-a9cf-e2855785ca78', 'null', '{"id": "702da523-c32e-4c1e-a9cf-e2855785ca78", "member_id": "a1989808-0afd-45e3-bf57-9f425b0f4e3a", "plan_id": "48ca40b1-5eba-4205-837d-f22fa5f8230f", "start_at": "2026-07-27T00:00:00+00:00", "end_at": "2027-07-27T00:00:00+00:00", "status": "ACTIVE", "derived_status": "ACTIVE", "price_paid": "4800000.00", "payment_reference": null, "created_by": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "suspended_at": null, "suspension_reason": null, "created_at": "2026-07-27T17:35:00.840520+00:00", "updated_at": "2026-07-27T17:35:00.840529+00:00"}', NULL, NULL, '7e1ef78d-4b34-4383-b30a-40a2f118b8b1', '2026-07-27 17:35:00.847860');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('32068863-734e-434c-80ba-d2a65548dba3', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '30823e09-4a15-43aa-8fed-abdd93399359', 'null', '{"id": "30823e09-4a15-43aa-8fed-abdd93399359", "member_id": "a1989808-0afd-45e3-bf57-9f425b0f4e3a", "consent_version": "v2.1", "consented_at": "2026-07-27T17:35:22.982746+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-07-27T17:35:22.982760+00:00"}', NULL, NULL, 'c7b7f6d5-d1d5-48d4-ab1e-921676f6c31a', '2026-07-27 17:35:22.986836');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5788b7af-68f9-4a46-bfd4-cd88bbab3ad4', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'cfbbdfb1-61d4-4e21-8e6d-0e9c3bafe220', 'null', 'null', NULL, NULL, '832bfde4-7578-45d4-9bb5-d066ae98a199', '2026-07-27 17:35:23.027250');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('79e35abc-d3eb-4571-9372-2593fbed11b9', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'FACE_PROFILE_ENROLLED', 'face_profile', '21ec80e9-0929-41f5-8be7-8e126f521953', 'null', '{"member_id": "a1989808-0afd-45e3-bf57-9f425b0f4e3a", "model_name": "opencv_sface", "model_version": "2021dec", "sample_count": 3}', NULL, NULL, 'd74c2b2c-a24b-403c-a8b1-fe89667fcb58', '2026-07-27 17:36:45.316271');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('9f145064-dc6f-49c0-96ae-4d723b8cfbb5', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '6fd5d355-01b5-4531-9cd1-5e7243948ffe', '2026-08-01 13:11:31.589802');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('99d18ea2-a585-4164-a160-971c360dff28', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'af7efc57-5206-4ae5-bd3d-77372f253439', 'null', '{"id": "af7efc57-5206-4ae5-bd3d-77372f253439", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-08-01T13:15:18.232308+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-08-01T13:15:18.232317+00:00"}', NULL, NULL, '4cc27fb5-b44c-49c1-a30c-40091738d661', '2026-08-01 13:15:18.237535');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('724f2321-0360-4bb1-9ff8-31ab981fb968', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '9d9962f2-dd4d-4d03-9e5d-906f0d26144d', '2026-08-01 13:16:52.424596');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('3f8eb2e3-2533-4f56-ad7d-101a5c08bf91', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '31a32a25-0051-43f8-a013-c03b23a6ad45', 'null', '{"id": "31a32a25-0051-43f8-a013-c03b23a6ad45", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-08-01T13:17:40.170180+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-08-01T13:17:40.170188+00:00"}', NULL, NULL, 'b770bd85-ee66-415d-8e03-06558c3b34ff', '2026-08-01 13:17:40.172036');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('8c8d757f-2185-4df4-bbc6-2f87fce747fb', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'ef558ec9-91ea-45f7-9058-0d653d1e4008', 'null', '{"id": "ef558ec9-91ea-45f7-9058-0d653d1e4008", "member_id": "f77fb14e-8c03-4a53-be63-6be4736c4c52", "consent_version": "v2.1", "consented_at": "2026-08-01T13:20:44.530254+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-08-01T13:20:44.530267+00:00"}', NULL, NULL, '07e5daa1-706d-4a17-b08d-a748a2782024', '2026-08-01 13:20:44.534889');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('cbb99322-593a-4677-877d-8e10659248ba', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8972', '6f5feb3c-5aef-4630-adab-c86bdd36a766', '2026-08-01 13:25:33.515397');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('f2606f47-1ec2-4323-b5d5-4e5b2f2fe5b8', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8972', '8f30a1f8-cbb3-4f38-8f69-d3c3f4db1037', '2026-08-01 13:53:38.992232');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('70e65514-1344-4a39-bf72-07fffb7b86c4', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '8f0d8abf-67c3-4045-885c-db4106964121', '2026-08-01 13:54:31.727309');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('a6cdce57-033a-4b74-a090-a5089fc96db7', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'python-httpx/0.28.1', 'b0c6bbcc-3b59-4b0f-a158-a8b21c03ea99', '2026-08-01 14:18:56.957309');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('81170db8-8929-4930-922c-e7dd1e6e6725', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'c4154170-a05e-485d-aa2d-e2b8c1505b8e', '2026-08-01 14:19:55.525719');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('41cee301-bf7c-40c1-81ff-289cdc19482c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '1fc0061d-ceda-4370-ae97-75a97cd985ce', '2026-08-01 14:43:31.862670');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('ba30f355-dca3-4b5b-bc0f-3fbaaa956409', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', 'd023adf3-7ab9-4d21-90ac-540ff9ba9bf1', '2026-09-24 05:19:42.344535');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('c9d933bf-ba05-43a0-b1c3-70e077deee74', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGOUT', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', 'a22addfa-1707-4960-8fdd-7c1f532ae7d3', '2026-09-24 05:21:55.784276');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('39a963aa-2159-4bd9-8f07-c6bf733d470d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '24180472-bf01-4837-9487-3456a6f75031', '2026-10-05 05:43:48.984736');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('e5fefbbd-6866-47cb-9e7c-df78014716ea', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '03f83f51-7cae-4507-ab3a-1be0ed16ef7c', '2026-10-08 04:09:37.900926');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('3dc4dbba-a120-446f-8011-e25709ca3727', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '56476059-57f5-4b4b-8d22-9f73dc3fb2cc', 'null', '{"id": "56476059-57f5-4b4b-8d22-9f73dc3fb2cc", "member_id": "c0c1ecb5-5488-475a-90c2-e1333eb27aa8", "consent_version": "v2.1", "consented_at": "2026-10-08T04:20:43.705008+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-10-08T04:20:43.705015+00:00"}', NULL, NULL, 'bf91593b-9327-40de-8536-8d905b8880ab', '2026-10-08 04:20:43.706841');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('035206e8-a52f-4c2a-8d21-67276fdab67f', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'a630909c-47e6-43dd-a025-62e62743889e', 'null', 'null', NULL, NULL, '42eff02a-1d48-40e0-aeba-5fd8b9bb1ed2', '2026-10-08 04:20:43.767116');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('d7ea6b9d-e0bf-4423-a495-75c485dcde3d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '26fbd01d-97b4-4861-aaa8-514457888f9e', '2026-10-08 04:25:22.921331');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('05950779-1030-4883-9496-71cc4dd04828', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '33ea1f42-5b0d-4234-a949-28e29e4c1596', 'null', '{"id": "33ea1f42-5b0d-4234-a949-28e29e4c1596", "member_id": "8afabe91-70e2-4333-91fb-8deb4bfc0283", "consent_version": "v2.1", "consented_at": "2026-10-08T04:25:40.336801+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-10-08T04:25:40.336807+00:00"}', NULL, NULL, 'd69a8139-d817-4b6d-bf9d-be200ce1722a', '2026-10-08 04:25:40.340382');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('091ada4b-e551-4e50-aa38-c4752f12a769', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '1ed61d62-92bc-46bc-b9b8-8a1413ae85b8', 'null', 'null', NULL, NULL, 'd8d34fb4-086d-4e59-b396-6b556cf78fb5', '2026-10-08 04:25:40.373800');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('88ab7e2a-c336-4c80-a0a5-136c8974d7d0', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', 'e3932b77-636b-4ee1-975f-eb8cf44c2aab', '2026-10-08 06:35:40.479357');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('96f1d01f-f78f-42d8-b640-3e3a9dea582c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0', 'e7f194f3-6db7-4b79-8c80-61d43bb20b7c', '2026-10-12 06:57:34.605521');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('9edef8ab-7141-4833-a24c-89d165727d12', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0', '3cef95da-de4e-4b5a-bde0-c9f333d192a7', '2026-10-12 07:43:11.922098');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('7703ca90-c7eb-4858-8fd0-526f4d01678b', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '0c8fb354-64a3-4b24-a46b-3fe3c048c564', '2026-10-12 07:44:02.689107');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('7fbff2f7-a48e-4049-8841-3e1e020162e8', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0', 'cea35cfe-c689-4209-ba95-6d2c7140f1d4', '2026-10-12 08:28:40.560349');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('05ff4778-33df-4367-aef9-06a9fe98f97d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0', 'b9375fae-36e9-4110-9737-baae1fad9d5f', '2026-10-12 09:01:38.819231');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4592dd6c-fb4c-4bb2-8cce-7ef3057df2bd', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '6babaff8-b335-468c-8ec9-1449507f98c5', '2026-10-12 09:02:20.759269');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5a4eec5a-5ebe-47ef-b6cc-3430527d083d', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.9818', 'a95c563c-603e-43ed-8088-32dab3a10da6', '2026-11-03 01:52:00.208147');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4d96a559-f086-472b-8c88-3f0a0b049429', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0', 'd4e3216b-20ef-4d12-9ca3-97dfcf98b103', '2026-11-03 01:53:59.681977');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('118e2028-6822-4fac-8b43-04c35d217a3c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBER_CREATED', 'member', 'd321faf5-2972-4324-b4c5-481737ce063e', 'null', '{"id": "d321faf5-2972-4324-b4c5-481737ce063e", "branch_id": "7a10682c-a453-43af-8696-a60405d55116", "member_code": "BG-AEDAD907", "full_name": "Anugrah Tejo Maliki", "email": "anugrahtejomaliki@gmail.com", "phone": "081231333063", "date_of_birth": null, "gender": null, "address": "Desa Kemuning RT 22/RW 04, Kec. Tarik, Kab. Sidoarjo", "photo_url": null, "status": "PENDING", "plan": null, "valid_until": null, "face_enrolled": false, "joined_at": "2026-11-03T01:55:16.261719+00:00", "emergency_contact_name": "1111111111", "emergency_contact_phone": "2222222222222222", "notes": null, "created_at": "2026-11-03T01:55:16.261719+00:00", "updated_at": "2026-11-03T01:55:16.261735+00:00"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0', 'dbc3e876-0e40-4565-b511-bb325695835a', '2026-11-03 01:55:16.279850');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('552bfcd2-8086-455c-b45e-7a701ad2eb0d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'MEMBERSHIP_CREATED', 'membership', '0d6443f5-1071-4ab2-aefc-9c05d45c4a41', 'null', '{"id": "0d6443f5-1071-4ab2-aefc-9c05d45c4a41", "member_id": "d321faf5-2972-4324-b4c5-481737ce063e", "plan_id": "48ca40b1-5eba-4205-837d-f22fa5f8230f", "start_at": "2026-11-03T00:00:00+00:00", "end_at": "2027-11-03T00:00:00+00:00", "status": "ACTIVE", "derived_status": "ACTIVE", "price_paid": "4800000.00", "payment_reference": null, "created_by": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "suspended_at": null, "suspension_reason": null, "created_at": "2026-11-03T01:55:16.373351+00:00", "updated_at": "2026-11-03T01:55:16.373369+00:00"}', NULL, NULL, '09be27b2-392e-4a68-8a56-9b41ced34578', '2026-11-03 01:55:16.377509');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('164686bf-f699-45cb-8b1e-dc2285bb145c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'f5d99ddf-05c8-4920-bfea-a9b560a703ed', 'null', '{"id": "f5d99ddf-05c8-4920-bfea-a9b560a703ed", "member_id": "d321faf5-2972-4324-b4c5-481737ce063e", "consent_version": "v2.1", "consented_at": "2026-11-03T01:55:37.721147+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-11-03T01:55:37.721150+00:00"}', NULL, NULL, 'abf9b776-5645-4a30-ae45-b428234259b7', '2026-11-03 01:55:37.725728');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('97ff70d7-5861-4110-be0b-cd8f3cb2c8a7', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '2f7224ff-9e8a-4e30-9467-947dd76897b8', 'null', 'null', NULL, NULL, 'cbcf472e-f131-4adf-b424-5c05de672184', '2026-11-03 01:55:37.821869');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5abdcf9c-38a5-462e-aaa5-65375b23ba6b', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'c8f1fbdf-7011-4083-a5bd-c5e1940c45ce', '2026-11-03 03:42:54.953177');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('a6744c74-5440-49ce-901b-47083d3cfdbf', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'MEMBER_CREATED', 'member', '8f0d767e-0158-4c60-9713-5352f35c2b76', 'null', '{"id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "branch_id": "7a10682c-a453-43af-8696-a60405d55116", "member_code": "VIP-20260729-041857-6460", "full_name": "Anugrah Tejo Maliki", "email": "anugrahtejomalaiki@gmail.com", "phone": "081231333063", "date_of_birth": "2005-07-01", "gender": "L", "address": "Desa Kemuning RT 22/RW 04, Kec. Tarik, Kab. Sidoarjo", "photo_url": null, "status": "PENDING", "plan": null, "valid_until": null, "face_enrolled": false, "joined_at": "2026-11-03T03:42:55.262707+00:00", "emergency_contact_name": null, "emergency_contact_phone": null, "notes": null, "created_at": "2026-11-03T03:42:55.262707+00:00", "updated_at": "2026-11-03T03:42:55.262715+00:00"}', '127.0.0.1', 'GuzzleHttp/7', '433f0186-05f7-45ca-bca1-3b1c5d515685', '2026-11-03 03:42:55.284948');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('99334434-96fc-44fd-be0f-c7a4209ef0d9', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '637f7949-5507-449d-84dd-8564d5e19b73', 'null', '{"id": "637f7949-5507-449d-84dd-8564d5e19b73", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-03T03:42:55.415509+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 1", "created_at": "2026-11-03T03:42:55.415515+00:00"}', NULL, NULL, '165a8865-517c-4c8b-b5f2-e9eb7cc5ab27', '2026-11-03 03:42:55.420582');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('be471131-0dc3-45a1-bfce-beb821b6537b', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '6989ca62-06ba-4323-9843-9d7f3a6f7002', 'null', 'null', NULL, NULL, '39c40a88-dca9-4510-8991-eb4641c81681', '2026-11-03 03:42:55.468336');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('cc533c56-6f17-4a4a-9239-3ea0bdabedfd', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.144.1 Chrome/150.0.7871.250 Electron/43.8.3 Safari/537.36', '3546cac2-bed2-45ab-a55f-baa656d2bcca', '2026-11-03 03:51:59.023130');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('1d0c03cf-5275-473c-9441-a04a7ade6155', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.9818', '605a081b-42bc-46bc-be93-2b070814fde4', '2026-11-03 04:00:00.854082');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('73001348-2a7a-4a28-b625-1ef17427b52c', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'dcafa335-1622-4aca-b2d5-abd8df60250e', '2026-11-03 04:00:56.304407');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('fef04832-a774-4807-ad03-ab08726ba522', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', '4b838272-3216-4461-8155-f26da4918169', '2026-11-03 04:03:01.621136');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('90af6ba4-0ece-4999-91d0-c7fa45ea46cc', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'a4f46961-6c0f-4738-aa27-fce35363cd84', 'null', '{"id": "a4f46961-6c0f-4738-aa27-fce35363cd84", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-03T04:03:01.764338+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 1", "created_at": "2026-11-03T04:03:01.764350+00:00"}', NULL, NULL, 'ab0d498f-946b-4c12-b074-b19ea7f4e351', '2026-11-03 04:03:01.771146');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('dab7b695-5131-402a-9c96-03b54fba927c', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '3870690f-4e58-45c7-b392-75cdc86e41c2', 'null', 'null', NULL, NULL, '75c24f45-ddb1-4396-835c-dfdafc18aa71', '2026-11-03 04:03:01.818171');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('519a834d-c96d-4577-821b-503c4292683b', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'DEVICE_CREDENTIAL_ROTATED', 'device', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'null', 'null', NULL, NULL, '71f4e582-b099-46bf-a1f0-26134d9705f9', '2026-11-03 04:05:20.148690');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('2cbffe93-4bb1-4abc-b000-091b6155878d', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'f8ce4bb5-fcce-44a3-baf0-5da70215483e', 'null', '{"id": "f8ce4bb5-fcce-44a3-baf0-5da70215483e", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-03T04:06:03.984828+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template sampai persetujuan dicabut; gambar mentah tidak disimpan.", "operator_user_id": "5960dc5e-1d4c-48d9-8080-3d5accd8df5c", "signature_reference": null, "created_at": "2026-11-03T04:06:03.984839+00:00"}', NULL, NULL, 'c5c2d5b1-5491-4752-8f8e-63214f21ef13', '2026-11-03 04:06:03.988574');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('45fb7adf-f5da-4283-bd58-fc2ea1df8687', 'USER', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'b68d1a17-4ae4-474d-bf14-a1b67ab4cc3a', 'null', 'null', NULL, NULL, '7eddaec0-7cd1-4c2e-8b69-f71a6ebaa8bb', '2026-11-03 04:06:04.027928');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('bceac063-429f-454d-80bc-432031dce50d', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'b4a71b54-d6e3-4be4-8e8d-8d2c92eb15a2', '2026-11-03 04:22:26.238082');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('4daf5d21-a260-4d39-a439-a3f964ac6936', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '5a40c101-cd4c-46eb-bdd4-d92fd7fc127c', 'null', '{"id": "5a40c101-cd4c-46eb-bdd4-d92fd7fc127c", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-03T04:22:26.333558+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 1", "created_at": "2026-11-03T04:22:26.333566+00:00"}', NULL, NULL, '640eb7a3-f91a-4bdf-b64e-061efbdd6de2', '2026-11-03 04:22:26.336349');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('7a38b366-b193-4f1c-956e-48d0a61da4ce', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '21a1c2ae-815a-4d17-99dd-0df935f9a5b9', 'null', 'null', NULL, NULL, '51d59b14-7569-4786-a32d-3c479d2e85f2', '2026-11-03 04:22:26.386098');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('faf3db0e-e420-4b94-a24e-c46fbd14f735', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'fff03575-f668-48f5-b9fe-adb29328b706', 'null', '{"id": "fff03575-f668-48f5-b9fe-adb29328b706", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-03T04:31:41.616515+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 1", "created_at": "2026-11-03T04:31:41.616520+00:00"}', NULL, NULL, 'acc56e0e-c942-4687-a3dd-f670afa5e649', '2026-11-03 04:31:41.625604');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('ea475064-0c9c-40a1-9845-a83e4d23ec10', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'a758e175-c89c-4547-bc5a-8e34e34892cb', 'null', 'null', NULL, NULL, 'c618c14c-9b09-40c5-a5f5-70859c8d1870', '2026-11-03 04:31:41.662983');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('fbccfe63-aa69-4673-bdce-96205e42426b', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'cfa70c78-0fa2-4317-b1c8-db4c4e4e181c', '2026-11-03 05:00:31.433235');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('15cdc035-f797-44ab-ae20-388295fd906e', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', '02c3e5dd-d343-4b8e-b1ca-e342bdccad63', '2026-11-03 05:00:33.174406');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('a716162d-9835-4305-b098-98a29eda0691', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'f9f91f0a-0caf-4c3f-9b73-b66525dcc088', '2026-11-03 05:00:33.753965');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('5e3ff940-0c8a-48e7-8172-56007f2a3ecb', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'e6588e6b-c26f-4f28-9148-ef2124442261', '2026-11-03 05:00:35.157277');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('301f0f99-d050-4583-8ebb-2306b6817caf', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', '8f3de910-c167-47e5-8792-106323afaef3', '2026-11-04 08:00:03.995899');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('ef2628f4-684a-434b-a176-eef076b0e9f1', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', '6fe20a07-a33f-4eef-9c91-24159bb04400', 'null', '{"id": "6fe20a07-a33f-4eef-9c91-24159bb04400", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-04T08:00:04.252539+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 5", "created_at": "2026-11-04T08:00:04.252545+00:00"}', NULL, NULL, '014aca42-69f1-400d-94f1-1468e30200c3', '2026-11-04 08:00:04.254616');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('d3bdfefa-cee4-4a7a-9690-131dc773b640', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', 'aa51ffb2-83e6-4fe6-a888-75118765852b', 'null', 'null', NULL, NULL, '46393a47-9a0c-4407-8641-df485dc69187', '2026-11-04 08:00:04.360325');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('c4ea1c7b-fd01-4d1a-bc99-7348982afbfd', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', '02d7c243-f427-4df2-8e1e-fdd67fee229b', '2026-11-06 08:44:23.822196');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('70a5faf8-5248-458d-b442-79f4c631a64e', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'BIOMETRIC_CONSENT_RECORDED', 'biometric_consent', 'c85df728-363a-4b57-a72b-0cd772c08095', 'null', '{"id": "c85df728-363a-4b57-a72b-0cd772c08095", "member_id": "8f0d767e-0158-4c60-9713-5352f35c2b76", "consent_version": "v2.1", "consented_at": "2026-11-06T08:46:22.566806+00:00", "revoked_at": null, "capture_purpose": "Kontrol akses gym", "retention_policy": "Template wajah disimpan sampai persetujuan dicabut; gambar mentah diproses sesaat dan tidak disimpan.", "operator_user_id": "249da968-8c47-45db-8708-eea1364c8386", "signature_reference": "Website-BisaGym operator user ID: 5", "created_at": "2026-11-06T08:46:22.566813+00:00"}', NULL, NULL, '3df0013c-2a73-48d6-9beb-327ee2a0c93c', '2026-11-06 08:46:22.578146');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('8d071801-fa7f-4194-9702-4259efd90508', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'ENROLLMENT_SESSION_CREATED', 'enrollment_session', '84383201-f9ac-4fa5-80de-bdf47b71547c', 'null', 'null', NULL, NULL, '9c384d18-4736-4adf-9335-278c25eb0130', '2026-11-06 08:46:22.667812');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('e1f5513f-e9a0-4dcc-8f22-2a010dd4936f', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', '6ddae6cf-df03-47ca-bc7a-7e79382d07c6', '2026-11-06 09:01:57.083346');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('24ca196b-545e-483b-825b-8226f0d32631', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'faba9105-fc8d-4732-babc-3e5112da06bd', '2026-11-16 15:26:26.500334');

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_id`, `action`, `resource_type`, `resource_id`, `before_data`, `after_data`, `ip_address`, `user_agent`, `correlation_id`, `created_at`) VALUES ('e11cd8cf-99b5-4ea8-b4c6-84d211dd946e', 'USER', '249da968-8c47-45db-8708-eea1364c8386', 'AUTH_LOGIN_SUCCESS', 'authentication', NULL, 'null', 'null', '127.0.0.1', 'GuzzleHttp/7', 'eca11888-5989-41be-8ee0-e3d7a6bf21f2', '2026-11-16 16:04:45.612359');

-- Data untuk tabel `auth_sessions` (45 baris)
INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('06d7660b-e6a1-4b1a-a540-75b726b0540a', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'e6e7b592f8c38cfea799c8a9ea1cc6b82385b0be8e19fd2ae9382f9167d72984', '2026-08-03 14:35:56.345618', NULL, '2026-07-27 14:35:56.350052');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('d0e09ea5-ee99-4f66-a984-c9bdc9625028', '249da968-8c47-45db-8708-eea1364c8386', '7ae0ee4c148c10eff781acff7d4882443825468b166cc9e2b359914b67e46628', '2026-08-03 14:56:34.371874', NULL, '2026-07-27 14:56:34.373360');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('a7df75de-9d08-4b15-9382-49309d421391', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '7ca0c96a4ea218b47407ad14d3baf30e561fe3792fcd21bfcdba6cb5a657e326', '2026-08-03 14:57:57.840985', NULL, '2026-07-27 14:57:58.013599');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('2a0532f6-f1e5-4d36-8c41-a90e3050912b', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'fb0bef9e6a9704d20039615f9601064d1d1237c4ae34b00e6a2f74af4cd48b8e', '2026-08-03 15:14:27.346516', NULL, '2026-07-27 15:14:27.350376');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('a4129cef-4ad0-44be-95e5-d69c54ed19aa', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '3e2cdb4d5d43f908a1e1fdaa0a1974690381ee360653d66f43fc9d7a7d77924c', '2026-08-03 15:20:08.204815', NULL, '2026-07-27 15:20:08.373843');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('2a9980db-494c-45ce-a5bb-349376dcf81f', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '149580a743826648ca13d236ee9daa3cf236f73d3535f9dfc3795c17bebd9067', '2026-08-03 16:59:45.116435', NULL, '2026-07-27 16:59:45.122327');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('6ffb047c-5052-4288-8db8-90d3615973f6', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '33bc09fad6f2758d887e58416c5d23a34d82fcca741dfe9b839fd5b0a1aa4298', '2026-08-03 17:01:26.575112', NULL, '2026-07-27 17:01:26.577406');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('3e7e854a-bf90-4cb5-9519-89ce56f04411', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '695c25f89591d4b919c96612dc5b477dbea0f05889500633f0695580b3d14863', '2026-08-03 17:05:27.659617', '2026-07-27 17:18:46.931996', '2026-07-27 17:05:27.840093');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('49bd8e55-a32f-4cb7-ae00-5d78e658abd0', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '662b0f0fa6f02e2a2524a5c33f7f00f2097c4ee5dbe859774f82542f782375e6', '2026-08-03 17:29:31.046489', NULL, '2026-07-27 17:29:31.217903');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('c6796893-6391-4f54-ba8f-a42c1264cbfc', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '35601a6d36b35b3318e8e2a8dfa2c47987722f27e7c9d030cdb39495b749cdab', '2026-08-08 13:11:31.584680', NULL, '2026-08-01 13:11:31.595402');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('fb9e870b-424f-486e-809c-377a9949d623', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'db2704cf797c320a578bf1d496c5894c5d22394bf2de3310b5036ee7fd3485e2', '2026-08-08 13:16:52.422833', NULL, '2026-08-01 13:16:52.428645');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('7a9b4648-db84-4806-ab86-b5982a24d28d', '249da968-8c47-45db-8708-eea1364c8386', '01780a03408b665becefd0e5d39ed1acced0976fdeb9bc39ecca89c056f97609', '2026-08-08 13:25:33.511096', NULL, '2026-08-01 13:25:33.519382');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('d8f49ec4-8929-4923-90f2-c78f1959f043', '249da968-8c47-45db-8708-eea1364c8386', 'c107061ca79a8de76a5c166080cada47e014f1c7ea1e3c2ee7c9017c52a9f868', '2026-08-08 13:53:38.990576', NULL, '2026-08-01 13:53:38.993896');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('de4b1e52-f96c-478e-b29c-df03e032105f', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '453d6ff7981611d7063573798796a6ac6d0edee0e0fb48c0f6b2a4f75956b486', '2026-08-08 13:54:31.726384', NULL, '2026-08-01 13:54:31.729357');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('676283aa-cd06-4be0-b9a7-7b811b009dd4', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '221be4977f8e4b6758e0eebcd9bde104cb748f38af6aeeb4d83e79a3be94325e', '2026-08-08 14:18:56.955666', NULL, '2026-08-01 14:18:56.959283');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('79b35818-da9d-4c1f-8b72-b49e57c9c5d6', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'c76b1888e462869868df028cfdebff09f6043f9283b1befc3dc35036b49da592', '2026-08-08 14:19:55.525072', NULL, '2026-08-01 14:19:55.579753');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('4d69800e-8177-4082-a822-7ba1ab5aecec', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'f3b0e8578c25d25bb4288fe7c69c3887a1d730c61f99b1b471bbe25af95a4961', '2026-08-08 14:43:31.861620', NULL, '2026-08-01 14:43:31.864862');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('19782b4e-ead6-4529-baf6-2d6a65c9450a', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'cd2cb92aa361574f9e3b5c80b8365ce4f43926cb93ec014259abb52942bdae79', '2026-10-01 05:19:42.341077', '2026-09-24 05:21:55.783698', '2026-09-24 05:19:42.352067');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('57af7262-6d75-4cac-adf7-0d894abbe5f1', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'af4349c74bc038a4b18afc0e1a7a710912ef9f188e32e19049e0ebc43e61791e', '2026-10-12 05:43:48.977438', NULL, '2026-10-05 05:43:48.994136');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('c201c283-f833-4fe2-bb05-71bf8c1af51b', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '6bebad3bed58aa020492d09dc54e269d142202d5512bfc81dbe78b5e52032ee5', '2026-10-15 04:09:37.896544', NULL, '2026-10-08 04:09:37.939976');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('afdd677a-e50d-4083-a661-b58369671977', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '06a360a038be8a1e46f230c63edffe3d3bce07457f46a9c4e3a2484f292bc8b3', '2026-10-15 04:25:22.920514', NULL, '2026-10-08 04:25:22.924257');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('7b12a13a-9632-4d9c-ad28-e64637b9fdc2', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'e31550c355afb8044f4b78fe3be249d8a9505542a1ec2563e1eaf6c669c5de09', '2026-10-15 06:35:40.471231', NULL, '2026-10-08 06:35:40.518788');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('e614d8b1-4950-4de2-81ed-d77b7e6db68c', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '4806f3198abdd0fc53cff5ca29479c5c0395c3648e0eb2fba4993b527116b994', '2026-10-19 06:57:34.601194', NULL, '2026-10-12 06:57:34.645175');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('9d9cbd60-106e-4e35-ab3d-91c8cc02e415', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '8151dd6a7636a35aab3b4edd30eac32240c56022d9a82e2bc8c81678279b9407', '2026-10-19 07:43:11.920872', NULL, '2026-10-12 07:43:11.957497');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('bbd2c770-ab33-4689-a99a-13d7ab84d705', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '4f14aea6f2bca01bdf30427e493f3175319c6b8e8a083d5f1818c2401a47d4b3', '2026-10-19 07:44:02.688183', NULL, '2026-10-12 07:44:02.722542');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('376f746a-dab0-400c-9290-eaa42500e14d', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '99d8fad5ad251fa4a835dda8aeb84a5e740664384e0459ee4dfb0cae9aaa7683', '2026-10-19 08:28:40.559372', NULL, '2026-10-12 08:28:40.595702');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('b43a6ffb-600a-4d19-b7c0-eac4302f228e', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '7fe183ffc597cb72d381066b145b96f44634edb5d3373ba996e8d1e9694fb383', '2026-10-19 09:01:38.818353', NULL, '2026-10-12 09:01:38.854440');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('58fa13ce-913d-43b4-8672-0333000a8adc', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'b21d9a9cfaa9a72bf9c1a2af3539b6046535c1abf56793b0fd216c8abe499547', '2026-10-19 09:02:20.758625', NULL, '2026-10-12 09:02:20.762824');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('adcaf64c-3c66-46aa-9716-51c10803df52', '249da968-8c47-45db-8708-eea1364c8386', 'ea16044ef630f29fb05f79e838b91d548c59b91d71cb7e54e613af848297329e', '2026-11-10 01:52:00.202560', NULL, '2026-11-03 01:52:00.214153');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('6e5d8234-eb01-4b4b-ba99-35bf4c1b3a39', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'daf6f1b61debeae77c24ee0b316c372c5c665deb8df7218d08c2a11f53db8b98', '2026-11-10 01:53:59.664430', NULL, '2026-11-03 01:53:59.697024');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('bd422ea6-9d10-4eff-b4b7-b36161cacbd7', '249da968-8c47-45db-8708-eea1364c8386', '01a64948b8491e50b0e332e955d311319f89d3be7954895e9091990a444f6027', '2026-11-10 03:42:54.934127', NULL, '2026-11-03 03:42:54.968754');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('79db5021-67e8-4729-aee6-b676017e304f', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', 'b75c57b78e9e22adb7a6da9ec0b0fa37cf51a6500243537c915a7aa2691020b3', '2026-11-10 03:51:58.993601', NULL, '2026-11-03 03:51:59.037577');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('2a1d5584-51b6-4306-a50e-9d9d26b5c795', '249da968-8c47-45db-8708-eea1364c8386', '14db367c2e72c0f7a4daa7c5c4d319e3afc761c39bc4c09bb61776ea269cb1d8', '2026-11-10 04:00:00.828262', NULL, '2026-11-03 04:00:00.870575');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('962290aa-0577-4987-b0c3-4de082f99fdd', '5960dc5e-1d4c-48d9-8080-3d5accd8df5c', '218fb6089d6d8d60cc1b29928365b4fa1077da7f6417d47f948d8ec4a0078116', '2026-11-10 04:00:56.297385', NULL, '2026-11-03 04:00:56.309996');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('3a37f17c-ed9c-4339-8324-25c529822d4a', '249da968-8c47-45db-8708-eea1364c8386', 'cb7a53c674b04977cf08505063845711c024cebfcc0754e8d1c6aeb0492a78ca', '2026-11-10 04:03:01.616328', NULL, '2026-11-03 04:03:01.624687');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('fd10d5f0-1ac4-4a03-a828-c12f40051d68', '249da968-8c47-45db-8708-eea1364c8386', '7bb3fd7eeaea7c964261ddd385c946becae005b08e02e013bba0f074b1464c68', '2026-11-10 04:22:26.218561', NULL, '2026-11-03 04:22:26.249444');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('e3626398-bc31-4448-b47d-b67e99b4f390', '249da968-8c47-45db-8708-eea1364c8386', '5c1e98d32a6133b6bed7daf71c72d1e257eac1ed60e57b223fc14971658923ac', '2026-11-10 05:00:31.400249', NULL, '2026-11-03 05:00:31.452413');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('34c8ae30-b692-4307-aae8-e5734ff3d508', '249da968-8c47-45db-8708-eea1364c8386', '5bb945084d16e032e6f43e71e14e7b84b0cae46fc25c22d4ffc70af40aea7aa2', '2026-11-10 05:00:33.163124', NULL, '2026-11-03 05:00:33.185435');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('ac37f4ad-7d13-451e-918d-18d07e02e51a', '249da968-8c47-45db-8708-eea1364c8386', '200ae914994aedc41f5e9a68444053277e232f5de67fbd5e7d4b2d15505cf2b4', '2026-11-10 05:00:33.751296', NULL, '2026-11-03 05:00:33.758376');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('d9ebb982-a0ae-45ab-b262-f9dbd3b6aaba', '249da968-8c47-45db-8708-eea1364c8386', '720f2ac93424d649fbc916d4112b52ae8f8f838efa090b32e90cc9cca456bafd', '2026-11-10 05:00:35.154420', NULL, '2026-11-03 05:00:35.165413');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('6b30b1eb-1873-4130-9363-cb3cdc346a3d', '249da968-8c47-45db-8708-eea1364c8386', '9c3a8ee920b0ee810035a39da58a82eb7fab36d5803830ebb205d33aa2ef51d8', '2026-11-11 08:00:03.891382', NULL, '2026-11-04 08:00:04.003334');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('d69396ba-b79e-4b12-a8b5-af18dd65a2f7', '249da968-8c47-45db-8708-eea1364c8386', '074a261a17ed2589818863f50c4d2bd84ca864834202ed938e872c9ba8cec6ab', '2026-11-13 08:44:23.815474', NULL, '2026-11-06 08:44:23.842126');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('2018d24d-37f6-44db-8907-3519ac639d64', '249da968-8c47-45db-8708-eea1364c8386', '8b4fa0ebde88e165014b8e8ccaae8d93a50dd26da71ca87a17db4a543ed91933', '2026-11-13 09:01:57.075582', NULL, '2026-11-06 09:01:57.095702');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('262e4259-9d9d-4ef4-b09f-3885d55eca79', '249da968-8c47-45db-8708-eea1364c8386', '2adc9bf737bda97741908af9c3379397950547cab969813f5b7eb0b2d66c8746', '2026-11-23 15:26:26.467149', NULL, '2026-11-16 15:26:26.513668');

INSERT INTO `auth_sessions` (`id`, `user_id`, `jti_hash`, `expires_at`, `revoked_at`, `created_at`) VALUES ('64d707e9-6c9a-4468-b466-c1f8aecc3ddb', '249da968-8c47-45db-8708-eea1364c8386', '0366277d1412f9ba3ec049eff319a60118a6bf7d94f9a65a8257098e7c344dad', '2026-11-23 16:04:45.592011', NULL, '2026-11-16 16:04:45.626510');

-- Data untuk tabel `kiosk_sessions` (77 baris)
INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a4046459-edf3-4a68-b6e1-ae54c7f5189b', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'dac51345e9527b6d1f4d8c5588ecb2d9e9c201db893cc699e9be4f0d11e18d8b', 'TURN_LEFT', '2026-07-27 14:36:26.423533', '2026-07-27 14:35:56.462685', '2026-07-27 14:35:56.426168');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('7e1a15fa-e5de-42aa-b4bf-2341fbb4f1b9', '0302e9bd-6b55-4e31-92f2-edad88c82623', '0673c713bc7ab1d2eb7b0e4a02ced28fd65eeac8e7bd545b6bfcfe42eff30f3c', 'TURN_LEFT', '2026-07-27 14:59:14.741148', '2026-07-27 14:58:44.956559', '2026-07-27 14:58:44.741483');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('bfa23bf8-fdb6-45f9-aae2-5bb4f1c60658', '0302e9bd-6b55-4e31-92f2-edad88c82623', '7b6ad3def29f56d22eb79ac3ce77531f393667d02b67cdfdb849a97a347ba3b6', 'TURN_RIGHT', '2026-07-27 14:59:24.728951', '2026-07-27 14:58:54.785612', '2026-07-27 14:58:54.731057');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('f9487221-5957-43bb-8247-4caa08a96283', '0302e9bd-6b55-4e31-92f2-edad88c82623', '9ff820d4606e1ce08f436bee9524f3a5e3daae0f9d533ce862ad1c4e3442ea4a', 'BLINK', '2026-07-27 14:59:55.596122', '2026-07-27 14:59:25.631275', '2026-07-27 14:59:25.597869');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('39ccbf17-c75b-4ab0-8e43-be6a193c5bde', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'dbbac23e6a02e1e77c8d72edc69e063d68b639997d2e3ede05941589ccb17f0d', 'TURN_RIGHT', '2026-07-27 15:02:22.564722', '2026-07-27 15:01:52.593954', '2026-07-27 15:01:52.566314');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('97f33e7c-572d-41a3-bd39-b36fe592299a', '0302e9bd-6b55-4e31-92f2-edad88c82623', '98b2817ba09d57940121a24437a1530673f087f4599d0d6225ac7562dd92b312', 'TURN_LEFT', '2026-07-27 15:02:39.487334', '2026-07-27 15:02:09.523859', '2026-07-27 15:02:09.487813');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('ec6bf68a-2b4d-4075-a27c-5250da641711', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'fb986dd5d26f51969ad919bba848682e40d638634faefecc9b81dde7a3d72791', 'BLINK', '2026-07-27 15:03:43.619556', '2026-07-27 15:03:13.839108', '2026-07-27 15:03:13.620366');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('d8c5d8de-2c30-45b1-a9f4-d19cf7360a09', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c7d8b0be8ec9349a7526c3790bcc33f02ba013b98e00b7f99f8755f4bc721ef7', 'TURN_LEFT', '2026-07-27 15:05:46.144687', '2026-07-27 15:05:16.221104', '2026-07-27 15:05:16.151527');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('bd06bf30-ed8d-4828-bfb5-a6c7a0e8a5fd', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c174b6d01785f72cbf9a13e6569ecbb919ade2954dfd434bbf9c66addf5aadbd', 'TURN_LEFT', '2026-07-27 15:14:14.187797', '2026-07-27 15:13:44.381170', '2026-07-27 15:13:44.188211');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('d454a0f3-65c0-4ff7-9b10-36bbf429c419', '0302e9bd-6b55-4e31-92f2-edad88c82623', '180dff8590ae7ce26736809ec79ac2f73f7ff8aa4650e20f054773202b27b6c0', 'TURN_RIGHT', '2026-07-27 15:14:35.442829', '2026-07-27 15:14:05.466867', '2026-07-27 15:14:05.445002');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('4cb01b86-1db6-41b3-b0e0-49f93319c7fd', '0302e9bd-6b55-4e31-92f2-edad88c82623', '67c6ed5616cd7c48992c22a3b6ebd4461b575cf10bc3029964916c3b0fcbb8e2', 'BLINK', '2026-07-27 15:15:33.729606', '2026-07-27 15:15:03.750659', '2026-07-27 15:15:03.730003');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('2e7b788d-f5e5-4ae2-95b3-d577c2d6e7d9', '0302e9bd-6b55-4e31-92f2-edad88c82623', '7591b58e0dff6f6b638d0b8f1ed122205edd401c466d56296746a2f3b45ffd61', 'BLINK', '2026-07-27 15:19:29.764073', '2026-07-27 15:18:59.829110', '2026-07-27 15:18:59.764390');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('0159c638-5723-4b6d-b611-49b99b77e0e7', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'ac5a403fbf92aa22ea0862f03a18d1da6f8739575ae35914e615e751587203e6', 'BLINK', '2026-07-27 15:21:05.919230', '2026-07-27 15:20:35.967236', '2026-07-27 15:20:35.920892');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('e9e70de7-deb5-4aef-aef2-a1d88147a374', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5e5c7745607aa464a472aba8b77a4d4c7de402211c6fea9a1e6c13a3142cbf24', 'BLINK', '2026-07-27 15:21:15.704121', '2026-07-27 15:20:45.771761', '2026-07-27 15:20:45.705798');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('c4dab9d0-6cc2-4a5d-ac96-985ebbab9a90', '0302e9bd-6b55-4e31-92f2-edad88c82623', '89641d6aef09eecebe1f4fa87f22d79a22ba363bef617e2a520c7ddb6e206d64', 'TURN_RIGHT', '2026-07-27 15:22:20.386165', '2026-07-27 15:21:50.436927', '2026-07-27 15:21:50.387930');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('b53c18d3-2aa7-4998-bde6-32eccea03a7e', '0302e9bd-6b55-4e31-92f2-edad88c82623', '1046722125580aab3a3c291e7e4a121fef47599bce720f6b3181cfc109d6701e', 'BLINK', '2026-07-27 15:22:29.985039', '2026-07-27 15:22:00.060351', '2026-07-27 15:21:59.985372');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('1619a72e-3316-4103-8713-60c8e86fdb1b', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b19721535acaad71fa299ac7bd7df165f2ad2344a0368041c2e05380e82a6825', 'BLINK', '2026-07-27 15:22:48.194929', '2026-07-27 15:22:18.268576', '2026-07-27 15:22:18.197131');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('39da28bb-dd15-4249-8b78-392aa9735f7d', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a63c3c1a93de67af028976b09cb2a41a37b0c7345a2eed2da7e6c749168697dd', 'TURN_RIGHT', '2026-07-27 15:22:51.689457', '2026-07-27 15:22:21.728321', '2026-07-27 15:22:21.690423');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('74675aaf-028e-4df1-9fec-b57ff141484f', '0302e9bd-6b55-4e31-92f2-edad88c82623', '3a01849f8ab58fbfc97f441c1d80df9407b7bf285493478e446d77fe42cada6b', 'TURN_LEFT', '2026-07-27 15:22:52.867568', '2026-07-27 15:22:22.924022', '2026-07-27 15:22:22.869577');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('42e9da1c-d334-461d-bdea-287110bdb662', '0302e9bd-6b55-4e31-92f2-edad88c82623', '8fa0fa672178d3696819334232d476447fe2bc4dab1f47d06d87f3d787596a3f', 'TURN_RIGHT', '2026-07-27 15:22:53.717109', '2026-07-27 15:22:23.748813', '2026-07-27 15:22:23.718043');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('d2e6ece6-7cff-4034-be53-7b2f70547d7f', '0302e9bd-6b55-4e31-92f2-edad88c82623', '4948afc983630e29f4b55ec050c4aaa7931d3d39d7ccc3c312425a12621f8055', 'NONE', '2026-07-27 17:00:15.723822', '2026-07-27 16:59:45.797984', '2026-07-27 16:59:45.724963');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('40d32d4d-e966-43d9-ac6e-fe16f2950e35', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'e837be9fb19b8deb6d44ca0909df95b399e69dc0eba5383c129c0440e632b549', 'NONE', '2026-07-27 17:08:33.238888', '2026-07-27 17:08:03.374204', '2026-07-27 17:08:03.239536');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('da3b4402-a430-4455-b136-d48f77aed8c7', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'bf92aec5376e70a3d34b27132867e1d35551fe950587e177430c64798ce66711', 'NONE', '2026-07-27 17:08:52.906872', '2026-07-27 17:08:22.966615', '2026-07-27 17:08:22.907406');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('2342e8c3-a437-4847-ac98-ce0edcd007d2', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'd2a046bef1fa132f899d3d2b104a4f836a99f91469f4998e3dacc961bb879729', 'NONE', '2026-07-27 17:09:02.347693', '2026-07-27 17:08:32.464534', '2026-07-27 17:08:32.350093');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a15c37ff-22b9-42e6-8144-2139529b80f7', '0302e9bd-6b55-4e31-92f2-edad88c82623', '7c003dda330045ec5813fd16ea868256af824f162c5f97a57b822fae1c3d11da', 'NONE', '2026-07-27 17:09:16.098912', '2026-07-27 17:08:46.151515', '2026-07-27 17:08:46.099507');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('ac526aa6-d023-455f-8c6f-09d2820c547f', '0302e9bd-6b55-4e31-92f2-edad88c82623', '9466e4989ed3b9a407151f210e4faaa5b1b295552589e20a8977533d7542b4da', 'NONE', '2026-07-27 17:09:29.554885', '2026-07-27 17:08:59.634096', '2026-07-27 17:08:59.555610');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('eb4bdec8-8215-4f2d-82df-4b206ca63273', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a3d09addf74256fd73b306fc94e3bf91c083af61313dba14062abe4aa3979bde', 'NONE', '2026-07-27 17:09:38.746962', '2026-07-27 17:09:08.893209', '2026-07-27 17:09:08.750227');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a4ccb4ca-bf9a-4df5-8d52-9c7a58f005f4', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c04b7acfbb7299859830ab15936d028d9007a4154ca54111a4e79121e0842270', 'NONE', '2026-07-27 17:09:52.207258', '2026-07-27 17:09:22.290028', '2026-07-27 17:09:22.209148');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a54705c7-7125-45a4-9abe-1eb3efcb26f7', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a62e5e93547f4993d17779dcd06a590307f0f4df8f6478cf0b64ba73ac77e718', 'NONE', '2026-07-27 17:11:05.862200', '2026-07-27 17:10:36.108373', '2026-07-27 17:10:35.864490');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('dc789277-766f-4731-9025-cc6bba7a2350', '0302e9bd-6b55-4e31-92f2-edad88c82623', '9c56757d11e30e85f605ed90e8d8d2f1ec6e7582aa9cae8ba6990fb7afe5b748', 'NONE', '2026-07-27 17:11:26.024242', '2026-07-27 17:10:56.313364', '2026-07-27 17:10:56.024748');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('81a26d47-7149-43a3-aa11-b8c274114f1d', '0302e9bd-6b55-4e31-92f2-edad88c82623', '6632121f4c012ecd84a3a618a108a2c06be9410fd4534cacace7ae83a69efce3', 'NONE', '2026-07-27 17:11:34.403664', '2026-07-27 17:11:04.464637', '2026-07-27 17:11:04.405236');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('9c392645-d683-46d3-bfd0-8fca6cfc1e20', '0302e9bd-6b55-4e31-92f2-edad88c82623', '029eced7ae9076f1edd5a27a5ec64a4ab4eca508aa091155868183c07f58a535', 'NONE', '2026-07-27 17:11:47.235763', '2026-07-27 17:11:17.477122', '2026-07-27 17:11:17.236825');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('59e611f6-2212-4369-8920-30058380e028', '0302e9bd-6b55-4e31-92f2-edad88c82623', '3d7f6492e2fb754b8fad82ebca9c385744dc37693efa58d72065199c7cde6a3f', 'NONE', '2026-07-27 17:17:01.348748', '2026-07-27 17:16:31.693499', '2026-07-27 17:16:31.351471');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('6457cd63-9b72-4bc5-9db6-5558694fcaf0', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'a55f677bcd4626f2bed923379bcc0aeb89a6833e947bd3fa6f7c22f5586e6311', 'NONE', '2026-07-27 17:17:41.035886', '2026-07-27 17:17:11.246257', '2026-07-27 17:17:11.036419');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('af71bd1a-3402-4f7b-b34c-a6a2efd665ae', '0302e9bd-6b55-4e31-92f2-edad88c82623', '76cedd7ae445b40d68aaa2c0ad32800b2bdcf183b208e47bf5feae2c0809da2b', 'NONE', '2026-07-27 17:17:45.484203', '2026-07-27 17:17:15.536200', '2026-07-27 17:17:15.485741');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('5d394df0-73a0-4988-b7eb-21e684edd1aa', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c18ca01417b6f0d5e8fa82735634d86729d49f0d32b63398f81defe8324fa1ad', 'NONE', '2026-07-27 17:18:03.624441', '2026-07-27 17:17:33.915647', '2026-07-27 17:17:33.625769');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a8ac03ae-8bb4-4ae1-934c-5a0fb9f7356b', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b955f518fa8b8122d234364f0e1091c978ccaea45224c2c9b89ddd51e1157807', 'NONE', '2026-07-27 17:18:10.401042', '2026-07-27 17:17:40.638449', '2026-07-27 17:17:40.401569');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('9143a940-f85b-479f-999e-b91f0c9f246e', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c88140a43ca1e17a422e437075bca1e48be208b9ffd918d09be32a56a91831e2', 'NONE', '2026-07-27 17:18:23.553490', '2026-07-27 17:17:53.795901', '2026-07-27 17:17:53.555312');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('6043fa48-21ef-4baf-bb12-7586e82634cc', '0302e9bd-6b55-4e31-92f2-edad88c82623', '362f514ac7cb7a3d98ff57810eafe225f35fa349183621230bb26031c264e5dd', 'NONE', '2026-07-27 17:18:32.260623', '2026-07-27 17:18:02.501288', '2026-07-27 17:18:02.263941');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('bc8e9095-4001-4121-8cb5-77ed3dd66eee', '0302e9bd-6b55-4e31-92f2-edad88c82623', '7d25d8ab93a0a069415076af41470861c332b0b39c26a4013ba8d2095ea30b41', 'NONE', '2026-07-27 17:30:55.413098', '2026-07-27 17:30:25.739678', '2026-07-27 17:30:25.413893');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('5ea34525-1728-491f-8c74-9b83d38659e4', '0302e9bd-6b55-4e31-92f2-edad88c82623', '1b388c58057de6b2c58e780d34ba4686d6028c1d1205c5b0ac76e07f8a9440a3', 'NONE', '2026-07-27 17:31:05.188891', '2026-07-27 17:30:35.335694', '2026-07-27 17:30:35.193720');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('c65f99f0-7bed-4cf1-8ac3-b251b9da81a5', '0302e9bd-6b55-4e31-92f2-edad88c82623', '361a2859d40d8a531887e721b0cbf68999f6c66321328f6ac2e6a572dbf82547', 'NONE', '2026-07-27 17:31:20.390713', '2026-07-27 17:30:50.484119', '2026-07-27 17:30:50.391325');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('602b61f3-5374-4d0e-9cc8-51cb4fea77b7', '0302e9bd-6b55-4e31-92f2-edad88c82623', '8f1e8681a2f574cd035da1ed63a851649649ae9c77b3222f18354ae86440acce', 'NONE', '2026-07-27 17:32:19.505008', '2026-07-27 17:31:49.706588', '2026-07-27 17:31:49.506691');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('62d0f6b1-83dc-4400-938b-7787142c40ad', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'ed592a858f4a23527b5d6571364b5f911ae115c7f0928f08d898f4d8abf09408', 'NONE', '2026-07-27 17:32:43.903566', '2026-07-27 17:32:14.072473', '2026-07-27 17:32:13.906996');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('ffed1f78-1931-46ae-9395-730f6843a716', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'c52f1643fbb62d049aeb44d623733c602e65da7fd5de484bc458b4f549c870fa', 'NONE', '2026-07-27 17:32:53.063459', '2026-07-27 17:32:23.148276', '2026-07-27 17:32:23.064384');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('7d18e738-bd9a-4a3e-8174-d923a77f396b', '0302e9bd-6b55-4e31-92f2-edad88c82623', '32d7ae291e30e598f146496fb25ba1c8c2574291b78b008636e83c95822c3685', 'NONE', '2026-07-27 17:37:30.944130', '2026-07-27 17:37:01.017845', '2026-07-27 17:37:00.945782');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('aa8f7b91-3dec-41f0-9ece-d0a5e03bc9b2', '0302e9bd-6b55-4e31-92f2-edad88c82623', '2e210203e61d3da756fdea88e1838e9c891a4ba3357544cfd5c3d43b6dad88f6', 'NONE', '2026-07-27 17:37:40.745738', '2026-07-27 17:37:10.806902', '2026-07-27 17:37:10.746670');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('801eceb8-5da3-4598-ab9d-85c14ac770a7', '0302e9bd-6b55-4e31-92f2-edad88c82623', '8708fca308bd88d784ed7465da23f76288c39b93cc38284c27855aabb679005b', 'NONE', '2026-08-01 13:26:29.180290', '2026-08-01 13:25:59.573043', '2026-08-01 13:25:59.186598');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('a1439762-3fe3-4488-942e-c2f5a1ece1f2', '0302e9bd-6b55-4e31-92f2-edad88c82623', '66675ebb2f24b3d10d0e8c9aef8a6ee4844524d5c50949666474367219213cd1', 'NONE', '2026-08-01 13:26:39.645204', '2026-08-01 13:26:09.703423', '2026-08-01 13:26:09.645628');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('70eac62d-9518-4082-bc3d-21030684b185', '0302e9bd-6b55-4e31-92f2-edad88c82623', '2aa8018932e8827e57153da3973a7fc0ce3680d3b2181819ae86605e1f7151fb', 'NONE', '2026-08-01 13:26:56.345061', '2026-08-01 13:26:26.438270', '2026-08-01 13:26:26.346630');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('3325e22c-3ca2-49d3-9c80-52d0402f3da1', '0302e9bd-6b55-4e31-92f2-edad88c82623', '55de932ac7535cdd2317e3d422cf737c6727c316e4c0d093ffc6c68336e6315c', 'NONE', '2026-08-01 13:27:13.068187', '2026-08-01 13:26:43.152642', '2026-08-01 13:26:43.069830');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('68b1e543-f3e4-40c5-aa1b-2bf32657ff12', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5fd768d547375b213ec86d083f8034cc6729009fb957c0e27cf2e9486e501677', 'NONE', '2026-08-01 13:27:25.673865', '2026-08-01 13:26:55.765358', '2026-08-01 13:26:55.674477');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('d352009d-5e6c-49f1-b43a-f11fbd37e9ac', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b4592a3188190ef91783cf73baf5e15dafe08af12dd158e9e4e2a99f8cf82c22', 'NONE', '2026-08-01 13:27:39.508808', '2026-08-01 13:27:09.569962', '2026-08-01 13:27:09.509579');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('b53f2e5f-d49f-4443-8dd1-cf4e97139451', '0302e9bd-6b55-4e31-92f2-edad88c82623', '1b7433854e4dee5e000a0c5384bc037c832ebebe08ed1d57737a1cb41b02401f', 'NONE', '2026-08-01 13:27:47.950381', '2026-08-01 13:27:18.025032', '2026-08-01 13:27:17.951781');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('97d9f085-02c5-45b9-8ce1-6435cd09916d', '0302e9bd-6b55-4e31-92f2-edad88c82623', '3fb8c1465ce65d5d5cf399b8b1a7ea7644049e46ac4937f3b9104f4760b60d53', 'NONE', '2026-08-01 13:27:54.981186', '2026-08-01 13:27:25.131175', '2026-08-01 13:27:24.982865');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('fde6c286-4b0c-4f4f-9c5e-b7d4caacb82f', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'eb4ada5e96085c8cd13a655797faa14a5ca09e4d7c504a46c6eb1b078d28da59', 'NONE', '2026-08-01 13:28:14.857011', '2026-08-01 13:27:44.935404', '2026-08-01 13:27:44.858043');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('fdc22da5-f10c-4165-ab48-bd1f51371231', '0302e9bd-6b55-4e31-92f2-edad88c82623', '324f5ecf038c89dd57847b0cea462c24a7d4e655cfc893cafa5c3d6758861af7', 'NONE', '2026-08-01 13:28:28.946902', '2026-08-01 13:27:59.034005', '2026-08-01 13:27:58.948283');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('78071e31-e588-4f7b-b3da-5a0078954f96', '0302e9bd-6b55-4e31-92f2-edad88c82623', '0e576cd33183f21a13c92ea08827cc52074fbe30db2cb4bc4c22e0d4ddf58167', 'NONE', '2026-08-01 13:28:37.295081', '2026-08-01 13:28:07.364582', '2026-08-01 13:28:07.298087');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('5775e721-a7d3-4d30-88f3-db607ae56dce', '0302e9bd-6b55-4e31-92f2-edad88c82623', '9d72c6b1b514466469171a9bcdc522778ec682309dc8dcb62e9380a4b62e95e4', 'NONE', '2026-08-01 13:28:48.972273', '2026-08-01 13:28:19.054828', '2026-08-01 13:28:18.973570');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('1b354bc3-ad70-4e35-b74a-1d5a015ee897', '0302e9bd-6b55-4e31-92f2-edad88c82623', '3c0b3f0b174e9695ee83f1f31165d559f4102aa4d874bf8f4115a142fbefba4d', 'NONE', '2026-08-01 13:28:56.349870', '2026-08-01 13:28:26.471876', '2026-08-01 13:28:26.351187');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('71a8573d-46dd-4132-85e2-7f041ead506c', '0302e9bd-6b55-4e31-92f2-edad88c82623', '8814082ba4496a2f14d1afbb083f52f5063cc50974af13ac2e851ff78fdcb2b0', 'NONE', '2026-08-01 13:29:02.603878', '2026-08-01 13:28:32.666547', '2026-08-01 13:28:32.604277');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('daedd473-38d6-4071-b2d0-33e341fef777', '0302e9bd-6b55-4e31-92f2-edad88c82623', '427f9ff324d5692bbe3a817983841eee147f3aa39e45787609f764d287881ebb', 'NONE', '2026-08-01 13:29:19.464748', '2026-08-01 13:28:49.542414', '2026-08-01 13:28:49.465892');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('1b58196d-b9e3-485a-8312-2f5ec58e4868', '0302e9bd-6b55-4e31-92f2-edad88c82623', '898b960d57d08caa2a14d819a28e841ca29890a124617388bb228e23e2af04d1', 'NONE', '2026-08-01 13:29:34.957057', '2026-08-01 13:29:05.043230', '2026-08-01 13:29:04.958450');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('5cbb32e3-97a8-4ba8-a21f-48b9392dd69b', '0302e9bd-6b55-4e31-92f2-edad88c82623', '0922daf399e533fa0b9947fc2fc9b59ca66bac077284b9d4eb028b552c681641', 'NONE', '2026-08-01 13:29:42.440722', '2026-08-01 13:29:12.516993', '2026-08-01 13:29:12.441533');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('50306e96-1eed-4d80-b96d-96a04241c745', '0302e9bd-6b55-4e31-92f2-edad88c82623', '56c2ae0aaaec4e06b5e61f19b43b77c2d0c0f08a33b1cc24213709859ce1eb2b', 'NONE', '2026-08-01 13:29:48.656771', '2026-08-01 13:29:18.713481', '2026-08-01 13:29:18.657758');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('2066d34d-f4dc-45ca-9694-b61ab80ff497', '0302e9bd-6b55-4e31-92f2-edad88c82623', '075e690f9a2f03f99a3041cce70af1293d682e2567648d5d6fa89774c964ff22', 'NONE', '2026-08-01 13:29:55.599525', '2026-08-01 13:29:25.664644', '2026-08-01 13:29:25.600547');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('781410c4-9446-4609-8cb7-607ffa4c9395', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'b4acfdf809646822bbfee623f019f60fee16edf3081f7631840010f02e3d54cd', 'NONE', '2026-08-01 13:30:06.964832', '2026-08-01 13:29:37.016534', '2026-08-01 13:29:36.966084');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('4595424f-b901-49ee-94f7-7c1d4d9765c1', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'fce8caa5351f6111376d129fc19323b86863bec5fd0fca9fc50fa632d39f3083', 'NONE', '2026-08-01 13:30:18.640049', '2026-08-01 13:29:48.724619', '2026-08-01 13:29:48.641537');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('923ef98a-793a-415c-aa50-26b6497acef5', '0302e9bd-6b55-4e31-92f2-edad88c82623', '87e31c4ed932887d86250f77e7a75f4973e5e6f1e4054313899871c5527e9eb7', 'NONE', '2026-08-01 13:30:28.139542', '2026-08-01 13:29:58.228775', '2026-08-01 13:29:58.140944');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('b120cd2d-1910-4f28-b7e9-8bf1c019ab94', '0302e9bd-6b55-4e31-92f2-edad88c82623', '29a4ae27d6db7d0f597234ed8696f04ccd8c015b7b3927e37031e3d68a15db94', 'NONE', '2026-08-01 13:30:37.323856', '2026-08-01 13:30:07.433604', '2026-08-01 13:30:07.325262');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('316f7b2e-4fd4-4904-9051-c964d31b7111', '0302e9bd-6b55-4e31-92f2-edad88c82623', '97862a1d7ee994bc4858c13be005eb0fe52979b7cd073a51737a5b5bdd4dbe3f', 'NONE', '2026-08-01 13:30:50.419558', '2026-08-01 13:30:20.476717', '2026-08-01 13:30:20.421854');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('8ee5c802-1c9a-43ea-ac1c-7ee62dd7c98c', '0302e9bd-6b55-4e31-92f2-edad88c82623', '1cd4bf7a933798e3ed443fec15df864b433e6073d86d887ab65238b8a4092aec', 'NONE', '2026-08-01 13:30:59.185483', '2026-08-01 13:30:29.272823', '2026-08-01 13:30:29.186796');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('7f742b6c-1a13-4cca-899b-2ef9933c70b8', '0302e9bd-6b55-4e31-92f2-edad88c82623', '38985f45a556235d37d7b798139b9d7c26fb5029f6405bd40e1c3ac1414be626', 'NONE', '2026-08-01 13:54:37.541023', '2026-08-01 13:54:08.198668', '2026-08-01 13:54:07.542241');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('286a4978-3799-4537-96f1-963f9af057b0', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'cb17d0c8f572a246bfaee8f560703a5ed344ec183e32fe2e9a9c77d7d011169d', 'NONE', '2026-08-01 13:55:46.028633', '2026-08-01 13:55:16.330911', '2026-08-01 13:55:16.030753');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('4f0d7b84-2c96-4b5c-ba3e-3cd94b81e0a2', '0302e9bd-6b55-4e31-92f2-edad88c82623', '63749ebd35dc5f0c2e361d205e6420e7cd79dd353b389ac4a2cc806577a36fb1', 'NONE', '2026-08-01 13:55:57.923216', '2026-08-01 13:55:28.268810', '2026-08-01 13:55:27.924436');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('8a0bbba5-208d-42ed-aafa-473e1237cc23', '0302e9bd-6b55-4e31-92f2-edad88c82623', 'ba3d0dcb410ece506ae2bd06cb237bb63beeeb6dbf492b8fbd4534aca54cecbb', 'NONE', '2026-08-01 13:56:14.580734', '2026-08-01 13:55:44.965710', '2026-08-01 13:55:44.582138');

INSERT INTO `kiosk_sessions` (`id`, `device_id`, `jti_hash`, `challenge`, `expires_at`, `used_at`, `created_at`) VALUES ('36efa8c4-ca38-46a2-a4f2-e08076317b3e', '0302e9bd-6b55-4e31-92f2-edad88c82623', '5c153ec0111305ba491d6c0583dc1dae8b133b88f198142417c0976111ffc52b', 'NONE', '2026-08-01 13:56:23.914443', '2026-08-01 13:55:54.210627', '2026-08-01 13:55:53.914930');



SET FOREIGN_KEY_CHECKS = 1;

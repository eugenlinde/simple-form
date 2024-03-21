-- Adminer 4.8.1 MySQL 8.2.0 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `form_sector`;
CREATE TABLE `form_sector` (
  `form_id` bigint unsigned NOT NULL,
  `sector_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`form_id`,`sector_id`),
  KEY `form_sector_sector_id_foreign` (`sector_id`),
  CONSTRAINT `form_sector_form_id_foreign` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `form_sector_sector_id_foreign` FOREIGN KEY (`sector_id`) REFERENCES `sectors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `form_sector` (`form_id`, `sector_id`) VALUES
(16,	2),
(8,	3),
(17,	6),
(9,	28),
(9,	29),
(9,	30),
(8,	37),
(8,	64),
(18,	77),
(18,	78);

DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `agreed` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `forms_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `forms` (`id`, `uuid`, `name`, `agreed`, `created_at`, `updated_at`) VALUES
(8,	'3b54000c-e6d3-11ee-99e4-33357199aa89',	'Foo',	1,	'2024-03-20 14:02:20',	'2024-03-20 14:02:20'),
(9,	'7acecf96-e6d3-11ee-99e4-33357199aa89',	'Bar',	1,	'2024-03-20 14:04:06',	'2024-03-20 14:04:06'),
(16,	'edf575e8-e6d7-11ee-99e4-33357199aa89',	'Baz',	1,	'2024-03-20 14:35:57',	'2024-03-20 14:35:57'),
(17,	'3122c304-e6db-11ee-99e4-33357199aa89',	'abc',	1,	'2024-03-20 14:59:19',	'2024-03-20 14:59:19'),
(18,	'5b574a5c-e76f-11ee-99e4-33357199aa89',	'Joe',	1,	'2024-03-21 08:39:55',	'2024-03-21 08:47:22');

DELIMITER ;;

CREATE TRIGGER `forms_before_insert` BEFORE INSERT ON `forms` FOR EACH ROW
BEGIN
                IF NEW.uuid IS NULL THEN
                    SET NEW.uuid = UUID();
                END IF;
            END;;

DELIMITER ;

DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1,	'0001_01_01_000000_create_users_table',	1),
(2,	'0001_01_01_000001_create_cache_table',	1),
(3,	'0001_01_01_000002_create_jobs_table',	1),
(7,	'2024_03_12_202728_create_sectors_table',	2),
(12,	'2024_03_12_202741_create_forms_table',	3),
(13,	'2024_03_12_202813_create_form_sector_pivot_table',	3);

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `sectors`;
CREATE TABLE `sectors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sectors_parent_id_foreign` (`parent_id`),
  CONSTRAINT `sectors_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `sectors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sectors` (`id`, `name`, `parent_id`, `created_at`, `updated_at`) VALUES
(1,	'Manufacturing',	NULL,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(2,	'Electronics and Optics',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(3,	'Construction materials',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(4,	'Printing',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(5,	'Labelling and packaging printing',	4,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(6,	'Advertising',	4,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(7,	'Book/Periodicals printing',	4,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(8,	'Food and Beverage',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(9,	'Milk & dairy products ',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(10,	'Meat & meat products',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(11,	'Fish & fish products ',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(12,	'Beverages',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(13,	'Bakery & confectionery products',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(14,	'Sweets & snack food',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(15,	'Other',	8,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(16,	'Textile and Clothing',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(17,	'Clothing',	16,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(18,	'Textile',	16,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(19,	'Wood',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(20,	'Wooden houses',	19,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(21,	'Wooden building materials',	19,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(22,	'Other (Wood)',	19,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(23,	'Plastic and Rubber',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(24,	'Packaging',	23,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(25,	'Plastic goods',	23,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(26,	'Plastic profiles',	23,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(27,	'Plastic processing technology',	23,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(28,	'Plastics welding and processing',	27,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(29,	'Blowing',	27,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(30,	'Moulding',	27,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(31,	'Metalworking',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(32,	'Construction of metal structures',	31,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(33,	'Houses and buildings',	31,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(34,	'Metal products',	31,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(35,	'Metal works',	31,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(36,	'Forgings, Fasteners ',	35,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(37,	'MIG, TIG, Aluminum welding',	35,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(38,	'Gas, Plasma, Laser cutting',	35,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(39,	'CNC-machining',	35,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(40,	'Machinery',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(41,	'Machinery equipment/tools',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(42,	'Metal structures',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(43,	'Machinery components',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(44,	'Manufacture of machinery ',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(45,	'Repair and maintenance service',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(46,	'Other',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(47,	'Maritime',	40,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(48,	'Ship repair and conversion',	47,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(49,	'Boat/Yacht building',	47,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(50,	'Aluminium and steel workboats ',	47,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(51,	'Furniture',	1,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(52,	'Kitchen ',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(53,	'Project furniture',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(54,	'Living room ',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(55,	'Outdoor ',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(56,	'Bedroom',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(57,	'Bathroom/sauna ',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(58,	'Children\'s room ',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(59,	'Office',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(60,	'Other (Furniture)',	51,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(61,	'Service',	NULL,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(62,	'Tourism',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(63,	'Business services',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(64,	'Engineering',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(65,	'Translation services',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(66,	'Transport and Logistics',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(67,	'Air',	66,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(68,	'Road',	66,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(69,	'Water',	66,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(70,	'Rail',	66,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(71,	'Information Technology and Telecommunications',	61,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(72,	'Software, Hardware',	71,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(73,	'Telecommunications',	71,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(74,	'Programming, Consultancy',	71,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(75,	'Data processing, Web portals, E-marketing',	71,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(76,	'Other',	NULL,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(77,	'Energy technology',	76,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(78,	'Environment',	76,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28'),
(79,	'Creative industries',	76,	'2024-03-20 13:56:28',	'2024-03-20 13:56:28');

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `payload` longtext NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('Q0Lm9KTBa6HJ258QFCB9BRzqycSqjzN3h3teXWEx',	NULL,	'127.0.0.1',	'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',	'YTozOntzOjY6Il90b2tlbiI7czo0MDoicjl3T2ZMbmpwSE1VU2s2Qk9DZG1lc2VaUW15dWdoUEhlUW43elBLMiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjQ6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9mb3Jtcy8zMTIyYzMwNC1lNmRiLTExZWUtOTllNC0zMzM1NzE5OWFhODkiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',	1710953985),
('ydIkgSkPwholfveeh4ugapbPRkVALf2dVw7yTBst',	NULL,	'127.0.0.1',	'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',	'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM2F4aUVUN2ZGZzRCaVN0NVRnU0tpcUlDOE8ydEYxdzVRWFRXb0hBbSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjQ6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9mb3Jtcy81YjU3NGE1Yy1lNzZmLTExZWUtOTllNC0zMzM1NzE5OWFhODkiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',	1711018042);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- 2024-03-21 11:10:36

-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 30, 2025 at 07:58 AM
-- Server version: 10.11.11-MariaDB-0+deb12u1
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cashierngl`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerSales` (IN `p_customer_id` INT)   BEGIN
    SELECT 
        customer_id, 
        COUNT(id) AS total_transactions,  -- Menghitung jumlah transaksi
        SUM(total_price) AS total_spent   -- Menghitung total pengeluaran
    FROM sales
    WHERE customer_id = p_customer_id
    GROUP BY customer_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertStock` (IN `p_product_id` VARCHAR(255), IN `p_stock_in` VARCHAR(255), IN `p_stock_out` VARCHAR(255), IN `p_current_stock` VARCHAR(255), IN `p_source` VARCHAR(255))   BEGIN
    DECLARE v_product_id BIGINT;
    DECLARE v_stock_in INT;
    DECLARE v_stock_out INT;
    DECLARE v_current_stock INT;

    DECLARE exit HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction rolled back due to an error';
    END;

    START TRANSACTION;

    -- Coba konversi ke integer
    SET v_product_id = CAST(p_product_id AS UNSIGNED);
    SET v_stock_in = CAST(p_stock_in AS SIGNED);
    SET v_stock_out = CAST(p_stock_out AS SIGNED);
    SET v_current_stock = CAST(p_current_stock AS SIGNED);

    -- Validasi: Jika hasil konversi NULL atau bukan angka, lakukan rollback
    IF v_product_id IS NULL OR v_stock_in IS NULL OR v_stock_out IS NULL OR v_current_stock IS NULL
       OR p_product_id REGEXP '[^0-9]' OR p_stock_in REGEXP '[^0-9]' 
       OR p_stock_out REGEXP '[^0-9]' OR p_current_stock REGEXP '[^0-9]' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input: Only integer values allowed';
    END IF;

    -- Insert jika valid
    INSERT INTO stocks (product_id, stock_in, stock_out, current_stock, source, created_at, updated_at)
    VALUES (v_product_id, v_stock_in, v_stock_out, v_current_stock, p_source, NOW(), NOW());

    COMMIT;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalProfit` (`year_param` INT, `month_param` INT) RETURNS DECIMAL(15,2) DETERMINISTIC BEGIN
    DECLARE total_sales DECIMAL(15,2);
    DECLARE total_purchases DECIMAL(15,2);
    DECLARE profit DECIMAL(15,2);

    -- Menghitung total sales berdasarkan tahun dan bulan
    SELECT COALESCE(SUM(total_price), 0) 
    INTO total_sales 
    FROM sales 
    WHERE YEAR(created_at) = year_param AND MONTH(created_at) = month_param;

    -- Menghitung total purchases berdasarkan tahun dan bulan
    SELECT COALESCE(SUM(total_price), 0) 
    INTO total_purchases 
    FROM purchases 
    WHERE YEAR(created_at) = year_param AND MONTH(created_at) = month_param;

    -- Menghitung profit
    SET profit = total_sales - total_purchases;

    RETURN profit;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(40) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(15) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `address`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'Raka Pratama', 'Dusun Sukamaju, RT.02, Sukamaju, Tanjungsari, Kec. Cijeruk, Kabupaten Bogor, Jawa Barat 16740', '2147483647', '2024-12-09 18:46:34', '2024-12-09 19:35:48'),
(2, 'Nadia Azzahra', 'Dusun Ngadirejo, RT.03, Ngadirejo, Pujon, Kec. Pujon, Kabupaten Malang, Jawa Timur 65391', '2147483647', '2024-12-09 18:50:46', '2024-12-09 19:38:35'),
(3, 'Dimas Putra', 'Dusun Cikaret, RT.01, Cikaret, Cisarua, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750', '2147483647', '2024-12-09 19:03:35', '2025-02-08 04:51:06'),
(5, 'Aulia Rahma', 'Dusun Talang Sari, RT.04, Talang, Kemuning, Kec. Kemuning, Kabupaten Musi Rawas, Sumatera Selatan 31661', '2147483647', '2024-12-09 19:43:04', '2024-12-09 19:45:12'),
(6, 'Salsa Nabila', 'Dusun Karanganyar, RT.02, Karanganyar, Kedungwuni, Kec. Kedungwuni, Kabupaten Pekalongan, Jawa Tengah 51173', '2147483647', '2024-12-09 19:46:51', '2024-12-09 19:46:51'),
(7, 'Fajar Alamsyah', 'Dusun Sumberjo, RT.05, Sumberjo, Talun, Kec. Talun, Kabupaten Blitar, Jawa Timur 66183', '2147483647', '2024-12-09 19:52:03', '2024-12-09 19:52:03'),
(8, 'Vira Meilani', 'Dusun Tegalrejo, RT.03, Tegalrejo, Gunungpati, Kec. Gunungpati, Kota Semarang, Jawa Tengah 50226', '2147483647', '2024-12-09 19:56:12', '2024-12-09 19:56:12'),
(9, 'Rendi Kurniawan', 'Dusun Batuputih, RT.01, Batuputih, Tanjung Bumi, Kec. Tanjung Bumi, Kabupaten Bangkalan, Jawa Timur 69155', '2147483647', '2025-02-05 01:25:32', '2025-02-05 01:25:32'),
(10, 'Citra Anjani', 'Dusun Sidomulyo, RT.04, Sidomulyo, Natar, Kec. Natar, Kabupaten Lampung Selatan, Lampung 35362', '2147483647', '2025-02-08 04:47:55', '2025-02-08 04:47:55'),
(11, 'Arya Saputra', 'Dusun Sambirejo, RT.02, Sambirejo, Mantingan, Kec. Mantingan, Kabupaten Ngawi, Jawa Timur 63257', '2147483647', '2025-02-08 05:00:44', '2025-02-08 05:01:09'),
(12, 'Ilham Fauzan', 'Dusun Pucangan, RT.03, Pucangan, Kartasura, Kec. Kartasura, Kabupaten Sukoharjo, Jawa Tengah 57168', '2147483647', '2025-02-08 05:02:41', '2025-02-08 05:02:41');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2014_10_12_100000_create_password_resets_table', 1),
(4, '2019_08_19_000000_create_failed_jobs_table', 1),
(5, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2024_12_02_014931_add_user_with_id_1_to_users_table', 2),
(7, '2024_12_03_074353_create_product_categories_table', 3),
(8, '2024_12_06_072019_create_products_table', 4),
(9, '2024_12_06_082022_create_product_units_table', 5),
(10, '2024_12_07_091812_add_user_priv_and_details_to_users_table', 6),
(11, '2024_12_07_092937_add_user_priv_and_details_to_users_table', 7),
(12, '2024_12_07_095857_modify_user_priv_enum_in_users_table', 8),
(13, '2024_12_10_012359_create_customers_table', 9),
(14, '2024_12_10_033548_create_permission_tables', 10),
(15, '2025_02_04_034626_create_sales_table', 11),
(16, '2025_02_05_011018_add_status_to_sales_table', 12),
(17, '2025_02_05_013025_create_sales_details_table', 13),
(18, '2025_02_05_084316_update_status_default_in_sales_table', 14),
(19, '2025_02_08_104447_remove_status_from_sales_table', 15),
(20, '2025_02_13_083232_create_suppliers_table', 16),
(21, '2025_02_13_094830_create_purchases_table', 17),
(22, '2025_02_13_094833_create_purchase_details_table', 17),
(23, '2025_02_13_102309_create_stocks_table', 18),
(24, '2025_03_11_151359_create_settings_table', 19);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 4),
(3, 'App\\Models\\User', 3),
(4, 'App\\Models\\User', 7);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'create products', 'web', '2024-12-09 21:15:18', '2024-12-09 21:15:18'),
(2, 'edit products', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(3, 'delete products', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(4, 'view products', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(5, 'create product categories', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(6, 'edit product categories', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(7, 'delete product categories', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(8, 'view product categories', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(9, 'create product units', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(10, 'edit product units', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(11, 'delete product units', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(12, 'view product units', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(13, 'create customers', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(14, 'edit customers', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(15, 'delete customers', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(16, 'view customers', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(17, 'create users', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(18, 'edit users', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(19, 'delete users', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(20, 'view users', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(21, 'create role', 'web', '2024-12-10 04:28:07', '2024-12-10 04:28:07'),
(22, 'edit role', 'web', '2024-12-10 04:28:07', '2024-12-10 04:28:07'),
(23, 'delete role', 'web', '2024-12-10 04:28:07', '2024-12-10 04:28:07'),
(24, 'view role', 'web', '2024-12-10 04:28:07', '2024-12-10 04:28:07'),
(25, 'create suppliers', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(26, 'edit suppliers', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(27, 'delete suppliers', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(28, 'view suppliers', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(29, 'create sales', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(30, 'delete sales', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(31, 'view sales', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(32, 'create purchases', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(33, 'delete purchases', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(34, 'view purchases', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(35, 'view stocks', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(36, 'view dashboards', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(37, 'edit settings', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(38, 'view settings', 'web', '2025-03-10 07:27:53', '2025-03-10 07:27:53'),
(39, 'delete stocks', 'web', '2025-03-17 09:44:47', '2025-03-17 09:44:47');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_category` varchar(255) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_units` varchar(255) DEFAULT NULL,
  `purchase_price` decimal(10,2) NOT NULL,
  `before_discount` decimal(10,2) DEFAULT NULL,
  `discount_product` int(20) DEFAULT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `stock` smallint(6) NOT NULL DEFAULT 0,
  `barcode` varchar(15) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `id_category`, `product_name`, `product_units`, `purchase_price`, `before_discount`, `discount_product`, `selling_price`, `stock`, `barcode`, `description`, `created_at`, `updated_at`) VALUES
(2, '1', 'HP Z3700 Wireless Mouse', '1', 150000.00, 170000.00, 0, 170000.00, 0, 'IDU-H.WM', 'Available in a variety of colors, suitable for both professional and casual work styles.', '2024-12-07 00:36:16', '2025-03-19 05:09:31'),
(3, '5', 'Kaizer KZ800 Cooling Pad', '1', 440000.00, 450000.00, 0, 450000.00, 0, 'CSU-K.CP', 'Kaizer KZ800 Cooling Pad Laptop 2400RPM Turbo Fan Kipas Pendingin Laptop', '2025-02-05 00:23:35', '2025-03-19 05:11:55'),
(4, '1', 'UGREEN Bluetooth Adapter Bluetooth 5.0', '2', 55000.00, 60000.00, 0, 60000.00, 0, 'IDP-U.BA-5', 'UGREEN Bluetooth Adapter for PC USB Bluetooth 5.0 Receiver Dongle Wireless Computer Adapter for Desktop Laptop Mouse Keyboard Printer Speaker Support', '2025-02-05 00:28:32', '2025-03-19 05:12:24'),
(5, '2', 'Orico Skt3 Usb Sound Card External', '1', 125000.00, 130000.00, 0, 130000.00, 0, 'ODU-O.SC', '1.) Material : ABS 2.) Color : Black 3.) Surface : Textured surface 4.) Output interface : USB-A*1, 3.5mm*1(microphone amp;earphone), 3.5mm earphone*1, 3.5mm microphone*1 5.) Input interface : USB2.0 6.) Cable length : 10cm', '2025-02-05 20:14:29', '2025-03-19 05:43:48'),
(6, '1', 'Ugreen 10 in 1 USB C Multi Docking', '2', 475000.00, 485000.00, 0, 485000.00, 0, 'IDP-U.MD-10', 'Ugreen 10 in 1 USB C Multi Docking RJ45 HDMI VGA USB 3.0 PD 3.5mm Audio CardReader', '2025-02-05 20:19:02', '2025-03-19 05:13:46'),
(8, '1', 'Logitech K120 USB QWERTZ Hongaria', '1', 110000.00, 115000.00, 0, 115000.00, 1, 'IDU-L.KH', 'Standard Keyboard Spill-resistant USB 1 Year (Local Official Distributor Warranty)', '2025-02-05 22:26:58', '2025-03-19 14:46:04'),
(9, '2', 'Dell Value Monitor 18.5inch D1918H', '4', 1900000.00, 2000000.00, 0, 2000000.00, 0, 'ODP-D.VM-18', '5 typical (white to black, black to white)', '2025-02-05 23:43:56', '2025-03-19 05:13:06');

--
-- Triggers `products`
--
DELIMITER $$
CREATE TRIGGER `log_product_deletion` BEFORE DELETE ON `products` FOR EACH ROW BEGIN
    INSERT INTO product_logs (product_id, category_id, product_name)
    VALUES (OLD.id, OLD.id_category, OLD.product_name);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_categories`
--

INSERT INTO `product_categories` (`id`, `nama`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Input Devices', 'active', '2024-12-05 08:19:54', '2024-12-05 08:19:54'),
(2, 'Output Devices', 'active', '2024-12-05 08:20:13', '2025-02-05 20:10:41'),
(5, 'Cooling System', 'active', '2024-12-05 09:10:49', '2024-12-05 09:10:49');

-- --------------------------------------------------------

--
-- Table structure for table `product_logs`
--

CREATE TABLE `product_logs` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_logs`
--

INSERT INTO `product_logs` (`id`, `product_id`, `category_id`, `product_name`, `deleted_at`) VALUES
(3, 11, 2, 'Golda Coffe', '2025-06-30 07:39:25'),
(4, 12, 5, 'Phanter', '2025-06-30 07:39:25');

-- --------------------------------------------------------

--
-- Table structure for table `product_units`
--

CREATE TABLE `product_units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_units`
--

INSERT INTO `product_units` (`id`, `name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Unit', 'active', '2024-12-06 03:02:56', '2024-12-06 03:16:45'),
(2, 'PCS', 'active', '2024-12-06 03:03:15', '2024-12-06 04:32:32'),
(4, 'Packet', 'active', '2024-12-06 04:15:10', '2024-12-06 04:15:10');

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `supplier_id` bigint(20) UNSIGNED DEFAULT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ppn` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(15,2) NOT NULL,
  `cash_paid` decimal(15,2) NOT NULL,
  `cash_return` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `user_id`, `supplier_id`, `discount`, `ppn`, `total_price`, `cash_paid`, `cash_return`, `created_at`, `updated_at`) VALUES
(3, 1, 4, 380000.00, 376200.00, 3796200.00, 3800000.00, 3800.00, '2025-03-06 15:12:26', '2025-03-06 15:12:26'),
(4, 1, 4, 570000.00, 564300.00, 5694300.00, 5800000.00, 105700.00, '2025-03-06 15:14:02', '2025-03-06 15:14:02'),
(5, 1, 2, 121000.00, 119790.00, 1208790.00, 1210000.00, 1210.00, '2025-03-06 15:48:43', '2025-03-06 15:48:43'),
(6, 1, 1, 11000.00, 10890.00, 109890.00, 110000.00, 110.00, '2025-03-10 07:50:47', '2025-03-10 07:50:47'),
(7, 1, 2, 11000.00, 10890.00, 109890.00, 110000.00, 110.00, '2025-03-11 04:22:53', '2025-03-11 04:22:53'),
(8, 1, 2, 22000.00, 21780.00, 219780.00, 220000.00, 220.00, '2025-03-12 01:02:06', '2025-03-12 01:02:06'),
(9, 1, 2, 11000.00, 10890.00, 109890.00, 110000.00, 110.00, '2025-03-16 14:31:51', '2025-03-16 14:31:51'),
(12, 1, NULL, 0.00, 13750.00, 138750.00, 150000.00, 11250.00, '2025-03-17 23:10:10', '2025-03-17 23:10:10'),
(13, 1, NULL, 0.00, 24200.00, 244200.00, 250000.00, 5800.00, '2025-03-18 02:21:35', '2025-03-18 02:21:35');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_details`
--

CREATE TABLE `purchase_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `purchase_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL,
  `qty` int(11) NOT NULL,
  `sub_total` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_details`
--

INSERT INTO `purchase_details` (`id`, `purchase_id`, `product_id`, `purchase_price`, `qty`, `sub_total`, `created_at`, `updated_at`) VALUES
(2, 3, 9, 1900000.00, 2, 3800000.00, '2025-03-06 15:12:26', '2025-03-06 15:12:26'),
(3, 4, 9, 1900000.00, 3, 5700000.00, '2025-03-06 15:14:02', '2025-03-06 15:14:02'),
(4, 5, 8, 110000.00, 11, 1210000.00, '2025-03-06 15:48:43', '2025-03-06 15:48:43'),
(5, 6, 4, 55000.00, 2, 110000.00, '2025-03-10 07:50:47', '2025-03-10 07:50:47'),
(6, 7, 4, 55000.00, 2, 110000.00, '2025-03-11 04:22:53', '2025-03-11 04:22:53'),
(7, 8, 8, 110000.00, 2, 220000.00, '2025-03-12 01:02:06', '2025-03-12 01:02:06'),
(8, 9, 8, 110000.00, 1, 110000.00, '2025-03-16 14:31:51', '2025-03-16 14:31:51'),
(11, 12, 5, 125000.00, 1, 125000.00, '2025-03-17 23:10:10', '2025-03-17 23:10:10'),
(12, 13, 8, 110000.00, 2, 220000.00, '2025-03-18 02:21:35', '2025-03-18 02:21:35');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(2, 'admin', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(3, 'officer', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19'),
(4, 'warehouse admin', 'web', '2024-12-09 21:15:19', '2024-12-09 21:15:19');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2),
(8, 1),
(8, 2),
(9, 1),
(9, 2),
(10, 1),
(10, 2),
(11, 1),
(11, 2),
(12, 1),
(12, 2),
(13, 1),
(13, 2),
(13, 3),
(14, 1),
(14, 2),
(15, 1),
(15, 2),
(16, 1),
(16, 2),
(16, 3),
(17, 1),
(17, 2),
(18, 1),
(19, 1),
(20, 1),
(20, 2),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(25, 2),
(25, 4),
(26, 1),
(26, 2),
(27, 1),
(27, 2),
(28, 1),
(28, 2),
(28, 4),
(29, 1),
(29, 2),
(29, 3),
(30, 1),
(30, 2),
(31, 1),
(31, 2),
(32, 1),
(32, 2),
(32, 4),
(33, 1),
(33, 2),
(34, 1),
(34, 2),
(35, 1),
(35, 2),
(36, 1),
(36, 2),
(37, 1),
(37, 2),
(38, 1),
(38, 2),
(39, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `ppn` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL,
  `cash_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cash_return` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `user_id`, `customer_id`, `discount`, `ppn`, `total_price`, `cash_paid`, `cash_return`, `created_at`, `updated_at`) VALUES
(14, 1, 10, 292000.00, 289080.00, 2917080.00, 3000000.00, 82920.00, '2025-03-06 15:53:29', '2025-03-06 15:53:29'),
(15, 1, 11, 34500.00, 34155.00, 344655.00, 350000.00, 5345.00, '2025-03-09 13:04:53', '2025-03-09 13:04:53'),
(16, 1, 8, 6000.00, 5940.00, 59940.00, 60000.00, 60.00, '2025-03-10 07:51:29', '2025-03-10 07:51:29'),
(17, 1, 2, 6000.00, 5940.00, 59940.00, 60000.00, 60.00, '2025-03-10 19:00:24', '2025-03-10 19:00:24'),
(21, 1, 11, 412000.00, 407880.00, 4115880.00, 4200000.00, 84120.00, '2025-03-14 15:49:31', '2025-03-14 15:49:31'),
(22, 1, NULL, 0.00, 12650.00, 127650.00, 130000.00, 2350.00, '2025-03-16 13:22:00', '2025-03-16 13:22:00'),
(23, 1, 2, 11500.00, 11385.00, 114885.00, 115000.00, 115.00, '2025-03-16 13:30:41', '2025-03-16 13:30:41'),
(24, 1, NULL, 0.00, 440000.00, 4440000.00, 4500000.00, 60000.00, '2025-03-16 15:00:40', '2025-03-16 15:00:40'),
(25, 1, NULL, 0.00, 14300.00, 144300.00, 150000.00, 5700.00, '2025-03-17 23:11:07', '2025-03-17 23:11:07'),
(28, 1, NULL, 0.00, 13640.00, 137640.00, 150000.00, 12360.00, '2025-03-19 14:46:04', '2025-03-19 14:46:04');

-- --------------------------------------------------------

--
-- Table structure for table `sales_details`
--

CREATE TABLE `sales_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sales_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `before_discount` decimal(10,2) DEFAULT NULL,
  `discount_product` int(20) DEFAULT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `qty` int(11) NOT NULL,
  `sub_total` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales_details`
--

INSERT INTO `sales_details` (`id`, `sales_id`, `product_id`, `before_discount`, `discount_product`, `selling_price`, `qty`, `sub_total`, `created_at`, `updated_at`) VALUES
(19, 14, 8, NULL, NULL, 115000.00, 8, 920000.00, '2025-03-06 15:53:29', '2025-03-06 15:53:29'),
(20, 14, 9, NULL, NULL, 2000000.00, 1, 2000000.00, '2025-03-06 15:53:29', '2025-03-06 15:53:29'),
(21, 15, 8, NULL, NULL, 115000.00, 3, 345000.00, '2025-03-09 13:04:53', '2025-03-09 13:04:53'),
(22, 16, 4, NULL, NULL, 60000.00, 1, 60000.00, '2025-03-10 07:51:29', '2025-03-10 07:51:29'),
(23, 17, 4, NULL, NULL, 60000.00, 1, 60000.00, '2025-03-10 19:00:24', '2025-03-10 19:00:24'),
(27, 21, 4, NULL, NULL, 60000.00, 2, 120000.00, '2025-03-14 15:49:31', '2025-03-14 15:49:31'),
(28, 21, 9, NULL, NULL, 2000000.00, 2, 4000000.00, '2025-03-14 15:49:31', '2025-03-14 15:49:31'),
(29, 22, 8, NULL, NULL, 115000.00, 1, 115000.00, '2025-03-16 13:22:00', '2025-03-16 13:22:00'),
(30, 23, 8, NULL, NULL, 115000.00, 1, 115000.00, '2025-03-16 13:30:41', '2025-03-16 13:30:41'),
(31, 24, 9, NULL, NULL, 2000000.00, 2, 4000000.00, '2025-03-16 15:00:40', '2025-03-16 15:00:40'),
(32, 25, 5, NULL, NULL, 130000.00, 1, 130000.00, '2025-03-17 23:11:07', '2025-03-17 23:11:07'),
(37, 28, 8, 115000.00, 0, 115000.00, 1, 115000.00, '2025-03-19 14:46:04', '2025-03-19 14:46:04');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `site_name` varchar(255) NOT NULL,
  `site_logo` varchar(255) DEFAULT NULL,
  `favicon` varchar(255) DEFAULT NULL,
  `site_title` varchar(255) DEFAULT NULL,
  `receipt_header` text DEFAULT NULL,
  `receipt_footer` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `site_name`, `site_logo`, `favicon`, `site_title`, `receipt_header`, `receipt_footer`, `created_at`, `updated_at`) VALUES
(1, 'Cashierngl 24/7', 'settings/3q13npzApx6ySWJIaHVxHUPz7DOX5NhCYSqr6uZq.png', 'settings/CH1SvvzCAEqMB7dEAUNICyCbYtqnrU4Ia6UZ8ecj.png', 'Cashierngl 24/7', '<br>We appreciate your visit! Here is your receipt for today\'s purchase. Have a great day!', 'Thank you for shopping with us! We look forward to serving you again.', '2025-03-11 08:15:32', '2025-06-30 18:58:09');

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `stock_in` int(11) NOT NULL,
  `stock_out` int(11) NOT NULL,
  `current_stock` int(11) NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `product_id`, `stock_in`, `stock_out`, `current_stock`, `source`, `created_at`, `updated_at`) VALUES
(1, 9, 2, 0, 2, 'purchase', '2025-03-06 15:12:26', '2025-03-06 15:12:26'),
(3, 9, 0, 4, 1, 'sale', '2025-03-06 15:38:49', '2025-03-06 15:38:49'),
(4, 8, 11, 0, 11, 'purchase', '2025-03-06 15:48:43', '2025-03-06 15:48:43'),
(5, 8, 0, 8, 3, 'sale', '2025-03-06 15:53:29', '2025-03-06 15:53:29'),
(6, 9, 0, 1, 0, 'sale', '2025-03-06 15:53:29', '2025-03-06 15:53:29'),
(7, 8, 0, 3, 0, 'sale', '2025-03-09 13:04:53', '2025-03-09 13:04:53'),
(8, 4, 2, 0, 2, 'purchase', '2025-03-10 07:50:47', '2025-03-10 07:50:47'),
(9, 4, 0, 1, 1, 'sale', '2025-03-10 07:51:29', '2025-03-10 07:51:29'),
(10, 4, 0, 1, 0, 'sale', '2025-03-10 19:00:24', '2025-03-10 19:00:24'),
(11, 4, 2, 0, 2, 'purchase', '2025-03-11 04:22:53', '2025-03-11 04:22:53'),
(12, 4, 0, 1, 1, 'sale', '2025-03-11 04:27:27', '2025-03-11 04:27:27'),
(13, 8, 2, 0, 2, 'purchase', '2025-03-12 01:02:06', '2025-03-12 01:02:06'),
(14, 8, 0, 1, 1, 'sale', '2025-03-12 01:03:36', '2025-03-12 01:03:36'),
(15, 8, 0, 1, 0, 'sale', '2025-03-12 04:00:57', '2025-03-12 04:00:57'),
(16, 4, 0, 2, 0, 'sale', '2025-03-14 15:49:31', '2025-03-14 15:49:31'),
(17, 9, 0, 2, 2, 'sale', '2025-03-14 15:49:31', '2025-03-14 15:49:31'),
(18, 8, 0, 1, 1, 'sale', '2025-03-16 13:22:00', '2025-03-16 13:22:00'),
(19, 8, 0, 1, 0, 'sale', '2025-03-16 13:30:41', '2025-03-16 13:30:41'),
(20, 8, 1, 0, 1, 'purchase', '2025-03-16 14:31:51', '2025-03-16 14:31:51'),
(21, 9, 0, 2, 0, 'sale', '2025-03-16 15:00:40', '2025-03-16 15:00:40'),
(22, 5, 2, 0, 2, 'purchase', '2025-03-17 22:40:12', '2025-03-17 22:40:12'),
(23, 5, 1, 0, 3, 'purchase', '2025-03-17 23:01:04', '2025-03-17 23:01:04'),
(24, 5, 1, 0, 2, 'purchase', '2025-03-17 23:10:10', '2025-03-17 23:10:10'),
(25, 5, 0, 1, 1, 'sale', '2025-03-17 23:11:07', '2025-03-17 23:11:07'),
(26, 8, 0, 1, 0, 'sale', '2025-03-18 02:18:33', '2025-03-18 02:18:33'),
(27, 8, 2, 0, 2, 'purchase', '2025-03-18 02:21:35', '2025-03-18 02:21:35'),
(29, 9, 3, 0, 5, 'purchase', '2025-03-19 00:48:24', '2025-03-19 00:48:24'),
(30, 9, 0, 4, 0, 'sale', '2025-03-19 00:51:42', '2025-03-19 00:51:42'),
(31, 9, 1, 0, 0, 'purchase', '2025-03-19 01:04:03', '2025-03-19 01:04:03'),
(32, 9, 1, 0, 1, 'purchase', '2025-03-19 01:14:10', '2025-03-19 01:14:10'),
(33, 9, 0, 1, 0, 'sale', '2025-03-19 01:18:28', '2025-03-19 01:18:28'),
(34, 9, 1, 0, 0, 'purchase', '2025-03-19 01:32:28', '2025-03-19 01:32:28'),
(35, 9, 1, 0, 0, 'purchase', '2025-03-19 01:45:04', '2025-03-19 01:45:04'),
(36, 9, 3, 0, 3, 'purchase', '2025-03-19 02:05:08', '2025-03-19 02:05:08'),
(37, 9, 1, 0, 3, 'sale', '2025-03-19 03:48:02', '2025-03-19 03:48:02'),
(39, 5, 0, 1, 0, 'sale', '2025-03-19 05:43:48', '2025-03-19 05:43:48'),
(43, 8, 0, 1, 1, 'sale', '2025-03-19 14:46:04', '2025-03-19 14:46:04');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `address`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'PT. BUNGA CEKATAN', 'Jl. Magelang No.KM.11, Dukuh, Tridadi, Kec. Sleman, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55511s', '62884734590872', '2025-02-13 02:30:40', '2025-02-13 02:35:05'),
(2, 'PT. GRAHA NUGRAHA', 'Jl. Danau Bogor Raya No.33, RT.01/RW.07, Tanah Baru, Kec. Bogor Utara, Kota Bogor, Jawa Barat 16144', '6286379786578', '2025-02-13 02:34:44', '2025-02-13 02:34:44'),
(4, 'PT. PLASTIK', 'Jl. Raya serang Km. 12,5 Desa Bitung Jaya, \nKecamatan Cikupa, Tangerang', '6287736282908', '2025-03-06 08:08:28', '2025-03-06 14:42:22');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `user_priv` enum('superadmin','admin','officer','warehouse admin') DEFAULT NULL,
  `address` text NOT NULL,
  `phone` varchar(15) NOT NULL,
  `status` varchar(11) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `user_priv`, `address`, `phone`, `status`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'angel', 'angelylv7@gmail.com', NULL, '$2y$10$NoEjVX3OuYRgKh2fmR8Bc.y6UjE6vTCh6GYwntU70Jvjm6kkIE4Re', 'superadmin', 'France', '086534567890', 'active', 'fwUezrnEDUMhbFvk4FpHAcmuWGY6eaBoEfdRWuUksX6krEdmnXiMU85C4GjK', '2024-12-01 18:49:48', '2025-03-16 18:44:05'),
(3, 'cashier', 'cashier7@gmail.com', NULL, '$2y$10$MvKLS/fo8Uc46f1J9TtGLuis3OEZjggF/rE1dGh1SqxO.tXkW.zVy', 'officer', 'Ukrain', '088973623212', 'active', 'jheKZLPgyFS2aJHJgldH5gm83GfK5xOFpl7XgpQtzcVGw2wwih5bT0fizfCI', '2024-12-07 06:12:06', '2025-06-30 18:42:32'),
(4, 'admin', 'admin7@gmail.com', NULL, '$2y$10$0SsO44Uj2ylfdVhm7K.jr.mug1AHtUyPv.Qi6KYVlvOTZg2VfNVDK', 'admin', 'Egypt', '098654578990', 'active', 't8ZrtsQsKTMgqQkOuC36DuLPaZV1CdNB72grQyAYXt2pHVnZBuGFxP38zbLN', '2024-12-07 08:26:38', '2025-06-30 18:41:59'),
(7, 'storage', 'storage7@gmail.com', NULL, '$2y$10$/iUcSLggEflU2f.LhdO4WuJSFxK7qO/S.JepWsPRA91BWdu309dKS', 'warehouse admin', 'Itali', '68273635611', 'active', 'y5hKJfX9OuqgC1ZkedQQrxIZGM8xESCEgQ1o9xtluMwMdLB9Bj4AeewBqsjl', '2025-03-12 16:12:35', '2025-06-30 18:42:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_logs`
--
ALTER TABLE `product_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id` (`product_id`,`category_id`);

--
-- Indexes for table `product_units`
--
ALTER TABLE `product_units`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchases_user_id_foreign` (`user_id`),
  ADD KEY `purchases_supplier_id_foreign` (`supplier_id`);

--
-- Indexes for table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_details_purchase_id_foreign` (`purchase_id`),
  ADD KEY `purchase_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_user_id_foreign` (`user_id`),
  ADD KEY `sales_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `sales_details`
--
ALTER TABLE `sales_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_details_sales_id_foreign` (`sales_id`),
  ADD KEY `sales_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stocks_product_id_foreign` (`product_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_logs`
--
ALTER TABLE `product_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `product_units`
--
ALTER TABLE `product_units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purchase_details`
--
ALTER TABLE `purchase_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `sales_details`
--
ALTER TABLE `sales_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchases_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD CONSTRAINT `purchase_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_details_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sales_details`
--
ALTER TABLE `sales_details`
  ADD CONSTRAINT `sales_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_details_sales_id_foreign` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

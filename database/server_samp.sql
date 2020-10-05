-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 05, 2020 at 04:27 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `server_samp`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_exp_skill` (`x_id_user` BIGINT, `x_id_skill` BIGINT, `x_jumlah_exp` INT)  BEGIN
	SELECT id INTO @id_user_skill FROM `user_skill` WHERE `id_skill` = `x_id_skill` AND `id_user` = `x_id_user`;
	IF(ROW_COUNT()) THEN
		UPDATE `user_skill` SET `exp` = `exp` + `x_jumlah_exp` WHERE `id` = @id_user_skill;
	ELSE
		INSERT INTO `user_skill`(id_skill, id_user, exp) VALUES(`x_id_skill`, `x_id_user`, `x_jumlah_exp`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_furniture` (`x_id_user` BIGINT, `x_id_furniture` BIGINT, `x_jumlah` INT)  BEGIN
	SELECT jumlah, id INTO @jumlah, @id_user_furniture FROM `user_furniture` WHERE `id_furniture` = `x_id_furniture` AND `id_user` = `x_id_user`;
	IF(ROW_COUNT()) THEN
		IF(x_jumlah < 0 AND (@jumlah - x_jumlah) < 1) THEN
			DELETE FROM `user_furniture` WHERE `id` = @id_user_furniture;
		ELSE
			UPDATE `user_furniture` SET `jumlah` = `jumlah` + `x_jumlah` WHERE `id` = @id_user_furniture;
		END IF;
	ELSE
		INSERT INTO `user_furniture`(id_furniture, id_user, jumlah) VALUES(`x_id_furniture`, `x_id_user`, `x_jumlah`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_item` (`x_id_user` BIGINT, `x_id_item` INT, `x_banyak_item` INT)  BEGIN
	SELECT jumlah, id_user_item INTO @jumlah, @id_user_item FROM `user_item` WHERE `id_item` = `x_id_item` AND `id_user` = `x_id_user`;
	IF(ROW_COUNT()) THEN
		IF(x_banyak_item < 0 AND (@jumlah - x_banyak_item) < 1) THEN
			DELETE FROM `user_item` WHERE `id_user_item` = @id_user_item;
		ELSE
			UPDATE `user_item` SET `jumlah` = `jumlah` + `x_banyak_item` WHERE `id_user_item` = @id_user_item;
		END IF;
	ELSE
		INSERT INTO `user_item`(id_item, id_user, jumlah) VALUES(`x_id_item`, `x_id_user`, `x_banyak_item`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_item_house` (`x_id_house` INT, `x_id_item` INT, `x_jumlah` INT)  BEGIN
	SELECT jumlah, id INTO @jumlah, @id_house_item FROM `house_inv_item` WHERE `id_item` = `x_id_item` AND `id_house` = `x_id_house`;
	IF(ROW_COUNT()) THEN
		IF(x_jumlah < 0 AND (@jumlah - x_jumlah) < 1) THEN
			DELETE FROM `house_inv_item` WHERE `id` = @id_house_item;
		ELSE
			UPDATE `house_inv_item` SET `jumlah` = `jumlah` + `x_jumlah` WHERE `id` = @id_house_item;
		END IF;
	ELSE
		INSERT INTO `house_inv_item`(id_item, id_house, jumlah) VALUES(`x_id_item`, `x_id_house`, `x_jumlah`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_item_vehicle` (`x_id_vehicle` INT, `x_id_item` INT, `x_jumlah` INT)  BEGIN
	SELECT jumlah, id INTO @jumlah, @id_item_vehicle FROM `vehicle_item` WHERE `id_item` = `x_id_item` AND `id_vehicle` = `x_id_vehicle`;
	IF(ROW_COUNT()) THEN
		IF(x_jumlah < 0 AND (@jumlah + x_jumlah) < 1) THEN
			DELETE FROM `vehicle_item` WHERE `id` = @id_item_vehicle;
		ELSE
			UPDATE `vehicle_item` SET `jumlah` = `jumlah` + `x_jumlah` WHERE `id` = @id_item_vehicle;
		END IF;
	ELSE
		INSERT INTO `vehicle_item`(id_item, id_vehicle, jumlah) VALUES(`x_id_item`, `x_id_vehicle`, `x_jumlah`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_skin` (`x_id_user` BIGINT, `x_id_skin` INT, `x_banyak_skin` INT)  BEGIN
	SELECT jumlah, id INTO @jumlah, @id FROM `user_skin` WHERE `id_skin` = `x_id_skin` AND `id_user` = `x_id_user`;
	IF(ROW_COUNT()) THEN
		IF(x_banyak_skin < 0 AND (@jumlah - x_banyak_skin) < 1) THEN
			DELETE FROM `user_skin` WHERE `id` = @id;
		ELSE
			UPDATE `user_skin` SET `jumlah` = `jumlah` + `x_banyak_skin` WHERE `id` = @id;
		END IF;
	ELSE
		INSERT INTO `user_skin`(id_skin, id_user, jumlah) VALUES(`x_id_skin`, `x_id_user`, `x_banyak_skin`); 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_transaksi_atm` (`rekening_pengirim` VARCHAR(50), `rekening_penerima` VARCHAR(50), `ex_nominal` BIGINT, `ex_keterangan` TEXT)  BEGIN
	INSERT INTO `trans_atm`(id_user, id_pengirim_penerima, nominal, tanggal, keterangan) 
	SELECT a.id as id_user, b.id as id_pengirim_penerima, ex_nominal as nominal, NOW() as tanggal, ex_keterangan as keterangan FROM `user` a
	LEFT JOIN `user` b ON b.rekening = rekening_pengirim WHERE a.rekening = rekening_penerima;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetIDMarketplace` () RETURNS INT(11) BEGIN
	DECLARE TEMP_ID INT DEFAULT 1;
	SELECT IFNULL(MAX(id), 1) INTO TEMP_ID FROM marketplace;
	RETURN TEMP_ID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `enter_exit`
--

CREATE TABLE `enter_exit` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `posisi_x` float NOT NULL,
  `posisi_y` float NOT NULL,
  `posisi_z` float NOT NULL,
  `posisi_int` int(11) NOT NULL,
  `posisi_vw` int(11) NOT NULL,
  `spawn_x` float NOT NULL,
  `spawn_y` float NOT NULL,
  `spawn_z` float NOT NULL,
  `spawn_int` int(11) NOT NULL,
  `spawn_vw` int(11) NOT NULL,
  `text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `faction`
--

CREATE TABLE `faction` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `nama_faction` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `faction`
--

INSERT INTO `faction` (`id`, `nama_faction`) VALUES
(1, 'Departemen Polisi'),
(2, 'Departemen Medis'),
(3, 'Departemen Pemerintah');

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_furniture` varchar(255) NOT NULL,
  `id_object` bigint(20) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `kapasitas` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `furniture`
--

INSERT INTO `furniture` (`id`, `nama_furniture`, `id_object`, `keterangan`, `kapasitas`) VALUES
(1, 'Meja I', 2115, 'Meja biasa', 1),
(2, 'Kasur Besar I', 11720, 'Kasur besar untuk tidur', 1);

-- --------------------------------------------------------

--
-- Table structure for table `gaji`
--

CREATE TABLE `gaji` (
  `id_gaji` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `nominal` bigint(50) NOT NULL,
  `tanggal` datetime NOT NULL,
  `keterangan` varchar(50) DEFAULT NULL COMMENT 'Berisi keterangan asal gaji',
  `status` smallint(1) NOT NULL DEFAULT 0 COMMENT 'Berisi status apakah sudah diambil atau belum.\r\n0 - Belum diambil\r\n1 - Sudah diambil'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `gaji`
--

INSERT INTO `gaji` (`id_gaji`, `id_user`, `nominal`, `tanggal`, `keterangan`, `status`) VALUES
(1, 22, 1000, '2020-05-23 14:24:15', NULL, 1),
(2, 22, 50, '2020-05-23 14:24:32', NULL, 1),
(3, 22, 100, '2020-05-26 13:09:48', NULL, 1),
(4, 36, 50, '2020-09-16 11:48:23', 'Truk Sampah (Trashmaster)', 1),
(5, 36, 40, '2020-09-16 14:37:19', 'Pengantar Pizza (Pizzaboy)', 0),
(6, 36, 30, '2020-09-16 15:46:07', 'Pembersih jalan (sweeper)', 0),
(7, 39, 30, '2020-09-27 18:49:08', 'Pembersih jalan (sweeper)', 0),
(8, 50, 30, '2020-09-28 03:22:27', 'Pembersih jalan (sweeper)', 0),
(9, 22, 300, '2020-10-03 17:23:45', 'gaji revive Naufl', 0),
(10, 36, 23, '2020-10-03 19:43:47', 'bonus menghancurkan ganja', 0),
(11, 36, 23, '2020-10-03 19:43:51', 'bonus menghancurkan ganja', 0);

-- --------------------------------------------------------

--
-- Table structure for table `house`
--

CREATE TABLE `house` (
  `id_house` int(20) NOT NULL,
  `id_user` int(20) NOT NULL DEFAULT -1,
  `level` int(11) NOT NULL DEFAULT 1,
  `harga` int(20) NOT NULL,
  `setharga` int(20) NOT NULL DEFAULT 0,
  `kunci` int(11) NOT NULL DEFAULT 1,
  `jual` int(11) NOT NULL DEFAULT 1,
  `icon_x` varchar(255) NOT NULL,
  `icon_y` varchar(255) NOT NULL,
  `icon_z` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `house`
--

INSERT INTO `house` (`id_house`, `id_user`, `level`, `harga`, `setharga`, `kunci`, `jual`, `icon_x`, `icon_y`, `icon_z`) VALUES
(6, -1, 3, 999999, 0, 1, 1, '2352.013184', '-1412.265625', '23.992413'),
(8, -1, 1, 15000, 0, 1, 1, '1854.006104', '-1914.264160', '15.256798'),
(9, -1, 1, 15000, 0, 1, 1, '1872.121826', '-1911.799316', '15.256798'),
(10, -1, 1, 15000, 0, 1, 1, '1938.541382', '-1911.309082', '15.256798'),
(11, -1, 1, 15000, 0, 1, 1, '1928.684326', '-1915.902710', '15.256798'),
(12, -1, 1, 15000, 0, 1, 1, '1891.978149', '-1914.507080', '15.256798'),
(13, -1, 1, 15000, 0, 1, 1, '1913.432251', '-1911.908936', '15.256798'),
(14, -1, 1, 13000, 0, 1, 1, '2016.201172', '-1716.995728', '14.125000'),
(15, -1, 1, 13000, 0, 1, 1, '2018.239014', '-1703.208618', '14.234375'),
(16, -1, 1, 13000, 0, 1, 1, '2015.348755', '-1732.601074', '14.234375'),
(17, -1, 1, 17000, 0, 1, 1, '1980.376465', '-1718.900146', '17.030275'),
(18, -1, 1, 17000, 0, 1, 1, '1980.992310', '-1682.856567', '17.053755'),
(19, -1, 1, 13000, 0, 1, 1, '2018.052490', '-1629.879028', '14.042566'),
(20, -1, 1, 13000, 0, 1, 1, '2016.536377', '-1641.569580', '14.112879'),
(22, -1, 1, 13000, 0, 1, 1, '2013.577271', '-1656.461548', '14.136316'),
(23, -1, 1, 13000, 0, 1, 1, '2066.787109', '-1656.404785', '14.132812'),
(24, -1, 1, 13000, 0, 1, 1, '2067.571045', '-1643.662598', '14.136316'),
(25, -1, 1, 13000, 0, 1, 1, '2067.729248', '-1628.835083', '14.206629'),
(26, -1, 1, 17000, 0, 1, 1, '2065.101807', '-1703.389648', '14.148438'),
(27, -1, 1, 13000, 0, 1, 1, '2066.385254', '-1717.131592', '14.136316'),
(28, -1, 1, 13000, 0, 1, 1, '2067.049561', '-1731.513550', '14.206629'),
(29, -1, 1, 30000, 0, 1, 1, '2495.338623', '-1691.134399', '14.765625'),
(30, -1, 1, 20000, 0, 1, 1, '2459.354248', '-1691.484009', '13.547171'),
(31, -1, 1, 13000, 0, 1, 1, '2469.657715', '-1646.349121', '13.780097'),
(32, -1, 1, 15000, 0, 1, 1, '2486.401855', '-1644.533813', '14.077179'),
(34, -1, 1, 13000, 0, 1, 1, '2498.692871', '-1642.258789', '14.113083'),
(35, -1, 1, 13000, 0, 1, 1, '2513.795410', '-1650.327393', '14.355666'),
(36, -1, 1, 13000, 0, 1, 1, '2524.700928', '-1658.717651', '15.824020'),
(37, -1, 1, 13000, 0, 1, 1, '2523.271484', '-1679.268921', '15.497000'),
(38, -1, 1, 13000, 0, 1, 1, '2514.364990', '-1691.561890', '14.046039'),
(40, -1, 1, 13000, 0, 1, 1, '2409.049561', '-1674.932617', '14.375000'),
(41, -1, 1, 13000, 0, 1, 1, '2413.678223', '-1646.798706', '14.011916'),
(42, -1, 1, 13000, 0, 1, 1, '2393.144775', '-1646.045044', '13.905097'),
(43, -1, 1, 13000, 0, 1, 1, '2384.646729', '-1675.836792', '15.245691'),
(44, -1, 1, 13000, 0, 1, 1, '2362.780762', '-1643.142578', '14.351562'),
(45, -1, 1, 13000, 0, 1, 1, '2368.360107', '-1675.301270', '14.168166'),
(46, -1, 1, 13000, 0, 1, 1, '2451.658936', '-1641.411743', '14.066208'),
(47, -1, 1, 15000, 0, 1, 1, '769.212708', '-1696.615967', '5.155420'),
(48, -1, 1, 15000, 0, 1, 1, '768.078491', '-1655.843628', '5.609375'),
(49, -1, 1, 17000, 0, 1, 1, '692.638489', '-1602.757202', '15.046875'),
(50, -1, 1, 15000, 0, 1, 1, '697.279602', '-1627.024048', '3.749170'),
(51, -1, 1, 17000, 0, 1, 1, '693.755737', '-1645.808960', '4.093750'),
(52, -1, 1, 17000, 0, 1, 1, '657.217529', '-1652.506104', '15.406250'),
(53, -1, 1, 15000, 0, 1, 1, '656.079346', '-1635.865112', '15.861748'),
(54, -1, 1, 15000, 0, 1, 1, '693.547668', '-1705.741333', '3.819483'),
(55, -1, 1, 17000, 0, 1, 1, '766.912415', '-1605.751099', '13.803858'),
(56, -1, 1, 30000, 0, 1, 1, '965.372498', '-1612.607056', '14.940853'),
(57, -1, 1, 30000, 0, 1, 1, '936.779846', '-1612.760254', '14.938278'),
(58, -1, 1, 30000, 0, 1, 1, '893.867188', '-1635.697998', '14.929688'),
(59, -1, 1, 30000, 0, 1, 1, '865.249268', '-1633.846558', '14.929688'),
(60, -1, 1, 25000, 0, 1, 1, '900.745422', '-1473.080322', '14.281717'),
(61, -1, 1, 25000, 0, 1, 1, '900.546570', '-1447.489624', '14.369725'),
(62, -1, 1, 25000, 0, 1, 1, '841.157471', '-1471.351318', '14.312389'),
(63, -1, 1, 25000, 0, 1, 1, '813.686462', '-1456.524780', '14.216631'),
(64, -1, 1, 25000, 0, 1, 1, '822.291809', '-1505.508179', '14.397955'),
(65, -1, 1, 25000, 0, 1, 1, '849.946533', '-1519.906006', '14.352840'),
(66, -1, 1, 25000, 0, 1, 1, '875.975586', '-1514.928345', '14.339621');

-- --------------------------------------------------------

--
-- Table structure for table `house_furniture`
--

CREATE TABLE `house_furniture` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_house` bigint(20) NOT NULL,
  `id_furniture` bigint(20) NOT NULL,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `rot_x` float DEFAULT 0,
  `rot_y` float DEFAULT 0,
  `rot_z` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `house_furniture`
--

INSERT INTO `house_furniture` (`id`, `id_house`, `id_furniture`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`) VALUES
(1, 2, 2, 1269.9, -776.13, 1090.9, 0, 0, 0),
(4, 2, 1, 1283.86, -780.705, 1088.75, -1.40001, -0.9, -170.9);

-- --------------------------------------------------------

--
-- Table structure for table `house_interior`
--

CREATE TABLE `house_interior` (
  `id_level` int(10) UNSIGNED NOT NULL,
  `nama_level` varchar(255) NOT NULL,
  `pickup_out_x` float NOT NULL,
  `pickup_out_y` float NOT NULL,
  `pickup_out_z` float NOT NULL,
  `spawn_in_x` float NOT NULL,
  `spawn_in_y` float NOT NULL,
  `spawn_in_z` float NOT NULL,
  `spawn_in_a` float NOT NULL,
  `spawn_in_interior` int(10) NOT NULL,
  `limit_item` int(10) NOT NULL COMMENT 'Limit item yang didapat di simpan pada rumah'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `house_interior`
--

INSERT INTO `house_interior` (`id_level`, `nama_level`, `pickup_out_x`, `pickup_out_y`, `pickup_out_z`, `spawn_in_x`, `spawn_in_y`, `spawn_in_z`, `spawn_in_a`, `spawn_in_interior`, `limit_item`) VALUES
(1, 'Rumah Kecil I', 223.2, 1287.08, 1082.14, 223.253, 1288.57, 1082.13, 357.976, 1, 50),
(2, 'Rumah Kecil II', 328.05, 1477.73, 1084.44, 328.666, 1481.18, 1084.44, 355.848, 15, 100),
(3, 'Rumah Medium I', 377.15, 1417.41, 1081.33, 373.995, 1417.33, 1081.33, 87.4219, 15, 150),
(4, 'Rumah Medium II', 260.85, 1237.24, 1084.26, 260.985, 1240.1, 1084.26, 356.931, 9, 200),
(5, 'Rumah Besar I', 2324.53, -1149.54, 1050.71, 2324.36, -1146.56, 1050.71, 357.809, 12, 250),
(6, 'Rumah Besar II', 2317.89, -1026.76, 1050.22, 2320.36, -1024.11, 1050.21, 1.2377, 9, 300),
(7, 'Rumah Mansion I', 234.19, 1063.73, 1084.21, 234.253, 1067.19, 1084.21, 358.955, 6, 350),
(8, 'Rumah Mansion II', 1260.64, -785.37, 1091.91, 1265.12, -782.524, 1091.91, 282.015, 5, 400);

-- --------------------------------------------------------

--
-- Table structure for table `house_inv_item`
--

CREATE TABLE `house_inv_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) NOT NULL,
  `id_house` bigint(20) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `house_inv_item`
--

INSERT INTO `house_inv_item` (`id`, `id_item`, `id_house`, `jumlah`) VALUES
(1, 13, 2, 0),
(2, 10, 2, 0),
(3, 1, 2, 0),
(4, 9, 2, 0),
(5, 2, 2, 0),
(6, 4, 2, 0),
(7, 7, 2, 0),
(8, 5, 2, 0),
(9, 14, 2, 0),
(10, 11, 2, 0),
(11, 12, 2, 0),
(12, 6, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id_item` int(11) NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Berisi public function yang akan di trigger saat pemilihan use item, pada item tersebut.',
  `kapasitas` int(11) NOT NULL DEFAULT 1 COMMENT 'Berisi kapasistas yang dibutuhkan untuk satu barang',
  `id_rarity` tinyint(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`id_item`, `nama_item`, `model_id`, `keterangan`, `fungsi`, `kapasitas`, `id_rarity`) VALUES
(1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.', 'pakaiHpFromInven', 3, 3),
(2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.', 'pakaiHpFromInven', 3, 3),
(3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.', 'pakaiHpFromInven', 3, 3),
(4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.', 'pakaiHpFromInven', 3, 4),
(5, 'Pas Foto', 2281, 'Pas Foto untuk keperluan administrasi.', NULL, 1, 2),
(6, 'Materai', 2059, 'Materai untuk keperluan administrasi.', NULL, 1, 2),
(7, 'KTP', 1581, 'KTP sebagai identitas kewarganegaraan.', NULL, 2, 2),
(8, 'Palu Tambang', 19631, 'Palu Tambang digunakan untuk menambang, 1x use item ini = 15 kali kesempatan tambang.', 'pakaiPaluTambang', 3, 2),
(9, 'Emas', 19941, 'Emas adalah item yang langka, berguna untuk banyak hal dan memiliki nilai yang tinggi.', NULL, 4, 4),
(10, 'Berlian', 1559, 'Berlian adalah item yang sangat langka, berguna untuk membuat item-item langka dan dapat menghasilkan banyak uang.', NULL, 5, 5),
(11, 'Aluminium', 2936, 'Aluminium adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL, 2, 3),
(12, 'Perak', 16134, 'Perak adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1, 3),
(13, 'Air Minum Mineral', 2647, 'Air minum mineral dapat menambah status minum sebanyak 5', 'pakaiMinuman', 1, 1),
(14, 'Steak', 19882, 'Steak dapat menambah status makan sebanyak 50', 'pakaiMakanan', 2, 2),
(15, 'SIM A', 1581, 'SIM A sebagai identitas kelayakan mengendarai kendaraan berupa mobil pribadi.', NULL, 2, 2),
(16, 'Nasi Bungkus', 2678, 'Nasi bungkus dapat menambah status makan sebanyak 37,5', 'pakaiMakanan', 2, 1),
(17, 'Sate', 2858, 'Sate dapat menambah status makan sebanyak 30', 'pakaiMakanan', 2, 1),
(18, 'Jus Jeruk', 19564, 'Jus jeruk dapat menambah status minum sebanyak 25', 'pakaiMinuman', 1, 1),
(19, 'Es Teh Manis', 2647, 'Es Teh Manis dapat menambah status minum sebanyak 20', 'pakaiMinuman', 1, 1),
(20, 'Kopi Panas', 2647, 'Kopi Panas dapat menambah status minum sebanyak 35', 'pakaiMinuman', 1, 1),
(21, 'Kopi Dingin', 2647, 'Kopi Dingin dapat menambah status minum sebanyak 35', 'pakaiMinuman', 1, 1),
(22, 'Minuman Soda', 2647, 'Minuman Soda dapat menambah status minum sebanyak 30', 'pakaiMinuman', 1, 1),
(23, 'Roti', 19579, 'Roti dapat menambah status makan sebanyak 25', 'pakaiMakanan', 2, 1),
(24, 'Telur Dadar', 19580, 'Telur Dadar dapat menambah status makan sebanyak 12,5', 'pakaiMakanan', 2, 1),
(25, 'Kayu', 19793, 'Kayu adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1, 2),
(26, 'Gergaji Mesin', 341, 'Gergaji Mesin digunakan untuk memotong pohon.', 'pakaiGergajiMesin', 3, 2),
(27, 'Alat Perbaikan Kendaraan', 19921, 'Alat ini dapat digunakan untuk memperbaiki kendaraan anda, pemakaian alat tergantung kerusakan', NULL, 3, 3),
(28, 'Cat Kendaraan', 365, 'Bahan untuk mengecat kendaraan anda.', NULL, 2, 3),
(29, 'Spare-part Kendaraan', 1098, 'Sparepart kendaraan untuk modifikasi', NULL, 4, 4),
(30, 'Paintjob Stiker Kendaraan', 365, 'Bahan untuk mengganti paintjob dari kendaraan.', NULL, 5, 4),
(31, 'Bibit Jeruk', 756, 'Biji Jeruk adalah item pertanian yang dapat ditanam dan tumbuh menjadi Jeruk.', 'pakaiBibitJeruk', 9, 1),
(32, 'Jeruk', 19574, 'Jeruk adalah buah hasil panen dengan rasa masam yang segar.', NULL, 1, 2),
(33, 'Bibit Ganja', 756, 'Biji Ganja adalah bibit terlarang yang dapat ditanam dan tumbuh menjadi Ganja.', 'pakaiBibitGanja', 9, 1),
(34, 'Ganja', 19473, 'Ganja adalah item terlarang yang dapat menambahkan Darah Putih sebesar 5 persen.', 'pakaiNarkoGanja', 1, 2),
(35, 'Joran Pancing', 18632, 'Joran Pancing adalah peralatan untuk memancing ikan.', 'pakaiJoranPancing', 1, 1),
(36, 'Tombak Ikan', 11716, 'Tombak Ikan adalah peralatan untuk memancing ikan, tingkat keberuntungan +14 persen.', 'pakaiTombakIkan', 1, 1),
(37, 'Ikan Arwana', 1600, 'Ikan Arwana adalah ikan yang sangat langka, memiliki nilai yang sangat tinggi.', NULL, 1, 1),
(38, 'Ikan Kakap', 1604, 'Ikan Kakap adalah ikan yang langka, berguna untuk banyak hal.', NULL, 1, 1),
(39, 'Ikan Mas', 1599, 'Ikan Mas adalah hasil mancing yang mirip dengan Ikan Mujair tapi lebih bagus.', NULL, 1, 1),
(40, 'Ikan Mujair', 19630, 'Ikan Mujair adalah ikan yang berguna dan juga diminati orang banyak.', NULL, 1, 1),
(41, 'Ubur-ubur', 1603, 'Ubur-ubur adalah ikan yang bagus dan diminati.', NULL, 1, 1),
(42, 'Bintang Laut', 902, 'Bintang Laut adalah ikan yang bagus dan diminati.', NULL, 1, 1),
(43, 'Roti - Umpan Ikan', 19883, 'Roti - Umpan Ikan adalah umpan yang digunakan untuk memancing ikan.', NULL, 1, 1),
(44, 'Bensin 20 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 20 liter', 'pakaiBensin', 2, 2),
(45, 'Bensin 50 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 50 liter', 'pakaiBensin', 3, 2),
(46, 'Bensin 100 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 100 liter', 'pakaiBensin', 4, 2),
(47, 'SIM B', 1581, 'SIM B sebagai identitas kelayakan mengendarai kendaraan berupa mobil penumpang atau barang.', NULL, 1, 2),
(48, 'SIM C', 1581, 'SIM C sebagai identitas kelayakan mengendarai kendaraan berupa motor.', NULL, 2, 2),
(49, 'Helm', 18645, 'Helm digunakan saat mengendarai motor. Note: Saat menggunakan helm anda tidak dapat dikenali oleh orang.', 'pakaiHelm', 3, 3),
(50, 'Topeng', 19037, 'Topeng digunakan untuk menutup wajah anda sehingga tidak dikenali oleh orang.', 'pakaiHelm', 3, 3),
(51, 'Ultimate Parts', 3096, 'Bisa anda gunakan untuk ditukarkan dengan jenis part/paintjob/warna apapun', NULL, 5, 5),
(52, 'Bubuk Herbal', 863, 'Dapat digunakan untuk membuat obat herbal revive.', NULL, 2, 2),
(53, 'Obat Herbal Revive', 1240, 'Dapat digunakan untuk menyelematkan orang sekarat.', NULL, 3, 3),
(54, 'Medical Kit 50', 11738, 'Dapat digunakan untuk menambah darah sebanyak 50 persen.', NULL, 5, 3),
(55, 'Medical Kit 100', 11738, 'Dapat digunakan untuk menambah darah sebanyak 100 persen.', NULL, 7, 3),
(56, 'Pil Darah Merah 20', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 20 persen.', 'pakaiPilMerah', 2, 3),
(57, 'Pil Darah Merah 50', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 50 persen.', 'pakaiPilMerah', 3, 3),
(58, 'Pil Darah Merah 100', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 100 persen.', 'pakaiPilMerah', 4, 3),
(59, 'Pil Darah Putih 20', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 20 persen.', 'pakaiPilPutih', 4, 3),
(60, 'Pil Darah Putih 50', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 50 persen.', 'pakaiPilPutih', 4, 3),
(61, 'Pil Darah Putih 100', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 100 persen.', 'pakaiPilPutih', 4, 3),
(62, 'Forger Case', 2780, 'Bahan utama yang dibutuhkan untuk dapat memulai skill Blacksmith.', NULL, 5, 5),
(63, 'Bijih Besi', 3117, 'Bijih besi merupakan material untuk membuat besi utuh.', NULL, 1, 2),
(64, 'Besi', 3117, 'Besi digunakan oleh banyak item sebagai material baku.', NULL, 3, 2),
(65, 'Serbuk Emas', 19941, 'Serbuk emas merupakan material untuk membuat emas utuh.', NULL, 1, 3),
(66, 'Bijih Perak', 16134, 'Bahan dasar pembuat perak.', NULL, 1, 2),
(67, 'Serbuk Berlian', 1559, 'Bahan dasar pembuat berlian.', NULL, 1, 3),
(68, 'Bijih Aluminium', 2936, 'Bahan dasar pembuat aluminium.', NULL, 1, 2),
(69, 'Batu Bata', 11708, 'Bahan tambang yang berguna.', NULL, 1, 2),
(70, 'Batu Bara', 11708, 'Bahan tambang yang berguna.', NULL, 1, 2),
(71, 'Bibit Jahe', 756, 'Biji Jahe adalah item pertanian yang dapat ditanam dan tumbuh menjadi Jahe.', 'pakaiBibitJahe', 9, 1),
(72, 'Bibit Temulawak', 756, 'Biji Temulawak adalah item pertanian yang dapat ditanam dan tumbuh menjadi Temulawak.', 'pakaiBibitTemulawak', 9, 1),
(73, 'Bibit Alpukat', 756, 'Biji Alpukat adalah item pertanian yang dapat ditanam dan tumbuh menjadi Alpukat.', 'pakaiBibitAlpukat', 9, 1),
(74, 'Bibit Pepaya', 756, 'Biji Pepaya adalah item pertanian yang dapat ditanam dan tumbuh menjadi Pepaya.', 'pakaiBibitPepaya', 9, 1),
(75, 'Bibit Belimbing', 756, 'Biji Belimbing adalah item pertanian yang dapat ditanam dan tumbuh menjadi Belimbing.', 'pakaiBibitBelimbing', 9, 1),
(76, 'Bibit Srikaya', 756, 'Biji Srikaya adalah item pertanian yang dapat ditanam dan tumbuh menjadi Srikaya.', 'pakaiBibitSrikaya', 9, 1),
(77, 'Jahe', 18631, 'Jahe adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2),
(78, 'Temulawak', 18631, 'Temulawak adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2),
(79, 'Alpukat', 18631, 'Alpukat adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2),
(80, 'Pepaya', 18631, 'Pepaya adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2),
(81, 'Belimbing', 18631, 'Belimbing adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2),
(82, 'Srikaya', 18631, 'Srikaya adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `item_rarity`
--

CREATE TABLE `item_rarity` (
  `id` tinyint(2) UNSIGNED NOT NULL,
  `nama_rarity` varchar(50) NOT NULL,
  `hex_color` varchar(14) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `item_rarity`
--

INSERT INTO `item_rarity` (`id`, `nama_rarity`, `hex_color`) VALUES
(1, 'Uncommon', '{FFFFFF}'),
(2, 'Normal', '{00CC00}'),
(3, 'Rare', '{0099CC}'),
(4, 'Epic', '{6600FF}'),
(5, 'Legendary', '{FF9933}'),
(6, 'Event', '{CC99FF}'),
(7, 'Limited', '{FF0000}');

-- --------------------------------------------------------

--
-- Table structure for table `item_sp`
--

CREATE TABLE `item_sp` (
  `id` int(11) UNSIGNED NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Callback public function untuk dipanggil saat menggunakan item',
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `item_sp`
--

INSERT INTO `item_sp` (`id`, `nama_item`, `model_id`, `fungsi`, `keterangan`) VALUES
(1, 'KTP', 1581, NULL, 'KTP sebagai identitas kewarganegaraan.'),
(2, 'SIM A', 1581, NULL, 'SIM sebagai identitas kelayakan berkendara.');

-- --------------------------------------------------------

--
-- Table structure for table `jenis_blocked`
--

CREATE TABLE `jenis_blocked` (
  `id` tinyint(1) UNSIGNED NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `jenis_blocked`
--

INSERT INTO `jenis_blocked` (`id`, `nama`, `keterangan`) VALUES
(1, 'Dikunci Sementara', 'Tidak diperbolehkan login sampai waktu yang telah ditentukan'),
(2, 'Banned', 'Dibanned oleh admin');

-- --------------------------------------------------------

--
-- Table structure for table `logs_user_konek`
--

CREATE TABLE `logs_user_konek` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `ip` varchar(50) NOT NULL,
  `kota` varchar(255) NOT NULL,
  `negara` varchar(255) NOT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `lumber`
--

CREATE TABLE `lumber` (
  `id` bigint(20) NOT NULL,
  `treeX` float NOT NULL,
  `treeY` float NOT NULL,
  `treeZ` float NOT NULL,
  `treeRX` float NOT NULL,
  `treeRY` float NOT NULL,
  `treeRZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `lumber`
--

INSERT INTO `lumber` (`id`, `treeX`, `treeY`, `treeZ`, `treeRX`, `treeRY`, `treeRZ`) VALUES
(1, 809.142, -977.933, 34.2219, 0, 0, 0),
(2, 831.846, -962.424, 37.5376, 0, 0, 0),
(3, 2434.51, -545.28, 101.753, 0, 0, 0),
(4, 2444.4, -568.66, 105.001, 0, 0, 0),
(5, 2448.54, -563.895, 103.645, 0, 0, 0),
(6, 2441.38, -561.425, 103.8, 0, 0, 33.3),
(7, 2436.48, -568.44, 105.152, 0, 0, 51.6),
(8, 2436.86, -557.331, 103.637, 0, 0, 0),
(9, 2434.45, -562.086, 104.541, 0, 0, 0),
(10, 2427.2, -555.168, 103.853, 0, 0, 0),
(11, 2569.31, -480.666, 82.8293, 0, 0, 0),
(12, 2568.08, -476.824, 82.5701, 0, 0, 0),
(13, 2572.27, -480.022, 82.286, 0, 0, 0),
(14, 2571.3, -476.751, 82.1401, 0, 0, 0),
(15, 2574.84, -477.806, 81.7718, 0, 0, 0),
(16, 2466.98, -390.565, 69.7685, 0, 0, 0),
(17, 2463.29, -389.383, 69.1539, 0, 0, 0),
(18, 2459.11, -388.899, 68.6628, 0, 0, 0),
(19, 820.233, -970.304, 36.0263, 0, 0, 0),
(20, 824.575, -979.366, 35.1262, 0, 0, 0),
(21, 2620.75, -380.595, 61.1259, 0, 0, 0),
(22, 2628.89, -378.523, 59.1472, 0, 0, 0),
(23, 2627.08, -373.252, 59.4517, 0, 0, 0),
(24, 2629.24, -384.994, 59.0856, 0, 0, 0),
(25, 2637.59, -377.029, 57.6627, 0, 0, 0),
(26, 2673.87, -207.77, 32.5733, 0, 0, 0),
(27, 2670.77, -204.163, 33.0181, 0, 0, 0),
(28, 2675.05, -201.988, 32.7795, 0, 0, 0),
(29, 2672.47, -198.603, 33.1089, 0, 0, 0),
(30, 2512.99, -813.636, 89.7667, 0, 0, 0),
(31, 2520.83, -818.763, 89.0555, 0, 0, 0),
(32, 2515.36, -829.042, 89.0118, 0, 0, 0),
(33, 2524.73, -831.863, 88.0311, 0, 0, 0),
(34, 2536.09, -832.222, 87.0501, 0, 0, 0),
(35, 2525.19, -825.828, 88.0547, 0, 0, 0),
(36, 2533.43, -823.211, 87.4401, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `marketplace`
--

CREATE TABLE `marketplace` (
  `id` int(11) UNSIGNED NOT NULL,
  `id_item` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga` bigint(50) NOT NULL DEFAULT 0 COMMENT 'Harga keseluruhan',
  `tanggal` datetime DEFAULT NULL COMMENT 'Tanggal di post',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Status :\r\n\r\n0 - Sedang Dijual\r\n1 - Terbeli\r\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `marketplace`
--

INSERT INTO `marketplace` (`id`, `id_item`, `id_user`, `jumlah`, `harga`, `tanggal`, `status`) VALUES
(4, 12, 22, 5, 120, '2020-09-09 23:22:37', 1),
(6, 14, 34, 1, 100, '2020-09-09 23:26:22', 1),
(7, 26, 22, 3, 50, '2020-09-09 23:28:35', 0);

-- --------------------------------------------------------

--
-- Table structure for table `papan`
--

CREATE TABLE `papan` (
  `id_papan` bigint(20) UNSIGNED NOT NULL,
  `id_model` bigint(20) NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `text` text DEFAULT NULL,
  `font_size` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `papan`
--

INSERT INTO `papan` (`id_papan`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `text`, `font_size`) VALUES
(5, 19805, 1555.75, -1675.57, 18.8443, 0, 0, -86.4, '{000000}KANTOR POLISI\n METRO LOS SANTOS', 25),
(7, 19805, 1477.38, -1638.2, 19.2322, 0, 0, 0, '{000000}MARKETPLACE\n LOS SANTOS', 32),
(9, 19805, 1479.42, -1753.5, 14.3069, 0, 0, -177, '{000000}KANTOR PEMERINTAH\n LOS SANTOS', 24),
(10, 19805, 1023.32, -1892.35, 14.6691, 0, 0, 92.8, '{000000}JUAL ALAT DAN \n BAHAN PANCINGAN', 30),
(13, 19805, 1494.45, -1660.6, 15.3322, 0, 0, -178.3, '{000000}JUAL\n BIBIT TANAMAN', 24),
(14, 19805, 1720.3, -1741.97, 17.0828, 0, 0, -178.1, '{000000}SELAMAT DATANG\n DI BLACKSMITH', 24),
(15, 3077, 1641.23, -1551.18, 12.5048, 0, 0, -82.5, '{000000}SELAMAT DATANG DI\n KESATUAN PENGANGKUT SAMPAH\n METRO LOS SANTOS\n HARAP ANTRI DAN \n JANGAN MENYELANG ANTRIAN !', 17),
(21, 3077, 690.679, -1182.17, 19.7347, 0, 0, -119.4, '{000000}SELAMAT DATANG DI\n KESATUAN PEMBERSIH JALAN\n METRO LOS SANTOS\n HARAP ANTRI DAN JANGAN\n MENYELANG ANTRIAN !', 18),
(22, 3077, 1419.08, -1655.19, 12.5328, 0, 0, 89, '{000000}SELAMAT DATANG DI\n TEMPAT PRAKTEK UJIAN SIM\n KEPOLISIAN METRO\n LOS SANTOS', 20),
(23, 3077, 316.44, -1785.71, 3.6219, 0, 0, 0, '{000000}TEMPAT\nPENYEWAAN KENDARAAN\n (GRATIS)', 24),
(24, 3077, 1807.84, -1907.85, 12.5894, 0, 0, -88.6, '{000000}TEMPAT\nPENYEWAAN\nKENDARAAN\n(GRATIS)', 24),
(25, 3077, 1566.2, -2329.51, 12.6869, 0, 0, -92.2, '{000000}TEMPAT\n PENYEWAAN KENDARAAN\n (GRATIS)', 24),
(26, 3077, 2404.52, -647.511, 126.012, 0, 0, -92.6, '{000000}PENYEWAAN KENDARAAN\nKERJA GRATIS', 24),
(30, 3077, -399.925, 2450.68, 41.3827, 0, 0, -47.5, '{000000}TEMPAT TAMBANG\n<<<', 24),
(31, 3077, -395.823, 2286.54, 40.414, 0, 0, 0, '{000000}TEMPAT TAMBANG\n>>>', 24);

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_ktp`
--

CREATE TABLE `pengambilan_ktp` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime NOT NULL,
  `tanggal_ambil` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `pengambilan_ktp`
--

INSERT INTO `pengambilan_ktp` (`id`, `id_user`, `tanggal_buat`, `tanggal_ambil`) VALUES
(5, 40, '2020-09-26 21:08:43', '2020-09-27 21:08:43'),
(6, 43, '2020-09-27 02:41:13', '2020-09-28 02:41:13'),
(7, 49, '2020-09-27 12:50:05', '2020-09-28 12:50:05'),
(8, 53, '2020-10-03 20:32:05', '2020-10-04 20:32:05');

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_sim`
--

CREATE TABLE `pengambilan_sim` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime DEFAULT NULL,
  `tanggal_ambil` datetime DEFAULT NULL,
  `tipe_sim` tinyint(1) DEFAULT NULL,
  `status_teori` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `pengambilan_sim`
--

INSERT INTO `pengambilan_sim` (`id`, `id_user`, `tanggal_buat`, `tanggal_ambil`, `tipe_sim`, `status_teori`) VALUES
(1, 22, '2020-05-26 12:54:01', '2020-05-26 13:24:01', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `report_log`
--

CREATE TABLE `report_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL COMMENT 'ID User yang mereport',
  `text` varchar(255) DEFAULT NULL,
  `tanggal` datetime DEFAULT NULL COMMENT 'tanggal submit report'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_skill` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`id`, `nama_skill`) VALUES
(1, 'Mekanik'),
(2, 'Medic'),
(3, 'Blacksmith');

-- --------------------------------------------------------

--
-- Table structure for table `sms`
--

CREATE TABLE `sms` (
  `id_sms` bigint(20) UNSIGNED NOT NULL,
  `id_user_pengirim` bigint(20) UNSIGNED NOT NULL,
  `id_user_penerima` bigint(20) UNSIGNED NOT NULL,
  `id_pemilik_pesan` bigint(20) UNSIGNED DEFAULT NULL,
  `pesan` text DEFAULT NULL,
  `tanggal_dikirim` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `sms`
--

INSERT INTO `sms` (`id_sms`, `id_user_pengirim`, `id_user_penerima`, `id_pemilik_pesan`, `pesan`, `tanggal_dikirim`) VALUES
(3, 22, 24, 22, 'LASD LAJSDLKAJSLKAJ DAS KJQW \\nakj LKDSJ ASKLDJ ASD ', '2020-05-04 00:44:23'),
(10, 30, 22, 30, 'Halo bambang', '2020-05-26 20:07:25'),
(11, 30, 22, 22, 'Halo bambang', '2020-05-26 20:07:25'),
(12, 30, 24, 30, 'Hallo', '2020-05-26 20:08:00'),
(13, 30, 24, 24, 'Hallo', '2020-05-26 20:08:00'),
(14, 22, 24, 22, 'Hloaasdkajsdkl jad \\nadasdad', '2020-05-31 11:39:34'),
(15, 22, 24, 24, 'Hloaasdkajsdkl jad \\nadasdad', '2020-05-31 11:39:34'),
(16, 22, 24, 22, 'alksjdalksjdalksjdlkasjdlaksjdlaksjdalsjdlaksdjlkasjdlajsdlakjsdalkjsdaljsdlkajsdklajdlkajdlkajsdljalskdjalkdsjlkajsdklajsdklj1k', '2020-05-31 11:40:21'),
(17, 22, 24, 24, 'alksjdalksjdalksjdlkasjdlaksjdlaksjdalsjdlaksdjlkasjdlajsdlakjsdalkjsdaljsdlkajsdklajdlkajdlkajsdljalskdjalkdsjlkajsdklajsdklj1k', '2020-05-31 11:40:21');

-- --------------------------------------------------------

--
-- Table structure for table `tagihan`
--

CREATE TABLE `tagihan` (
  `id_tagihan` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `nominal` bigint(50) NOT NULL,
  `jenis` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Jenis Tagihan:\r\n0 - Universal (Umum)\r\n1 - Rumah Sakit\r\n2 - Polisi',
  `tanggal` datetime NOT NULL,
  `keterangan` varchar(50) DEFAULT NULL COMMENT 'Berisi keterangan tagihan',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Berisi status apakah sudah dibayar atau belum.\r\n0 - Belum dibayar\r\n1 - Sudah dibayar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tempat_atm`
--

CREATE TABLE `tempat_atm` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `tempat_atm`
--

INSERT INTO `tempat_atm` (`id`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`) VALUES
(1, 1154.8, -1448.92, 15.3781, 0, -0.1, -90.0167),
(2, 167.85, 1776.37, 3499.68, 0, 0, 0.586794),
(3, 1398.65, -32.9516, 1000.56, 0, 0, 1.45935),
(4, -2651.68, 1397.16, 905.977, 0, 0, 178.99);

-- --------------------------------------------------------

--
-- Table structure for table `toko_perabot`
--

CREATE TABLE `toko_perabot` (
  `id` bigint(20) NOT NULL,
  `text_toko` text DEFAULT NULL,
  `posisi_x` float NOT NULL,
  `posisi_y` float NOT NULL,
  `posisi_z` float NOT NULL,
  `posisi_vw` int(11) DEFAULT NULL,
  `posisi_int` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `toko_perabot_item`
--

CREATE TABLE `toko_perabot_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_furniture` bigint(20) NOT NULL,
  `id_toko_perabot` bigint(20) NOT NULL,
  `harga` bigint(50) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `trans_atm`
--

CREATE TABLE `trans_atm` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `id_pengirim_penerima` bigint(20) DEFAULT NULL COMMENT 'ID Pengirim berisi id pemain jika ada, jika tidak ada maka 0',
  `nominal` bigint(50) DEFAULT NULL COMMENT 'Nominal bisa berisi minus juga',
  `tanggal` datetime NOT NULL COMMENT 'Berisi tanggal transaksi',
  `keterangan` text DEFAULT NULL COMMENT 'Berisi keterangan dari pengirim'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Player',
  `nama` varchar(50) NOT NULL COMMENT 'Nama Pemain',
  `password` varchar(255) DEFAULT NULL COMMENT 'Password pemain hash pakai SHA-256',
  `current_skin` int(10) DEFAULT NULL COMMENT 'ID Skin yang sedang dipakai',
  `jumlah_login` int(50) NOT NULL DEFAULT 1 COMMENT 'Mencatat banyak player login',
  `join_date` datetime DEFAULT NULL COMMENT 'Tanggal Player Register',
  `uang` bigint(50) DEFAULT 0 COMMENT 'Jumlah Uang Player',
  `jenis_kelamin` smallint(1) DEFAULT NULL COMMENT '0 - Laki dan 1 - Perempuan',
  `email` varchar(255) DEFAULT NULL COMMENT 'Email player akan dilakukan aktivas email nantinya',
  `account_status` smallint(2) DEFAULT NULL COMMENT '0 - Default, 1 - Email Pending, 2 - Activate, 3 - Banned',
  `last_x` varchar(255) DEFAULT NULL COMMENT 'Letak posisi terakhir x',
  `last_y` varchar(255) DEFAULT NULL COMMENT 'Letak posisi terakhir y',
  `last_z` varchar(255) DEFAULT NULL COMMENT 'Letak posisi terakhir z',
  `last_a` varchar(255) DEFAULT NULL COMMENT 'Letak posisi terakhir angle',
  `last_int` varchar(255) DEFAULT NULL COMMENT 'Letak Interior',
  `last_vw` varchar(255) DEFAULT NULL COMMENT 'Letak Virtual World',
  `nomor_handphone` varchar(50) DEFAULT NULL COMMENT 'Nomor HP Player, 1 player hanya 1 nomor HP',
  `masa_aktif_nomor` datetime DEFAULT NULL COMMENT 'Berisi masa aktif nomor hp pemain',
  `use_phone` bigint(20) UNSIGNED DEFAULT 0 COMMENT 'Berisi id_item (handphone) bukan id_user_item',
  `rekening` varchar(50) DEFAULT NULL COMMENT 'Berisi nomor rekening player',
  `save_house` int(11) NOT NULL DEFAULT 0,
  `last_hp` float DEFAULT 100 COMMENT 'Berisi jumlah hp pemain',
  `last_armour` float DEFAULT 0 COMMENT 'Berisi jumlah armour pemain',
  `last_stats_makan` float DEFAULT 100 COMMENT 'Berisi jumlah status makan',
  `last_stats_minum` float DEFAULT 100 COMMENT 'Berisi jumlah status minum',
  `playtime` bigint(20) DEFAULT 0 COMMENT 'Berisi jumlah waktu bermain dalam detik',
  `in_house` bigint(20) DEFAULT 0 COMMENT 'ID rumah yang sedang di kunjungi',
  `login_attempt` tinyint(1) DEFAULT 0 COMMENT 'Attempt yang terjadi pada login sebelumnya',
  `on_mask` int(8) DEFAULT 0 COMMENT 'ID item mask jika sedang menggunakan, dan 0 jika tidak menggunakan apa-apa',
  `in_die` smallint(4) UNSIGNED DEFAULT 0 COMMENT 'Menyimpan countdown detik sebelum player sampai dipindahkan ke rumah sakit',
  `in_penjara` smallint(4) UNSIGNED DEFAULT 0 COMMENT 'Menyimpan countdown detik penjara\r\n',
  `admin_level` tinyint(1) UNSIGNED DEFAULT 0 COMMENT 'Menyimpan Level admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `password`, `current_skin`, `jumlah_login`, `join_date`, `uang`, `jenis_kelamin`, `email`, `account_status`, `last_x`, `last_y`, `last_z`, `last_a`, `last_int`, `last_vw`, `nomor_handphone`, `masa_aktif_nomor`, `use_phone`, `rekening`, `save_house`, `last_hp`, `last_armour`, `last_stats_makan`, `last_stats_minum`, `playtime`, `in_house`, `login_attempt`, `on_mask`, `in_die`, `in_penjara`, `admin_level`) VALUES
(22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 125, 620, '2020-04-24 21:12:03', 215562, 0, 'nathan@gmail.com', 0, '1474.745483', '-1651.441162', '13.292188', '97.479614', '0', '0', '621234', '2020-08-20 16:31:12', 4, '12345678', 2, 71.62, 0, 32, 4.5, 220190, 0, 0, 0, 0, 0, 2),
(35, 'khususgaming', '9238C25F424E375303276ACFE5D7EBAA5B6B0001DD6088B3C0ED9914BE88C378', 1, 54, '2020-09-09 23:24:22', 6790, 0, 'anggaputraramadian25@gmail.com', 0, '318.357208', '-1792.668213', '4.664446', '25.420494', '0', '0', NULL, NULL, 0, NULL, 0, 90.1, 0, 76, 69, 37973, 0, 0, 0, 0, 0, 2),
(36, 'cosmos', '798BD7627E4EFA679B63CDFA8C08E393AEA78C183657280D604B1223F3BFE95F', 2, 125, '2020-09-11 21:18:10', 7776, 0, 'fucku@gmail.com', 0, '1002.661072', '-1759.471069', '13.396607', '168.431183', '0', '0', NULL, NULL, 4, NULL, 0, 77.2125, 93.73, 60, 28, 111660, 0, 0, 0, 0, 0, 2),
(37, 'fathurrizali', 'F25BA01E33812F75B7BC2A78A15A7155604D9D33F3047FB43B6F8F835513B652', 68, 4, '2020-09-18 19:15:26', 100, 0, 'muhammad.fathurrizali596@gmail.com', 0, '1834.031006', '-1853.624390', '16.985937', '173.529068', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 75, 61.5, 617, 0, 0, 0, 0, 0, 0),
(38, 'test_test', '900DC1D9C3650FD7DAA6CF670899425A32C832A465059247F73FD6DD47C8E478', 101, 0, '2020-09-21 16:04:25', 100, 0, 'kupledoang30@gmail.com', 0, '288.5987', '-1984.3574', '2.4633', '357.0744', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0),
(39, 'AjiMNazar', '013BEC801ACC3431E8D1E5B96E53427BC1D3DB48EB5420C316E1598C85AF1AC7', 72, 2, '2020-09-26 19:18:09', 48, 0, 'ajimn2701@gmail.com', 0, '1093.922607', '-1580.402222', '13.553796', '270.488342', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 82.5, 85, 3063, 0, 0, 0, 0, 0, 0),
(40, 'Faridryn', '6327462FB3A286C1BC914D148BBA28C344EFD8702AD67CAAB2166A470E42EFD1', 101, 8, '2020-09-26 20:26:24', 4920, 0, 'ridfarid60@gmail.com', 0, '-493.567444', '292.823456', '2001.085938', '210.400116', '1', '1', NULL, NULL, 4, NULL, 0, 84.16, 0, 90, 100, 21257, 0, 0, 0, 0, 0, 0),
(41, 'Thuthi', '5F3A5F4C60F58E5D056F75B2BC553685ED0B8643BBB5404CBE864384156BAF96', 1, 4, '2020-09-26 20:37:43', 100, 0, 'anggaputraramadian25@gmail.com', 0, '1477.224121', '-1654.563843', '13.292188', '174.848724', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 90, 85, 968, 0, 0, 0, 0, 0, 0),
(42, 'The_Pandora', '34A5F0DE92202A06421D9B8BC74BF5945209138554E85281256B748CE866E702', 2, 0, '2020-09-27 02:17:02', 100, 0, 'rifqim671@gmail.com', 0, '288.5987', '-1984.3574', '2.4633', '357.0744', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0),
(43, 'Artemis', '881ED61FB067BD887C77446CFBFF33202BE61395AA343C46F14C3D9E749362C4', 2, 4, '2020-09-27 02:21:20', 20, 0, 'rifqim671@gmail.com', 0, '1013.020752', '-1654.990723', '14.590525', '19.506884', '0', '0', NULL, NULL, 0, NULL, 0, 83.7263, 0, 95, 56, 10085, 0, 0, 0, 0, 0, 0),
(44, 'Eric_Floch', '87449D79FD6CF83AB9640BEF238898930BC9DAB55693667478A377EF33C43D97', 98, 0, '2020-09-27 05:07:39', 100, 0, 'fadilrahman26vhs@gmail.com', 0, '1754.5775', '-1898.9517', '13.5615', '269.7162', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0),
(45, 'Kim_Roseanne', '37A06883DEBADB714FC4FACED0A3A1DDB4EE190DBD7A5B141686DE4AF1B8BCAF', 172, 1, '2020-09-27 06:15:15', 100, 1, 'ipulganteng1123@gmail.com', 0, '1937.386597', '-1769.887451', '12.979632', '27.893608', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 99, 97.5, 175, 0, 0, 0, 0, 0, 0),
(46, 'Eustaquio_Chavarria', 'D685F7F19EA55D5A5C5C4CC0C1C9C883A04E65936E136AC89F04A997050323AB', 184, 0, '2020-09-27 06:37:24', 100, 0, 'slowlowlow3@gmail.com', 0, '288.5987', '-1984.3574', '2.4633', '357.0744', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0),
(47, 'Takiya_Maddog', '4317081A509CAE0B7F64F210FA1C08275E69E1F986152CF5EAE82D2C6F33432E', 1, 0, '2020-09-27 07:20:06', 100, 0, 'faridryn18@gmail.com', 0, '288.5987', '-1984.3574', '2.4633', '357.0744', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 100, 100, 0, 0, 0, 0, 0, 0, 0),
(48, 'Vero', '5D1F9E2F9FC1AB72ECEF3CF17D993AD0CCCB4709752A6512362AA31578AED370', 47, 3, '2020-09-27 11:35:04', 55, 0, 'irfankurniawan.mail@gmail.com', 0, '-556.940063', '-573.182861', '119.732979', '215.871307', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 77, 49, 2197, 0, 0, 0, 0, 0, 0),
(49, 'Diego_Hargreeves', '5944E20B2C6A24F460D5B17B6DE15150D89182CCF83A8429F206BEAD190854EF', 170, 1, '2020-09-27 12:18:19', 110, 0, 'ganendrae@gmail.com', 0, '1400.540283', '-1863.144775', '13.138779', '206.332977', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 52, 20.5, 4419, 0, 0, 0, 0, 0, 0),
(50, 'iovfx', 'CB2077F3D40E1BBFED12B5EE35F6661BBAE3F5934F43FA3AA6CE47DA9761E3ED', 101, 1, '2020-09-28 03:06:09', 44, 0, 'info.ikhwanvfx@gmail.com', 0, '2498.601807', '-1659.173828', '13.354198', '93.333473', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 70, 55.5, 2803, 0, 0, 0, 0, 0, 0),
(51, 'Jack_Wilder', '72A07D19A0767F2D0404AC0210EC2C0ACB5ABFD6BE83B071B9314BBA898EB303', 101, 2, '2020-09-28 17:47:23', 100, 0, 'muhammadmusaakbar@gmail.com', 0, '901.764465', '-1387.512207', '13.051743', '97.857887', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 84, 69, 1539, 0, 0, 0, 0, 0, 0),
(52, 'Michiko_Karizawa', '5306C34BA8928DB3A6F364432652B3E226CD9460BC140CFD2AF81C697F8CDA32', 101, 1, '2020-09-28 20:36:10', 100, 0, 'Mrivaldolc@gmail.com', 0, '1476.455444', '-1776.353516', '13.546875', '105.973083', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 89, 76.5, 1004, 0, 0, 0, 0, 0, 0),
(53, 'Naufl', '78FE6E6AE56E9545771E3C16B3069D85BD10C1C55C7F814DD1F71CCE4CADF625', 21, 4, '2020-09-29 06:11:16', 1894, 0, 'guestred123@gmail.com', 0, '-493.478912', '291.915070', '2001.085938', '121.940018', '1', '1', NULL, NULL, 0, NULL, 0, 48.9536, 0, 73.5, 57, 13426, 0, 0, 0, 0, 0, 0),
(54, 'Woogiesii', '2222EA9F717DA6630437A03BAF72250897A192DD9BD2A1219D78978915D91CF6', 2, 1, '2020-10-01 06:31:41', 100, 0, 'mineofcrafter@gmail.com', 0, '1830.594360', '-1868.294800', '13.382988', '190.643173', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 99, 96, 168, 0, 0, 0, 0, 0, 0),
(55, 'Bogel_Santoso', 'C09AFBFB6D444BCA32780A0B3C861472FC7318320BB54EC276CDED4C914AF6BD', 2, 1, '2020-10-01 12:55:43', 100, 0, 'deoajages@gmail.com', 0, '1594.086182', '-2183.037354', '13.554688', '224.674835', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 98, 94.5, 201, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_blocked`
--

CREATE TABLE `user_blocked` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `jenis_block` tinyint(1) NOT NULL COMMENT 'Jenis Block yang didapat oleh user',
  `happen` datetime DEFAULT NULL COMMENT 'Tanggal terjadi block',
  `expired` datetime DEFAULT NULL COMMENT 'Expired Block',
  `keterangan` text DEFAULT NULL,
  `id_admin` bigint(20) DEFAULT NULL COMMENT 'ID admin yang banned (digunakan sebagai log aja)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_blocked`
--

INSERT INTO `user_blocked` (`id`, `id_user`, `jenis_block`, `happen`, `expired`, `keterangan`, `id_admin`) VALUES
(1, 22, 1, '2020-07-22 23:29:01', '2020-07-22 23:37:07', 'Salah memasukan password hingga melebihi batas attempt.', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_faction`
--

CREATE TABLE `user_faction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_faction` tinyint(3) UNSIGNED NOT NULL COMMENT 'Tipe Job Pemain :',
  `id_user` bigint(20) NOT NULL,
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `expired` datetime DEFAULT NULL COMMENT 'Expired jika masa kerja temporary'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_faction`
--

INSERT INTO `user_faction` (`id`, `id_faction`, `id_user`, `level`, `expired`) VALUES
(1, 2, 22, 1, NULL),
(2, 2, 22, 1, '2020-08-05 20:26:18'),
(5, 1, 22, 2, NULL),
(9, 1, 36, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_furniture`
--

CREATE TABLE `user_furniture` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_furniture` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `jumlah` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_furniture`
--

INSERT INTO `user_furniture` (`id`, `id_furniture`, `id_user`, `jumlah`) VALUES
(1, 1, 22, 4),
(2, 2, 22, 7);

-- --------------------------------------------------------

--
-- Table structure for table `user_item`
--

CREATE TABLE `user_item` (
  `id_user_item` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(11) DEFAULT 1,
  `kunci` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Status terkunci (agar tidak bisa dihapus)\r\n- 0 = Tidak terkunci\r\n- 1 = Terkunci'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_item`
--

INSERT INTO `user_item` (`id_user_item`, `id_item`, `id_user`, `jumlah`, `kunci`) VALUES
(1, 1, 1, 2, 0),
(3, 2, 1, 4, 0),
(7, 3, 1, 1, 0),
(8, 4, 22, 1, 0),
(10, 1, 22, 0, 0),
(17, 2, 22, 1, 0),
(26, 1, 23, 8, 0),
(27, 1, 25, 2, 0),
(30, 1, 24, 1, 0),
(31, 5, 24, 26, 0),
(32, 3, 24, 0, 0),
(33, 6, 24, 12, 0),
(34, 7, 24, 1, 0),
(35, 5, 22, 1, 0),
(36, 6, 22, 0, 0),
(37, 7, 22, 1, 0),
(38, 8, 22, 3, 0),
(39, 11, 22, 0, 0),
(40, 12, 22, 0, 0),
(41, 9, 22, 9, 0),
(42, 10, 22, 6, 1),
(45, 14, 22, 0, 0),
(46, 13, 22, 0, 0),
(48, 3, 30, 0, 0),
(49, 22, 22, 0, 0),
(50, 17, 22, 0, 0),
(51, 25, 22, 0, 0),
(52, 26, 22, 0, 0),
(53, 27, 22, 0, 0),
(54, 28, 22, 0, 0),
(55, 29, 22, 0, 0),
(56, 30, 22, 0, 0),
(57, 43, 24, 1, 0),
(58, 35, 24, 1, 0),
(59, 41, 24, -1, 0),
(60, 38, 24, 1, 0),
(61, 45, 22, 0, 0),
(62, 14, 24, 4, 0),
(63, 21, 24, 1, 0),
(64, 46, 22, 0, 0),
(65, 50, 22, 1, 0),
(66, 51, 24, 0, 0),
(67, 27, 24, 5, 0),
(68, 56, 22, 0, 0),
(69, 59, 22, 0, 0),
(70, 21, 22, 0, 0),
(71, 29, 24, 1, 0),
(72, 8, 34, 0, 0),
(73, 12, 34, 5, 0),
(74, 14, 34, 15, 0),
(75, 18, 34, 5, 0),
(76, 9, 34, 0, 0),
(77, 11, 34, 0, 0),
(78, 56, 34, 0, 0),
(79, 14, 35, 9, 0),
(80, 30, 34, 1, 0),
(81, 18, 22, 0, 0),
(82, 12, 35, 1, 0),
(83, 5, 34, 1, 0),
(84, 5, 35, 5, 0),
(85, 20, 22, 0, 0),
(86, 8, 35, 0, 0),
(87, 10, 35, 0, 0),
(88, 18, 35, 0, 0),
(89, 62, 22, 1, 0),
(90, 35, 22, 0, 0),
(91, 62, 36, 0, 0),
(92, 21, 35, 0, 0),
(93, 50, 35, 1, 0),
(94, 16, 35, 0, 0),
(95, 20, 36, 0, 0),
(96, 14, 36, 11, 0),
(97, 63, 36, 0, 0),
(98, 63, 22, 15, 0),
(99, 64, 36, 0, 0),
(100, 64, 22, 3, 0),
(101, 21, 36, 6, 0),
(102, 34, 36, 0, 0),
(103, 16, 36, 0, 0),
(104, 26, 36, 0, 0),
(105, 51, 36, 0, 0),
(106, 11, 36, 0, 0),
(107, 12, 36, 0, 0),
(108, 27, 36, 9, 0),
(109, 59, 35, 3, 0),
(110, 56, 35, 1, 0),
(111, 55, 36, 0, 0),
(112, 57, 36, 0, 0),
(113, 61, 36, 0, 0),
(114, 56, 36, 0, 0),
(115, 6, 36, 0, 0),
(116, 5, 36, 0, 0),
(117, 9, 40, 0, 0),
(118, 6, 40, 0, 0),
(119, 5, 40, 0, 0),
(120, 46, 36, 0, 0),
(121, 8, 40, 0, 0),
(122, 8, 36, 0, 0),
(123, 70, 36, 0, 0),
(124, 69, 40, 3, 0),
(125, 20, 40, 0, 0),
(126, 16, 40, 0, 0),
(127, 64, 40, 4, 0),
(128, 65, 36, 0, 0),
(129, 65, 40, 3, 0),
(130, 4, 40, 0, 0),
(131, 4, 36, 0, 0),
(132, 13, 36, 0, 0),
(133, 6, 43, 0, 0),
(134, 5, 43, 0, 0),
(135, 16, 43, 2, 0),
(136, 18, 43, 0, 0),
(137, 49, 43, 1, 0),
(138, 49, 36, 0, 0),
(139, 8, 43, 0, 0),
(140, 69, 43, 1, 0),
(141, 65, 43, 1, 0),
(142, 45, 43, 0, 0),
(143, 44, 36, 0, 0),
(144, 36, 43, 0, 0),
(145, 36, 36, 0, 0),
(146, 18, 36, 16, 0),
(147, 35, 36, 0, 0),
(148, 35, 43, 0, 0),
(149, 36, 35, 0, 0),
(150, 26, 35, 1, 0),
(151, 43, 35, 4, 0),
(152, 43, 36, -1, 0),
(153, 39, 36, 0, 0),
(154, 38, 35, 0, 0),
(155, 40, 35, 3, 0),
(156, 39, 35, 3, 0),
(157, 40, 36, 0, 0),
(158, 37, 35, 1, 0),
(159, 38, 36, 0, 0),
(160, 40, 43, 1, 0),
(161, 38, 43, 2, 0),
(162, 39, 43, 2, 0),
(163, 6, 49, 0, 0),
(164, 5, 49, 0, 0),
(165, 19, 36, 0, 0),
(166, 24, 39, 2, 0),
(167, 19, 39, 1, 0),
(168, 13, 39, 0, 0),
(169, 5, 39, 1, 0),
(170, 5, 50, 1, 0),
(171, 22, 50, 0, 0),
(172, 18, 50, 2, 0),
(173, 24, 50, 4, 0),
(174, 25, 36, 0, 0),
(175, 35, 48, 0, 0),
(176, 43, 48, 2, 0),
(177, 37, 48, 1, 0),
(178, 40, 48, 2, 0),
(179, 31, 48, 3, 0),
(180, 7, 36, 1, 1),
(181, 18, 40, 1, 0),
(182, 13, 53, 0, 0),
(183, 16, 53, 2, 0),
(184, 8, 53, 0, 0),
(185, 56, 53, 0, 0),
(186, 64, 53, 2, 0),
(187, 65, 22, 1, 0),
(188, 53, 22, 0, 0),
(189, 58, 22, 1, 0),
(190, 58, 53, 1, 0),
(191, 58, 40, 0, 0),
(192, 65, 53, 0, 0),
(193, 19, 22, 1, 0),
(194, 9, 36, 0, 0),
(195, 68, 36, 0, 0),
(196, 19, 53, 0, 0),
(197, 66, 53, 0, 0),
(198, 66, 40, 1, 0),
(199, 12, 40, 1, 0),
(200, 11, 40, 0, 0),
(201, 9, 53, 0, 0),
(202, 66, 22, 1, 0),
(203, 25, 53, 4, 0),
(204, 21, 53, 6, 0),
(205, 14, 53, 4, 0),
(206, 18, 53, 6, 0),
(207, 16, 22, 3, 0),
(208, 14, 40, 1, 0),
(209, 21, 40, 1, 0),
(210, 33, 22, 1, 0),
(211, 33, 53, 8, 0),
(212, 57, 53, 0, 0),
(213, 5, 53, 0, 0),
(214, 6, 53, 0, 0),
(215, 76, 35, 0, 0),
(216, 82, 35, 21, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_item_limit`
--

CREATE TABLE `user_item_limit` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(10) NOT NULL,
  `expired` datetime DEFAULT NULL COMMENT 'Jika null berarti permanent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_item_limit`
--

INSERT INTO `user_item_limit` (`id`, `id_user`, `jumlah`, `expired`) VALUES
(1, 23, 150, NULL),
(2, 24, 150, NULL),
(3, 26, 150, NULL),
(4, 25, 150, NULL),
(5, 28, 150, NULL),
(6, 22, 150, NULL),
(7, 27, 150, NULL),
(8, 30, 150, NULL),
(9, 29, 150, NULL),
(10, 31, 150, NULL),
(11, 32, 150, NULL),
(12, 33, 150, NULL),
(13, 34, 150, NULL),
(14, 35, 150, NULL),
(15, 36, 150, NULL),
(16, 37, 150, NULL),
(17, 38, 150, NULL),
(18, 39, 150, NULL),
(19, 40, 150, NULL),
(20, 41, 150, NULL),
(21, 42, 150, NULL),
(22, 43, 150, NULL),
(23, 44, 150, NULL),
(24, 45, 150, NULL),
(25, 46, 150, NULL),
(26, 47, 150, NULL),
(27, 48, 150, NULL),
(28, 49, 150, NULL),
(29, 50, 150, NULL),
(30, 51, 150, NULL),
(31, 52, 150, NULL),
(32, 53, 150, NULL),
(33, 54, 150, NULL),
(34, 55, 150, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_item_sp`
--

CREATE TABLE `user_item_sp` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_item_sp` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `expired` datetime DEFAULT NULL COMMENT 'Permanen = NULL\r\nTidak Permanen =Terisi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `user_skill`
--

CREATE TABLE `user_skill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_skill` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `exp` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Pada skill kita tidak memakai level, tapi exp.\r\nDimana pembagian melalui exp.\r\nMisalnya exp  >= 1000 maka di asumsikan dia ada level 1 atau jika exp >= 2000 maka level 2, dst\r\n\r\n',
  `is_active` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Status pada skill :\r\n0 - Tidak Aktif\r\n1 - Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_skill`
--

INSERT INTO `user_skill` (`id`, `id_skill`, `id_user`, `exp`, `is_active`) VALUES
(1, 1, 22, 8099, 1),
(7, 1, 24, 0, 1),
(8, 3, 22, 10, 1),
(10, 1, 36, 8242, 1),
(15, 2, 22, 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_skin`
--

CREATE TABLE `user_skin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_skin` int(20) NOT NULL,
  `jumlah` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_skin`
--

INSERT INTO `user_skin` (`id`, `id_user`, `id_skin`, `jumlah`) VALUES
(31, 22, 125, 1),
(32, 22, 28, 1),
(33, 23, 24, 1),
(34, 24, 21, 1),
(35, 25, 76, 1),
(36, 26, 298, 1),
(37, 27, 9, 1),
(38, 24, 73, 1),
(39, 24, 17, 1),
(40, 24, 19, 6),
(41, 28, 25, 1),
(42, 29, 172, 1),
(43, 30, 17, 1),
(44, 31, 41, 1),
(45, 32, 21, 1),
(46, 33, 22, 2),
(47, 33, 20, 0),
(48, 34, -1, 0),
(49, 34, 2, 0),
(50, 35, -1, 1),
(51, 35, 1, 0),
(52, 34, 19, 1),
(53, 36, 101, 1),
(54, 36, 2, 0),
(55, 36, 30, 1);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE `vehicle` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_pemilik` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Pemilik Kendaraan',
  `id_model` int(5) NOT NULL COMMENT 'ID Jenis kendaraan',
  `pos_x` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_y` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_z` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_a` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `color_1` int(3) DEFAULT 0 COMMENT 'Warna 1 kendaraan',
  `color_2` int(3) DEFAULT 0 COMMENT 'Warna 2 kendaraan',
  `paintjob` int(5) DEFAULT -1 COMMENT 'Menyimpan paint job kendaraan jika ada',
  `veh_mod_1` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 1',
  `veh_mod_2` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 2',
  `veh_mod_3` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 3',
  `veh_mod_4` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 4',
  `veh_mod_5` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 5',
  `veh_mod_6` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 6',
  `veh_mod_7` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 7',
  `veh_mod_8` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 8',
  `veh_mod_9` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 9',
  `veh_mod_10` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 10',
  `veh_mod_11` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 11',
  `veh_mod_12` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 12',
  `veh_mod_13` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 13',
  `veh_mod_14` int(8) DEFAULT 0 COMMENT 'Menyimpan mod dengan index ke 14',
  `darah` float DEFAULT 100 COMMENT 'Nyimpan darah vehicle terakhir',
  `is_reparasi` tinyint(1) DEFAULT 0 COMMENT 'Nyimpan status kendaraan apakah sedang di reparasi.\r\n\r\n0 - untuk tidak\r\n1 - untuk sedang reparasi (sedang didalam tempat reparasi karena rusak dan harus diambil)',
  `status_panels` int(11) DEFAULT 0 COMMENT 'Damage status panels',
  `status_doors` int(11) DEFAULT 0 COMMENT 'Damage status doors',
  `status_lights` int(11) DEFAULT 0 COMMENT 'Damage status lights',
  `status_tires` int(11) DEFAULT 0 COMMENT 'Damage status tires',
  `harga_beli` bigint(50) UNSIGNED DEFAULT 0 COMMENT 'Harga beli dari dealer',
  `bensin` smallint(6) DEFAULT 1000 COMMENT 'Sisa Bensin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `id_pemilik`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `paintjob`, `veh_mod_1`, `veh_mod_2`, `veh_mod_3`, `veh_mod_4`, `veh_mod_5`, `veh_mod_6`, `veh_mod_7`, `veh_mod_8`, `veh_mod_9`, `veh_mod_10`, `veh_mod_11`, `veh_mod_12`, `veh_mod_13`, `veh_mod_14`, `darah`, `is_reparasi`, `status_panels`, `status_doors`, `status_lights`, `status_tires`, `harga_beli`, `bensin`) VALUES
(4, 24, 557, 994.214, -1666.57, 14.9775, 133.934, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 989.193, 0, 0, 0, 0, 0, 10000, 980),
(5, 24, 567, 1056.7, -1289.62, 13.5909, 181.551, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 810.734, 0, 18874400, 33554944, 4, 0, 10000, 891),
(6, 24, 562, 1481.5, -1646.52, 12.9501, 92.6758, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 431.276, 0, 52559907, 131584, 5, 0, 10000, 488),
(9, 22, 560, -705.598, 2382.06, 130.591, 259.879, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 260, 0, 35651616, 514, 4, 0, 10000, 314),
(10, 22, 561, -695.47, 2381.87, 130.019, 346.505, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 991.34, 0, 0, 131072, 0, 0, 0, 939),
(13, 22, 541, 1514.95, -1774.22, 13.1719, 211.273, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 884, 0, 2097153, 0, 1, 0, 10000, 925),
(14, 36, 415, 1023.54, -1716.26, 13.1324, 269.971, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 10000, 267),
(15, 36, 411, -543.079, -547.278, 25.267, 179.852, 2, 2, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 952.227, 0, 16777216, 512, 0, 0, 1, 313);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_components`
--

CREATE TABLE `vehicle_components` (
  `componentid` smallint(4) UNSIGNED NOT NULL,
  `part` enum('Exhausts','Front Bullbars','Front Bumper','Hood','Hydraulics','Lights','Misc','Rear Bullbars','Rear Bumper','Roof','Side Skirts','Spoilers','Vents','Wheels') DEFAULT NULL,
  `type` varchar(22) NOT NULL,
  `cars` smallint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vehicle_components`
--

INSERT INTO `vehicle_components` (`componentid`, `part`, `type`, `cars`) VALUES
(1000, 'Spoilers', 'Pro', 0),
(1001, 'Spoilers', 'Win', 0),
(1002, 'Spoilers', 'Drag', 0),
(1003, 'Spoilers', 'Alpha', 0),
(1004, 'Hood', 'Champ Scoop', 0),
(1005, 'Hood', 'Fury Scoop', 0),
(1006, 'Roof', 'Roof Scoop', 0),
(1007, 'Side Skirts', 'Sideskirt', 0),
(1011, 'Hood', 'Race Scoop', 0),
(1012, 'Hood', 'Worx Scoop', 0),
(1013, 'Lights', 'Round Fog', 0),
(1014, 'Spoilers', 'Champ', 0),
(1015, 'Spoilers', 'Race', 0),
(1016, 'Spoilers', 'Worx', 0),
(1018, 'Exhausts', 'Upswept', 0),
(1019, 'Exhausts', 'Twin', 0),
(1020, 'Exhausts', 'Large', 0),
(1021, 'Exhausts', 'Medium', 0),
(1022, 'Exhausts', 'Small', 0),
(1023, 'Spoilers', 'Fury', 0),
(1024, 'Lights', 'Square Fog', 0),
(1025, 'Wheels', 'Offroad', 0),
(1027, 'Side Skirts', 'Alien', 560),
(1028, 'Exhausts', 'Alien', 560),
(1029, 'Exhausts', 'X-Flow', 560),
(1030, 'Side Skirts', 'X-Flow', 560),
(1032, 'Roof', 'Alien Roof Vent', 560),
(1033, 'Roof', 'X-Flow Roof Vent', 560),
(1034, 'Exhausts', 'Alien', 562),
(1035, 'Roof', 'X-Flow Roof Vent', 562),
(1037, 'Exhausts', 'X-Flow', 562),
(1038, 'Roof', 'Alien Roof Vent', 562),
(1039, 'Side Skirts', 'X-Flow', 562),
(1040, 'Side Skirts', 'Alien', 562),
(1043, 'Exhausts', 'Slamin', 575),
(1044, 'Exhausts', 'Chrome', 575),
(1045, 'Exhausts', 'X-Flow', 565),
(1046, 'Exhausts', 'Alien', 565),
(1049, 'Spoilers', 'Alien', 565),
(1050, 'Spoilers', 'X-Flow', 565),
(1051, 'Side Skirts', 'Alien', 565),
(1052, 'Side Skirts', 'X-Flow', 565),
(1053, 'Roof', 'X-Flow', 565),
(1054, 'Roof', 'Alien', 565),
(1055, 'Roof', 'Alien', 561),
(1058, 'Spoilers', 'Alien', 561),
(1059, 'Exhausts', 'X-Flow', 561),
(1060, 'Spoilers', 'X-Flow', 561),
(1061, 'Roof', 'X-Flow', 561),
(1062, 'Side Skirts', 'Alien', 561),
(1063, 'Side Skirts', 'X-Flow', 561),
(1064, 'Exhausts', 'Alien', 561),
(1065, 'Exhausts', 'Alien', 559),
(1066, 'Exhausts', 'X-Flow', 559),
(1067, 'Roof', 'Alien', 559),
(1068, 'Roof', 'X-Flow', 559),
(1071, 'Side Skirts', 'Alien', 559),
(1072, 'Side Skirts', 'X-Flow', 559),
(1073, 'Wheels', 'Shadow', -1),
(1074, 'Wheels', 'Mega', -1),
(1075, 'Wheels', 'Rimshine', -1),
(1076, 'Wheels', 'Wires', -1),
(1077, 'Wheels', 'Classic', -1),
(1078, 'Wheels', 'Twist', -1),
(1079, 'Wheels', 'Cutter', -1),
(1080, 'Wheels', 'Switch', -1),
(1081, 'Wheels', 'Grove', -1),
(1082, 'Wheels', 'Import', -1),
(1083, 'Wheels', 'Dollar', -1),
(1084, 'Wheels', 'Trance', -1),
(1085, 'Wheels', 'Atomic', -1),
(1087, 'Hydraulics', 'Hydraulics', -1),
(1088, 'Roof', 'Alien', 558),
(1089, 'Exhausts', 'X-Flow', 558),
(1091, 'Roof', 'X-Flow', 558),
(1092, 'Exhausts', 'Alien', 558),
(1094, 'Side Skirts', 'Alien', 558),
(1096, 'Wheels', 'Ahab', -1),
(1097, 'Wheels', 'Virtual', -1),
(1098, 'Wheels', 'Access', -1),
(1099, 'Side Skirts', 'Chrome', 575),
(1100, 'Misc', 'Chrome Grill', 534),
(1101, 'Side Skirts', 'Chrome Flames', 534),
(1102, 'Side Skirts', 'Chrome Strip', 567),
(1103, 'Roof', 'Covertible', 536),
(1104, 'Exhausts', 'Chrome', 536),
(1105, 'Exhausts', 'Slamin', 536),
(1107, 'Side Skirts', 'Chrome Strip', 536),
(1109, 'Rear Bullbars', 'Chrome', 535),
(1110, 'Rear Bullbars', 'Slamin', 535),
(1113, 'Exhausts', 'Chrome', 535),
(1114, 'Exhausts', 'Slamin', 535),
(1115, 'Front Bullbars', 'Chrome', 535),
(1116, 'Front Bullbars', 'Slamin', 535),
(1117, 'Front Bumper', 'Chrome', 535),
(1120, 'Side Skirts', 'Chrome Trim', 535),
(1121, 'Side Skirts', 'Wheelcovers', 535),
(1123, 'Misc', 'Bullbar Chrome Bars', 534),
(1124, 'Side Skirts', 'Chrome Arches', 534),
(1125, 'Misc', 'Bullbar Chrome Lights', 534),
(1126, 'Exhausts', 'Chrome', 534),
(1127, 'Exhausts', 'Slamin', 534),
(1128, 'Roof', 'Vinyl Hardtop', 536),
(1129, 'Exhausts', 'Chrome', 567),
(1130, 'Roof', 'Hardtop', 567),
(1131, 'Roof', 'Softtop', 567),
(1132, 'Exhausts', 'Slamin', 567),
(1135, 'Exhausts', 'Slamin', 576),
(1136, 'Exhausts', 'Chrome', 576),
(1137, 'Side Skirts', 'Chrome Strip', 576),
(1138, 'Spoilers', 'Alien', 560),
(1139, 'Spoilers', 'X-Flow', 560),
(1140, 'Rear Bumper', 'X-Flow', 560),
(1141, 'Rear Bumper', 'Alien', 560),
(1143, 'Vents', 'Oval Vents', 0),
(1145, 'Vents', 'Square Vents', 0),
(1146, 'Spoilers', 'X-Flow', 562),
(1147, 'Spoilers', 'Alien', 562),
(1148, 'Rear Bumper', 'X-Flow', 562),
(1149, 'Rear Bumper', 'Alien', 562),
(1150, 'Rear Bumper', 'Alien', 565),
(1151, 'Rear Bumper', 'X-Flow', 565),
(1152, 'Front Bumper', 'X-Flow', 565),
(1153, 'Front Bumper', 'Alien', 565),
(1154, 'Rear Bumper', 'Alien', 561),
(1155, 'Front Bumper', 'Alien', 561),
(1156, 'Rear Bumper', 'X-Flow', 561),
(1157, 'Front Bumper', 'X-Flow', 561),
(1158, 'Spoilers', 'X-Flow', 559),
(1159, 'Rear Bumper', 'Alien', 559),
(1160, 'Front Bumper', 'Alien', 559),
(1161, 'Rear Bumper', 'X-Flow', 559),
(1162, 'Spoilers', 'Alien', 559),
(1163, 'Spoilers', 'X-Flow', 558),
(1164, 'Spoilers', 'Alien', 558),
(1165, 'Front Bumper', 'X-Flow', 558),
(1166, 'Front Bumper', 'Alien', 558),
(1167, 'Rear Bumper', 'X-Flow', 558),
(1168, 'Rear Bumper', 'Alien', 558),
(1169, 'Front Bumper', 'Alien', 560),
(1170, 'Front Bumper', 'X-Flow', 560),
(1171, 'Front Bumper', 'Alien', 562),
(1172, 'Front Bumper', 'X-Flow', 562),
(1173, 'Front Bumper', 'X-Flow', 559),
(1174, 'Front Bumper', 'Chrome', 575),
(1175, 'Rear Bumper', 'Slamin', 575),
(1176, 'Front Bumper', 'Chrome', 575),
(1177, 'Rear Bumper', 'Slamin', 575),
(1178, 'Rear Bumper', 'Slamin', 534),
(1179, 'Front Bumper', 'Chrome', 534),
(1180, 'Rear Bumper', 'Chrome', 534),
(1181, 'Front Bumper', 'Slamin', 536),
(1182, 'Front Bumper', 'Chrome', 536),
(1183, 'Rear Bumper', 'Slamin', 536),
(1184, 'Rear Bumper', 'Chrome', 536),
(1185, 'Front Bumper', 'Slamin', 534),
(1186, 'Rear Bumper', 'Slamin', 567),
(1187, 'Rear Bumper', 'Chrome', 567),
(1188, 'Front Bumper', 'Slamin', 567),
(1189, 'Front Bumper', 'Chrome', 567),
(1190, 'Front Bumper', 'Slamin', 576),
(1191, 'Front Bumper', 'Chrome', 576),
(1192, 'Rear Bumper', 'Chrome', 576),
(1193, 'Rear Bumper', 'Slamin', 576);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_dealer`
--

CREATE TABLE `vehicle_dealer` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_model` int(5) NOT NULL COMMENT 'ID Jenis kendaraan',
  `pos_x` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_y` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_z` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `pos_a` float DEFAULT NULL COMMENT 'Posisi terakir kendaraan',
  `color_1` int(3) DEFAULT 0 COMMENT 'Warna 1 kendaraan',
  `color_2` int(3) DEFAULT 0 COMMENT 'Warna 2 kendaraan',
  `harga` bigint(50) DEFAULT NULL COMMENT 'Harga kendaraan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vehicle_dealer`
--

INSERT INTO `vehicle_dealer` (`id`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `harga`) VALUES
(17, 415, 996.236, -1755.11, 13.5912, 234.092, 5, 5, 95000),
(19, 535, 995.798, -1747.65, 13.5974, 233.205, 9, 9, 40000),
(20, 579, 1010.66, -1745.88, 13.7439, 126.87, 53, 53, 60000),
(21, 492, 1011.39, -1754.06, 13.6231, 126.883, 19, 19, 17000),
(22, 461, 1010.67, -1760.77, 13.4194, 127.185, 69, 69, 66000),
(23, 521, 995.921, -1760.93, 13.45, 235.388, 97, 97, 77000),
(25, 458, 995.069, -1736.9, 14.3659, 269.793, 44, 44, 32500),
(27, 426, 994.827, -1733.32, 14.2318, 270.853, 24, 24, 32000);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_item`
--

CREATE TABLE `vehicle_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_item` int(11) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `jumlah` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_item`
--

INSERT INTO `vehicle_item` (`id`, `id_item`, `id_vehicle`, `jumlah`) VALUES
(1, 28, 10, 2),
(2, 25, 10, 0),
(3, 26, 10, 10),
(4, 30, 10, 1),
(19, 43, 13, 1),
(20, 46, 14, 4);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_keys`
--

CREATE TABLE `vehicle_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `expired` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Gunakan unix timestamp untuk menyimpan maupun query'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vehicle_keys`
--

INSERT INTO `vehicle_keys` (`id`, `id_user`, `id_vehicle`, `expired`) VALUES
(2, 53, 13, 1601738334),
(3, 35, 10, 1601987472),
(4, 40, 13, 1601816151);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_model_parts`
--

CREATE TABLE `vehicle_model_parts` (
  `modelid` smallint(3) UNSIGNED NOT NULL,
  `parts` bit(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `vehicle_model_parts`
--

INSERT INTO `vehicle_model_parts` (`modelid`, `parts`) VALUES
(400, b'100001101'),
(401, b'111111111'),
(402, b'100000100'),
(403, b'100000100'),
(404, b'101101101'),
(405, b'101000101'),
(407, b'100000000'),
(408, b'100000100'),
(409, b'100000100'),
(410, b'101111101'),
(411, b'100000100'),
(412, b'100000100'),
(413, b'100000100'),
(414, b'100000101'),
(415, b'101100101'),
(416, b'100000101'),
(418, b'101010101'),
(419, b'100000101'),
(420, b'101000111'),
(421, b'101000101'),
(422, b'100101101'),
(423, b'100000101'),
(424, b'100000100'),
(426, b'101010111'),
(427, b'100000101'),
(428, b'100000101'),
(429, b'100000100'),
(431, b'100000100'),
(432, b'100000000'),
(433, b'100000100'),
(434, b'100000100'),
(436, b'101111101'),
(437, b'100000100'),
(438, b'100000101'),
(439, b'111101100'),
(440, b'100000101'),
(441, b'100000100'),
(442, b'100000100'),
(443, b'100000000'),
(445, b'100000101'),
(451, b'100000100'),
(455, b'100000100'),
(456, b'100000101'),
(457, b'100000100'),
(458, b'111101101'),
(459, b'100000100'),
(466, b'100000101'),
(467, b'100000101'),
(470, b'100000100'),
(474, b'100000101'),
(475, b'100000101'),
(477, b'100110101'),
(478, b'100001111'),
(479, b'100000101'),
(480, b'100000101'),
(482, b'100000101'),
(483, b'100000101'),
(485, b'100000100'),
(486, b'100000000'),
(489, b'101011111'),
(490, b'101010111'),
(491, b'111100101'),
(492, b'101010111'),
(494, b'100000100'),
(495, b'100000101'),
(496, b'111111111'),
(498, b'100000101'),
(499, b'100000101'),
(500, b'100001101'),
(502, b'100000100'),
(503, b'100000100'),
(504, b'100000101'),
(505, b'101011111'),
(506, b'100000101'),
(507, b'100000101'),
(508, b'100000101'),
(514, b'100000100'),
(515, b'100000100'),
(516, b'101100111'),
(517, b'111100101'),
(518, b'111111111'),
(524, b'100000000'),
(525, b'100000000'),
(526, b'100000101'),
(527, b'101110101'),
(528, b'100000100'),
(529, b'101110111'),
(530, b'100000000'),
(531, b'100000000'),
(532, b'100000100'),
(533, b'100000100'),
(540, b'111111111'),
(541, b'100000100'),
(542, b'111000101'),
(543, b'101110100'),
(544, b'100000100'),
(545, b'100000100'),
(546, b'111101111'),
(547, b'111000101'),
(549, b'111100111'),
(550, b'111011111'),
(551, b'101010111'),
(552, b'100000101'),
(554, b'100000101'),
(555, b'100000100'),
(566, b'100000101'),
(568, b'100000100'),
(571, b'100000100'),
(572, b'100000100'),
(574, b'100000100'),
(578, b'100000100'),
(579, b'101010101'),
(580, b'101110101'),
(582, b'100000101'),
(583, b'100000100'),
(585, b'111111101'),
(587, b'101000111'),
(588, b'100000100'),
(589, b'111111111'),
(594, b'100000100'),
(596, b'100000101'),
(597, b'100000101'),
(598, b'100000101'),
(599, b'101010111'),
(600, b'100111111'),
(601, b'100000000'),
(602, b'100000100'),
(603, b'111111101'),
(604, b'100000101'),
(605, b'101110101'),
(609, b'100000101');

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_rent`
--

CREATE TABLE `vehicle_rent` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_list` bigint(20) NOT NULL DEFAULT -1,
  `id_place` bigint(20) NOT NULL DEFAULT -1,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `pos_a` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_rent`
--

INSERT INTO `vehicle_rent` (`id`, `id_list`, `id_place`, `pos_x`, `pos_y`, `pos_z`, `pos_a`) VALUES
(1, 0, 2, 315.372, -1788.15, 4.62322, 0.250229),
(2, 1, 2, 316.481, -1788.62, 4.6372, 358.057),
(3, 0, 1, 1804.71, -1910.78, 13.3971, 268.838),
(4, 1, 1, 1804.83, -1912.77, 13.3963, 263.198),
(5, 0, 3, 1560.77, -2328.74, 13.5469, 268.116),
(6, 1, 3, 1561.1, -2330.2, 13.5469, 268.116),
(8, 2, 4, 2402.39, -650.995, 127.386, 269.479);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_rent_place`
--

CREATE TABLE `vehicle_rent_place` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `durasi_gratis` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_rent_place`
--

INSERT INTO `vehicle_rent_place` (`id`, `pos_x`, `pos_y`, `pos_z`, `durasi_gratis`) VALUES
(1, 1804.82, -1908.66, 13.3981, 1601732965),
(2, 318.362, -1789.61, 4.67799, 1601737717),
(3, 1559.88, -2332.08, 13.5469, 0),
(4, 2400.82, -647.287, 127.224, 1601859063);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_rent_player`
--

CREATE TABLE `vehicle_rent_player` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) NOT NULL DEFAULT -1,
  `id_list` bigint(20) NOT NULL DEFAULT -1,
  `id_place` bigint(20) NOT NULL DEFAULT -1,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `pos_a` float DEFAULT NULL,
  `bensin` smallint(6) DEFAULT 1000,
  `expired` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Gunakan unix timestamp untuk menyimpan maupun query'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_rent_player`
--

INSERT INTO `vehicle_rent_player` (`id`, `id_user`, `id_list`, `id_place`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `bensin`, `expired`) VALUES
(1, 45, 0, 1, 1804.82, -1908.66, 13.3981, 0, 1000, 1601250448),
(8, 48, 0, 1, 1483.2, -1646.89, 12.8867, 300.857, 1000, 1601197719),
(9, 49, 0, 2, 1400.54, -1863.14, 13.1388, 24.4732, 630, 1601276178),
(11, 39, 0, 1, 2097.42, -1813.5, 12.9591, 277.448, 1000, 1601298140),
(12, 50, 0, 2, 1635.47, -1551.17, 13.2102, 162.767, 856, 1601329539),
(15, 52, 0, 2, 1473.6, -1776.71, 13.1449, 189.047, 747, 1601392173),
(18, 51, 0, 2, 901.764, -1387.51, 13.0517, 85.6952, 903, 1601529644);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `enter_exit`
--
ALTER TABLE `enter_exit`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `faction`
--
ALTER TABLE `faction`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `gaji`
--
ALTER TABLE `gaji`
  ADD PRIMARY KEY (`id_gaji`) USING BTREE;

--
-- Indexes for table `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id_house`) USING BTREE;

--
-- Indexes for table `house_furniture`
--
ALTER TABLE `house_furniture`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `house_interior`
--
ALTER TABLE `house_interior`
  ADD PRIMARY KEY (`id_level`) USING BTREE;

--
-- Indexes for table `house_inv_item`
--
ALTER TABLE `house_inv_item`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`);

--
-- Indexes for table `item_rarity`
--
ALTER TABLE `item_rarity`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `item_sp`
--
ALTER TABLE `item_sp`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `jenis_blocked`
--
ALTER TABLE `jenis_blocked`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `logs_user_konek`
--
ALTER TABLE `logs_user_konek`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `lumber`
--
ALTER TABLE `lumber`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marketplace`
--
ALTER TABLE `marketplace`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `papan`
--
ALTER TABLE `papan`
  ADD PRIMARY KEY (`id_papan`) USING BTREE;

--
-- Indexes for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `report_log`
--
ALTER TABLE `report_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`id_sms`) USING BTREE;

--
-- Indexes for table `tagihan`
--
ALTER TABLE `tagihan`
  ADD PRIMARY KEY (`id_tagihan`) USING BTREE;

--
-- Indexes for table `tempat_atm`
--
ALTER TABLE `tempat_atm`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `toko_perabot`
--
ALTER TABLE `toko_perabot`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `toko_perabot_item`
--
ALTER TABLE `toko_perabot_item`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `trans_atm`
--
ALTER TABLE `trans_atm`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `nama` (`nama`) USING BTREE,
  ADD UNIQUE KEY `rekening` (`rekening`) USING BTREE;

--
-- Indexes for table `user_blocked`
--
ALTER TABLE `user_blocked`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_faction`
--
ALTER TABLE `user_faction`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_furniture`
--
ALTER TABLE `user_furniture`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_item`
--
ALTER TABLE `user_item`
  ADD PRIMARY KEY (`id_user_item`) USING BTREE,
  ADD UNIQUE KEY `id_item` (`id_item`,`id_user`) USING BTREE;

--
-- Indexes for table `user_item_limit`
--
ALTER TABLE `user_item_limit`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_item_sp`
--
ALTER TABLE `user_item_sp`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `id_skill` (`id_skill`,`id_user`) USING BTREE;

--
-- Indexes for table `user_skin`
--
ALTER TABLE `user_skin`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vehicle_components`
--
ALTER TABLE `vehicle_components`
  ADD PRIMARY KEY (`componentid`) USING BTREE,
  ADD KEY `cars` (`cars`) USING BTREE,
  ADD KEY `part` (`part`) USING BTREE,
  ADD KEY `type` (`type`) USING BTREE;

--
-- Indexes for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vehicle_item`
--
ALTER TABLE `vehicle_item`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_item` (`id_item`,`id_vehicle`);

--
-- Indexes for table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vehicle_model_parts`
--
ALTER TABLE `vehicle_model_parts`
  ADD PRIMARY KEY (`modelid`) USING BTREE;

--
-- Indexes for table `vehicle_rent`
--
ALTER TABLE `vehicle_rent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_rent_place`
--
ALTER TABLE `vehicle_rent_place`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_rent_player`
--
ALTER TABLE `vehicle_rent_player`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `enter_exit`
--
ALTER TABLE `enter_exit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faction`
--
ALTER TABLE `faction`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gaji`
--
ALTER TABLE `gaji`
  MODIFY `id_gaji` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id_house` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `house_furniture`
--
ALTER TABLE `house_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `house_interior`
--
ALTER TABLE `house_interior`
  MODIFY `id_level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `house_inv_item`
--
ALTER TABLE `house_inv_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `item_rarity`
--
ALTER TABLE `item_rarity`
  MODIFY `id` tinyint(2) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `item_sp`
--
ALTER TABLE `item_sp`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jenis_blocked`
--
ALTER TABLE `jenis_blocked`
  MODIFY `id` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `logs_user_konek`
--
ALTER TABLE `logs_user_konek`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lumber`
--
ALTER TABLE `lumber`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `marketplace`
--
ALTER TABLE `marketplace`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `papan`
--
ALTER TABLE `papan`
  MODIFY `id_papan` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `report_log`
--
ALTER TABLE `report_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tagihan`
--
ALTER TABLE `tagihan`
  MODIFY `id_tagihan` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toko_perabot_item`
--
ALTER TABLE `toko_perabot_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trans_atm`
--
ALTER TABLE `trans_atm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player', AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `user_blocked`
--
ALTER TABLE `user_blocked`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_faction`
--
ALTER TABLE `user_faction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `user_furniture`
--
ALTER TABLE `user_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_item`
--
ALTER TABLE `user_item`
  MODIFY `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT for table `user_item_limit`
--
ALTER TABLE `user_item_limit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `user_item_sp`
--
ALTER TABLE `user_item_sp`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_skill`
--
ALTER TABLE `user_skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user_skin`
--
ALTER TABLE `user_skin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `vehicle_item`
--
ALTER TABLE `vehicle_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vehicle_rent`
--
ALTER TABLE `vehicle_rent`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `vehicle_rent_place`
--
ALTER TABLE `vehicle_rent_place`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vehicle_rent_player`
--
ALTER TABLE `vehicle_rent_player`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

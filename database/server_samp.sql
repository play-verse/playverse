-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2020 at 05:22 PM
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
CREATE DEFINER=`eternity`@`%` PROCEDURE `tambah_furniture` (`x_id_user` BIGINT, `x_id_furniture` BIGINT, `x_jumlah` INT)  BEGIN
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

CREATE DEFINER=`eternity`@`%` PROCEDURE `tambah_item` (`x_id_user` INT, `x_id_item` INT, `x_banyak_item` INT)  BEGIN
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

CREATE DEFINER=`eternity`@`%` PROCEDURE `tambah_item_house` (`x_id_house` INT, `x_id_item` INT, `x_jumlah` INT)  BEGIN
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

CREATE DEFINER=`eternity`@`%` PROCEDURE `tambah_skin` (`x_id_user` INT, `x_id_skin` INT, `x_banyak_skin` INT)  BEGIN
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

CREATE DEFINER=`eternity`@`%` PROCEDURE `tambah_transaksi_atm` (`rekening_pengirim` VARCHAR(50), `rekening_penerima` VARCHAR(50), `ex_nominal` BIGINT, `ex_keterangan` TEXT)  BEGIN
	INSERT INTO `trans_atm`(id_user, id_pengirim_penerima, nominal, tanggal, keterangan) 
	SELECT a.id as id_user, b.id as id_pengirim_penerima, ex_nominal as nominal, NOW() as tanggal, ex_keterangan as keterangan FROM `user` a
	LEFT JOIN `user` b ON b.rekening = rekening_pengirim WHERE a.rekening = rekening_penerima;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(1, 'Meja  I', 2115, 'Meja biasa', 1),
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
  `status` smallint(1) NOT NULL COMMENT 'Berisi status apakah sudah diambil atau belum.\r\n0 - Belum diambil\r\n1 - Sudah diambil'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `gaji`
--

INSERT INTO `gaji` (`id_gaji`, `id_user`, `nominal`, `tanggal`, `keterangan`, `status`) VALUES
(1, 22, 1000, '2020-05-23 14:24:15', NULL, 1),
(2, 22, 50, '2020-05-23 14:24:32', NULL, 1),
(3, 22, 100, '2020-05-26 13:09:48', NULL, 1),
(4, 29, 100, '2020-06-10 12:33:06', 'Pembersih jalan (sweeper)', 1),
(5, 29, 100, '2020-06-27 09:28:12', 'Pembersih jalan (sweeper)', 1);

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
(1, 24, 8, 10000, 0, 0, 0, '841.189392', '-1471.353149', '14.312580'),
(2, 22, 8, 100, 0, 0, 0, '822.442566', '-1505.515015', '14.397550'),
(3, 29, 8, 10000, 999999, 0, 1, '849.636841', '-1520.081909', '14.347800'),
(4, 30, 8, 1000, 0, 0, 0, '875.588501', '-1515.328125', '14.195910'),
(5, 29, 8, 100, 99999, 0, 1, '1583.305420', '-1636.751221', '13.390459');

-- --------------------------------------------------------

--
-- Table structure for table `house_furniture`
--

CREATE TABLE `house_furniture` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_house` bigint(20) NOT NULL,
  `id_furniture` bigint(20) NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` varchar(255) DEFAULT NULL,
  `rot_y` varchar(255) DEFAULT NULL,
  `rot_z` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `house_furniture`
--

INSERT INTO `house_furniture` (`id`, `id_house`, `id_furniture`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`) VALUES
(1, 5, 2, 1268.21, -781.303, 1091.91, NULL, NULL, NULL),
(2, 5, 1, 1269, -777.224, 1090.84, '0.000000', '0.000000', '0.000000');

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
  `limit_item` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `house_inv_item`
--

INSERT INTO `house_inv_item` (`id`, `id_item`, `id_house`, `jumlah`) VALUES
(1, 13, 2, 10),
(2, 5, 2, 20),
(3, 10, 5, 2),
(4, 12, 5, 10),
(5, 11, 5, 14),
(6, 5, 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id_item` int(255) NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Berisi public function yang akan di trigger saat pemilihan use item, pada item tersebut.',
  `kapasitas` int(11) NOT NULL DEFAULT 1 COMMENT 'Berisi kapasistas yang dibutuhkan untuk satu barang'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`id_item`, `nama_item`, `model_id`, `keterangan`, `fungsi`, `kapasitas`) VALUES
(1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.', 'pakaiHpFromInven', 3),
(2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.', 'pakaiHpFromInven', 3),
(3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.', 'pakaiHpFromInven', 3),
(4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.', 'pakaiHpFromInven', 3),
(5, 'Pas Foto', 2281, 'Pas Foto untuk keperluan administrasi.', NULL, 1),
(6, 'Materai', 2059, 'Materai untuk keperluan administrasi.', NULL, 1),
(7, 'KTP', 1581, 'KTP sebagai identitas kewarganegaraan.', NULL, 2),
(8, 'Palu Tambang', 19631, 'Palu Tambang digunakan untuk menambang, 1x use item ini = 15 kali kesempatan tambang.', 'pakaiPaluTambang', 3),
(9, 'Emas', 19941, 'Emas adalah item yang langka, berguna untuk banyak hal dan memiliki nilai yang tinggi.', NULL, 4),
(10, 'Berlian', 1559, 'Berlian adalah item yang sangat langka, berguna untuk membuat item-item langka dan dapat menghasilkan banyak uang.', NULL, 5),
(11, 'Perunggu', 2936, 'Perunggu adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL, 2),
(12, 'Perak', 16134, 'Perak adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1),
(13, 'Air Minum Mineral', 2647, 'Air minum mineral dapat menambah status minum sebanyak 5', 'pakaiMinuman', 1),
(14, 'Steak', 19882, 'Steak dapat menambah status makan sebanyak 50', 'pakaiMakanan', 2),
(15, 'SIM', 1581, 'SIM sebagai identitas kelayakan berkendara.', NULL, 2),
(16, 'Nasi Bungkus', 2678, 'Nasi bungkus dapat menambah status makan sebanyak 37,5', 'pakaiMakanan', 2),
(17, 'Sate', 2858, 'Sate dapat menambah status makan sebanyak 30', 'pakaiMakanan', 2),
(18, 'Jus Jeruk', 19564, 'Jus jeruk dapat menambah status minum sebanyak 25', 'pakaiMinuman', 1),
(19, 'Es Teh Manis', 2647, 'Es Teh Manis dapat menambah status minum sebanyak 20', 'pakaiMinuman', 1),
(20, 'Kopi Panas', 2647, 'Kopi Panas dapat menambah status minum sebanyak 35', 'pakaiMinuman', 1),
(21, 'Kopi Dingin', 2647, 'Kopi Dingin dapat menambah status minum sebanyak 35', 'pakaiMinuman', 1),
(22, 'Minuman Soda', 2647, 'Minuman Soda dapat menambah status minum sebanyak 30', 'pakaiMinuman', 1),
(23, 'Roti', 19579, 'Roti dapat menambah status makan sebanyak 25', 'pakaiMakanan', 2),
(24, 'Telur Dadar', 19580, 'Telur Dadar dapat menambah status makan sebanyak 12,5', 'pakaiMakanan', 2),
(25, 'Kayu', 19793, 'Kayu adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1),
(26, 'Gergaji Mesin', 341, 'Gergaji Mesin digunakan untuk memotong pohon.', 'pakaiGergajiMesin', 3),
(27, 'Alat Perbaikan Kendaraan', 19921, 'Alat ini dapat digunakan untuk memperbaiki kendaraan anda, pemakaian alat tergantung kerusakan', NULL, 3),
(28, 'Cat Kendaraan', 365, 'Bahan untuk mengecat kendaraan anda.', NULL, 2),
(29, 'Bibit Jeruk', 756, 'Biji Jeruk adalah item pertanian yang dapat ditanam dan tumbuh menjadi Jeruk.', 'pakaiBibitJeruk', 9),
(30, 'Jeruk', 19574, 'Jeruk adalah buah hasil panen dengan rasa masam yang segar.', NULL, 1),
(31, 'Bibit Ganja', 756, 'Biji Ganja adalah bibit terlarang yang dapat ditanam dan tumbuh menjadi Ganja.', 'pakaiBibitGanja', 9),
(32, 'Ganja', 19473, 'Ganja adalah item terlarang yang dapat menambahkan Darah Putih sebesar 5%.', 'pakaiNarkoGanja', 1);

-- --------------------------------------------------------

--
-- Table structure for table `lumber`
--

CREATE TABLE `lumber` (
  `id` int(20) NOT NULL,
  `treeX` varchar(32) NOT NULL,
  `treeY` varchar(32) NOT NULL,
  `treeZ` varchar(32) NOT NULL,
  `treeRX` varchar(32) NOT NULL,
  `treeRY` varchar(32) NOT NULL,
  `treeRZ` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `lumber`
--

INSERT INTO `lumber` (`id`, `treeX`, `treeY`, `treeZ`, `treeRX`, `treeRY`, `treeRZ`) VALUES
(0, '2374.425293', '-661.560547', '127.419678', '0.0', '0.0', '0.0'),
(1, '2379.692871', '-664.465576', '127.569733', '0.0', '0.0', '0.0'),
(2, '2371.416992', '-652.318237', '126.722504', '0.0', '0.0', '0.0'),
(0, '2374.425293', '-661.560547', '127.419678', '0.0', '0.0', '0.0'),
(1, '2379.692871', '-664.465576', '127.569733', '0.0', '0.0', '0.0'),
(2, '2371.416992', '-652.318237', '126.722504', '0.0', '0.0', '0.0'),
(3, '804.784546', '-975.955017', '34.650154', '0.000000', '0.000000', '0.000000'),
(4, '2371.577393', '-646.913757', '126.412544', '0.000000', '0.000000', '0.000000'),
(0, '2374.425293', '-661.560547', '127.419678', '0.0', '0.0', '0.0'),
(1, '2379.692871', '-664.465576', '127.569733', '0.0', '0.0', '0.0'),
(2, '2371.416992', '-652.318237', '126.722504', '0.0', '0.0', '0.0'),
(3, '804.784546', '-975.955017', '34.650154', '0.000000', '0.000000', '0.000000'),
(4, '2371.577393', '-646.913757', '126.412544', '0.000000', '0.000000', '0.000000'),
(0, '2374.425293', '-661.560547', '127.419678', '0.0', '0.0', '0.0'),
(1, '2379.692871', '-664.465576', '127.569733', '0.0', '0.0', '0.0'),
(2, '2371.416992', '-652.318237', '126.722504', '0.0', '0.0', '0.0'),
(3, '804.784546', '-975.955017', '34.650154', '0.000000', '0.000000', '0.000000'),
(4, '2371.577393', '-646.913757', '126.412544', '0.000000', '0.000000', '0.000000');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `papan`
--

INSERT INTO `papan` (`id_papan`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `text`, `font_size`) VALUES
(1, 5846, 691.718, -1182.78, 17.6628, 0, 0, -24.1, '{000000}Selamat datang di satuan pembersih jalan.\nSilahkan mengantri untuk mendapatkan giliran anda.\nPastikan anda tidak memotong. :)', 13),
(2, 5846, 715.661, -1154.27, 24.375, 0, 0, 0, '{000000}Hallo nama sa\nasldalksd', 24),
(3, 5846, 679.516, -1175.96, 15.4559, 0, 0, 0, '{000000}tes', 24);

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

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_sim`
--

CREATE TABLE `pengambilan_sim` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime NOT NULL,
  `tanggal_ambil` datetime NOT NULL,
  `status_teori` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `pengambilan_sim`
--

INSERT INTO `pengambilan_sim` (`id`, `id_user`, `tanggal_buat`, `tanggal_ambil`, `status_teori`) VALUES
(2, 30, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1),
(3, 33, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_skill` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`id`, `nama_skill`) VALUES
(1, 'Mekanik'),
(2, 'Cheff');

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
(3, 22, 24, 22, 'LASD LAJSDLKAJSLKAJ DAS KJQW \\nakj LKDSJ ASKLDJ ASD ', '2020-05-04 00:44:23');

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
(1, 825.349, -1385.69, 13.3079, 0, 0, 1.74972),
(2, 834.154, -1392.16, 13.2094, 0, 0, 95.021),
(3, 1423.01, -985.867, -55.5764, 0, 0, -90.0012);

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

--
-- Dumping data for table `trans_atm`
--

INSERT INTO `trans_atm` (`id`, `id_user`, `id_pengirim_penerima`, `nominal`, `tanggal`, `keterangan`) VALUES
(1, 22, NULL, 2000, '2020-05-19 11:52:04', 'tes'),
(2, 22, NULL, 10, '2020-05-19 12:20:34', 'Deposit tabungan'),
(3, 22, NULL, -10, '2020-05-20 22:29:34', 'Penarikan uang'),
(4, 29, NULL, 50, '2020-05-20 12:28:48', 'Deposit tabungan'),
(5, 29, NULL, -50, '2020-05-20 12:29:32', 'Penarikan uang'),
(6, 29, NULL, 80, '2020-05-20 12:31:27', 'Deposit tabungan'),
(7, 29, 22, -50, '2020-05-20 12:32:05', 'Setuju'),
(8, 22, 29, 50, '2020-05-20 12:32:05', 'Setuju'),
(9, 22, 29, -100, '2020-05-20 12:33:37', 'Bayar uang bulanan kuliah'),
(10, 29, 22, 100, '2020-05-20 12:33:37', 'Bayar uang bulanan kuliah'),
(11, 22, NULL, -100, '2020-05-20 12:34:59', 'Penarikan uang'),
(12, 29, NULL, -130, '2020-05-20 12:35:03', 'Penarikan uang'),
(13, 29, NULL, 150, '2020-05-20 12:39:43', 'Deposit tabungan'),
(14, 22, 30, -200, '2020-05-20 12:54:24', 'Bagi bagi duit'),
(15, 30, 22, 200, '2020-05-20 12:54:24', 'Bagi bagi duit'),
(16, 30, 22, -100, '2020-05-20 12:58:09', 'kembalian'),
(17, 22, 30, 100, '2020-05-20 12:58:09', 'kembalian'),
(18, 30, NULL, -100, '2020-05-26 15:25:44', 'Penarikan uang'),
(19, 29, NULL, -10, '2020-05-26 15:30:54', 'Pembelian Steak sebanyak 1'),
(20, 29, NULL, -10, '2020-05-27 01:34:54', 'Pembelian Air Minum Mineral sebanyak 5'),
(21, 29, NULL, -10, '2020-05-27 01:35:15', 'Pembelian Steak sebanyak 1'),
(22, 30, NULL, 1000, '2020-06-18 21:50:32', 'Deposit tabungan'),
(23, 29, NULL, 2000, '2020-06-27 16:17:36', 'Deposit tabungan');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Player',
  `nama` varchar(50) NOT NULL COMMENT 'Nama Pemain',
  `password` varchar(255) NOT NULL COMMENT 'Password pemain hash pakai SHA-256',
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
  `use_phone` bigint(20) UNSIGNED DEFAULT 0 COMMENT 'Berisi id_item (handphone) bukan id_user_item',
  `rekening` varchar(50) DEFAULT NULL COMMENT 'Berisi nomor rekening player',
  `save_house` int(11) NOT NULL DEFAULT 0,
  `last_hp` float NOT NULL COMMENT 'Berisi jumlah hp pemain',
  `last_armour` float NOT NULL COMMENT 'Berisi jumlah armour pemain',
  `last_stats_makan` float NOT NULL COMMENT 'Berisi jumlah status makan',
  `last_stats_minum` float NOT NULL COMMENT 'Berisi jumlah status minum',
  `playtime` bigint(20) NOT NULL DEFAULT 0,
  `in_house` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `password`, `current_skin`, `jumlah_login`, `join_date`, `uang`, `jenis_kelamin`, `email`, `account_status`, `last_x`, `last_y`, `last_z`, `last_a`, `last_int`, `last_vw`, `nomor_handphone`, `use_phone`, `rekening`, `save_house`, `last_hp`, `last_armour`, `last_stats_makan`, `last_stats_minum`, `playtime`, `in_house`) VALUES
(22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 28, 105, '2020-04-24 21:12:03', 60, 0, 'nathan@gmail.com', 0, '827.283386', '-1497.464478', '14.386312', '296.427979', '0', '0', '621234', 4, '12345678', 0, 95, 0, 80, 37.5, 10373, 0),
(23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', 100, 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0),
(24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 19, 92, '2020-04-30 15:31:48', 174940, 0, 'natan@gmail.com', 0, '1020.575256', '-1697.387695', '14.590525', '283.207886', '0', '0', '629876', 1, NULL, 0, 100, 0, 80, 79, 204, 0),
(25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', 0, 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0),
(26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', 0, 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0),
(27, 'cosiozo', 'EEF3ABEA0977171744D9AC2BF8A4761A389F8C55136BDC00B02E9E49524340B1', 9, 1, '2020-05-10 16:59:42', 100, 1, 'asd2@gmail.com', 0, '285.288879', '-1863.428467', '2.890330', '309.904419', '0', '0', NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0),
(28, 'cosine_xx', 'FE1F21653A573338CC45562B2F50BD5F0F4B5DBC7AE9E67DD7702A3FEA265DB2', 25, 3, '2020-05-13 14:14:19', 100, 0, 'natan@gmail.com', 0, '597.599731', '-1747.577515', '37.244843', '312.951660', '0', '0', NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0),
(29, 'cosmos', '798BD7627E4EFA679B63CDFA8C08E393AEA78C183657280D604B1223F3BFE95F', 2, 62, '2020-05-20 12:08:55', 325, 0, 'kupledoang30@gmail.com', 0, '1014.501770', '-1688.689575', '14.590525', '271.670715', '0', '0', '621953', 4, '19531953', 5, 100, 0, 130, 112.5, 16634, 5),
(30, 'khususgaming', 'DA44B8D789EB9E31FC2C423B6AA49471CADEACF250E47C475B0DD1F0A89F05A6', 1, 36, '2020-05-20 12:11:34', 14650, 0, 'anggaputraramadian25@gmail.com', 0, '687.171082', '-1182.052124', '15.357858', '241.647034', '0', '0', NULL, 3, '12312312', 0, 90, 0, 80, 75.5, 11588, 0),
(31, 'sin', '406F041ABFCF5AFC6A7A6A4FF6F7D4FAED5707AC7E4DD6A50B77950E19339215', 170, 1, '2020-05-27 00:50:29', 100, 0, 'sin@gmail.com', 0, '826.177124', '-1621.854614', '13.476579', '55.781780', '0', '0', '628888', 0, NULL, 0, 100, 0, 80, 75, 0, 0),
(32, 'Name_Surname', '197ADFA4615B7D2953143E2B8CEEE2072A218087EBE2DE374766C77AEF53740B', 1, 3, '2020-05-30 06:56:09', 100, 0, 'surename@gmail.com', 0, '981.989258', '-1811.750366', '14.205122', '250.916183', '0', '0', NULL, 0, NULL, 0, 100, 0, 80, 59, 0, 0),
(33, 'yaya_toure', '68F7031A760F119992F825B7224D5D401FBE5B599DDECC5FA0AD209B8D4DCEED', 1, 5, '2020-06-10 11:07:49', 900, 0, 'yaya@gmail.com', 0, '663.397034', '-1200.737549', '17.954485', '135.873444', '0', '0', NULL, 0, NULL, 0, 95, 0, 80, 4.5, 3576, 0),
(34, 'Elon_Washington', 'FA90EAD28229E7E85C27CDA0477C2F89B7B23B5071F930D8AABACC2E9D25C768', 25, 4, '2020-06-23 09:04:39', 100, 0, 'test@gmail.com', 0, '0.000000', '0.000000', '0.000000', '0.000000', '0', '0', NULL, 0, NULL, 0, 0, 0, 80, 66, 340, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_furniture`
--

CREATE TABLE `user_furniture` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_furniture` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `jumlah` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_furniture`
--

INSERT INTO `user_furniture` (`id`, `id_furniture`, `id_user`, `jumlah`) VALUES
(1, 1, 22, 2),
(2, 2, 22, 2),
(3, 1, 29, 0),
(4, 2, 29, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_item`
--

CREATE TABLE `user_item` (
  `id_user_item` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(255) DEFAULT 1,
  `kunci` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `user_item`
--

INSERT INTO `user_item` (`id_user_item`, `id_item`, `id_user`, `jumlah`, `kunci`) VALUES
(1, 1, 1, 2, 0),
(3, 2, 1, 4, 0),
(7, 3, 1, 1, 0),
(8, 4, 22, 1, 0),
(10, 1, 22, 3, 0),
(17, 2, 22, 1, 0),
(26, 1, 23, 8, 0),
(27, 1, 25, 2, 0),
(30, 1, 24, 0, 0),
(31, 5, 24, 8, 0),
(32, 3, 24, 1, 0),
(33, 6, 24, 14, 0),
(34, 7, 24, 1, 0),
(35, 5, 22, 4, 0),
(36, 6, 22, 6, 0),
(37, 7, 22, 1, 0),
(38, 6, 29, 16, 0),
(39, 5, 29, 0, 0),
(40, 7, 29, 1, 1),
(41, 7, 30, 1, 0),
(42, 5, 30, 6, 0),
(43, 6, 30, 8, 0),
(44, 8, 22, 22, 0),
(45, 9, 22, 10, 0),
(46, 12, 22, 12, 0),
(47, 11, 22, 8, 0),
(48, 3, 30, 0, 0),
(49, 8, 29, 0, 0),
(50, 8, 30, 8, 0),
(51, 10, 30, 4, 0),
(52, 12, 29, 0, 0),
(53, 9, 30, 5, 0),
(54, 12, 30, 3, 0),
(55, 9, 29, 11, 1),
(56, 10, 22, 5, 0),
(57, 11, 30, 4, 0),
(58, 11, 29, 0, 0),
(59, 10, 29, 0, 0),
(60, 2, 29, 1, 0),
(61, 14, 29, 12, 0),
(62, 13, 29, 0, 0),
(63, 14, 22, 0, 0),
(64, 4, 29, 0, 0),
(65, 13, 22, 33, 0),
(66, 14, 30, 10, 0),
(67, 7, 33, 1, 0),
(68, 26, 22, 1, 0),
(69, 25, 22, 6, 0),
(70, 26, 30, 1, 0),
(71, 21, 22, 1, 0),
(72, 19, 29, 4, 0),
(73, 25, 29, 3, 0),
(74, 26, 29, 0, 0),
(75, 15, 29, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_item_limit`
--

CREATE TABLE `user_item_limit` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(10) NOT NULL,
  `expired` datetime DEFAULT NULL COMMENT 'Jika null berarti permanent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(8, 29, 150, NULL),
(9, 30, 150, NULL),
(10, 32, 150, NULL),
(11, 31, 150, NULL),
(12, 33, 150, NULL),
(13, 34, 150, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_skill`
--

CREATE TABLE `user_skill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_skill` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `exp` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Pada skill kita tidak memakai level, tapi exp.\r\nDimana pembagian melalui exp.\r\nMisalnya exp  >= 1000 maka di asumsikan dia ada level 1 atau jika exp >= 2000 maka level 2, dst\r\n\r\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_skill`
--

INSERT INTO `user_skill` (`id`, `id_skill`, `id_user`, `exp`) VALUES
(1, 1, 22, 1523);

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
(31, 22, 125, 2),
(32, 22, 28, 0),
(33, 23, 24, 1),
(34, 24, 21, 1),
(35, 25, 76, 1),
(36, 26, 298, 1),
(37, 27, 9, 1),
(38, 24, 73, 1),
(39, 24, 17, 1),
(40, 24, 19, 6),
(41, 28, 25, 1),
(42, 29, 2, 1),
(43, 30, 1, 1),
(44, 31, 170, 1),
(45, 32, 1, 1),
(46, 33, 1, 1),
(47, 34, 25, 1);

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
  `is_reparasi` tinyint(1) DEFAULT 0 COMMENT 'Nyimpan status kendaraan apakah sedang di reparasi.\r\n\r\n0 - untuk tidak\r\n1 - untuk sedang reparasi (sedang didalam tempat reparasi karena rusak dan harus diambil)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `id_pemilik`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `paintjob`, `veh_mod_1`, `veh_mod_2`, `veh_mod_3`, `veh_mod_4`, `veh_mod_5`, `veh_mod_6`, `veh_mod_7`, `veh_mod_8`, `veh_mod_9`, `veh_mod_10`, `veh_mod_11`, `veh_mod_12`, `veh_mod_13`, `veh_mod_14`, `darah`, `is_reparasi`) VALUES
(1, 22, 555, 830.529, -1501.71, 12.7399, 355.491, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 992.252, 0),
(2, 22, 521, 837.2, -1501.92, 12.6249, 353.508, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 595, 0),
(3, 29, 415, 1015.19, -1683.9, 14.3626, 272.268, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0),
(4, 30, 467, 1020.4, -1690.91, 14.3327, 72.3988, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 998.848, 2),
(5, 22, 555, 1023.45, -1694.18, 14.0978, 73.6548, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 621.513, 0),
(6, 29, 559, 1015.15, -1686.98, 14.2469, 271.671, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 992.358, 0),
(7, 30, 561, 1052.49, -1700, 13.3603, 168.979, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 821.529, 0),
(8, 22, 560, 774.782, -1394.43, 13.0966, 73.1231, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500.911, 0);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_dealer`
--

INSERT INTO `vehicle_dealer` (`id`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `harga`) VALUES
(1, 415, 530.936, -1291.21, 17.014, 357.776, 0, 0, 10000),
(11, 562, 527.604, -1291.25, 16.9023, 4.03834, 0, 0, 25000);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_keys`
--

CREATE TABLE `vehicle_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `expired` bigint(20) DEFAULT NULL COMMENT 'Gunakan unix timestamp untuk menyimpan maupun query'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_keys`
--

INSERT INTO `vehicle_keys` (`id`, `id_user`, `id_vehicle`, `expired`) VALUES
(1, 24, 2, 1591199673),
(4, 22, 6, 1591172875),
(5, 29, 2, 1591174983),
(6, 30, 8, 1591173923),
(7, 30, 2, 1591177564),
(8, 29, 8, 1591199236);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `enter_exit`
--
ALTER TABLE `enter_exit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `gaji`
--
ALTER TABLE `gaji`
  ADD PRIMARY KEY (`id_gaji`);

--
-- Indexes for table `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id_house`) USING BTREE;

--
-- Indexes for table `house_furniture`
--
ALTER TABLE `house_furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `house_interior`
--
ALTER TABLE `house_interior`
  ADD PRIMARY KEY (`id_level`);

--
-- Indexes for table `house_inv_item`
--
ALTER TABLE `house_inv_item`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`);

--
-- Indexes for table `papan`
--
ALTER TABLE `papan`
  ADD PRIMARY KEY (`id_papan`);

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
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`id_sms`) USING BTREE;

--
-- Indexes for table `tempat_atm`
--
ALTER TABLE `tempat_atm`
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
-- Indexes for table `user_furniture`
--
ALTER TABLE `user_furniture`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_skin`
--
ALTER TABLE `user_skin`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
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
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gaji`
--
ALTER TABLE `gaji`
  MODIFY `id_gaji` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id_house` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `house_furniture`
--
ALTER TABLE `house_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `house_interior`
--
ALTER TABLE `house_interior`
  MODIFY `id_level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `house_inv_item`
--
ALTER TABLE `house_inv_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `papan`
--
ALTER TABLE `papan`
  MODIFY `id_papan` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `trans_atm`
--
ALTER TABLE `trans_atm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player', AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `user_furniture`
--
ALTER TABLE `user_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_item`
--
ALTER TABLE `user_item`
  MODIFY `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `user_item_limit`
--
ALTER TABLE `user_item_limit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_skill`
--
ALTER TABLE `user_skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_skin`
--
ALTER TABLE `user_skin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

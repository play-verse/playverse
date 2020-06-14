-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 14, 2020 at 09:27 PM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_item` (`x_id_user` INT, `x_id_item` INT, `x_banyak_item` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_skin` (`x_id_user` INT, `x_id_skin` INT, `x_banyak_skin` INT)  BEGIN
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

DELIMITER ;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.', 'pakaiHpFromInven', 1),
(2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.', 'pakaiHpFromInven', 1),
(3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.', 'pakaiHpFromInven', 1),
(4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.', 'pakaiHpFromInven', 1),
(5, 'Pas Foto', 2281, 'Pas Foto untuk keperluan administrasi.', NULL, 1),
(6, 'Materai', 2059, 'Materai untuk keperluan administrasi.', NULL, 1),
(7, 'KTP', 1581, 'KTP sebagai identitas kewarganegaraan.', NULL, 1),
(8, 'Palu Tambang', 19631, 'Palu Tambang digunakan untuk menambang, 1x use item ini = 15 kali kesempatan tambang.', 'pakaiPaluTambang', 1),
(9, 'Emas', 19941, 'Emas adalah item yang langka, berguna untuk banyak hal dan memiliki nilai yang tinggi.', NULL, 1),
(10, 'Berlian', 1559, 'Berlian adalah item yang sangat langka, berguna untuk membuat item-item langka dan dapat menghasilkan banyak uang.', NULL, 1),
(11, 'Perunggu', 2936, 'Perunggu adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL, 1),
(12, 'Perak', 16134, 'Perak adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1),
(13, 'Air Minum Mineral', 2647, 'Air minum mineral untuk minum', 'pakaiMinuman', 1),
(14, 'Steak', 19882, 'Steak sapi untuk makan, dapat dikonsumsi sehingga menambah status Makan', 'pakaiMakanan', 1),
(15, 'SIM', 1581, 'SIM sebagai identitas kelayakan berkendara.', NULL, 1),
(16, 'Kayu', 19793, 'Kayu adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL, 1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_ktp`
--

CREATE TABLE `pengambilan_ktp` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime NOT NULL,
  `tanggal_ambil` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pengambilan_sim`
--

CREATE TABLE `pengambilan_sim` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime NOT NULL,
  `tanggal_ambil` datetime NOT NULL,
  `status_teori` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `last_hp` float DEFAULT NULL COMMENT 'Berisi jumlah hp pemain',
  `last_armour` float DEFAULT NULL COMMENT 'Berisi jumlah armour pemain',
  `last_stats_makan` float DEFAULT NULL COMMENT 'Berisi jumlah status makan',
  `last_stats_minum` float DEFAULT NULL COMMENT 'Berisi jumlah status minum',
  `playtime` bigint(20) DEFAULT NULL COMMENT 'Berisi jumlah waktu bermain dalam detik'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Table structure for table `user_item`
--

CREATE TABLE `user_item` (
  `id_user_item` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(255) DEFAULT 1,
  `kunci` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Status terkunci (agar tidak bisa dihapus)\r\n- 0 = Tidak terkunci\r\n- 1 = Terkunci'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Table structure for table `user_skin`
--

CREATE TABLE `user_skin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_skin` int(20) NOT NULL,
  `jumlah` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_keys`
--

CREATE TABLE `vehicle_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `expired` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Gunakan unix timestamp untuk menyimpan maupun query'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gaji`
--
ALTER TABLE `gaji`
  ADD PRIMARY KEY (`id_gaji`);

--
-- Indexes for table `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id_house`);

--
-- Indexes for table `house_furniture`
--
ALTER TABLE `house_furniture`
  ADD PRIMARY KEY (`id`) USING BTREE;

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
  ADD PRIMARY KEY (`id`);

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
  ADD PRIMARY KEY (`id_sms`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

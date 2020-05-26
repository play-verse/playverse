-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2020 at 09:41 AM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

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
-- Table structure for table `gaji`
--

CREATE TABLE `gaji` (
  `id_gaji` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `nominal` bigint(50) NOT NULL,
  `tanggal` datetime NOT NULL,
  `status` smallint(1) NOT NULL COMMENT 'Berisi status apakah sudah diambil atau belum.\r\n0 - Belum diambil\r\n1 - Sudah diambil'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `gaji`
--

INSERT INTO `gaji` (`id_gaji`, `id_user`, `nominal`, `tanggal`, `status`) VALUES
(1, 22, 1000, '2020-05-23 14:24:15', 1),
(2, 22, 50, '2020-05-23 14:24:32', 1),
(3, 22, 100, '2020-05-26 13:09:48', 1);

-- --------------------------------------------------------

--
-- Table structure for table `house`
--

CREATE TABLE `house` (
  `id_house` int(20) NOT NULL,
  `id_user` int(20) NOT NULL DEFAULT -1,
  `level` int(11) NOT NULL DEFAULT 1,
  `harga` int(20) NOT NULL,
  `kunci` int(11) NOT NULL DEFAULT 1,
  `jual` int(11) NOT NULL DEFAULT 1,
  `icon_x` varchar(255) NOT NULL,
  `icon_y` varchar(255) NOT NULL,
  `icon_z` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `house`
--

INSERT INTO `house` (`id_house`, `id_user`, `level`, `harga`, `kunci`, `jual`, `icon_x`, `icon_y`, `icon_z`) VALUES
(1, 24, 3, 10000, 1, 0, '841.189392', '-1471.353149', '14.312580'),
(2, 22, 1, 100, 1, 0, '822.442566', '-1505.515015', '14.397550');

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id_item` int(255) NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Berisi public function yang akan di trigger saat pemilihan use item, pada item tersebut.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`id_item`, `nama_item`, `model_id`, `keterangan`, `fungsi`) VALUES
(1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.', 'pakaiHpFromInven'),
(2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.', 'pakaiHpFromInven'),
(3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.', 'pakaiHpFromInven'),
(4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.', 'pakaiHpFromInven'),
(5, 'Pas Foto', 2281, 'Pas Foto untuk keperluan administrasi.', NULL),
(6, 'Materai', 2059, 'Materai untuk keperluan administrasi.', NULL),
(7, 'KTP', 1581, 'KTP sebagai identitas kewarganegaraan.', NULL),
(8, 'Palu Tambang', 19631, 'Palu Tambang digunakan untuk menambang, 1x use item ini = 15 kali kesempatan tambang.', 'pakaiPaluTambang'),
(9, 'Emas', 19941, 'Emas adalah item yang langka, berguna untuk banyak hal dan memiliki nilai yang tinggi.', NULL),
(10, 'Berlian', 1559, 'Berlian adalah item yang sangat langka, berguna untuk membuat item-item langka dan dapat menghasilkan banyak uang.', NULL),
(11, 'Perunggu', 2936, 'Perunggu adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL),
(12, 'Perak', 16134, 'Perak adalah item yang bagus dan diminati, biasanya digunakan untuk membuat berbagai item.', NULL),
(13, 'Air Minum Mineral', 2647, 'Air minum mineral untuk minum', 'pakaiMinuman'),
(14, 'Steak', 19882, 'Steak sapi untuk makan, dapat dikonsumsi sehingga menambah status Makan', 'pakaiMakanan'),
(15, 'SIM', 1581, 'SIM sebagai identitas kelayakan berkendara.', NULL);

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
  `tanggal_ambil` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `pengambilan_sim`
--

INSERT INTO `pengambilan_sim` (`id`, `id_user`, `tanggal_buat`, `tanggal_ambil`) VALUES
(1, 22, '2020-05-26 12:54:01', '2020-05-26 13:24:01');

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

--
-- Dumping data for table `sms`
--

INSERT INTO `sms` (`id_sms`, `id_user_pengirim`, `id_user_penerima`, `id_pemilik_pesan`, `pesan`, `tanggal_dikirim`) VALUES
(3, 22, 24, 22, 'LASD LAJSDLKAJSLKAJ DAS KJQW \\nakj LKDSJ ASKLDJ ASD ', '2020-05-04 00:44:23');

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

--
-- Dumping data for table `trans_atm`
--

INSERT INTO `trans_atm` (`id`, `id_user`, `id_pengirim_penerima`, `nominal`, `tanggal`, `keterangan`) VALUES
(1, 22, NULL, 2000, '2020-05-19 11:52:04', 'tes'),
(2, 22, NULL, 10, '2020-05-19 12:20:34', 'Deposit tabungan'),
(3, 22, NULL, -10, '2020-05-20 22:29:34', 'Penarikan uang'),
(4, 22, NULL, 1050, '2020-05-23 14:50:16', 'Pencairan gaji'),
(5, 22, NULL, -100, '2020-05-23 14:50:48', 'Penarikan uang'),
(6, 22, NULL, -100, '2020-05-23 14:50:55', 'Penarikan uang'),
(7, 22, NULL, 400, '2020-05-23 14:51:28', 'Deposit tabungan'),
(8, 22, NULL, 70, '2020-05-23 14:51:56', 'Deposit tabungan'),
(9, 22, NULL, -3000, '2020-05-23 14:52:11', 'Penarikan uang'),
(10, 22, NULL, 2800, '2020-05-23 21:55:28', 'Deposit tabungan'),
(11, 22, NULL, -20, '2020-05-25 16:01:41', 'Pembelian Air Minum Mineral sebanyak 10'),
(12, 22, NULL, -3000, '2020-05-25 16:06:31', 'Penarikan uang'),
(13, 22, NULL, -10, '2020-05-25 16:07:54', 'Pembelian Steak sebanyak 1'),
(14, 22, NULL, -2, '2020-05-25 16:09:06', 'Pembelian Air Minum Mineral sebanyak 1'),
(15, 22, NULL, -2, '2020-05-25 16:09:13', 'Pembelian Air Minum Mineral sebanyak 1'),
(16, 22, NULL, -2, '2020-05-25 16:09:35', 'Pembelian Air Minum Mineral sebanyak 1'),
(17, 22, NULL, -2, '2020-05-25 16:09:42', 'Pembelian Air Minum Mineral sebanyak 1'),
(18, 22, NULL, -2, '2020-05-25 16:09:48', 'Pembelian Air Minum Mineral sebanyak 1'),
(19, 22, NULL, -2, '2020-05-25 16:09:56', 'Pembelian Air Minum Mineral sebanyak 1'),
(20, 22, NULL, -2, '2020-05-25 16:10:05', 'Pembelian Air Minum Mineral sebanyak 1'),
(21, 22, NULL, -2, '2020-05-25 16:10:11', 'Pembelian Air Minum Mineral sebanyak 1'),
(22, 22, NULL, -2, '2020-05-25 16:20:31', 'Pembelian Air Minum Mineral sebanyak 1'),
(23, 22, NULL, 0, '2020-05-25 16:24:24', 'Pembelian Steak sebanyak 0'),
(24, 22, NULL, 0, '2020-05-25 16:24:50', 'Pembelian Steak sebanyak 0'),
(25, 22, NULL, -2, '2020-05-25 16:26:34', 'Pembelian Air Minum Mineral sebanyak 1'),
(26, 22, NULL, -20, '2020-05-25 18:28:51', 'Pembelian Air Minum Mineral sebanyak 10'),
(27, 22, NULL, 2000, '2020-05-26 13:12:46', 'Deposit tabungan'),
(28, 22, NULL, 1000, '2020-05-26 14:15:57', 'Deposit tabungan'),
(29, 22, NULL, -100, '2020-05-26 14:16:05', 'Penarikan uang'),
(30, 22, NULL, -1000, '2020-05-26 14:16:14', 'Penarikan uang');

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
  `last_stats_minum` float DEFAULT NULL COMMENT 'Berisi jumlah status minum'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `password`, `current_skin`, `jumlah_login`, `join_date`, `uang`, `jenis_kelamin`, `email`, `account_status`, `last_x`, `last_y`, `last_z`, `last_a`, `last_int`, `last_vw`, `nomor_handphone`, `use_phone`, `rekening`, `save_house`, `last_hp`, `last_armour`, `last_stats_makan`, `last_stats_minum`) VALUES
(22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 28, 132, '2020-04-24 21:12:03', 1212, 0, 'nathan@gmail.com', 0, '1064.278442', '-1341.301270', '12.961114', '25.894300', '0', '0', '621234', 4, '12345678', 0, 90, 0, 320, 67.5),
(23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', 100, 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL),
(24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 19, 91, '2020-04-30 15:31:48', 174940, 0, 'natan@gmail.com', 0, '1519.263184', '-1696.209229', '13.292188', '109.391800', '0', '0', '629876', 1, NULL, 0, NULL, NULL, NULL, NULL),
(25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', 0, 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL),
(26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', 0, 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL),
(27, 'cosiozo', 'EEF3ABEA0977171744D9AC2BF8A4761A389F8C55136BDC00B02E9E49524340B1', 9, 1, '2020-05-10 16:59:42', 100, 1, 'asd2@gmail.com', 0, '285.288879', '-1863.428467', '2.890330', '309.904419', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL),
(28, 'cosine_xx', 'FE1F21653A573338CC45562B2F50BD5F0F4B5DBC7AE9E67DD7702A3FEA265DB2', 25, 3, '2020-05-13 14:14:19', 100, 0, 'natan@gmail.com', 0, '597.599731', '-1747.577515', '37.244843', '312.951660', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL),
(29, 'xoxo', 'FC922095F45335113D9195483EA4E2F6CBA407DAB53BF08D7F1C8B58177FD0EB', 172, 2, '2020-05-23 17:35:10', 100, 1, 'xoxo@gmail.com', 0, '329.041931', '-1804.449341', '4.580854', '307.374207', '0', '0', '621234', 0, NULL, 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_item`
--

CREATE TABLE `user_item` (
  `id_user_item` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(255) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_item`
--

INSERT INTO `user_item` (`id_user_item`, `id_item`, `id_user`, `jumlah`) VALUES
(1, 1, 1, 2),
(3, 2, 1, 4),
(7, 3, 1, 1),
(8, 4, 22, 1),
(10, 1, 22, 3),
(17, 2, 22, 1),
(26, 1, 23, 8),
(27, 1, 25, 2),
(30, 1, 24, 0),
(31, 5, 24, 8),
(32, 3, 24, 1),
(33, 6, 24, 14),
(34, 7, 24, 1),
(35, 5, 22, 14),
(36, 6, 22, 6),
(37, 7, 22, 1),
(38, 8, 22, 4),
(39, 11, 22, 12),
(40, 12, 22, 14),
(41, 9, 22, 5),
(42, 10, 22, 1),
(45, 14, 22, 6),
(46, 13, 22, 8);

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
(42, 29, 172, 1);

--
-- Indexes for dumped tables
--

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
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`);

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
-- Indexes for table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`id_sms`);

--
-- Indexes for table `trans_atm`
--
ALTER TABLE `trans_atm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`),
  ADD UNIQUE KEY `rekening` (`rekening`);

--
-- Indexes for table `user_item`
--
ALTER TABLE `user_item`
  ADD PRIMARY KEY (`id_user_item`),
  ADD UNIQUE KEY `id_item` (`id_item`,`id_user`);

--
-- Indexes for table `user_skin`
--
ALTER TABLE `user_skin`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gaji`
--
ALTER TABLE `gaji`
  MODIFY `id_gaji` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id_house` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `trans_atm`
--
ALTER TABLE `trans_atm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player', AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `user_item`
--
ALTER TABLE `user_item`
  MODIFY `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `user_skin`
--
ALTER TABLE `user_skin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

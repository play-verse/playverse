-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 28, 2020 at 05:47 PM
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `furniture`
--

INSERT INTO `furniture` (`id`, `nama_furniture`, `id_object`, `keterangan`, `kapasitas`) VALUES
(1, 'Meja I', 2115, 'Meja biasa', 1),
(2, 'Kasur Besar I', 11720, 'Kasur besar untuk tidur', 1);

--
-- Dumping data for table `gaji`
--

INSERT INTO `gaji` (`id_gaji`, `id_user`, `nominal`, `tanggal`, `keterangan`, `status`) VALUES
(1, 22, 1000, '2020-05-23 14:24:15', NULL, 1),
(2, 22, 50, '2020-05-23 14:24:32', NULL, 1),
(3, 22, 100, '2020-05-26 13:09:48', NULL, 1);

--
-- Dumping data for table `house`
--

INSERT INTO `house` (`id_house`, `id_user`, `level`, `harga`, `setharga`, `kunci`, `jual`, `icon_x`, `icon_y`, `icon_z`) VALUES
(1, 24, 3, 10000, 0, 1, 0, '841.189392', '-1471.353149', '14.312580'),
(2, 22, 3, 100, 0, 1, 0, '822.442566', '-1505.515015', '14.397550'),
(3, 22, 3, 10000, 0, 1, 0, '875.976257', '-1514.975098', '14.339783'),
(4, -1, 3, 20000, 0, 1, 1, '849.718933', '-1519.958496', '14.350296'),
(5, -1, 3, 30000, 0, 1, 1, '900.770447', '-1473.218506', '14.265127'),
(6, -1, 3, 999999, 0, 1, 1, '2352.013184', '-1412.265625', '23.992413');

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

--
-- Dumping data for table `house_inv_item`
--

INSERT INTO `house_inv_item` (`id`, `id_item`, `id_house`, `jumlah`) VALUES
(1, 13, 2, 1),
(2, 10, 2, 2),
(3, 1, 2, 3),
(4, 9, 2, 6),
(5, 2, 2, 1),
(6, 4, 2, 1),
(7, 7, 2, 1),
(8, 5, 2, 13),
(9, 14, 2, 15),
(10, 11, 2, 13),
(11, 12, 2, 10),
(12, 6, 2, 6);

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
(28, 'Cat Kendaraan', 365, 'Bahan untuk mengecat kendaraan anda.', NULL, 2);

--
-- Dumping data for table `logs_user_konek`
--

INSERT INTO `logs_user_konek` (`id`, `id_user`, `ip`, `kota`, `negara`, `tanggal`) VALUES
(1, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-22 22:27:38'),
(2, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-23 23:27:05'),
(3, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-26 22:46:08'),
(4, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-27 00:12:35'),
(5, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-27 00:30:29'),
(6, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-27 00:36:13'),
(7, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 11:36:07'),
(8, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 11:46:54'),
(9, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 14:20:03'),
(10, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 14:28:17'),
(11, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 15:00:10'),
(12, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 22:04:18'),
(13, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 22:05:57'),
(14, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 22:28:16'),
(15, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 22:30:22'),
(16, 22, '127.0.0.1', 'Unknown', 'Unknown', '2020-06-28 22:33:28');

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

--
-- Dumping data for table `lumber`
--

INSERT INTO `lumber` (`id`, `treeX`, `treeY`, `treeZ`, `treeRX`, `treeRY`, `treeRZ`) VALUES
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
(3, 5846, 1480.02, -1754.43, 13.5469, 0, 0, -82.5, '{000000}Kantor Pemerintah Eternity Legend', 24);

--
-- Dumping data for table `pengambilan_sim`
--

INSERT INTO `pengambilan_sim` (`id`, `id_user`, `tanggal_buat`, `tanggal_ambil`, `status_teori`) VALUES
(1, 22, '2020-05-26 12:54:01', '2020-05-26 13:24:01', NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tempat_atm`
--

INSERT INTO `tempat_atm` (`id`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`) VALUES
(1, 825.349, -1385.69, 13.3079, 0, 0, 1.74972),
(2, 834.154, -1392.16, 13.2094, 0, 0, 95.021);

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
(30, 22, NULL, -1000, '2020-05-26 14:16:14', 'Penarikan uang'),
(31, 22, NULL, -250, '2020-05-30 14:23:01', 'biaya perbaikan Windsor'),
(32, 22, NULL, -250, '2020-05-31 11:42:41', 'biaya perbaikan FCR-900'),
(33, 22, NULL, -200, '2020-05-31 14:22:52', 'Pembelian Air Minum Mineral sebanyak 100'),
(34, 22, NULL, -100, '2020-06-01 23:34:43', 'Pembelian Air Minum Mineral sebanyak 50'),
(35, 22, NULL, -32, '2020-06-01 23:37:04', 'Pembelian Air Minum Mineral sebanyak 16');

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `password`, `current_skin`, `jumlah_login`, `join_date`, `uang`, `jenis_kelamin`, `email`, `account_status`, `last_x`, `last_y`, `last_z`, `last_a`, `last_int`, `last_vw`, `nomor_handphone`, `use_phone`, `rekening`, `save_house`, `last_hp`, `last_armour`, `last_stats_makan`, `last_stats_minum`, `playtime`, `in_house`) VALUES
(22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 28, 348, '2020-04-24 21:12:03', 102529, 0, 'nathan@gmail.com', 0, '837.304321', '-1476.358276', '14.382813', '192.141724', '0', '0', '621234', 4, '12345678', 2, 60, 0, 80, 17.5, 93334, 0),
(23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', 100, 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 19, 95, '2020-04-30 15:31:48', 174940, 0, 'natan@gmail.com', 0, '1014.401489', '-1690.642578', '14.590525', '31.962248', '0', '0', '629876', 1, NULL, 0, 56, 0, 80, 75.5, 408, 0),
(25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', 0, 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', 0, 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(27, 'cosiozo', 'EEF3ABEA0977171744D9AC2BF8A4761A389F8C55136BDC00B02E9E49524340B1', 9, 1, '2020-05-10 16:59:42', 100, 1, 'asd2@gmail.com', 0, '285.288879', '-1863.428467', '2.890330', '309.904419', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(28, 'cosine_xx', 'FE1F21653A573338CC45562B2F50BD5F0F4B5DBC7AE9E67DD7702A3FEA265DB2', 25, 3, '2020-05-13 14:14:19', 100, 0, 'natan@gmail.com', 0, '597.599731', '-1747.577515', '37.244843', '312.951660', '0', '0', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(29, 'xoxo', 'FC922095F45335113D9195483EA4E2F6CBA407DAB53BF08D7F1C8B58177FD0EB', 172, 2, '2020-05-23 17:35:10', 100, 1, 'xoxo@gmail.com', 0, '329.041931', '-1804.449341', '4.580854', '307.374207', '0', '0', '621234', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0),
(30, 'sin', '406F041ABFCF5AFC6A7A6A4FF6F7D4FAED5707AC7E4DD6A50B77950E19339215', 17, 2, '2020-05-26 20:05:42', 100, 0, 'fasda@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', '621234', 3, NULL, 0, 100, 0, 80, 80, NULL, 0);

--
-- Dumping data for table `user_furniture`
--

INSERT INTO `user_furniture` (`id`, `id_furniture`, `id_user`, `jumlah`) VALUES
(1, 1, 22, 3),
(2, 2, 22, 6);

--
-- Dumping data for table `user_item`
--

INSERT INTO `user_item` (`id_user_item`, `id_item`, `id_user`, `jumlah`, `kunci`) VALUES
(1, 1, 1, 2, 0),
(3, 2, 1, 4, 0),
(7, 3, 1, 1, 0),
(8, 4, 22, 0, 0),
(10, 1, 22, 0, 0),
(17, 2, 22, 0, 0),
(26, 1, 23, 8, 0),
(27, 1, 25, 2, 0),
(30, 1, 24, 0, 0),
(31, 5, 24, 8, 0),
(32, 3, 24, 1, 0),
(33, 6, 24, 14, 0),
(34, 7, 24, 1, 0),
(35, 5, 22, 1, 0),
(36, 6, 22, 0, 0),
(37, 7, 22, 0, 0),
(38, 8, 22, 0, 0),
(39, 11, 22, 0, 0),
(40, 12, 22, 20, 0),
(41, 9, 22, 3, 1),
(42, 10, 22, 2, 1),
(45, 14, 22, 0, 0),
(46, 13, 22, 28, 0),
(48, 3, 30, 0, 0),
(49, 22, 22, 0, 0),
(50, 17, 22, 2, 0),
(51, 25, 22, 56, 0),
(52, 26, 22, 7, 0),
(53, 27, 22, 6, 0),
(54, 28, 22, 4, 0);

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
(9, 29, 150, NULL);

--
-- Dumping data for table `user_skill`
--

INSERT INTO `user_skill` (`id`, `id_skill`, `id_user`, `exp`) VALUES
(1, 1, 22, 1523);

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
(42, 29, 172, 1),
(43, 30, 17, 1);

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `id_pemilik`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `paintjob`, `veh_mod_1`, `veh_mod_2`, `veh_mod_3`, `veh_mod_4`, `veh_mod_5`, `veh_mod_6`, `veh_mod_7`, `veh_mod_8`, `veh_mod_9`, `veh_mod_10`, `veh_mod_11`, `veh_mod_12`, `veh_mod_13`, `veh_mod_14`, `darah`, `is_reparasi`) VALUES
(1, 22, 555, 833.193, -1474.54, 12.694, 176.966, 3, 3, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0),
(2, 22, 521, 1013.37, -1634.85, 13.0879, 22.0688, 6, 6, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0);

--
-- Dumping data for table `vehicle_dealer`
--

INSERT INTO `vehicle_dealer` (`id`, `id_model`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color_1`, `color_2`, `harga`) VALUES
(1, 415, 530.936, -1291.21, 17.014, 357.776, 0, 0, 10000);

--
-- Dumping data for table `vehicle_keys`
--

INSERT INTO `vehicle_keys` (`id`, `id_user`, `id_vehicle`, `expired`) VALUES
(1, 24, 2, 1591199673);

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `house_interior`
--
ALTER TABLE `house_interior`
  ADD PRIMARY KEY (`id_level`);

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
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tempat_atm`
--
ALTER TABLE `tempat_atm`
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
-- AUTO_INCREMENT for table `house_interior`
--
ALTER TABLE `house_interior`
  MODIFY `id_level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `papan`
--
ALTER TABLE `papan`
  MODIFY `id_papan` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

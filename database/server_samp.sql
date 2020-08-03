-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 03, 2020 at 06:09 PM
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

DROP TABLE IF EXISTS `enter_exit`;
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
-- Table structure for table `faction`
--

DROP TABLE IF EXISTS `faction`;
CREATE TABLE `faction` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `nama_faction` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

DROP TABLE IF EXISTS `furniture`;
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

-- --------------------------------------------------------

--
-- Table structure for table `gaji`
--

DROP TABLE IF EXISTS `gaji`;
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

DROP TABLE IF EXISTS `house`;
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

DROP TABLE IF EXISTS `house_furniture`;
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

DROP TABLE IF EXISTS `house_interior`;
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

-- --------------------------------------------------------

--
-- Table structure for table `house_inv_item`
--

DROP TABLE IF EXISTS `house_inv_item`;
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

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `id_item` int(255) NOT NULL,
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
(11, 'Perunggu', 2936, 'Perunggu adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL, 2, 3),
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
(43, 'Roti - Umpan Ikan', 19883, 'Roti - Umpan Ikan adalah umpan yang digunakan untuk memancing ikan.', 'pakaiUmpanIkan', 1, 1),
(44, 'Bensin 20 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 20 liter', 'pakaiBensin', 2, 2),
(45, 'Bensin 50 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 50 liter', 'pakaiBensin', 3, 2),
(46, 'Bensin 100 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 100 liter', 'pakaiBensin', 4, 2),
(47, 'SIM B', 1581, 'SIM B sebagai identitas kelayakan mengendarai kendaraan berupa mobil penumpang atau barang.', NULL, 1, 2),
(48, 'SIM C', 1581, 'SIM C sebagai identitas kelayakan mengendarai kendaraan berupa motor.', NULL, 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `item_rarity`
--

DROP TABLE IF EXISTS `item_rarity`;
CREATE TABLE `item_rarity` (
  `id` tinyint(2) UNSIGNED NOT NULL,
  `nama_rarity` varchar(50) NOT NULL,
  `hex_color` varchar(14) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

DROP TABLE IF EXISTS `item_sp`;
CREATE TABLE `item_sp` (
  `id` int(11) UNSIGNED NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Callback public function untuk dipanggil saat menggunakan item',
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

DROP TABLE IF EXISTS `jenis_blocked`;
CREATE TABLE `jenis_blocked` (
  `id` tinyint(1) UNSIGNED NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `logs_user_konek`
--

DROP TABLE IF EXISTS `logs_user_konek`;
CREATE TABLE `logs_user_konek` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `ip` varchar(50) NOT NULL,
  `kota` varchar(255) NOT NULL,
  `negara` varchar(255) NOT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `lumber`
--

DROP TABLE IF EXISTS `lumber`;
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

DROP TABLE IF EXISTS `papan`;
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

DROP TABLE IF EXISTS `pengambilan_ktp`;
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

DROP TABLE IF EXISTS `pengambilan_sim`;
CREATE TABLE `pengambilan_sim` (
  `id` bigint(20) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime NOT NULL,
  `tanggal_ambil` datetime NOT NULL,
  `tipe_sim` tinyint(1) DEFAULT NULL,
  `status_teori` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
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

DROP TABLE IF EXISTS `sms`;
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
-- Table structure for table `tempat_atm`
--

DROP TABLE IF EXISTS `tempat_atm`;
CREATE TABLE `tempat_atm` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `toko_perabot`
--

DROP TABLE IF EXISTS `toko_perabot`;
CREATE TABLE `toko_perabot` (
  `id` bigint(20) NOT NULL,
  `text_toko` text DEFAULT NULL,
  `posisi_x` float NOT NULL,
  `posisi_y` float NOT NULL,
  `posisi_z` float NOT NULL,
  `posisi_vw` int(11) DEFAULT NULL,
  `posisi_int` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `toko_perabot_item`
--

DROP TABLE IF EXISTS `toko_perabot_item`;
CREATE TABLE `toko_perabot_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_furniture` bigint(20) NOT NULL,
  `id_toko_perabot` bigint(20) NOT NULL,
  `harga` bigint(50) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `trans_atm`
--

DROP TABLE IF EXISTS `trans_atm`;
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
(30, 22, NULL, -1000, '2020-05-26 14:16:14', 'Penarikan uang'),
(31, 22, NULL, -250, '2020-05-30 14:23:01', 'biaya perbaikan Windsor'),
(32, 22, NULL, -250, '2020-05-31 11:42:41', 'biaya perbaikan FCR-900'),
(33, 22, NULL, -200, '2020-05-31 14:22:52', 'Pembelian Air Minum Mineral sebanyak 100'),
(34, 22, NULL, -100, '2020-06-01 23:34:43', 'Pembelian Air Minum Mineral sebanyak 50'),
(35, 22, NULL, -32, '2020-06-01 23:37:04', 'Pembelian Air Minum Mineral sebanyak 16'),
(36, 24, NULL, 10000, '2020-07-14 22:50:01', 'Deposit tabungan'),
(37, 24, NULL, -1000, '2020-07-14 22:50:25', 'Pembelian Savanna dari dealer'),
(38, 22, NULL, -1000, '2020-07-31 21:22:55', 'Pembelian Stratum dari dealer');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
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
  `masa_aktif_nomor` datetime DEFAULT NULL COMMENT 'Berisi masa aktif nomor hp pemain',
  `use_phone` bigint(20) UNSIGNED DEFAULT 0 COMMENT 'Berisi id_item (handphone) bukan id_user_item',
  `rekening` varchar(50) DEFAULT NULL COMMENT 'Berisi nomor rekening player',
  `save_house` int(11) NOT NULL DEFAULT 0,
  `last_hp` float DEFAULT NULL COMMENT 'Berisi jumlah hp pemain',
  `last_armour` float DEFAULT NULL COMMENT 'Berisi jumlah armour pemain',
  `last_stats_makan` float DEFAULT NULL COMMENT 'Berisi jumlah status makan',
  `last_stats_minum` float DEFAULT NULL COMMENT 'Berisi jumlah status minum',
  `playtime` bigint(20) DEFAULT NULL COMMENT 'Berisi jumlah waktu bermain dalam detik',
  `in_house` bigint(20) DEFAULT 0 COMMENT 'ID rumah yang sedang di kunjungi',
  `login_attempt` tinyint(1) DEFAULT 0 COMMENT 'Attempt yang terjadi pada login sebelumnya'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `password`, `current_skin`, `jumlah_login`, `join_date`, `uang`, `jenis_kelamin`, `email`, `account_status`, `last_x`, `last_y`, `last_z`, `last_a`, `last_int`, `last_vw`, `nomor_handphone`, `masa_aktif_nomor`, `use_phone`, `rekening`, `save_house`, `last_hp`, `last_armour`, `last_stats_makan`, `last_stats_minum`, `playtime`, `in_house`, `login_attempt`) VALUES
(22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 28, 457, '2020-04-24 21:12:03', 106043, 0, 'nathan@gmail.com', 0, '1691.275635', '-1618.101074', '13.382813', '191.118088', '0', '0', '621234', '2020-08-20 16:31:12', 4, '12345678', 2, 95, 0, 61, 58.5, 128818, 0, 0),
(23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', 100, 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 19, 105, '2020-04-30 15:31:48', 154815, 0, 'natan@gmail.com', 0, '1480.604614', '-1652.693726', '13.292188', '264.581512', '0', '0', '629876', NULL, 3, '12345671', 0, 95, 0, 80, 37, 5245, 0, 0),
(25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', 0, 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', 0, 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(27, 'cosiozo', 'EEF3ABEA0977171744D9AC2BF8A4761A389F8C55136BDC00B02E9E49524340B1', 9, 1, '2020-05-10 16:59:42', 100, 1, 'asd2@gmail.com', 0, '285.288879', '-1863.428467', '2.890330', '309.904419', '0', '0', NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(28, 'cosine_xx', 'FE1F21653A573338CC45562B2F50BD5F0F4B5DBC7AE9E67DD7702A3FEA265DB2', 25, 3, '2020-05-13 14:14:19', 100, 0, 'natan@gmail.com', 0, '597.599731', '-1747.577515', '37.244843', '312.951660', '0', '0', NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(29, 'xoxo', 'FC922095F45335113D9195483EA4E2F6CBA407DAB53BF08D7F1C8B58177FD0EB', 172, 2, '2020-05-23 17:35:10', 100, 1, 'xoxo@gmail.com', 0, '329.041931', '-1804.449341', '4.580854', '307.374207', '0', '0', '621234', NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 0, 0),
(30, 'sin', '406F041ABFCF5AFC6A7A6A4FF6F7D4FAED5707AC7E4DD6A50B77950E19339215', 17, 2, '2020-05-26 20:05:42', 100, 0, 'fasda@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', '621234', NULL, 3, NULL, 0, 100, 0, 80, 80, NULL, 0, 0),
(31, 'sors', 'F73EBB3BBF72A9E75B5C4676A2313AC1BE6CF8B14F4749E03EAA38924F04E646', 41, 1, '2020-07-16 11:43:58', 100, 1, 'asd@gmail.com', 0, '289.497101', '-1963.463501', '2.463300', '356.134369', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 80, 79, 9, 0, 0),
(32, 'sorse', '488C5AA934DBD590833909689E833E7BE7AD1DDAD40BF0AD5730C38317B0C27B', 21, 1, '2020-07-16 11:44:43', 100, 0, 'ads@gmail.com', 0, '1668.485474', '-2319.720215', '13.382813', '271.152710', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 80, 78.5, 16, 0, 0),
(33, 'cosinuszz', '7CF2E85D8734E1AEE3B99349E3F7BCCE92DC85634D0C479EA2D56247381170D4', 20, 2, '2020-07-31 18:42:40', 8600, 0, 'fasdmas@gmail.com', 0, '1435.767212', '-1437.876587', '25.185537', '86.357544', '0', '0', NULL, NULL, 0, NULL, 0, 100, 0, 79, 78, 117, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_blocked`
--

DROP TABLE IF EXISTS `user_blocked`;
CREATE TABLE `user_blocked` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `jenis_block` tinyint(1) NOT NULL COMMENT 'Jenis Block yang didapat oleh user',
  `happen` datetime DEFAULT NULL COMMENT 'Tanggal terjadi block',
  `expired` datetime DEFAULT NULL COMMENT 'Expired Block',
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_faction`
--

DROP TABLE IF EXISTS `user_faction`;
CREATE TABLE `user_faction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_faction` tinyint(3) UNSIGNED NOT NULL COMMENT 'Tipe Job Pemain :',
  `id_user` bigint(20) NOT NULL,
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `expired` datetime DEFAULT NULL COMMENT 'Expired jika masa kerja temporary'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_furniture`
--

DROP TABLE IF EXISTS `user_furniture`;
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

DROP TABLE IF EXISTS `user_item`;
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

DROP TABLE IF EXISTS `user_item_limit`;
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
(8, 30, 150, NULL),
(9, 29, 150, NULL),
(10, 31, 150, NULL),
(11, 32, 150, NULL),
(12, 33, 150, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_item_sp`
--

DROP TABLE IF EXISTS `user_item_sp`;
CREATE TABLE `user_item_sp` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_item_sp` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `expired` datetime DEFAULT NULL COMMENT 'Permanen = NULL\r\nTidak Permanen =Terisi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_skill`
--

DROP TABLE IF EXISTS `user_skill`;
CREATE TABLE `user_skill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_skill` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `exp` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Pada skill kita tidak memakai level, tapi exp.\r\nDimana pembagian melalui exp.\r\nMisalnya exp  >= 1000 maka di asumsikan dia ada level 1 atau jika exp >= 2000 maka level 2, dst\r\n\r\n',
  `is_active` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Status pada skill :\r\n0 - Tidak Aktif\r\n1 - Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_skin`
--

DROP TABLE IF EXISTS `user_skin`;
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

DROP TABLE IF EXISTS `vehicle`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_components`
--

DROP TABLE IF EXISTS `vehicle_components`;
CREATE TABLE `vehicle_components` (
  `componentid` smallint(4) UNSIGNED NOT NULL,
  `part` enum('Exhausts','Front Bullbars','Front Bumper','Hood','Hydraulics','Lights','Misc','Rear Bullbars','Rear Bumper','Roof','Side Skirts','Spoilers','Vents','Wheels') DEFAULT NULL,
  `type` varchar(22) NOT NULL,
  `cars` smallint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

DROP TABLE IF EXISTS `vehicle_dealer`;
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

DROP TABLE IF EXISTS `vehicle_keys`;
CREATE TABLE `vehicle_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `expired` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Gunakan unix timestamp untuk menyimpan maupun query'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_model_parts`
--

DROP TABLE IF EXISTS `vehicle_model_parts`;
CREATE TABLE `vehicle_model_parts` (
  `modelid` smallint(3) UNSIGNED NOT NULL,
  `parts` bit(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `enter_exit`
--
ALTER TABLE `enter_exit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faction`
--
ALTER TABLE `faction`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `item_rarity`
--
ALTER TABLE `item_rarity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item_sp`
--
ALTER TABLE `item_sp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jenis_blocked`
--
ALTER TABLE `jenis_blocked`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_user_konek`
--
ALTER TABLE `logs_user_konek`
  ADD PRIMARY KEY (`id`);

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

--
-- Indexes for table `tempat_atm`
--
ALTER TABLE `tempat_atm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `toko_perabot`
--
ALTER TABLE `toko_perabot`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `toko_perabot_item`
--
ALTER TABLE `toko_perabot_item`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `user_blocked`
--
ALTER TABLE `user_blocked`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_faction`
--
ALTER TABLE `user_faction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_furniture`
--
ALTER TABLE `user_furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_item`
--
ALTER TABLE `user_item`
  ADD PRIMARY KEY (`id_user_item`),
  ADD UNIQUE KEY `id_item` (`id_item`,`id_user`);

--
-- Indexes for table `user_item_limit`
--
ALTER TABLE `user_item_limit`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user_item_sp`
--
ALTER TABLE `user_item_sp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_skin`
--
ALTER TABLE `user_skin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_components`
--
ALTER TABLE `vehicle_components`
  ADD PRIMARY KEY (`componentid`),
  ADD KEY `cars` (`cars`),
  ADD KEY `part` (`part`),
  ADD KEY `type` (`type`);

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
-- Indexes for table `vehicle_model_parts`
--
ALTER TABLE `vehicle_model_parts`
  ADD PRIMARY KEY (`modelid`);

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
  MODIFY `id_gaji` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id_house` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `house_furniture`
--
ALTER TABLE `house_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `house_interior`
--
ALTER TABLE `house_interior`
  MODIFY `id_level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `house_inv_item`
--
ALTER TABLE `house_inv_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

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
  MODIFY `id` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs_user_konek`
--
ALTER TABLE `logs_user_konek`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `papan`
--
ALTER TABLE `papan`
  MODIFY `id_papan` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toko_perabot_item`
--
ALTER TABLE `toko_perabot_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trans_atm`
--
ALTER TABLE `trans_atm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player', AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `user_blocked`
--
ALTER TABLE `user_blocked`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_faction`
--
ALTER TABLE `user_faction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_furniture`
--
ALTER TABLE `user_furniture`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_item`
--
ALTER TABLE `user_item`
  MODIFY `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_item_limit`
--
ALTER TABLE `user_item_limit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_item_sp`
--
ALTER TABLE `user_item_sp`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_skill`
--
ALTER TABLE `user_skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_skin`
--
ALTER TABLE `user_skin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_dealer`
--
ALTER TABLE `vehicle_dealer`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_keys`
--
ALTER TABLE `vehicle_keys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

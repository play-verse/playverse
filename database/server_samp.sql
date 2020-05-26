-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2020 at 05:21 AM
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
(13, 'SIM', 1581, 'SIM sebagai identitas kelayakan berkendara.', NULL);

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
  `tanggal_ambil` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
  `save_house` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `user_item`
--

CREATE TABLE `user_item` (
  `id_user_item` bigint(20) UNSIGNED NOT NULL,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(255) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
-- Indexes for dumped tables
--

--
-- Indexes for table `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id_house`) USING BTREE;

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`) USING BTREE;

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
-- Indexes for table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`id_sms`) USING BTREE;

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
-- Indexes for table `user_item`
--
ALTER TABLE `user_item`
  ADD PRIMARY KEY (`id_user_item`) USING BTREE,
  ADD UNIQUE KEY `id_item` (`id_item`,`id_user`) USING BTREE;

--
-- Indexes for table `user_skin`
--
ALTER TABLE `user_skin`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id_house` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `pengambilan_ktp`
--
ALTER TABLE `pengambilan_ktp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengambilan_sim`
--
ALTER TABLE `pengambilan_sim`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sms`
--
ALTER TABLE `sms`
  MODIFY `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trans_atm`
--
ALTER TABLE `trans_atm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player';

--
-- AUTO_INCREMENT for table `user_item`
--
ALTER TABLE `user_item`
  MODIFY `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_skin`
--
ALTER TABLE `user_skin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

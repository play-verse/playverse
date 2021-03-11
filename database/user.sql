-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 11, 2021 at 04:18 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
  `admin_level` tinyint(1) UNSIGNED DEFAULT 0 COMMENT 'Menyimpan Level admin',
  `exp_score` bigint(20) DEFAULT 0,
  `score` bigint(20) DEFAULT 0,
  `masa_jamsos` datetime DEFAULT NULL,
  `last_stats_energi` float DEFAULT 100,
  `last_active` datetime DEFAULT NULL COMMENT 'Tanggal terakhir dia logout (terupdate jika hanya dia login)',
  `used_weapon` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `used_ammo` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `voice_mute` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `nama` (`nama`) USING BTREE,
  ADD UNIQUE KEY `rekening` (`rekening`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player';
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

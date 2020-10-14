-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2020 at 04:22 AM
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
-- Table structure for table `user_achievement`
--

CREATE TABLE `user_achievement` (
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `ikan_arwana` int(11) UNSIGNED DEFAULT 0,
  `ikan_kakap` int(11) UNSIGNED DEFAULT 0,
  `ikan_mas` int(11) UNSIGNED DEFAULT 0,
  `ikan_mujair` int(11) UNSIGNED DEFAULT 0,
  `ubur_ubur` int(11) UNSIGNED DEFAULT 0,
  `bintang_laut` int(11) UNSIGNED DEFAULT 0,
  `berlian` int(11) UNSIGNED DEFAULT 0,
  `emas` int(11) UNSIGNED DEFAULT 0,
  `aluminium` int(11) UNSIGNED DEFAULT 0,
  `perak` int(11) UNSIGNED DEFAULT 0,
  `besi` int(11) UNSIGNED DEFAULT 0,
  `kayu` int(11) UNSIGNED DEFAULT 0,
  `batu_bara` int(11) UNSIGNED DEFAULT 0,
  `batu_bata` int(11) UNSIGNED DEFAULT 0,
  `berlaut` int(11) UNSIGNED DEFAULT 0 COMMENT 'Memancing / Menombak',
  `bertambang` int(11) UNSIGNED DEFAULT 0 COMMENT 'Percobaan menggali'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `user_achievement`
--
ALTER TABLE `user_achievement`
  ADD PRIMARY KEY (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

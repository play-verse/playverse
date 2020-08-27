-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 27, 2020 at 03:34 PM
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

--
-- Dumping data for table `user_skill`
--

INSERT INTO `user_skill` (`id`, `id_skill`, `id_user`, `exp`, `is_active`) VALUES
(1, 1, 22, 8060, 1),
(7, 1, 24, 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_skill` (`id_skill`,`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user_skill`
--
ALTER TABLE `user_skill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

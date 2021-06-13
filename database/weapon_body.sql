-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 13, 2021 at 08:22 PM
-- Server version: 10.4.10-MariaDB
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
-- Table structure for table `weapon_body`
--

CREATE TABLE `weapon_body` (
  `id` int(11) NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `bone_status` int(11) NOT NULL DEFAULT 0 COMMENT 'Status 0 = default, jika 1 = custom',
  `bone_topX` float NOT NULL DEFAULT 0,
  `bone_topY` float NOT NULL DEFAULT 0,
  `bone_topZ` float NOT NULL DEFAULT 0,
  `bone_topRX` float NOT NULL DEFAULT 0,
  `bone_topRY` float NOT NULL DEFAULT 0,
  `bone_topRZ` float NOT NULL DEFAULT 0,
  `bone_bottomX` float NOT NULL DEFAULT 0,
  `bone_bottomY` float NOT NULL DEFAULT 0,
  `bone_bottomZ` float NOT NULL DEFAULT 0,
  `bone_bottomRX` float NOT NULL DEFAULT 0,
  `bone_bottomRY` float NOT NULL DEFAULT 0,
  `bone_bottomRZ` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `weapon_body`
--
ALTER TABLE `weapon_body`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `weapon_body`
--
ALTER TABLE `weapon_body`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

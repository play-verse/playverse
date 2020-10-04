-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 03, 2020 at 11:59 AM
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

DELIMITER $$
CREATE DEFINER=CURRENT_USER PROCEDURE `tambah_item_vehicle`(`x_id_vehicle` INT, `x_id_item` INT, `x_jumlah` INT)
BEGIN
	SELECT jumlah, id INTO @jumlah, @id_item_vehicle FROM `vehicle_item` WHERE `id_item` = `x_id_item` AND `id_vehicle` = `x_id_vehicle`;
	IF(ROW_COUNT()) THEN
		IF(x_jumlah < 0 AND (@jumlah + x_jumlah) < 1) THEN
			DELETE FROM `vehicle_item` WHERE `id` = @id_item_vehicle;
		ELSE
			UPDATE `vehicle_item` SET `jumlah` = `jumlah` + `x_jumlah` WHERE `id` = @id_item_vehicle;
		END IF;
	ELSE
		INSERT INTO `vehicle_item`(id_item, id_vehicle, jumlah) VALUES(`x_id_item`, `x_id_vehicle`, `x_jumlah`); 
	END IF;
END$$
DELIMITER ;

--
-- Database: `server_samp`
--

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_item`
--

CREATE TABLE `vehicle_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_item` int(11) UNSIGNED NOT NULL,
  `id_vehicle` bigint(20) NOT NULL,
  `jumlah` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vehicle_item`
--

INSERT INTO `vehicle_item` (`id`, `id_item`, `id_vehicle`, `jumlah`) VALUES
(1, 28, 10, 2),
(2, 25, 10, 0),
(3, 26, 10, 10),
(4, 30, 10, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `vehicle_item`
--
ALTER TABLE `vehicle_item`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_item` (`id_item`,`id_vehicle`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `vehicle_item`
--
ALTER TABLE `vehicle_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

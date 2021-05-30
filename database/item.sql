-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 30, 2021 at 03:27 AM
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
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id_item` int(11) NOT NULL,
  `nama_item` varchar(255) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `fungsi` varchar(100) DEFAULT NULL COMMENT 'Berisi public function yang akan di trigger saat pemilihan use item, pada item tersebut.',
  `kapasitas` int(11) NOT NULL DEFAULT 1 COMMENT 'Berisi kapasistas yang dibutuhkan untuk satu barang',
  `id_rarity` tinyint(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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
(11, 'Aluminium', 2936, 'Aluminium adalah item yang bagus dan diminati, berguna untuk banyak hal.', NULL, 2, 3),
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
(33, 'Bibit Kangkung Ijo', 756, 'Biji  Kangkung Ijo adalah bibit terlarang yang dapat ditanam dan tumbuh menjadi Kangkung Ijo.', 'pakaiBibitGanja', 9, 1),
(34, 'Kangkung Ijo', 19473, 'Kangkung Ijo adalah item terlarang yang dapat menambahkan Darah Putih sebesar 5 persen.', 'pakaiNarkoGanja', 1, 2),
(35, 'Joran Pancing', 18632, 'Joran Pancing adalah peralatan untuk memancing ikan.', 'pakaiJoranPancing', 1, 1),
(36, 'Tombak Ikan', 11716, 'Tombak Ikan adalah peralatan untuk memancing ikan, tingkat keberuntungan +14 persen.', 'pakaiTombakIkan', 1, 1),
(37, 'Ikan Arwana', 1600, 'Ikan Arwana adalah ikan yang sangat langka, memiliki nilai yang sangat tinggi.', NULL, 1, 1),
(38, 'Ikan Kakap', 1604, 'Ikan Kakap adalah ikan yang langka, berguna untuk banyak hal.', NULL, 1, 1),
(39, 'Ikan Mas', 1599, 'Ikan Mas adalah hasil mancing yang mirip dengan Ikan Mujair tapi lebih bagus.', NULL, 1, 1),
(40, 'Ikan Mujair', 19630, 'Ikan Mujair adalah ikan yang berguna dan juga diminati orang banyak.', NULL, 1, 1),
(41, 'Ubur-ubur', 1603, 'Ubur-ubur adalah ikan yang bagus dan diminati.', NULL, 1, 1),
(42, 'Bintang Laut', 902, 'Bintang Laut adalah ikan yang bagus dan diminati.', NULL, 1, 1),
(43, 'Roti - Umpan Ikan', 19883, 'Roti - Umpan Ikan adalah umpan yang digunakan untuk memancing ikan.', NULL, 1, 1),
(44, 'Bensin 20 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 20 liter', 'pakaiBensin', 2, 2),
(45, 'Bensin 50 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 50 liter', 'pakaiBensin', 3, 2),
(46, 'Bensin 100 Liter', 1650, 'Dapat menambahkan bensin kendaraan anda sebanyak 100 liter', 'pakaiBensin', 4, 2),
(47, 'SIM B', 1581, 'SIM B sebagai identitas kelayakan mengendarai kendaraan berupa mobil penumpang atau barang.', NULL, 1, 2),
(48, 'SIM C', 1581, 'SIM C sebagai identitas kelayakan mengendarai kendaraan berupa motor.', NULL, 2, 2),
(49, 'Helm', 18645, 'Helm digunakan saat mengendarai motor. Note: Saat menggunakan helm anda tidak dapat dikenali oleh orang.', 'pakaiHelm', 3, 3),
(50, 'Topeng', 19037, 'Topeng digunakan untuk menutup wajah anda sehingga tidak dikenali oleh orang.', 'pakaiHelm', 3, 3),
(51, 'Ultimate Parts', 3096, 'Bisa anda gunakan untuk ditukarkan dengan jenis part/paintjob/warna apapun', NULL, 5, 5),
(52, 'Bubuk Herbal', 863, 'Dapat digunakan untuk membuat obat herbal revive.', NULL, 2, 2),
(53, 'Obat Herbal Revive', 1240, 'Dapat digunakan untuk menyelematkan orang sekarat.', NULL, 3, 3),
(54, 'Medical Kit 50', 11738, 'Dapat digunakan untuk menambah darah sebanyak 50 persen.', NULL, 5, 3),
(55, 'Medical Kit 100', 11738, 'Dapat digunakan untuk menambah darah sebanyak 100 persen.', NULL, 7, 3),
(56, 'Pil Darah Merah 20', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 20 persen.', 'pakaiPilMerah', 2, 3),
(57, 'Pil Darah Merah 50', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 50 persen.', 'pakaiPilMerah', 3, 3),
(58, 'Pil Darah Merah 100', 1241, 'Dapat digunakan untuk menambah darah secara instant sebanyak 100 persen.', 'pakaiPilMerah', 4, 3),
(59, 'Pil Darah Putih 20', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 20 persen.', 'pakaiPilPutih', 4, 3),
(60, 'Pil Darah Putih 50', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 50 persen.', 'pakaiPilPutih', 4, 3),
(61, 'Pil Darah Putih 100', 1241, 'Dapat digunakan untuk menambah armour secara instant sebanyak 100 persen.', 'pakaiPilPutih', 4, 3),
(62, 'Forger Case', 2780, 'Bahan utama yang dibutuhkan untuk dapat memulai skill Blacksmith.', NULL, 5, 5),
(63, 'Bijih Besi', 3117, 'Bijih besi merupakan material untuk membuat besi utuh.', NULL, 1, 2),
(64, 'Besi', 3117, 'Besi digunakan oleh banyak item sebagai material baku.', NULL, 3, 2),
(65, 'Serbuk Emas', 19941, 'Serbuk emas merupakan material untuk membuat emas utuh.', NULL, 1, 3),
(66, 'Bijih Perak', 16134, 'Bahan dasar pembuat perak.', NULL, 1, 2),
(67, 'Serbuk Berlian', 1559, 'Bahan dasar pembuat berlian.', NULL, 1, 3),
(68, 'Bijih Aluminium', 2936, 'Bahan dasar pembuat aluminium.', NULL, 1, 2),
(69, 'Batu Bata', 11708, 'Bahan tambang yang berguna.', NULL, 1, 2),
(70, 'Batu Bara', 11708, 'Bahan tambang yang berguna.', NULL, 1, 2),
(71, 'Bibit Jahe', 756, 'Biji Jahe adalah item pertanian yang dapat ditanam dan tumbuh menjadi Jahe.', 'pakaiBibitJahe', 9, 1),
(72, 'Bibit Temulawak', 756, 'Biji Temulawak adalah item pertanian yang dapat ditanam dan tumbuh menjadi Temulawak.', 'pakaiBibitTemulawak', 9, 1),
(73, 'Bibit Alpukat', 756, 'Biji Alpukat adalah item pertanian yang dapat ditanam dan tumbuh menjadi Alpukat.', 'pakaiBibitAlpukat', 9, 1),
(74, 'Bibit Pepaya', 756, 'Biji Pepaya adalah item pertanian yang dapat ditanam dan tumbuh menjadi Pepaya.', 'pakaiBibitPepaya', 9, 1),
(75, 'Bibit Belimbing', 756, 'Biji Belimbing adalah item pertanian yang dapat ditanam dan tumbuh menjadi Belimbing.', 'pakaiBibitBelimbing', 9, 1),
(76, 'Bibit Srikaya', 756, 'Biji Srikaya adalah item pertanian yang dapat ditanam dan tumbuh menjadi Srikaya.', 'pakaiBibitSrikaya', 9, 1),
(77, 'Jahe', 18631, 'Jahe adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(78, 'Temulawak', 18631, 'Temulawak adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(79, 'Alpukat', 18631, 'Alpukat adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(80, 'Pepaya', 18631, 'Pepaya adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(81, 'Belimbing', 18631, 'Belimbing adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(82, 'Srikaya', 18631, 'Srikaya adalah adalah buah hasil panen dengan banyak manfaat bagi kesehatan.', NULL, 1, 1),
(83, 'GPS', 19167, 'Dapat digunakan berkali-kali untuk menunjukan lokasi dari suatu tempat.', 'pakaiGps', 4, 4),
(84, 'Bibit Labu', 756, 'Item spesial halloween yang dapat kamu tanam.', 'pakaiBibitLabu', 9, 1),
(85, 'Labu', 18631, 'Item spesial halloween yang dapat dijual ataupun dimakan.', 'pakaiLabu', 1, 1),
(86, 'Colt 45', 346, 'Pistol yang digunakan oleh tentara US jaman dahulu.', 'pakaiWeapon', 5, 4),
(87, 'Silenced Colt 45', 347, 'Pistol dengan peredam yang digunakan oleh tentara US jaman dahulu.', 'pakaiWeapon', 5, 4),
(88, 'Deagle', 348, 'Pistol dengan peluru yang mematikan', 'pakaiWeapon', 5, 4),
(89, 'Shotgun', 349, 'Shotgun memiliki peluru yang menyebar saat ditembakan.', 'pakaiWeapon', 10, 4),
(90, 'Sawnoff SG', 350, 'Shotgun dengan fire speed yang cocok digunakan untuk dual.', 'pakaiWeapon', 10, 4),
(91, 'Combat SG', 351, 'Shotgun dengan fire speed dan ammo yang cocok digunakan untuk berperang.', 'pakaiWeapon', 10, 4),
(92, 'Uzi', 352, 'Senjata berjenis SMG yang sering digunakan untuk jarak dekat.', 'pakaiWeapon', 8, 4),
(93, 'MP5', 353, 'Senjata berjenis SMG yang mempunyai kestabilan tinggi.', 'pakaiWeapon', 8, 4),
(94, 'Tec-9', 372, 'Senjata berjenis SMG yang mempunyai damage dan firespeed yang tinggi.', 'pakaiWeapon', 8, 4),
(95, 'AK-47', 355, 'Senjata berjenis Assault dengan damage yang luar biasa.', 'pakaiWeapon', 15, 4),
(96, 'M4', 356, 'Senjata berjenis Assault dengan damage yang kuat dan akurasi tinggi.', 'pakaiWeapon', 15, 4),
(97, 'Ammo 4,5MM', 2061, 'Amunisi dengan ukuran 4,5 MM.', 'pakaiAmmo', 1, 3),
(98, 'Ammo Bold 7,5MM', 2061, 'Amunisi tebal dengan ukuran 7,5 MM.', 'pakaiAmmo', 2, 3),
(99, 'Ammo 12,5MM', 2061, 'Amunisi dengan ukuran 12,5 MM.', 'pakaiAmmo', 1, 3),
(100, 'Tazer Pulse', 347, 'Senjata berjenis Electric dengan daya kejut listrik yang cukup kuat dan akurasi yang tinggi.', 'pakaiWeapon', 15, 4),
(101, 'Ammo Electro', 2061, 'Amunisi dengan daya listrik.', 'pakaiAmmo', 2, 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id_item`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

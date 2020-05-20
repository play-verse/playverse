/*
 Navicat Premium Data Transfer

 Source Server         : Mysql
 Source Server Type    : MySQL
 Source Server Version : 100408
 Source Host           : localhost:3306
 Source Schema         : server_samp

 Target Server Type    : MySQL
 Target Server Version : 100408
 File Encoding         : 65001

 Date: 20/05/2020 23:04:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for house
-- ----------------------------
DROP TABLE IF EXISTS `house`;
CREATE TABLE `house`  (
  `id_house` int(20) NOT NULL AUTO_INCREMENT,
  `id_user` int(20) NOT NULL DEFAULT -1,
  `level` int(11) NOT NULL DEFAULT 1,
  `harga` int(20) NOT NULL,
  `kunci` int(11) NOT NULL DEFAULT 1,
  `jual` int(11) NOT NULL DEFAULT 1,
  `icon_x` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `icon_y` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `icon_z` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_house`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of house
-- ----------------------------
INSERT INTO `house` VALUES (1, 24, 3, 10000, 1, 0, '841.189392', '-1471.353149', '14.312580');
INSERT INTO `house` VALUES (2, 22, 1, 100, 1, 0, '822.442566', '-1505.515015', '14.397550');

-- ----------------------------
-- Table structure for item
-- ----------------------------
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item`  (
  `id_item` int(255) NOT NULL AUTO_INCREMENT,
  `nama_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model_id` int(11) NULL DEFAULT NULL,
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `fungsi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Berisi public function yang akan di trigger saat pemilihan use item, pada item tersebut.',
  PRIMARY KEY (`id_item`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of item
-- ----------------------------
INSERT INTO `item` VALUES (1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.', 'pakaiHpFromInven');
INSERT INTO `item` VALUES (2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.', 'pakaiHpFromInven');
INSERT INTO `item` VALUES (3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.', 'pakaiHpFromInven');
INSERT INTO `item` VALUES (4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.', 'pakaiHpFromInven');
INSERT INTO `item` VALUES (5, 'Pas Foto', 2281, 'Pas Foto untuk keperluan administrasi.', NULL);
INSERT INTO `item` VALUES (6, 'Materai', 2059, 'Materai untuk keperluan administrasi.', NULL);
INSERT INTO `item` VALUES (7, 'KTP', 1581, 'KTP sebagai identitas kewarganegaraan.', NULL);

-- ----------------------------
-- Table structure for pengambilan_ktp
-- ----------------------------
DROP TABLE IF EXISTS `pengambilan_ktp`;
CREATE TABLE `pengambilan_ktp`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) NOT NULL,
  `tanggal_buat` datetime(0) NOT NULL,
  `tanggal_ambil` datetime(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sms
-- ----------------------------
DROP TABLE IF EXISTS `sms`;
CREATE TABLE `sms`  (
  `id_sms` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user_pengirim` bigint(20) UNSIGNED NOT NULL,
  `id_user_penerima` bigint(20) UNSIGNED NOT NULL,
  `id_pemilik_pesan` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `pesan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `tanggal_dikirim` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id_sms`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sms
-- ----------------------------
INSERT INTO `sms` VALUES (3, 22, 24, 22, 'LASD LAJSDLKAJSLKAJ DAS KJQW \\nakj LKDSJ ASKLDJ ASD ', '2020-05-04 00:44:23');

-- ----------------------------
-- Table structure for trans_atm
-- ----------------------------
DROP TABLE IF EXISTS `trans_atm`;
CREATE TABLE `trans_atm`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) NOT NULL,
  `id_pengirim_penerima` bigint(20) NULL DEFAULT NULL COMMENT 'ID Pengirim berisi id pemain jika ada, jika tidak ada maka 0',
  `nominal` bigint(50) NULL DEFAULT NULL COMMENT 'Nominal bisa berisi minus juga',
  `tanggal` datetime(0) NOT NULL COMMENT 'Berisi tanggal transaksi',
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'Berisi keterangan dari pengirim',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trans_atm
-- ----------------------------
INSERT INTO `trans_atm` VALUES (1, 22, NULL, 2000, '2020-05-19 11:52:04', 'tes');
INSERT INTO `trans_atm` VALUES (2, 22, NULL, 10, '2020-05-19 12:20:34', 'Deposit tabungan');
INSERT INTO `trans_atm` VALUES (3, 22, NULL, -10, '2020-05-20 22:29:34', 'Penarikan uang');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player',
  `nama` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Nama Pemain',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Password pemain hash pakai SHA-256',
  `current_skin` int(10) NULL DEFAULT NULL COMMENT 'ID Skin yang sedang dipakai',
  `jumlah_login` int(50) NOT NULL DEFAULT 1 COMMENT 'Mencatat banyak player login',
  `join_date` datetime(0) NULL DEFAULT NULL COMMENT 'Tanggal Player Register',
  `uang` bigint(50) NULL DEFAULT 0 COMMENT 'Jumlah Uang Player',
  `jenis_kelamin` smallint(1) NULL DEFAULT NULL COMMENT '0 - Laki dan 1 - Perempuan',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Email player akan dilakukan aktivas email nantinya',
  `account_status` smallint(2) NULL DEFAULT NULL COMMENT '0 - Default, 1 - Email Pending, 2 - Activate, 3 - Banned',
  `last_x` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak posisi terakhir x',
  `last_y` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak posisi terakhir y',
  `last_z` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak posisi terakhir z',
  `last_a` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak posisi terakhir angle',
  `last_int` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak Interior',
  `last_vw` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Letak Virtual World',
  `nomor_handphone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Nomor HP Player, 1 player hanya 1 nomor HP',
  `use_phone` bigint(20) UNSIGNED NULL DEFAULT 0 COMMENT 'Berisi id_item (handphone) bukan id_user_item',
  `rekening` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Berisi nomor rekening player',
  `save_house` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `nama`(`nama`) USING BTREE,
  UNIQUE INDEX `rekening`(`rekening`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 125, 73, '2020-04-24 21:12:03', 370, 0, 'nathan@gmail.com', 0, '1414.218872', '-986.193054', '-55.276352', '261.726257', '1', '1', '621234', 4, '12345678', 0);
INSERT INTO `user` VALUES (23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', 100, 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0);
INSERT INTO `user` VALUES (24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 19, 91, '2020-04-30 15:31:48', 174940, 0, 'natan@gmail.com', 0, '1519.263184', '-1696.209229', '13.292188', '109.391800', '0', '0', '629876', 1, NULL, 0);
INSERT INTO `user` VALUES (25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', 0, 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, 0, NULL, 0);
INSERT INTO `user` VALUES (26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', 0, 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, 0, NULL, 0);
INSERT INTO `user` VALUES (27, 'cosiozo', 'EEF3ABEA0977171744D9AC2BF8A4761A389F8C55136BDC00B02E9E49524340B1', 9, 1, '2020-05-10 16:59:42', 100, 1, 'asd2@gmail.com', 0, '285.288879', '-1863.428467', '2.890330', '309.904419', '0', '0', NULL, 0, NULL, 0);
INSERT INTO `user` VALUES (28, 'cosine_xx', 'FE1F21653A573338CC45562B2F50BD5F0F4B5DBC7AE9E67DD7702A3FEA265DB2', 25, 3, '2020-05-13 14:14:19', 100, 0, 'natan@gmail.com', 0, '597.599731', '-1747.577515', '37.244843', '312.951660', '0', '0', NULL, 0, NULL, 0);

-- ----------------------------
-- Table structure for user_item
-- ----------------------------
DROP TABLE IF EXISTS `user_item`;
CREATE TABLE `user_item`  (
  `id_user_item` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_item` bigint(20) UNSIGNED NOT NULL,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(255) NULL DEFAULT 1,
  PRIMARY KEY (`id_user_item`) USING BTREE,
  UNIQUE INDEX `id_item`(`id_item`, `id_user`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_item
-- ----------------------------
INSERT INTO `user_item` VALUES (1, 1, 1, 2);
INSERT INTO `user_item` VALUES (3, 2, 1, 4);
INSERT INTO `user_item` VALUES (7, 3, 1, 1);
INSERT INTO `user_item` VALUES (8, 4, 22, 1);
INSERT INTO `user_item` VALUES (10, 1, 22, 3);
INSERT INTO `user_item` VALUES (17, 2, 22, 1);
INSERT INTO `user_item` VALUES (26, 1, 23, 8);
INSERT INTO `user_item` VALUES (27, 1, 25, 2);
INSERT INTO `user_item` VALUES (30, 1, 24, 0);
INSERT INTO `user_item` VALUES (31, 5, 24, 8);
INSERT INTO `user_item` VALUES (32, 3, 24, 1);
INSERT INTO `user_item` VALUES (33, 6, 24, 14);
INSERT INTO `user_item` VALUES (34, 7, 24, 1);
INSERT INTO `user_item` VALUES (35, 5, 22, 14);
INSERT INTO `user_item` VALUES (36, 6, 22, 6);
INSERT INTO `user_item` VALUES (37, 7, 22, 1);

-- ----------------------------
-- Table structure for user_skin
-- ----------------------------
DROP TABLE IF EXISTS `user_skin`;
CREATE TABLE `user_skin`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_skin` int(20) NOT NULL,
  `jumlah` int(10) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_skin
-- ----------------------------
INSERT INTO `user_skin` VALUES (31, 22, 125, 1);
INSERT INTO `user_skin` VALUES (32, 22, 28, 1);
INSERT INTO `user_skin` VALUES (33, 23, 24, 1);
INSERT INTO `user_skin` VALUES (34, 24, 21, 1);
INSERT INTO `user_skin` VALUES (35, 25, 76, 1);
INSERT INTO `user_skin` VALUES (36, 26, 298, 1);
INSERT INTO `user_skin` VALUES (37, 27, 9, 1);
INSERT INTO `user_skin` VALUES (38, 24, 73, 1);
INSERT INTO `user_skin` VALUES (39, 24, 17, 1);
INSERT INTO `user_skin` VALUES (40, 24, 19, 6);
INSERT INTO `user_skin` VALUES (41, 28, 25, 1);

-- ----------------------------
-- Procedure structure for tambah_item
-- ----------------------------
DROP PROCEDURE IF EXISTS `tambah_item`;
delimiter ;;
CREATE PROCEDURE `tambah_item`(`x_id_user` int,`x_id_item` int,`x_banyak_item` int)
BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for tambah_skin
-- ----------------------------
DROP PROCEDURE IF EXISTS `tambah_skin`;
delimiter ;;
CREATE PROCEDURE `tambah_skin`(`x_id_user` int,`x_id_skin` int,`x_banyak_skin` int)
BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for tambah_transaksi_atm
-- ----------------------------
DROP PROCEDURE IF EXISTS `tambah_transaksi_atm`;
delimiter ;;
CREATE PROCEDURE `tambah_transaksi_atm`(`rekening_pengirim` varchar(50),`rekening_penerima` varchar(50),`ex_nominal` bigint,`ex_keterangan` text)
BEGIN
	INSERT INTO `trans_atm`(id_user, id_pengirim_penerima, nominal, tanggal, keterangan) 
	SELECT a.id as id_user, b.id as id_pengirim_penerima, ex_nominal as nominal, NOW() as tanggal, ex_keterangan as keterangan FROM `user` a
	LEFT JOIN `user` b ON b.rekening = rekening_pengirim WHERE a.rekening = rekening_penerima;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

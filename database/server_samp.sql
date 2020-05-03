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

 Date: 03/05/2020 21:48:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for item
-- ----------------------------
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item`  (
  `id_item` int(255) NOT NULL AUTO_INCREMENT,
  `nama_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model_id` int(11) NULL DEFAULT NULL,
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id_item`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of item
-- ----------------------------
INSERT INTO `item` VALUES (1, 'ePhone 1', 18874, 'Dapat digunakan untuk PM, BC, SMS.');
INSERT INTO `item` VALUES (2, 'ePhone 2', 18872, 'Dapat digunakan untuk PM, BC, SMS, Shareloc.');
INSERT INTO `item` VALUES (3, 'ePhone 3', 18870, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking.');
INSERT INTO `item` VALUES (4, 'ePhone 4', 18867, 'Dapat digunakan untuk PM, BC, SMS, Shareloc, ATM-Banking, Marketplace.');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player',
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Nama Pemain',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Password pemain hash pakai SHA-256',
  `current_skin` int(10) NULL DEFAULT NULL COMMENT 'ID Skin yang sedang dipakai',
  `jumlah_login` int(50) NOT NULL DEFAULT 1 COMMENT 'Mencatat banyak player login',
  `join_date` datetime(0) NULL DEFAULT NULL COMMENT 'Tanggal Player Register',
  `uang` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Jumlah Uang Player',
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 125, 46, '2020-04-24 21:12:03', '0', 0, 'nathan@gmail.com', 0, '835.376709', '-1895.104736', '12.867188', '269.074280', '0', '0', '621234', 4);
INSERT INTO `user` VALUES (23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', '100', 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `user` VALUES (24, 'cosine', '2308812CE036BE27F4D6818D366094F107A5DB381F4B91973A7A4F6DA4AE1557', 21, 27, '2020-04-30 15:31:48', '0', 0, 'natan@gmail.com', 0, '156.119431', '-1926.437134', '3.773438', '344.008118', '0', '0', NULL, 0);
INSERT INTO `user` VALUES (25, 'cosines', '9E3645C36D5625B86030BC447A51771E48B0C1D82360E4FCFD15AE896407663B', 76, 4, '2020-05-03 01:51:46', '0', 1, 'nathan@gmail.com', 0, '299.019104', '-2026.331421', '1.413125', '1.111884', '0', '0', NULL, 0);
INSERT INTO `user` VALUES (26, 'cosinec', '4673452E1D20E8417166B9FF852DC48246F1D1D24FD11076976A3DCB4307675B', 298, 3, '2020-05-03 16:56:12', '0', 1, 'nathan@gmail.com', 0, '188.238831', '-1935.149414', '-0.552782', '273.730988', '0', '0', NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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

-- ----------------------------
-- Table structure for user_skin
-- ----------------------------
DROP TABLE IF EXISTS `user_skin`;
CREATE TABLE `user_skin`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` bigint(20) UNSIGNED NOT NULL,
  `id_skin` int(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_skin
-- ----------------------------
INSERT INTO `user_skin` VALUES (31, 22, 125);
INSERT INTO `user_skin` VALUES (32, 22, 28);
INSERT INTO `user_skin` VALUES (33, 23, 24);
INSERT INTO `user_skin` VALUES (34, 24, 21);
INSERT INTO `user_skin` VALUES (35, 25, 76);
INSERT INTO `user_skin` VALUES (36, 26, 298);

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

SET FOREIGN_KEY_CHECKS = 1;

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

 Date: 30/04/2020 00:40:23
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
-- Table structure for nomor_handphone
-- ----------------------------
DROP TABLE IF EXISTS `nomor_handphone`;
CREATE TABLE `nomor_handphone`  (
  `id_nomor` int(255) NOT NULL AUTO_INCREMENT,
  `nomor_handphone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_user` int(255) NOT NULL,
  PRIMARY KEY (`id_nomor`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Player',
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
  `use_phone` int(255) NULL DEFAULT 0 COMMENT 'Berisi id_item (handphone) bukan id_user_item',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (22, 'cosinus', '6E1789AD7F6CFF1BAF1DA2A6B7745F9F6CA6F0F3CCDBA5C97FC40EB22EF7793C', 125, 41, '2020-04-24 21:12:03', '100', 0, 'nathan@gmail.com', 0, '290.565094', '-1874.325317', '6.402288', '22.307587', '0', '0', '621234', 1);
INSERT INTO `user` VALUES (23, 'Anxitail', '465EBC8A47CC6776C8131DC0EA4EA26B621D72E4B86852B0D51F7A14ACBBA214', 24, 1, '2020-04-25 16:48:59', '100', 0, 'kolak@gmail.com', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for user_item
-- ----------------------------
DROP TABLE IF EXISTS `user_item`;
CREATE TABLE `user_item`  (
  `id_user_item` int(11) NOT NULL AUTO_INCREMENT,
  `id_item` int(255) NOT NULL,
  `id_user` int(255) NOT NULL,
  `jumlah` int(255) NULL DEFAULT 1,
  PRIMARY KEY (`id_user_item`) USING BTREE,
  UNIQUE INDEX `id_item`(`id_item`, `id_user`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_item
-- ----------------------------
INSERT INTO `user_item` VALUES (1, 1, 1, 2);
INSERT INTO `user_item` VALUES (3, 2, 1, 4);
INSERT INTO `user_item` VALUES (7, 3, 1, 1);
INSERT INTO `user_item` VALUES (8, 4, 22, 2);
INSERT INTO `user_item` VALUES (10, 1, 22, 1);

-- ----------------------------
-- Table structure for user_skin
-- ----------------------------
DROP TABLE IF EXISTS `user_skin`;
CREATE TABLE `user_skin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(255) NOT NULL,
  `id_skin` int(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_skin
-- ----------------------------
INSERT INTO `user_skin` VALUES (31, 22, 125);
INSERT INTO `user_skin` VALUES (32, 22, 28);
INSERT INTO `user_skin` VALUES (33, 23, 24);

SET FOREIGN_KEY_CHECKS = 1;

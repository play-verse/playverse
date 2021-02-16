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

 Date: 17/02/2021 02:36:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for setup
-- ----------------------------
DROP TABLE IF EXISTS `setup`;
CREATE TABLE `setup`  (
  `nama_setup` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipe_value` int(11) NOT NULL COMMENT '1: Integer\r\n2: Float\r\n3: String\r\n>4: Ukuran Text',
  `value_integer` int(11) NULL DEFAULT NULL,
  `value_float` float NULL DEFAULT NULL,
  `value_string` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `value_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`nama_setup`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of setup
-- ----------------------------
INSERT INTO `setup` VALUES ('GAJI_MONTIR_LISTRIK', 1, 15, NULL, NULL, NULL, 'Gaji minimal per checkpoint');
INSERT INTO `setup` VALUES ('GAJI_PIZZABOY', 1, 15, NULL, NULL, NULL, 'Gaji minimal per checkpoint');
INSERT INTO `setup` VALUES ('GAJI_SWEEPER', 1, 127, NULL, NULL, NULL, 'Gaji setelah selesai semua pekerjaan.');
INSERT INTO `setup` VALUES ('GAJI_TRASHMASTER', 1, 20, NULL, NULL, NULL, 'Gaji minimal per checkpoint');
INSERT INTO `setup` VALUES ('TAGIHAN_DENDA_SEWA_KENDARAAN', 1, 25, NULL, NULL, NULL, 'Tagihan yang dikenakan saat kendaran sewa rusak.');
INSERT INTO `setup` VALUES ('TAGIHAN_MATI_RS', 1, 600, NULL, NULL, NULL, 'Tagihan yang dikenakan saat mati dan masuk rumah sakit.');
INSERT INTO `setup` VALUES ('TAGIHAN_REVIVE', 1, 400, NULL, NULL, NULL, 'Tagihan yang dikenakan saat di revive medic on duty.');

SET FOREIGN_KEY_CHECKS = 1;

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

 Date: 31/01/2021 22:59:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for item_sp
-- ----------------------------
DROP TABLE IF EXISTS `item_sp`;
CREATE TABLE `item_sp`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model_id` int(11) NULL DEFAULT NULL,
  `fungsi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Callback public function untuk dipanggil saat menggunakan item',
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `id_rarity` tinyint(3) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_item_sp
-- ----------------------------
DROP TABLE IF EXISTS `user_item_sp`;
CREATE TABLE `user_item_sp`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_item_sp` int(11) NOT NULL,
  `id_user` bigint(20) NOT NULL,
  `original_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Original Pemilik (Berguna untuk KTP, dan sebagainya)',
  `original_created` datetime(0) NOT NULL COMMENT 'Created Date',
  `amount` int(11) NOT NULL DEFAULT 0 COMMENT 'Extra Amount Field (berguna untuk senjata)',
  `expired` datetime(0) NULL DEFAULT NULL COMMENT 'Permanen = NULL\r\nTidak Permanen =Terisi',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

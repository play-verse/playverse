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

 Date: 20/06/2020 00:43:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tempat_atm
-- ----------------------------
DROP TABLE IF EXISTS `tempat_atm`;
CREATE TABLE `tempat_atm`  (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tempat_atm
-- ----------------------------
INSERT INTO `tempat_atm` VALUES (1, 825.349, -1385.69, 13.3079, 0, 0, 1.74972);
INSERT INTO `tempat_atm` VALUES (2, 834.154, -1392.16, 13.2094, 0, 0, 95.021);

SET FOREIGN_KEY_CHECKS = 1;

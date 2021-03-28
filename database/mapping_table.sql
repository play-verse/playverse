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

 Date: 28/03/2021 14:51:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mapping
-- ----------------------------
DROP TABLE IF EXISTS `mapping`;
CREATE TABLE `mapping`  (
  `mapping_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `object_id` int(11) NOT NULL,
  `pos_x` float NULL DEFAULT 0,
  `pos_y` float NULL DEFAULT 0,
  `pos_z` float NULL DEFAULT 0,
  `rot_x` float NULL DEFAULT 0,
  `rot_y` float NULL DEFAULT 0,
  `rot_z` float NULL DEFAULT 0,
  `radius` float NULL DEFAULT 0,
  `is_object` tinyint(1) NULL DEFAULT 1 COMMENT '0: RemoveBuildingForPlayer\r\n1: CreateDynamicObject'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mapping_parent
-- ----------------------------
DROP TABLE IF EXISTS `mapping_parent`;
CREATE TABLE `mapping_parent`  (
  `mapping_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `loaded` tinyint(1) NULL DEFAULT 0,
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `last_update` datetime(0) NULL DEFAULT current_timestamp(0),
  PRIMARY KEY (`mapping_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

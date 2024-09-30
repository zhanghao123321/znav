/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.222.173
 Source Server Type    : MySQL
 Source Server Version : 80400 (8.4.0)
 Source Host           : 192.168.222.173:3306
 Source Schema         : lsky

 Target Server Type    : MySQL
 Target Server Version : 80400 (8.4.0)
 File Encoding         : 65001

 Date: 30/09/2024 16:37:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for albums
-- ----------------------------
DROP TABLE IF EXISTS `albums`;
CREATE TABLE `albums`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `intro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '简介',
  `image_num` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片数量',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `albums_user_id_foreign`(`user_id` ASC) USING BTREE,
  CONSTRAINT `albums_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of albums
-- ----------------------------

-- ----------------------------
-- Table structure for configs
-- ----------------------------
DROP TABLE IF EXISTS `configs`;
CREATE TABLE `configs`  (
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置值',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE INDEX `configs_name_unique`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of configs
-- ----------------------------
INSERT INTO `configs` VALUES ('app_name', 'Lsky Pro', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('app_version', 'V 2.1', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('icp_no', '', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('is_allow_guest_upload', '0', '2024-09-30 13:43:40', '2024-09-30 13:47:00');
INSERT INTO `configs` VALUES ('is_enable_api', '1', '2024-09-30 13:43:40', '2024-09-30 13:47:00');
INSERT INTO `configs` VALUES ('is_enable_gallery', '1', '2024-09-30 13:43:40', '2024-09-30 13:47:00');
INSERT INTO `configs` VALUES ('is_enable_registration', '0', '2024-09-30 13:43:40', '2024-09-30 13:47:00');
INSERT INTO `configs` VALUES ('is_user_need_verify', '0', '2024-09-30 13:43:40', '2024-09-30 13:47:00');
INSERT INTO `configs` VALUES ('mail', '{\"default\":\"smtp\",\"mailers\":{\"smtp\":{\"smtp\":\"smtp\",\"host\":\"smtp.mailgun.org\",\"port\":587,\"encryption\":\"tls\",\"username\":\"\",\"password\":\"\",\"timeout\":null}}}', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('site_description', 'Lsky Pro, Your photo album on the cloud.', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('site_keywords', 'Lsky Pro,lsky,兰空图床', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('site_notice', '', '2024-09-30 13:43:40', '2024-09-30 13:43:40');
INSERT INTO `configs` VALUES ('user_initial_capacity', '512000', '2024-09-30 13:43:40', '2024-09-30 13:43:40');

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `failed_jobs_uuid_unique`(`uuid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for group_strategy
-- ----------------------------
DROP TABLE IF EXISTS `group_strategy`;
CREATE TABLE `group_strategy`  (
  `group_id` bigint UNSIGNED NOT NULL COMMENT '角色组',
  `strategy_id` bigint UNSIGNED NOT NULL COMMENT '策略',
  INDEX `group_strategy_group_id_foreign`(`group_id` ASC) USING BTREE,
  INDEX `group_strategy_strategy_id_foreign`(`strategy_id` ASC) USING BTREE,
  CONSTRAINT `group_strategy_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `group_strategy_strategy_id_foreign` FOREIGN KEY (`strategy_id`) REFERENCES `strategies` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_strategy
-- ----------------------------
INSERT INTO `group_strategy` VALUES (1, 1);

-- ----------------------------
-- Table structure for groups
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色组名称',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认',
  `is_guest` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为游客组',
  `configs` json NOT NULL COMMENT '组配置',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of groups
-- ----------------------------
INSERT INTO `groups` VALUES (1, '系统默认组&游客组', 1, 1, '{\"scan_configs\": {\"driver\": \"tencent\", \"drivers\": {\"aliyun\": {\"scenes\": [\"porn\"], \"biz_type\": \"\", \"region_id\": \"\", \"access_key_id\": \"\", \"access_key_secret\": \"\"}, \"nsfwjs\": {\"api_url\": \"\", \"attr_name\": \"image\", \"threshold\": 60}, \"tencent\": {\"region\": \"\", \"biz_type\": \"\", \"endpoint\": \"ims.tencentcloudapi.com\", \"secret_id\": \"\", \"secret_key\": \"\"}}}, \"limit_per_day\": 300, \"is_enable_scan\": 0, \"limit_per_hour\": 100, \"limit_per_week\": 600, \"scanned_action\": \"mark\", \"image_cache_ttl\": 2626560, \"limit_per_month\": 999, \"file_naming_rule\": \"{uniqid}\", \"limit_per_minute\": 20, \"path_naming_rule\": \"{Y}/{m}/{d}\", \"image_save_format\": \"\", \"maximum_file_size\": 5120, \"watermark_configs\": {\"mode\": 1, \"driver\": \"font\", \"drivers\": {\"font\": {\"x\": 10, \"y\": 10, \"font\": \"\", \"size\": 50, \"text\": \"Lsky Pro\", \"angle\": 0, \"color\": \"#000000\", \"position\": \"bottom-right\"}, \"image\": {\"x\": 10, \"y\": 10, \"image\": \"\", \"width\": 0, \"height\": 0, \"rotate\": 0, \"opacity\": 100, \"position\": \"bottom-right\"}}}, \"image_save_quality\": 100, \"is_enable_watermark\": 0, \"concurrent_upload_num\": 3, \"accepted_file_suffixes\": [\"jpeg\", \"jpg\", \"png\", \"gif\", \"tif\", \"bmp\", \"ico\", \"psd\", \"webp\"], \"is_enable_original_protection\": 0}', '2024-09-30 13:43:40', '2024-09-30 13:43:40');

-- ----------------------------
-- Table structure for images
-- ----------------------------
DROP TABLE IF EXISTS `images`;
CREATE TABLE `images`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '用户',
  `album_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '相册',
  `group_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '角色组',
  `strategy_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '策略',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'key',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保存路径',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保存名称',
  `origin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原始名称',
  `alias_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '别名',
  `size` decimal(8, 2) NOT NULL DEFAULT 0.00 COMMENT '图片大小(kb)',
  `mimetype` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `extension` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件后缀',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件MD5',
  `sha1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件SHA1',
  `width` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '宽',
  `height` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '高',
  `permission` tinyint NOT NULL DEFAULT 0 COMMENT '访问权限',
  `is_unhealthy` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为不健康的',
  `uploaded_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上传IP',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `images_key_unique`(`key` ASC) USING BTREE,
  INDEX `images_user_id_foreign`(`user_id` ASC) USING BTREE,
  INDEX `images_album_id_foreign`(`album_id` ASC) USING BTREE,
  INDEX `images_group_id_foreign`(`group_id` ASC) USING BTREE,
  INDEX `images_strategy_id_foreign`(`strategy_id` ASC) USING BTREE,
  CONSTRAINT `images_album_id_foreign` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `images_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `images_strategy_id_foreign` FOREIGN KEY (`strategy_id`) REFERENCES `strategies` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `images_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of images
-- ----------------------------
INSERT INTO `images` VALUES (1, 1, NULL, 1, 1, 'aAh5jc', '2024/09/30', '66fa3cb191b7f.jpg', '头像1.jpg', '', 74.08, 'image/jpeg', 'jpg', '9097da272986e8d3724c0c4053da3da7', '917c864cf878b2b3ce1f0afba278abd8f4ce4a21', 1427, 1427, 1, 0, '192.168.28.166', '2024-09-30 13:52:49', '2024-09-30 13:52:49');
INSERT INTO `images` VALUES (2, 1, NULL, 1, 1, 'pvB2LP', '2024/09/30', '66fa3ecac91b4.jpg', '头像2.jpg', '', 41.88, 'image/jpeg', 'jpg', '0ca298f1ba95fbd1969d138afa81e51a', '120de7d65f3053925b10b75d40f68208d63764ea', 640, 640, 1, 0, '192.168.28.166', '2024-09-30 14:01:46', '2024-09-30 14:01:46');
INSERT INTO `images` VALUES (34, 1, NULL, 1, 1, 'vmUc5h', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:18', '2024-09-30 16:03:18');
INSERT INTO `images` VALUES (35, 1, NULL, 1, 1, 'kajpoW', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:19', '2024-09-30 16:03:19');
INSERT INTO `images` VALUES (36, 1, NULL, 1, 1, 'jX4Tlw', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:24', '2024-09-30 16:03:24');
INSERT INTO `images` VALUES (37, 1, NULL, 1, 1, 'ICQJOB', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:33', '2024-09-30 16:03:33');
INSERT INTO `images` VALUES (38, 1, NULL, 1, 1, 'qJGn7w', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:35', '2024-09-30 16:03:35');
INSERT INTO `images` VALUES (39, 1, NULL, 1, 1, 'K8asCS', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:41', '2024-09-30 16:03:41');
INSERT INTO `images` VALUES (40, 1, NULL, 1, 1, 'W6F5bK', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:03:43', '2024-09-30 16:03:43');
INSERT INTO `images` VALUES (41, 1, NULL, 1, 1, 'fyittZ', '2024/09/30', '66fa5e8eead71.png', 'icon.png', '', 3.28, 'image/png', 'png', 'ba9cda2b06bc7b0f139a25f919d2fb04', 'aaf5d87174e6c3a7837e09fd59917cffe8d511b9', 141, 79, 1, 0, '192.168.28.166', '2024-09-30 16:17:18', '2024-09-30 16:17:18');
INSERT INTO `images` VALUES (42, 1, NULL, 1, 1, 'tihj98', '2024/09/30', '66fa5e8eead71.png', 'icon.png', '', 3.28, 'image/png', 'png', 'ba9cda2b06bc7b0f139a25f919d2fb04', 'aaf5d87174e6c3a7837e09fd59917cffe8d511b9', 141, 79, 1, 0, '192.168.28.166', '2024-09-30 16:17:24', '2024-09-30 16:17:24');
INSERT INTO `images` VALUES (43, 1, NULL, 1, 1, 'dPhLnG', '2024/09/30', '66fa5b461d0cd.png', 'icon.png', '', 0.85, 'image/png', 'png', 'f4959574ded7a35ba0fb20d6b8ca26c6', '9fd063fa5e47f6d7b400df4d87fd854d0de358ab', 32, 32, 1, 0, '192.168.28.166', '2024-09-30 16:21:24', '2024-09-30 16:21:24');

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of migrations
-- ----------------------------
INSERT INTO `migrations` VALUES (1, '2014_10_10_000000_create_groups_table', 1);
INSERT INTO `migrations` VALUES (2, '2014_10_12_000000_create_users_table', 1);
INSERT INTO `migrations` VALUES (3, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO `migrations` VALUES (4, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO `migrations` VALUES (5, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO `migrations` VALUES (6, '2021_12_11_184521_create_strategies_table', 1);
INSERT INTO `migrations` VALUES (7, '2021_12_11_185759_create_albums_table', 1);
INSERT INTO `migrations` VALUES (8, '2021_12_11_191158_create_images_table', 1);
INSERT INTO `migrations` VALUES (9, '2021_12_11_200033_create_configs_table', 1);
INSERT INTO `migrations` VALUES (10, '2022_01_20_201231_create_group_strategy_table', 1);

-- ----------------------------
-- Table structure for password_resets
-- ----------------------------
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets`  (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  INDEX `password_resets_email_index`(`email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of password_resets
-- ----------------------------

-- ----------------------------
-- Table structure for personal_access_tokens
-- ----------------------------
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `personal_access_tokens_token_unique`(`token` ASC) USING BTREE,
  INDEX `personal_access_tokens_tokenable_type_tokenable_id_index`(`tokenable_type` ASC, `tokenable_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of personal_access_tokens
-- ----------------------------
INSERT INTO `personal_access_tokens` VALUES (1, 'App\\Models\\User', 1, 'zh@qq.com', '6ab5f6bb069d8620b87d3d462b9af50414eaf83300a8dbc2d6e606d7bd6d07d4', '[\"*\"]', NULL, '2024-09-30 13:56:39', '2024-09-30 13:56:39');
INSERT INTO `personal_access_tokens` VALUES (2, 'App\\Models\\User', 1, 'zh@qq.com', 'c6bf7db07d7eb33619de228dc7f61b94930e07eaa71a877a3bcca14652257904', '[\"*\"]', '2024-09-30 16:21:24', '2024-09-30 14:01:03', '2024-09-30 16:21:24');

-- ----------------------------
-- Table structure for strategies
-- ----------------------------
DROP TABLE IF EXISTS `strategies`;
CREATE TABLE `strategies`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` tinyint UNSIGNED NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '策略名称',
  `intro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '简介',
  `configs` json NOT NULL COMMENT '策略配置',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of strategies
-- ----------------------------
INSERT INTO `strategies` VALUES (1, 1, '默认本地策略', '系统默认的本地策略', '{\"url\": \"http://192.168.222.173:12345/i\", \"root\": \"/var/www/html/storage/app/uploads\", \"driver\": \"local\", \"visibility\": \"public\"}', '2024-09-30 13:43:40', '2024-09-30 13:43:40');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '角色组',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_adminer` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为管理员',
  `capacity` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '总容量(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '个人主页',
  `configs` json NOT NULL COMMENT '配置',
  `image_num` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片数量',
  `album_num` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '相册数量',
  `registered_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '注册IP',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `users_email_unique`(`email` ASC) USING BTREE,
  INDEX `users_group_id_foreign`(`group_id` ASC) USING BTREE,
  CONSTRAINT `users_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 1, '超级管理员', 'zh@qq.com', '$2y$10$yaOJL4xKbw6rPnRiyYeXKuUSOzNV9I4FqqFEnoW7Kb397DnhPOFC6', 'SJWcYIJH0RdSOeU3QviGdgEmlpcDhTZbjG2ePi53eFwxuefEwQjKRckBCRK9', 1, 512000.00, '', '{\"default_album\": 0, \"pasted_action\": 1, \"default_strategy\": 0, \"default_permission\": 1, \"is_auto_clear_preview\": 0}', 12, 0, '192.168.28.166', 1, '2024-09-30 13:43:40', '2024-09-30 13:43:40', '2024-09-30 16:21:24');

SET FOREIGN_KEY_CHECKS = 1;

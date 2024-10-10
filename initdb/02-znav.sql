/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.222.173
 Source Server Type    : MySQL
 Source Server Version : 80400 (8.4.0)
 Source Host           : 192.168.222.173:3306
 Source Schema         : znav

 Target Server Type    : MySQL
 Target Server Version : 80400 (8.4.0)
 File Encoding         : 65001

 Date: 10/10/2024 16:18:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for applications
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `icon` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `link` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `order_id` bigint NULL DEFAULT 0,
  `icon_color` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_menus_apps`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `fk_menus_apps` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 232 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of applications
-- ----------------------------
INSERT INTO `applications` VALUES (62, 'LINUX DO', 'https://pic2.ziyuan.wang/user/hozh/diy/icofolder/icon_58e05dfaee148.png', 'https://linux.do/', '真诚、友善、团结、专业，共建你我引以为荣之社区。', 'active', 42, '2024-09-02 09:02:48.686', '2024-10-10 16:08:02.979', -7, '#000000');
INSERT INTO `applications` VALUES (63, '水墨图床', 'https://img.ink/favicon.ico', 'https://img.ink/', '图片映客--水墨图床，免费专业的高速外链图床-免费高速图床-致力于创建一流的图片加速空间', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (64, 'ChatGPT', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/apple-touch-icon.82af6fe1_0add8de44f2d9.png', 'https://www.chatgpt.com/', 'ChatGPT 是OpenAI研发的一款聊天机器人程序', 'active', 42, '2024-09-02 09:02:48.686', '2024-09-25 15:06:52.375', -10, '#000000');
INSERT INTO `applications` VALUES (65, 'New API', 'https://pic2.ziyuan.wang/user/hozh/diy/icofolder/icon_2d18f2b7e080c.png', 'https://zh.hooz.fun/', 'OpenAI 接口聚合管理，支持多种渠道包括 Azure，可用于二次分发管理 key，仅单可执行文件，已打包好 Docker 镜像，一键部署，开箱即用', 'active', 42, '2024-09-02 09:02:48.686', '2024-10-10 16:15:03.945', -9, '#000000');
INSERT INTO `applications` VALUES (66, 'Claude', 'https://pic2.ziyuan.wang/user/hozh/diy/icofolder/icon_40ed4d522ab67.png', 'https://claude.ai/', 'Claude，美国人工智能初创公司Anthropic发布的大型语言模型家族', 'active', 44, '2024-09-02 09:02:48.686', '2024-10-10 16:08:19.082', 0, '#000000');
INSERT INTO `applications` VALUES (67, 'Kimi', 'https://statics.moonshot.cn/kimi-chat/favicon.ico', 'https://kimi.moonshot.cn/', 'Kimi 是一个有着超大“内存”的智能助手，可以一口气读完二十万字的小说，还会上网冲浪，快来跟他聊聊吧 | Kimi.ai - Moonshot AI 出品的智能助手', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-04 03:33:37.155', 0, '#000000');
INSERT INTO `applications` VALUES (68, 'ChatGLM', 'https://chatglm.cn/img/logo-collapse.d00ef130.svg', 'https://www.chatglm.cn/', 'ChatGLM是清华大学开发的,经过约1T标识符的中英双语训练,拥有62 亿参数的开源AI大语言模型,它能生成相当符合人类偏好的回答。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (69, '讯飞星火', 'https://xinghuo.xfyun.cn/spark-icon.ico', 'https://xinghuo.xfyun.cn/', '讯飞星火大模型，是由科大讯飞推出的新一代认知智能大模型，拥有跨领域的知识和语言理解能力，能够基于自然对话方式理解与执行任务，提供语言理解、知识问答、逻辑推理、数学题解答、代码理解与编写等多种能力。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (70, '文心一言', 'https://nlp-eb.cdn.bcebos.com/logo/favicon.ico', 'https://yiyan.baidu.com/', '文心一言（英文名：ERNIE Bot）是百度全新一代知识增强大语言模型，文心大模型家族的新成员，能够与人对话互动、回答问题、协助创作，高效便捷地帮助人们获取信息、知识和灵感。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (71, '小浣熊', 'https://raccoon-sta.sensetime.com/assets/web/logo.svg', 'https://raccoon.sensetime.com/', 'Raccoon - Another Comprehensive CO-pilOt Navigator ｜ Raccoon是基于商汤自研大语言模型的智能助手，包含代码助手、办公助手，满足用户代码编写、数据分析、编程学习等各类需求。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (72, '通义千问', 'https://img.alicdn.com/imgextra/i1/O1CN01AKUdEM1qP6BQVaYhT_!!6000000005487-2-tps-512-512.png', 'https://tongyi.aliyun.com/', '通义官网，致力于实现类人智慧的通用智能', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (73, 'SearchAI', 'https://isou.chat/favicon.ico', 'https://isou.chat/', 'Search with AI - Free and Open Source Search Engine, Open-Source Perplexity, Support Ollama/SearXNG.', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (74, '豆包', 'https://lf-flow-web-cdn.doubao.com/obj/flow-doubao/doubao/web/logo-icon.png', 'https://www.doubao.com/', '豆包是字节跳动公司基于云雀模型开发的AI工具，提供聊天机器人、写作助手以及英语学习助手等功能，它可以回答各种问题并进行对话，帮助人们获取信息，支持网页 Web 平台，iOS 以及安卓平台。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (75, '阿里云', 'https://img.alicdn.com/tfs/TB1_ZXuNcfpK1RjSZFOXXa6nFXa-32-32.ico', 'https://www.aliyun.com/', '阿里云——阿里巴巴集团旗下公司，是全球领先的云计算及人工智能科技公司之一。提供免费试用、云服务器、云数据库、云安全、云企业应用等云计算服务，以及大数据、人工智能服务、精准定制基于场景的行业解决方案。免费备案，7x24小时售后支持，助企业无忧上云。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (76, '腾讯云', 'https://cloudcache.tencent-cloud.com/qcloud/favicon.ico?t=201902181234', 'https://cloud.tencent.com/', '腾讯云(tencent cloud)为数百万的企业和开发者提供安全稳定的云计算服务，涵盖云服务器、云数据库、云存储、视频与CDN、域名注册等全方位云服务和各行业解决方案。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (77, '华为云', 'https://www.huaweicloud.com/favicon.ico', 'https://www.huaweicloud.com/', '华为云提供稳定可靠、安全可信、可持续发展的云服务，致力于让云无处不在，让智能无所不及，共建智能世界云底座。助力企业降本增效，全球300万客户的共同选择。7x24小时专业服务支持，5天内无理由退订，免费快速备案。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (78, '又拍云', 'https://pic2.ziyuan.wang/user/hozh/diy/icofolder/icon_4e5a35ec9cc30.png', 'https://console.upyun.com/', '又拍云是国内知名企业级云服务商、国家高新技术企业，持有工信部颁发的 CDN 牌照；致力于为客户提供一站式的在线业务加速服务。', 'active', 43, '2024-09-02 09:02:48.686', '2024-10-10 16:16:54.711', 0, '#000000');
INSERT INTO `applications` VALUES (79, 'AWS云服务', 'https://a0.awsstatic.com/libra-css/images/site/fav/favicon.ico', 'https://aws.amazon.com/cn/', 'Amazon Web Services 提供的云计算服务可靠、可扩展且费用合理。免费加入，只需按使用量付费。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (80, 'Oracle Cloud', 'https://signup.cloud.oracle.com/oraclefavicon.ico', 'https://signup.cloud.oracle.com/', 'Oracle Cloud Free Tier Signup', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (81, 'cloudflare', 'https://dash.cloudflare.com/favicon.ico', 'https://dash.cloudflare.com/', 'Cloudflare是比较出名的且少有能免费使用的美国CDN服务商。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (82, 'DNSPod', 'https://cloudcache.tencent-cloud.cn/open_proj/proj_qcloud_v2/tc-console/dnspod/gateway/css/img/dnspod.ico', 'https://www.dnspod.cn/', 'DNSPod是国内提供智能DNS产品的网站，致力于为各类网站提供高质量的电信、网通、教育网双线或者三线智能DNS免费解析。目前DNSPod已经是国内最大的免费DNS解析产品提供商', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (83, '零点云', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon_57f84af1f4630.ico', 'https://bdoos.com/', '欢迎来到零点云,我们为您敲开世界的大门', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (84, 'ChatGPT账号商店', 'https://chatgptid.net/favicon.ico', 'https://chatgptid.net/', '提供ChatGPT账号购买,ChatGPT账号,ChatGPT账号批发,OpenAI账号购买,Chatgpt api,Chatgpt api批发,Chatgpt api购买,OpenAI账号,OpenAI API,ChatGPT4,chatgpt key购买,chatgpt普号购买,chatgpt普号批发,Claude账号,Midjourney账号,专业ai批发平台!', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (85, '阿里云矢量图库', 'https://img.alicdn.com/imgextra/i4/O1CN01Z5paLz1O0zuCC7osS_!!6000000001644-55-tps-83-82.svg', 'https://www.iconfont.cn/', 'iconfont-国内功能很强大且图标内容很丰富的矢量图标库，提供矢量图标下载、在线存储、格式转换等功能。阿里巴巴体验团队倾力打造，设计和前端开发的便捷工具', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (86, '字节矢量图库', 'https://lf1-cdn2-tos.bytegoofy.com/bydesign/iconparksite/logo.svg', 'http://iconpark.oceanengine.com/home', 'IconPark图标库是一个通过技术驱动矢量图标样式的开源图标库', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (87, '阿里巴巴开源镜像站', 'https://img.alicdn.com/tfs/TB1_ZXuNcfpK1RjSZFOXXa6nFXa-32-32.ico', 'https://developer.aliyun.com/mirror/', '阿里巴巴开源镜像站，免费提供Linux镜像下载服务，拥有Ubuntu、CentOS、Deepin、MongoDB、Apache、Maven、Composer等多种开源软件镜像源，此外还提供域名解析DNS、网络授时NTP等服务，致力于为互联网用户提供全面，高效和稳定的基础服务。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (88, 'Gitee', 'https://gitee.com/favicon.ico', 'https://gitee.com/', '面向企业提供一站式研发管理解决方案，包括代码管理、项目管理、文档协作、测试管理、CICD、效能度量等多个模块，支持SaaS、私有化等多种部署方式，帮助企业有序规划和管理研发过程，提升研发效率和质量。', 'active', 67, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (89, 'GitHub', 'https://github.githubassets.com/favicons/favicon.png', 'https://github.com/', 'GitHub是一个面向开源及私有软件项目的托管平台，因为只支持Git作为唯一的版本库格式进行托管，故名GitHub。', 'active', 67, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (90, 'Apifox', 'https://cdn.apifox.com/logo/apifox-logo-256.png', 'https://app.apifox.com', 'Apifox是广州睿狐科技有限公司主办的信息服务系统网站，主要服务有API 文档，API 调试、API 数据 Mock、API 自动化测试，通过一套系统、一份数据，解决多个系统之间的数据同步问题。', 'active', 67, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (91, 'HelloGitHub', 'https://hellogithub.com/favicon/android-icon-192x192.png', 'https://hellogithub.com/', '分享 GitHub 上有趣、入门级的开源项目', 'active', 67, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (92, 'xshell', 'lucide:shell', 'https://www.xshell.com/zh/all-downloads/', 'Xshell 是一个强大的安全终端模拟软件', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-09 08:37:13.813', 1, '#9D2B2B');
INSERT INTO `applications` VALUES (93, '书栈网', 'https://www.bookstack.cn/favicon.ico', 'https://www.bookstack.cn/', '书栈网，IT程序员互联网开源编程书籍阅读分享，囊括小程序、前端、后端、移动端、云计算、大数据、区块链、机器学习、人工智能和面试笔试等相关书籍，助你【码】力十足！', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (94, '牛客网', 'https://static.nowcoder.com/fe/file/images/nowpick/web/www-favicon.ico', 'https://www.nowcoder.com/', '求职之前，先上牛客，就业找工作一站解决。互联网IT技术/产品/运营/硬件/汽车机械制造/金融/财务管理/审计/银行/市场营销/地产/快消/管培生等等专业技能学习/备考/求职神器，在线进行企业校招实习笔试面试真题模拟考试练习，全面提升求职竞争力，找到好工作，拿到好offer。_牛客网_牛客在手,offer不愁', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (95, 'CSDN', 'https://g.csdnimg.cn/static/logo/favicon32.ico', 'https://www.csdn.net/', 'CSDN是全球知名中文IT技术交流平台,创建于1999年,包含原创博客、精品问答、职业培训、技术论坛、资源下载等产品服务,提供原创、优质、完整内容的专业IT技术开发社区.', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (96, 'Leetcode', 'https://leetcode-cn.com/favicon.ico', 'https://leetcode-cn.com/', '力扣 LeetCode ，全球IT人才职业技能成长平台，提供海量技术面试资源，助你高效提升编程技能，轻松拿下IT名企DreamOffer。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (97, '掘金', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon-32x32_86d2aee69e67f.png', 'https://juejin.cn/', '掘金是一个帮助开发者成长的社区，是一个面向互联网技术人的内容分享平台。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (98, 'xiaoxuan6\'s 周刊', 'https://weekly.xiaoxuan6.cloudns.be/assets/images/favicon.png', 'https://weekly.xiaoxuan6.cloudns.be/', '记录我看到的有价值的信息，主要针对计算机领域，内容主题极大程度被我个人喜好主导。这个项目核心目的在于记录让自己有印象的信息做一个留存以及共享。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (99, '阮一峰周刊', 'https://www.ruanyifeng.com/favicon.ico', 'https://www.ruanyifeng.com/blog/', '这里记录每周值得分享的科技内容，周五发布。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (100, 'UI组件', 'https://uiverse.io/favicon-32x32.png', 'https://uiverse.io/', 'Library of free and customizable UI elements made with CSS or Tailwind. It\'s all open-source, and it\'s all free. Try it out to save you many hours spent on building & customizing UI components for your next project.', 'active', 68, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (101, '背景生成器', 'https://www.color4bg.com/static/images/favicon.ico', 'https://www.color4bg.com/zh-hans/quick-start/', '了解 Color4bg 如何为您的项目提供非凡的背景图像。易于使用，几秒钟内即可获得大量抽象的背景', 'active', 68, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (102, 'Open UI', 'https://open-ui.org/images/favicon-32x32.png', 'https://open-ui.org/', 'Open UI', 'active', 68, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (103, 'OpenTiny', 'https://res.hc-cdn.com/tinyui-design/1.0.7.20240711104855/home/favicon.ico', 'https://opentiny.design/', '华为云企业级前端开发解决方案', 'active', 68, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (104, '开源框架 ice', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon_444311065ab6b.ico', 'http://waitmoon.com/zh/', '致力于解决灵活繁复的硬编码问题', 'active', 69, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (105, 'JEECG', 'https://www.jeecg.com/favicon.ico', 'https://www.jeecg.com/', 'JeecgBoot低代码平台，基于SpringBoot+Ant Design的前后端分离微服务架构,集成完善的工作流平台、强大的代码生成器、流程设计器、表单设计器、大屏设计器、报表门户设计，可以应用在任何J2EE项目开发中，尤其适合企业信息管理系统（MIS）、办公系统（OA）、企业资源计划系统（ERP）、客户关系管理系统（CRM）等，其半智能+手工Merge的低代码开发方式，可以显著提高开发效率70%以上，极大降低研发成本。', 'active', 69, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (106, 'RuoYi', 'https://doc.ruoyi.vip/images/favicon.ico', 'https://doc.ruoyi.vip/', '使用若依快速构建web应用程序', 'active', 69, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (107, 'Next-Admin', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon_d75369ae17ca2.ico', 'http://next-admin.com/', '一款基于NextJS 14.0+ 和 antd5.0 开发的全栈开箱即用的多页面中后台管理解决方案', 'active', 68, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (108, '1Panel', 'https://www.fit2cloud.com/1panel/img/favicon.png', 'https://www.fit2cloud.com/1panel/index.html', '1Panel 是一个现代化、开源的 Linux 服务器运维管理面板。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (109, 'CloudExplorer', 'https://fit2cloud.com/cloudexplorer-lite/images/favicon.png', 'https://fit2cloud.com/cloudexplorer-lite/', 'CloudExplorer Lite 是一款开源的轻量级云管平台。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (110, 'WGCLOUD', 'https://www.wgstart.com/wgcloud/images/favicon-32x32.png', 'https://www.wgstart.com/', 'WGCLOUD是新一代运维监控系统，极简、轻量、高效，专注Linux、Windows等服务器主机的性能监测和健康分析，实时故障告警通知。WGCLOUD部署使用简单、分布式、开源、免注册、也可内网运行，完全私有化本地部署。我们的愿景是让运维工作简单高效，人人都可以零基础搭建自己的运维监控平台', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (111, 'Uptime Kuma', 'https://uptime.kuma.pet/img/icon.svg', 'https://uptime.kuma.pet/', 'uptime-kuma简介 uptime-kuma是一款开源的、多功能的服务器监控面板 。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (112, 'Tianji', 'https://tianji.msgbyte.com/img/favicon.ico', 'https://tianji.msgbyte.com/', 'Tianji = 网站分析+正常运行时间监控+服务器状态平台', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (113, 'Domain Admin', 'https://domain-admin.readthedocs.io/favicon.ico', 'https://domain-admin.readthedocs.io/zh-cn/latest/', 'Domain Admin基于Python + Vue3.js 技术栈实现的域名和SSL证书监测平台', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (114, 'Jpom项目运维', 'https://jpom.top/favicon.ico', 'https://jpom.top/', 'Jpom是一款简而轻的低侵入式在线构建、自动部署、日常运维、项目监控软件。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (115, 'Iconify Design', 'https://iconify.design/favicon.ico', 'https://iconify.design/', 'All popular icon sets, one framework', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-05 01:28:03.695', -10, '#000000');
INSERT INTO `applications` VALUES (116, 'JumpServer', 'https://www.fit2cloud.com/jumpserver/images/logo/favicon.ico', 'https://www.fit2cloud.com/jumpserver/index.html', 'JumpServer 是广受欢迎的开源堡垒机，是符合 4A 规范的专业运维安全审计系统。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (117, 'AWVS漏洞扫描', 'http://www.acunetix.com/favicon.ico', 'http://www.acunetix.com/', 'AWVS（Acunetix Web Vulnerability Scanner）是一款用于检测和评估Web应用程序安全漏洞的强大工具。Docker是一个开源的应用容器引擎，可以轻松创建、部署和运行应用程序。本文将介绍如何使用Docker来安装AWVS。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (118, '雷池', 'https://waf-ce.chaitin.cn/favicon.ico', 'https://waf-ce.chaitin.cn', '一款足够简单、好用、强大的免费WAF。基于业界领先的语义分析检测技术，保护你的网站不受黑客攻击。', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-06 02:31:51.854', 0, '#000000');
INSERT INTO `applications` VALUES (119, 'Teleport堡垒机', 'https://docs.tp4a.com/img/favicon.ico', 'https://docs.tp4a.com/', 'Teleport是一款简单易用的开源堡垒机系统', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (120, 'httpsok-SSL证书管理', 'https://httpsok.com/favicon.ico', 'https://httpsok.com/doc/', 'httpsok官方文档 httpsok.com 免费SSL证书 SSL免费证书申请 nginx证书 https证书 免费证书 证书一键续签', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (121, 'Idea激活码', 'https://33tool.com/_nuxt/icons/icon_64x64.4510fe.png', 'https://33tool.com/idea/', '本站提供Idea激活码,Idea注册码,PyCharm激活码,PyCharm注册码,WebStorm激活码,WebStorm注册码,jetbrains相关激活码。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (122, '花瓣网', 'https://huaban.com/favicon.ico', 'https://huaban.com/', '花瓣网, 设计师寻找灵感的天堂！图片素材领导者，帮你采集、发现网络上你喜欢的事物。你可以用它收集灵感,保存有用的素材,计划旅行,晒晒自己想要的东西', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (123, 'WPS学堂', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/learning_991b69d5661f2.png', 'https://www.wps.cn/learning/', 'WPS学堂是WPS官方Office 技巧免费学习平台,', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (124, 'ico图标生成器-标小智', 'https://www.logosc.cn/img/logo-icons/logosc-new.svg', 'https://www.logosc.cn/favicon-generator', '输入字母或者汉字一键生成透明ICO图标。免费下载多尺寸和分辨率的Favicon.ico图标自动为浏览器提供最佳适配版本的Favicon展示。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (125, 'Chrome极简插件', 'https://chrome.zzzmh.cn/favicon.ico', 'https://chrome.zzzmh.cn/#/index', '极简插件是一个优质Chrome插件下载商店，收录热门好用的Chrome插件扩展，国内最方便的Chrome插件下载网站。一键下载谷歌扩展插件，无套路下载插件。', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (126, '全民简历', 'https://www.qmjianli.com/favicon.ico', 'https://www.qmjianli.com/', '全民简历网是专业的在线简历制作、简历模板下载网站。提供大量原创设计的个人简历模板，包括各种职业和大学生简历模板，让求职者快速制作出高质量简历，服务超700万用户！', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (127, 'PDF转换工具', 'https://tools.pdf24.org/static/img/pageIcons/svg/default.svg?v=5cae54fd', 'https://tools.pdf24.org/zh/all-tools', 'PDF24提供大量的经过精心裁剪的针对特定问题的工具集合。您将在这个页面找到所有的PDF工具。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (128, 'ProcessOn思维导图', 'https://www.processon.com/public_login/favicon.983368c6.ico', 'https://www.processon.com/', 'ProcessOn是一款专业在线作图工具和知识分享社区，提供AI生成思维导图流程图。支持思维导图、流程图、组织结构图、网络拓扑图、鱼骨图、UML图等多种图形，同时可实现人与人之间的实时协作和共享，提升团队工作效率。', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (129, '哔哩哔哩', 'https://www.bilibili.com/favicon.ico', 'https://www.bilibili.com/', '哔哩哔哩（bilibili.com)是国内知名的视频弹幕网站，这里有及时的动漫新番，活跃的ACG氛围，有创意的Up主。大家可以在这里找到许多欢乐。', 'active', 49, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (130, '慕课网-程序员的梦工厂', 'https://www.imooc.com/static/img/common/touch-icon-ipad.png', 'https://www.imooc.com/', '慕课网是垂直的互联网IT技能学习网站，自2013年上线始终专注于IT在线教育领域，以培养互联网企业实用型人才为己任，邀请一线大厂技术达人打造前沿的IT技术精品课程，帮助每一位有志向的开发者实现职业梦想。', 'active', 49, '2024-09-02 09:02:48.686', '2024-09-06 02:36:40.940', 0, '#000000');
INSERT INTO `applications` VALUES (131, '极客网', 'https://www.fromgeek.com/favicon.ico', 'https://www.fromgeek.com/', '极客网以精选资讯和深度评论联接科技商业创新者、观察者和读者，探索科技创新在新商业变革中的角色和能量。', 'active', 49, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (132, 'w3cschool官网', 'https://7n.w3cschool.cn/statics/images/favicon.ico?v=2.2', 'https://www.w3cschool.cn/', 'w3cschool启用中文品牌名--编程狮，是一个专业的W3C前端开发及编程入门学习平台，提供包括HTML,CSS,Javascript,jQuery,C,PHP,Java,Python,Sql,Mysql等编程语言和开源技术的在线教程及使用手册，是类国外w3schools的W3C学习社区及菜鸟编程平台。', 'active', 49, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (134, '网易邮箱', 'https://email.163.com/favicon.ico', 'https://email.163.com/', '网易免费邮箱，你的专业电子邮局，提供以@163.com、@126.com和@yeah.net为后缀的免费邮箱。超过20年邮箱运营经验，系统快速稳定安全，支持超大附件和网盘服务。网易邮箱官方App“邮箱大师”帮您高效处理邮件，支持所有邮箱，并可在手机、Windows和Mac上多端协同使用。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-09 09:33:42.029', 0, '#000000');
INSERT INTO `applications` VALUES (135, '秘塔AI搜索', 'https://metaso.cn/favicon.ico', 'https://metaso.cn/', '秘塔AI搜索，没有广告，直达结果', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (136, 'huggingface', 'mdi:face-outline', 'https://huggingface.co/', 'huggingface 共同为大模型在垂直行业的应用提供平台产品和解决方案汇集人工智能行业上下游企业链,并积极与生态合作伙伴共同探索更多领域的落地应用.', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (137, '互连协议IP查询', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/logo_9d92bdd1d270d.png', 'https://www.cip.cc/', '查IP(www.cip.cc)网站, 提供免费的IP查询服务,命令行查询IP, 并且支持\'PC网站, 手机网站, 命令行(Windows/UNIX/Linux)\' 三大平台, 是个多平台的IP查询网站, 更新即使, 数据准确是我们的目标', 'active', 42, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -8, '#000000');
INSERT INTO `applications` VALUES (138, 'crontab时间计算', 'eos-icons:cronjob', 'https://tool.lu/crontab/', 'crontab执行时间计算', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-23 17:12:39.149', 0, '#0BCCD3');
INSERT INTO `applications` VALUES (139, 'DeepL翻译', 'https://static.deepl.com/img/favicon/favicon_16.png', 'https://www.deepl.com/zh/translator', '即时翻译文本&完整的文档文件。为个人和团队提供准确的翻译。每天有数百万人使用DeepL进行翻译。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (140, 'DuckDuck邮箱', 'https://duckduckgo.com/email/favicon.ico', 'https://duckduckgo.com/email/settings/autofill', 'DuckDuckGo是一个互联网搜索引擎', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (141, 'FOFA网络空间测绘', 'https://fofa.info/favicon.ico', 'https://fofa.info/', 'FOFA 是白帽汇推出的一款网络空间搜索引擎，它通过进行网络空间测绘，能够帮助研究人员或者企业迅速进行网络资产匹配，例如进行漏洞影响范围分析、应用分布统计、应用流行度排名统计等。', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (142, '霂明坊 - 创意工作者的优质论坛', 'https://mumingfang.com/favicon.ico', 'https://mumingfang.com/', '霂明坊是一个汇集了众多创意工作者的优质社区。在这里，你可以与其他创意工作者交流、分享和学习，共同成长', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (143, '临时邮箱生成', 'https://rootsh.com/favicon.ico', 'https://rootsh.com/', '免费的临时邮箱注册，接收。', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (144, '美国地址生成器', 'https://static11.meiguodizhi.com/favicon.ico', 'https://www.meiguodizhi.com/', '随机生成美国地址, 身份信息，信用卡信息，手机号码和其他基本信息。还会随机生成工作信息，财务信息，兴趣爱好等信息。', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (145, '接码平台', 'https://receive-sms-free.cc/favicon.ico', 'https://receive-sms-free.cc/Free-USA-Phone-Number/', 'receive-sms-free手机短信接码平台', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (146, 'Random Credit Card', 'https://namso-gen.com/favicon.svg', 'https://namso-gen.com/?tab=advance\\u0026network=MasterCard', 'Enhance testing, validation, and development with Namsogen – the ultimate solution for precise, valid credit card numbers tailored for seamless integration.', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (147, 'Free Credit Card Checker', 'https://checker.top/icons/favicon-128x128.png', 'https://checker.top/', 'Online credit card checker instantly. Check CCN and CCV free. CC checker and Bin checker live or dead, free forever.', 'active', 50, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (148, '随机密码生成器 - 在线工具', 'fluent:password-16-regular', 'https://tool.lu/strrandom/', '随机密码生成器，随机字符串生成器', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-23 17:13:50.223', 0, '#EA0B0B');
INSERT INTO `applications` VALUES (149, 'Diffchecker - 在线比较文本', 'https://www.diffchecker.com/favicon.ico', 'https://www.diffchecker.com/zh-Hans/', 'Diffchecker 将比较文本以找出两个文本文件之间的差异。只需粘贴您的文件，然后单击查找差异！', 'active', 45, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (150, '后浪云', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/logo_c6ed96945cac5.png', 'https://www.idc.net/addons?_plugin=13&_controller=index&_action=index', '后浪云专注于简单好用，价格厚道的香港云服务器、美国云服务器、香港服务器、美国服务器、日韩服务器等全球IDC服务。APNIC+ARIN双会员，IDC+ISP+ICP资质，15年运营经验。服务热线：4000-070-040。服务网站: IDC.NET。', 'active', 43, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (151, '知乎网', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/apple-touch-icon-152.81060cab_54b3dd6a1de4f.png', 'https://www.zhihu.com/', '知乎,中文互联网高质量的问答社区和创作者聚集的原创内容平台', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (152, 'Chat评测榜单', 'https://rank.opencompass.org.cn/logo.png', 'https://rank.opencompass.org.cn/leaderboard-llm', '评测榜单旨在为大语言模型和多模态模型提供全面、客观且中立的得分与排名，同时提供多能力维度的评分参考，以便用户能够更全面地了解大模型的能力水平。', 'active', 44, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (153, 'Golang中文社区', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon_205797a06c09a.ico', 'https://studygolang.com/', 'Go语言中文网，中国 Golang 社区，Go语言学习园地，致力于构建完善的 Golang 中文社区，Go语言爱好者的学习家园。分享 Go 语言知识，交流使用经验', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -9, '#000000');
INSERT INTO `applications` VALUES (154, '地鼠文档', 'https://www.topgoer.cn/favicon.ico', 'https://www.topgoer.cn/', 'go语言文档网站通过收集整理go语言相关的学习文档，为大家提供一个学习平台', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (155, 'Gin中文文档 · 看云', 'https://www.kancloud.cn/favicon.ico', 'https://www.kancloud.cn/shuangdeyu/gin_book/949411', 'Gin中文参考文档', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (156, 'Go入门教程', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/cover_164e222e404f0461_small_e3ad3333b3348.png', 'https://mp.weixin.qq.com/mp/appmsgalbum?__biz=Mzk0MDI3MTE0MQ==&action=getalbum&album_id=2587461366412787713&scene=173&from_msgid=2247486604&from_itemidx=2&count=3&nolastread=1#wechat_redirect', 'Golang 入门级教程', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (157, 'Go Guide学习指南', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/cover_1614039c3c523480_small_864c181f1484f.jpg', 'https://github.com/coderit666/GoGuide', '「Go语言学习指南」一份涵盖大部分 Golang 程序员所需要掌握的核心知识，拥有 Go语言教程、Go开源书籍、Go语言入门教程、Go语言学习路线。零基础学习 Go语言、Go编程，首选 GoGuide。', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (158, 'go.dev', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon-gopher_43fac683bdc87.png', 'https://go.dev/', 'Go is an open source programming language that makes it simple to build secure, scalable systems.', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -10, '#000000');
INSERT INTO `applications` VALUES (159, 'Go语言学习资料大全', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/v2-8bc230dd8bf5f082bf3c2af6d03cd9e3_xl_d87ddb3aaa7c3.jpg', 'https://zhuanlan.zhihu.com/p/437672297', '这是一篇可以让你受益终身的Go语言学习资料精华，汇聚了 Golang 各类资料的精华！\n\n建议你花 5 钟读完这篇文章，可以帮你节省100% 的寻找 Go 语言学习资料的时间，一定要坚持读到最后。', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (160, 'Go标准库中文文档', 'https://studygolang.com/static/img/go.ico', 'https://studygolang.com/pkgdoc', 'Go语言文档中文版，Go语言中文网，中国 Golang 社区，Go语言学习园地，致力于构建完善的 Golang 中文社区，Go语言爱好者的学习家园。分享 Go 语言知识，交流使用经验', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (161, '8小时转职Golang工程师', 'https://mdn.alipayobjects.com/huamei_0prmtq/afts/img/A*vMxOQIh4KBMAAAAAAAAAAAAADvuFAQ/original', 'https://www.yuque.com/aceld/mo95lb', '本书偏入门级，主要是针对后端想快速低成本掌握golan...', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (162, 'Helm', 'https://helm.sh/img/favicon-152.png', 'https://helm.sh/', 'Helm 是 Kubernetes 的一个包管理工具', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -7, '#000000');
INSERT INTO `applications` VALUES (163, 'Docker hub', 'mdi:docker', 'https://hub.docker.com/', 'Docker hub 是docker官方存放镜像的仓库', 'active', 46, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (164, 'Artifact Hub', 'https://artifacthub.io/static/media/logo_v2.png', 'https://artifacthub.io/', 'Find, install and publish Cloud Native packages', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (165, 'YAML生成器', 'https://k8syaml.com/Octopus-96x96.c5fbe17b7d3edd3be5534adafd39f5c4.hashedasset.png', 'https://k8syaml.com/', 'YAML生成器', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (166, 'Killercoda', 'https://killercoda.com/favicon.ico', 'https://killercoda.com/', 'Learn DevOps Linux Kubernetes CKS CKA CKAD Git Cassandra etc | Katacoda compatible', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (167, 'Kubernetes 文档', 'https://kubernetes.io/images/kubernetes.png', 'https://kubernetes.io/zh-cn/docs/home/', 'Kubernetes 是一个开源的容器编排引擎，用来对容器化应用进行自动部署、扩缩和管理。此开源项目由云原生计算基金会（CNCF）托管。', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -9, '#000000');
INSERT INTO `applications` VALUES (168, 'Kubernetes中文文档', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/cropped-con999-32x32_ff09010ec1e3c_3e8337608c0be.png', 'https://www.kubernetes.org.cn/docs', 'Kubernetes中文手册 Kubernetes单词起源于希腊语, 是“舵手”或者“领航员”的意思，是“管理者”和“控制论”的根源。 K8s是把用8代替8个字符“ubernete”而成的缩写。  本文档较老，请大家转向新子域名查看相关文档： http://docs.kubernetes.org.cn/   	Kubernetes概述  	Kubernete', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -10, '#000000');
INSERT INTO `applications` VALUES (169, '小林coding', 'https://xiaolincoding.com/icon.webp', 'https://xiaolincoding.com/', '图解计算机网络、操作系统、计算机组成、数据库，让天下没有难懂的八股文！', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (170, '南宫乘风 - 博客', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/logo_0d93e8df1ae8b.png', 'https://blog.51cto.com/heian99', '当你的才华撑不起你的野心时，只有静下心学', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (171, 'k8s架构师课程资料', 'https://github.com/fluidicon.png', 'https://github.com/dotbalo/kubernetes-study-documents-tx', 'k8s架构师课程资料', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (172, '云原生实战', 'https://mdn.alipayobjects.com/huamei_0prmtq/afts/img/A*vMxOQIh4KBMAAAAAAAAAAAAADvuFAQ/original', 'https://www.yuque.com/leifengyang/oncloud', '从0开始的云原生实战入门系列课程', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', -8, '#000000');
INSERT INTO `applications` VALUES (173, '菜鸟教程', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/favicon_916b4aa866f06.ico', 'https://www.runoob.com/', '菜鸟教程(www.runoob.com)提供了编程的基础技术教程, 介绍了HTML、CSS、Javascript、Python，Java，Ruby，C，PHP , MySQL等各种编程语言的基础知识。 同时本站中也提供了大量的在线实例，通过实例，您可以更好的学习编程。..', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-06 08:12:59.619', -10, '#000000');
INSERT INTO `applications` VALUES (174, 'DecoHack周刊', 'https://decohack.com/wp-content/uploads/2024/08/logo_512-150x150.png', 'https://decohack.com/category/decohack-weekly/', 'DecoHack是专为独立开发者设计的灵感周刊，该周刊主要记录和分享与独立产品设计和开发相关的有趣和引人入胜的内容。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (175, 'AI神器集', 'https://hao.logosc.cn/favicon-32x32.png', 'https://hao.logosc.cn/', '收录最新的互联网工具神器和AI产品导航，一站式人工智能AI工具神器集，一键提交网址分享你喜爱的产品吧。', 'active', 48, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (176, 'Portainer', 'https://www.portainer.io/hubfs/portainer-logo-black.svg', 'https://www.portainer.io/', 'Portainer 是一款开源的轻量级容器管理工具，它主要用于简化Docker容器的部署、管理和监控。', 'active', 54, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (177, 'gin-vue-admin', 'https://www.gin-vue-admin.com/logo.png', 'https://www.gin-vue-admin.com/', 'gin+vue编写的自动化代码开发脚手架，是gin+vue全栈学习最好的项目，腾讯阿里开发均有采用gin-vue-admin为模型进行相关业务开发，代码自动化，加快开发速度，权限系统齐全，减少重复工作', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (178, 'go-admin', 'https://pic2.ziyuan.wang/user/hozh/diy/navicon/logo_2cf8cd32e705b.png', 'https://www.go-admin.pro/', 'GIN-VUE-ADMIN 是一款基于GIN+VUE+ElementPlus开发的全栈基础开发平台', 'active', 70, '2024-09-02 09:02:48.686', '2024-09-03 17:58:57.652', 0, '#000000');
INSERT INTO `applications` VALUES (208, 'Prompt', 'https://agicto.com/agicto-logo-icon.png', 'https://agicto.com/prompt', 'Prompt模版', 'active', 44, '2024-09-04 05:08:52.979', '2024-09-04 05:08:52.979', 0, '#000000');
INSERT INTO `applications` VALUES (211, 'PearAPI调用平台', 'https://api.pearktrue.cn/favicon.ico', 'https://api.pearktrue.cn/', '欢迎来到PearAPI服务页面,本服务由PearNo提供技术支持,永久免费稳定提供各类API服务接口.', 'active', 45, '2024-09-05 07:55:41.549', '2024-09-06 08:12:51.375', -9, '#000000');
INSERT INTO `applications` VALUES (212, 'ECharts', 'https://echarts.apache.org/en/images/favicon.png?_v_=20240226', 'https://echarts.apache.org/', 'Apache ECharts, a powerful, interactive charting and visualization library for browser', 'active', 67, '2024-09-06 09:53:04.728', '2024-09-19 14:46:48.414', 0, '#000000');
INSERT INTO `applications` VALUES (213, '桑帛云API', 'https://api.lolimi.cn/assets/img/favicons/favicon.png', 'https://api.lolimi.cn/', '桑帛云API,简单、易用、免费。提供多种实用接口,助力开发者高效工作。欢迎体验,探索无限可能,快速的免费API数据接口服务,服务器采用国内,稳定运行,官方交流群：516666275', 'active', 45, '2024-09-09 09:32:55.914', '2024-09-09 09:33:29.976', -8, '#000000');
INSERT INTO `applications` VALUES (215, '网易云课堂', 'tabler:book', 'https://study.163.com/', '网易云课堂，一个专注于成人终身学习的在线教育平台。立足于实用性的要求, 与优质的教育内容创作者一起，为您提供全面、有效的在线学习内容。', 'active', 49, '2024-09-19 14:12:26.928', '2024-09-19 14:30:46.510', 0, '#BF4444');
INSERT INTO `applications` VALUES (216, 'Element', 'https://element.eleme.cn/favicon.ico', 'https://element.eleme.cn/', 'Element，一套为开发者、设计师和产品经理准备的基于 Vue 2.0 的桌面端组件库', 'active', 67, '2024-09-19 14:45:45.113', '2024-09-19 14:46:31.640', 0, '#000000');
INSERT INTO `applications` VALUES (217, 'Open WebUI', 'https://www.zhozw.cn/static/favicon.png', 'https://www.zhozw.cn/', 'Open WebUI 是一个多功能且直观的开源用户界面,与 ollama 配合使用,它作为一个webui,为用户提供了一个私有化的 ChatGPT 体验。', 'active', 42, '2024-09-20 15:46:58.837', '2024-09-20 15:47:45.384', 0, '#000000');
INSERT INTO `applications` VALUES (218, 'IP 检测工具', 'oui:token-ip', 'https://ping0.cc/', '高质量IP归属地查询、检测、全球小鸡监控平台。', 'active', 45, '2024-09-20 17:21:37.833', '2024-09-23 17:14:18.319', 0, '#000000');
INSERT INTO `applications` VALUES (219, '数字玩家', 'https://www.opkfc.com/favicon.ico', 'https://www.opkfc.com/list', '数字玩家-免费共享的GPT账户', 'active', 44, '2024-09-20 17:47:57.069', '2024-09-20 17:47:57.069', 0, '#000000');
INSERT INTO `applications` VALUES (220, 'OpenUI', 'mdi:material-ui', 'https://openui.fly.dev/ai/new', 'OpenUI是一个基于现代Web标准（如HTML5, CSS3 和 ES6）的轻量级框架，它的核心理念是提供可自定义的组件和模块化的设计，以适应各种项目需求。通过OpenUI，您可以快速地搭建用户界面，节省时间和精力，同时保持代码的整洁与可维护性。', 'active', 44, '2024-09-20 17:50:44.845', '2024-09-20 18:03:09.354', 0, '#6BBC1A');
INSERT INTO `applications` VALUES (221, 'AI工具集官网', 'https://ai-bot.cn/wp-content/uploads/2023/03/ai-bot-square-logo.png', 'https://ai-bot.cn/', 'AI工具集官网收录了国内外数百个AI工具，该导航网站包括AI写作工具、AI图像生成和背景移除、AI视频制作、AI音频转录、AI辅助编程、AI音乐生成、AI绘画设计、AI对话聊天等AI工具集合大全，以及AI学习开发的常用网站、框架和模型，帮助你加入人工智能浪潮，自动化高效完成任务！', 'active', 44, '2024-09-20 17:51:10.773', '2024-09-20 17:51:10.773', 0, '#000000');
INSERT INTO `applications` VALUES (223, 'DWAI', 'https://dw.dwai.world/list/favicon.ico', 'https://dw.dwai.world/list', 'ChatGPT公益站点', 'active', 44, '2024-09-20 17:54:49.119', '2024-09-20 17:58:18.388', 0, '#000000');
INSERT INTO `applications` VALUES (224, 'AMZ123亚马逊导航', 'tabler:layout-navbar-collapse', 'https://amz123.com', 'AMZ123亚马逊导航是一家致力于服务中国跨境电商从业者的综合平台，以让跨境电商出海更便捷为使命，始终围绕卖家需求，为卖家提供实时的跨境资讯，实用的跨境干货、工具、数据和服务，打造一站式跨境流量入口。做跨境电商，就上AMZ123。', 'active', 44, '2024-09-20 18:07:21.940', '2024-09-20 18:07:21.940', 0, '#29B1B5');
INSERT INTO `applications` VALUES (225, '腾讯安全|威胁情报中心', 'https://tix.qq.com/favicon.ico', 'https://tix.qq.com/', '第一手威胁情报,小程序一手掌握 情报动态 当前有效安全情报。', 'active', 43, '2024-09-23 15:45:24.855', '2024-09-23 15:46:37.737', 0, '#000000');
INSERT INTO `applications` VALUES (226, '程序员开发工具大全', 'fluent:window-dev-tools-16-filled', 'https://tool.ip138.com/', '程序员开发工具提供众多程序开发过程中需要用到的在线工具，有JSON格式化、 Javascript格式化、CSS格式化、URL编码、时间戳转换、正则表达式等各种在线工具。', 'active', 45, '2024-09-23 17:11:42.237', '2024-09-23 17:11:42.237', 0, '#159235');
INSERT INTO `applications` VALUES (227, 'Ingress-Nginx Controller', 'https://kubernetes.github.io/ingress-nginx/assets/images/favicon.png', 'https://kubernetes.github.io/ingress-nginx/', 'This is the documentation for the Ingress NGINX Controller.', 'active', 54, '2024-09-25 15:05:17.746', '2024-09-25 15:07:49.518', 0, '#000000');
INSERT INTO `applications` VALUES (228, 'kubeasz', 'eos-icons:kubelet-outlined', 'https://github.com/easzlab/kubeasz', '使用Ansible脚本安装K8S集群，介绍组件交互原理，方便直接，不受国内网络环境影响. Contribute to easzlab/kubeasz development by creating an account on GitHub.', 'active', 54, '2024-09-25 15:06:37.845', '2024-09-25 15:06:37.845', 0, '#0CA5BC');
INSERT INTO `applications` VALUES (230, 'Light2f', 'https://light2f.com/favicon.png', 'https://light2f.com/#/home', '前端中后台低代码（lowcode）可视化开发平台', 'active', 68, '2024-09-27 10:46:57.458', '2024-09-27 10:46:57.458', 0, '#000000');
INSERT INTO `applications` VALUES (231, '小陈运维 k8s', 'https://github.githubassets.com/favicons/favicon.png', 'https://github.com/cby-chen/Kubernetes', 'kubernetes (k8s) 二进制高可用安装，Binary installation of kubernetes (k8s)  --- 开源不易，帮忙点个star，谢谢了🌹 - cby-chen/Kubernetes', 'active', 54, '2024-09-29 14:52:21.641', '2024-09-29 14:52:21.641', 0, '#000000');

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `icon` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `order_id` bigint NULL DEFAULT 0,
  `icon_color` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES (42, '常用导航', 'bxs:hot', 'active', '2024-09-02 08:44:35.915', '2024-09-04 05:13:49.743', -10, '#FF0000', NULL);
INSERT INTO `menus` VALUES (43, '云服务', 'material-symbols-light:cloud-outline', 'active', '2024-09-02 08:46:40.251', '2024-09-03 06:12:10.382', -9, '#0081FF', NULL);
INSERT INTO `menus` VALUES (44, 'AI工具', 'fluent-emoji:robot', 'active', '2024-09-02 08:46:56.394', '2024-09-02 08:46:56.394', -8, '#000000', NULL);
INSERT INTO `menus` VALUES (45, '在线工具', 'clarity:tools-line', 'active', '2024-09-02 08:47:19.393', '2024-09-03 01:36:14.732', -7, '#3C6909', NULL);
INSERT INTO `menus` VALUES (46, '运维工具', 'pajamas:issue-type-maintenance', 'active', '2024-09-02 08:47:34.305', '2024-09-02 08:47:34.305', -6, '#BE8800', NULL);
INSERT INTO `menus` VALUES (47, '开发相关', 'entypo-social:github', 'active', '2024-09-02 08:47:53.218', '2024-09-02 08:47:53.218', -5, '#2101A4', NULL);
INSERT INTO `menus` VALUES (48, '论坛博客', 'mingcute:book-5-line', 'active', '2024-09-02 08:48:10.414', '2024-09-04 03:33:26.580', -4, '#706E04', NULL);
INSERT INTO `menus` VALUES (49, '视频影视', 'solar:tv-broken', 'active', '2024-09-02 08:48:28.538', '2024-09-02 08:48:28.538', -3, '#D3027C', NULL);
INSERT INTO `menus` VALUES (50, '其他工具', 'icon-park-outline:other', 'active', '2024-09-02 08:48:46.219', '2024-09-05 06:09:41.093', -2, '#231111', NULL);
INSERT INTO `menus` VALUES (54, 'k8s', 'mdi:kubernetes', 'active', '2024-09-02 09:24:47.999', '2024-09-03 01:53:28.832', 1, '#56ADE4', 46);
INSERT INTO `menus` VALUES (67, '开发工具', 'ic:round-menu', 'active', '2024-09-03 02:13:13.830', '2024-09-03 02:13:13.830', -4, '#000000', 47);
INSERT INTO `menus` VALUES (68, '前端开发', 'icon-park-twotone:web-page', 'active', '2024-09-03 02:13:40.346', '2024-09-03 02:13:40.346', -3, '#0CA714', 47);
INSERT INTO `menus` VALUES (69, '后端开发', 'fluent:window-dev-tools-16-filled', 'active', '2024-09-03 02:14:06.190', '2024-09-03 02:14:06.190', -2, '#0A88AE', 47);
INSERT INTO `menus` VALUES (70, 'GO开发', 'tabler:brand-golang', 'active', '2024-09-03 02:16:13.063', '2024-09-03 02:16:13.063', -1, '#00D4FF', 47);

-- ----------------------------
-- Table structure for site_settings
-- ----------------------------
DROP TABLE IF EXISTS `site_settings`;
CREATE TABLE `site_settings`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `icon` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `footer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `icp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `icon_color` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `image_host_token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of site_settings
-- ----------------------------
INSERT INTO `site_settings` VALUES (1, 'zh导航', 'https://img1.baidu.com/it/u=1217061905,2277984247&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 'zh导航. All Rights Reserved.', '123456', '2024-10-08 16:04:30.063', '2024-10-10 15:11:55.025', '', 'c10cc8537aeae7519d552c5dadaf6343');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `login_at` datetime(3) NULL DEFAULT NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `is_admin` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_users_deleted_at`(`deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '$2a$14$uzFqW5e3w/2hUgOjXerJH.bkM5RF5./9fhpTQtcmCmUjM3THi/yg6', '2024-09-11 14:40:40.941', 'enabled', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNzI4NDUyNDEyfQ.dnkswIXglsmuyhZzQeyR_6tsoWP2yJ4s73hh1ms5UNU', '2024-09-11 14:40:42.069', '2024-10-08 13:40:12.358', NULL, 1);
INSERT INTO `users` VALUES (15, 'zh', '$2a$14$3ikAJJvQF/RqURuFt9A3mOrZZv3AKknYeb2xh/59QTQ.qNs1GffjC', '2024-09-12 14:42:11.844', 'disabled', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InpoIiwiZXhwIjoxNzI2ODAyNTQwfQ.dxJ42P5ZckijTn0kIL5nkNNQZIMBkvqEMiBXK0o6Jgk', '2024-09-12 14:42:11.845', '2024-09-20 15:32:25.109', NULL, 0);

SET FOREIGN_KEY_CHECKS = 1;

DROP DATABASE  IF EXISTS withU;
CREATE DATABASE withU DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
USE withU;

-- --------------------------------------
-- 创建用户表
-- 表名：withU_users
-- 作者：cby
-- 版本：alpha 1.2
-- 描述：保存用户资料
-- 具体内容：
-- ---------------------------------------
CREATE TABLE withU_users
(
	userId				int,
	userNickName		VARCHAR(10) UNIQUE,
	userPassword		VARCHAR(32) NOT NULL,
	userAge				TINYINT,
	userSex				CHAR(4),
	userEmail			CHAR(20) UNIQUE,
	userPhoneNumber		CHAR(20) UNIQUE, 
	userArea			CHAR(10),
	PRIMARY KEY (userId)

);
-- --------------------------------------------
-- 创建用户在线信息表
-- 表名：withU_user_login_status
-- 作者：cby
-- -------------------------------------------
CREATE TABLE withU_user_login_status
(
	userId int,
	loginDate DATETIME,
	logoutDate DATETIME,
	isOnline BOOL DEFAULT False,
	FOREIGN KEY (userId) REFERENCES withU_users(userId)
	ON DELETE CASCADE
);




INSERT withU_users VALUES(10000, 'cby', '12345', 21, '男', '394220838@qq.com', '15757101755', '杭州');
INSERT withU_users VALUES(10001, 'cbdafy', '4553456', NULL, NULL, NULL, '1575710qwe1755', NULL);
INSERT withU_users VALUES(10002, 'hiokop', '4553456', NULL, NULL, NULL, '15757201755', NULL);
INSERT withU_user_login_status VALUES(10000, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
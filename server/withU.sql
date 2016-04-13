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
	userNickName		VARCHAR(15) UNIQUE,
	userPassword		VARCHAR(32) NOT NULL,
	userAge				CHAR(5),
	userSex				CHAR(5),
	userEmail			CHAR(20),
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



INSERT withU_users VALUES(10000, 'xnhftrsymptmvo', '123456', '21', '男', 'NULL', '15757101756', '杭州');
INSERT withU_user_login_status VALUES(10000, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10001, 'bopidoe', '123456', '21', '女', 'NULL', '15757101757', '杭州');
INSERT withU_user_login_status VALUES(10001, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10002, 'kriofxqcaxc', '123456', '21', '女', 'NULL', '15757101758', '杭州');
INSERT withU_user_login_status VALUES(10002, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10003, 'achfvfds', '123456', '21', '女', 'NULL', '15757101759', '杭州');
INSERT withU_user_login_status VALUES(10003, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10004, 'jsnynzxqxog', '123456', '21', '男', 'NULL', '15757101760', '杭州');
INSERT withU_user_login_status VALUES(10004, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10005, 'jtqknhhy', '123456', '21', '女', 'NULL', '15757101761', '杭州');
INSERT withU_user_login_status VALUES(10005, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10006, 'ajrjkccbre', '123456', '21', '女', 'NULL', '15757101762', '杭州');
INSERT withU_user_login_status VALUES(10006, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10007, 'dmanchqn', '123456', '21', '女', 'NULL', '15757101763', '杭州');
INSERT withU_user_login_status VALUES(10007, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10008, 'pkgyhdm', '123456', '21', '女', 'NULL', '15757101764', '杭州');
INSERT withU_user_login_status VALUES(10008, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
INSERT withU_users VALUES(10009, 'javmtjaxqi', '123456', '21', '男', 'NULL', '15757101765', '杭州');
INSERT withU_user_login_status VALUES(10009, '2016-3-28 20:23:12', '2016-3-27 02:23:45', true);
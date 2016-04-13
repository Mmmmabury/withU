# encoding=utf-8
import json
from dataBaseHandle import *
import time
from friends import *
################################
#
# 获取信息
#
################################


class postHandle:
    def __init__(self, urlParse):
        self.urlParse = urlParse
        self.dataBase = dataBase()

    def logout(self):
        message = {"method": "logout", "status": "failed", "message": "登出失败"}
        userId = ''
        params = self.urlParse.query.split('&')
        logoutInfo = {}
        for element in params:
            logoutInfo[element.split('=')[0]] = element.split('=')[1]
        userId = logoutInfo['userId']
        sql = "update withU_user_login_status set isOnline=false where userId=%s;"
        sql = sql % userId
        try:
            self.dataBase.databaseHandle(sql)
            message['message'] = "登出成功"
            message['status'] = "success"
        except Exception as e:
            print("#### logout is wrong :" + str(e))
        encodingJson = json.dumps(message)
        return encodingJson

    def update(self):
        message = {"method": "update", "status": "failed", "message": "更新失败"}
        userId = ''
        item = ''
        values = ''
        params = self.urlParse.query.split('&')
        info = {}
        for element in params:
            info[element.split('=')[0]] = element.split('=')[1]
        userId = info.pop('userId')
        for i in info:
            item = i
            values = info[item]
        if item == 'userPassword' or item == 'userId' or item == 'userPhoneNumber':
            return json.dumps(message)
        sql = "update withU_users set %s='%s' where userId=%s;"
        sql = sql % (item, values, userId)
        try:
            self.dataBase.databaseHandle(sql)
            message['message'] = "修改成功"
            message['status'] = "success"
        except Exception as e:
            print("#### update is wrong :" + str(e))
        encodingJson = json.dumps(message)
        return encodingJson

    def delete(self):
        params = self.urlParse.query.split('&')
        info = {}
        for element in params:
            info[element.split('=')[0]] = element.split('=')[1]
        self.friends = Friends(info['userId'])
        message = self.friends.deleteFriend(info['friendId'])
        encodingJson = json.dumps(message)
        return encodingJson

    def addFriend(self):
        params = self.urlParse.query.split('&')
        info = {}
        for element in params:
            info[element.split('=')[0]] = element.split('=')[1]
        self.friends = Friends(info['userId'])
        message = self.friends.addFriend(info['friendId'])
        encodingJson = json.dumps(message)
        return encodingJson

    def register(self):
        flag = {"users": 0, "login_status": 0}
        message = {"method": "register", "status": "failed", "message": "注册失败"}
        try:
            registerInfo = {}
            params = self.urlParse.query.split('&')
            type = ''
            for element in params:
                ele = element.split('=')
                registerInfo[ele[0]] = ele[1]
                if ele[0] == 'userPhoneNumber':
                    type = 'userPhoneNumber'
                if ele[0] == 'userEmail':
                    type = 'userEmail'
            if type == 'userPhoneNumber':
                # 检查账号是否已注册
                sql = "select * from withU_users where userPhoneNumber='%s';"
                sql = sql % registerInfo['userPhoneNumber']
                result = self.dataBase.databaseHandle(sql)
                datetime = time.strftime('%Y-%m-%d %H:%M:%S')
                if len(result) > 0:
                    message['message'] = "账号已注册"
                else:
                    sql = "select userId from withU_users order by userId desc;"
                    maxUserId = self.dataBase.databaseHandle(sql)
                    userId = maxUserId[0]['userId'] + 1
                    sql = "insert withU_users values(%s, NULL, '%s', NULL, NULL, NULL,'%s',NULL);"
                    sql = sql % (userId, registerInfo['password'], registerInfo['userPhoneNumber'])
                    self.dataBase.databaseHandle(sql)
                    flag['users'] = 1
                    sql = "insert withU_user_login_status values(%s, '%s',NULL, true);" % (userId, datetime)
                    self.dataBase.databaseHandle(sql)
                    flag['login_status'] = 1
                    message['userId'] = userId
                    message['message'] = "注册成功"
                    message['status'] = "success"
        except Exception as e:
            print("register is wrong" + str(e))
            message['message'] = "注册出错"
            if flag['users'] == 1:
                sql = "delete from withU_users where userPhoneNumber='%s';"
                sql = sql % registerInfo['userPhoneNumber']
                self.dataBase.databaseHandle(sql)
            if flag['login_status'] == 1:
                sql = "delete from withU_user_login_status where userId='%s';"
                sql = sql % datetime
                self.dataBase.databaseHandle(sql)
        finally:
            encodingJson = json.dumps(message)
            print(encodingJson)
            return encodingJson



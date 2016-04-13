# encoding=utf-8
import json
from dataBaseHandle import *
from friends import *
################################
#
# 获取信息
#
################################


class getHandle:
    def __init__(self, urlParse):
        self.urlParse = urlParse
        self.dataBase = dataBase()

    def login(self):
        message = {"method": "login", "status": "failed", "message": "something is wrong"}
        try:
            params = self.urlParse.query.split('&')
            loginInfo = {}
            for element in params:
                loginInfo[element.split('=')[0]] = element.split('=')[1]
            # userId = loginInfo['query']
            passwordFromClient = loginInfo['password']
            # sql = "select * from withU_users where userId=%s" % userId
            # result = self.dataBase.databaseHandle(sql)
            # if len(result) != 1:
            userPhoneNumber = loginInfo['query']
            sql = "select * from withU_users where userPhoneNumber='%s'" % userPhoneNumber
            result = self.dataBase.databaseHandle(sql)
            if len(result) != 1:
                userEmail = loginInfo['query']
                sql = "select * from withU_users where userEmail='%s'" % userEmail
                result = self.dataBase.databaseHandle(sql)
                if len(result) != 1:
                    message['message'] = "该手机号/邮箱没有注册"
            if len(result) == 1:
                passwordFromDatabase = result[0]['userPassword']
                if passwordFromDatabase == passwordFromClient:
                    message["status"] = "success"
                    message["userId"] = result[0]['userId']
                    message["userAge"] = result[0]['userAge']
                    message["userNickName"] = result[0]['userNickName']
                    message["userSex"] = result[0]['userSex']
                    message["userArea"] = result[0]['userArea']
                    message["message"] = "登录成功"
                    sql = "update withU_user_login_status set isOnline=true;"
                    self.dataBase.databaseHandle(sql)
                    print("#### login success")
                else:
                    message["status"] = "failed"
                    message["message"] = "账号密码错误"
        except:
            print("#### something is wrong")
        encodingJson = json.dumps(message)
        return encodingJson

    def profile(self):
        try:
            message = {"method": "profile", "status": "failed", "message": "没有这个用户"}
            params = self.urlParse.query.split('&')
            info = {}
            for element in params:
                info[element.split('=')[0]] = element.split('=')[1]
                userId = info['userId']
                sql = "select userNickName, userAge, userSex, userArea from withU_users where userId='%s';"
                sql = sql % userId
                profile = self.dataBase.databaseHandle(sql)
            encodingJson = json.dumps(profile[0])
            return encodingJson
        except Exception as e:
            print("#### profile is wrong:" + str(e))
            encodingJson = json.dumps(message)
            return encodingJson

    def userinformation(self):
        message = {"method": "userInfo", "status": "failed", "message": "查询失败"}
        try:
            params = self.urlParse.query.split('&')
            info = {}
            for element in params:
                info[element.split('=')[0]] = element.split('=')[1]
            sql = "select userId, userNickName, userAge, userSex, userArea from withU_users where userId = %s;"
            sql = sql % info["userId"]
            result = self.dataBase.databaseHandle(sql)
            infoDict = result[0]
            message.update(infoDict)
        except Exception as e:
            print("#### userinformation is wrong:" + str(e))
        finally:
            encodingJson = json.dumps(message)
            return encodingJson

    def findUsersByQuery(self):
        message = {"method": "findUsers", "status": "failed", "message": "查询失败"}
        try:
            params = self.urlParse.query.split('&')
            info = {}
            for element in params:
                info[element.split('=')[0]] = element.split('=')[1]
            sql = "select userId, userNickName, userAge, userSex, userArea from withU_users where userNickName like '%s' ;"
            sql = sql % ("%" + info["query"] + "%")
            result = self.dataBase.databaseHandle(sql)
            if len(result) > 0:
                message["resultArray"] = result
                message["message"] = "查询成功"
                message["status"] = "success"
            else:
                message["message"] = "没有匹配的用户"
        except Exception as e:
            print("#### findUsers is wrong:" + str(e))
        finally:
            encodingJson = json.dumps(message)
            return encodingJson

    def friends(self):
        try:
            message = {"method": "friends", "status": "failed", "message": "没有这个用户"}
            params = self.urlParse.query.split('&')
            info = {}
            for element in params:
                info[element.split('=')[0]] = element.split('=')[1]
            self.friends = Friends(info['userId'])
            friendsList = self.friends.listFriendsFromJson
            for friendsDict in friendsList:
                userId = friendsDict['userId']
                sql = "select userId, userNickName, userAge, userSex, userArea from withU_users where userId=%s;"
                sql = sql % userId
                friendInfo = self.dataBase.databaseHandle(sql)
                friendsDict.update(friendInfo[0])
            encodingJson = json.dumps(friendsList)
            return encodingJson
        except Exception as e:
            print("#### friends is wrong:" + str(e))
            encodingJson = json.dumps(message)
            return encodingJson

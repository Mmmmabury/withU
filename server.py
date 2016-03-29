# encoding=utf-8
import json
import socketserver
import http.server
import re
from urllib.parse import urlparse
import pymysql
import time    

PORT = 8000
FILEPATH = "grade.json"

class TestHttpServer(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        print(self.path)
        parsed_path = urlparse(self.path)
        self.urlParse = parsed_path
        # path_dict = {}

        if parsed_path.path == '/login':
            self.login()
        elif parsed_path.path == '/logout':
            pass
        elif parsed_path.path == '/profile':
            pass
        elif parsed_path.path == '/usrinformation':
            pass


    def do_POST(self):
        parsed_path = urlparse.urlparse(self.path)
        # print parsed_path

        # print parsed_path

################################
#
#获取信息
#
################################
    def login(self):
        print(self.urlParse.query)
        message = {"method":"login", "status":"failed", "message":"something is wrong"}
        try:
            params = self.urlParse.query.split('&')
            loginInfo = {}
            for element in params:
                loginInfo[element.split('=')[0]] = element.split('=')[1]
            userId = loginInfo['query']
            passwordFromClient = loginInfo['password']
            sql = "select * from withU_users where userId='%s'" % userId;
            result = self.databaseHandle(sql)
            if len(result) != 1:
                userPhoneNumber = loginInfo['query']
                sql = "select * from withU_users where userPhoneNumber='%s'" % userPhoneNumber;
                result = self.databaseHandle(sql)
                if len(result) != 1:
                    userEmail = loginInfo['query']
                    sql = "select * from withU_users where userEmail='%s'" % userEmail;
                    result = self.databaseHandle(sql)
                    if len(result) != 1:
                        message = {"method":"login", "status":"failed", "message":"账号密码错误"}
            if len(result) == 1:
                passwordFromDatabase = result[0]['userPassword']
                if passwordFromDatabase == passwordFromClient:
                    message["status"] = "success"
                    message["message"] = "登录成功"
                    sql = "update withU_user_login_status set isOnline=true;"
                    self.databaseHandle(sql)
                    print("login success")
                else:
                    message["status"] = "failed"
                    message["message"] = "账号密码错误"
        except:
            print("something is wrong")
        encodingJson = json.dumps(message)
        print(encodingJson)
        self.protocal_version = "HTTP/1.1"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(encodingJson, 'utf-8'))


    def logout(self):
        pass

    def profile(self):
        pass

    def usrinformation(self):
        pass


################################
#
#修改信息
#
################################

    def editProfile(self):
        pass

    def register(self):
        message = {"method":"register", "status":"failed", "message":"something is wrong"}
        try:
            params = self.urlParse.query.split('&')
            loginInfo = {}
            type = ''
            for element in params:
                ele = element.split('=')
                registerInfo[ele[0]] = ele[1]:
                if ele[0] == 'userPhoneNumber':
                    type = 'userPhoneNumber'
                if ele[0] == 'userEmail':
                    type = 'userEmail'
            if type == 'userPhoneNumber':
                # 检查账号是否已注册
                sql = "select * from withU_users where userPhoneNumber='%s';" % registerInfo['userPhoneNumber']
                result = self.databaseHandle(sql)
                datetime = time.strftime('%Y-%m-%d %H:%M:%S')
                if len(result) > 0:
                    message['message'] = "账号已注册"
                    return
                sql = "insert withU_users values('%s', NULL, '%s', NULL, NULL,'%s',NULL);" % datetime, registerInfo['password'], registerInfo['userPhoneNumber']
                print(sql)





################################
#
#数据库函数
#
################################

    def databaseHandle(self, sql):
        connection = pymysql.connect(host='127.0.0.1',
                     user='root',
                     password='',
                     db='withU',
                     cursorclass=pymysql.cursors.DictCursor)
        try:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                sqltype = sql.split(' ')[0]
                if sqltype == 'select':
                    result = cursor.fetchall()
                else:
                    result = []
                connection.commit()
                return result
     
        finally:
            connection.close();


Handler = TestHttpServer
httpd = socketserver.TCPServer(("127.0.0.1", PORT), Handler)
print("serving at port", PORT)
httpd.serve_forever()

# encoding=utf-8
import socketserver
import http.server
from urllib.parse import urlparse
from dataBaseHandle import *
from getHandle import *
from postHandle import *

PORT = 8000
FILEPATH = "grade.json"


class TestHttpServer(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        print("#### url:" + self.path)
        parsed_path = urlparse(self.path)
        self.urlParse = parsed_path
        self.dataBase = dataBase()
        self.getHandle = getHandle(self.urlParse)
        print("#### parsePath " + self.urlParse.path)
        encodingJson = ""

        if parsed_path.path == '/login':
            encodingJson = self.getHandle.login()
        elif parsed_path.path == '/profile':
            encodingJson = self.getHandle.profile()
        elif parsed_path.path == '/userinformation':
            encodingJson = self.getHandle.userinformation()
        elif parsed_path.path == '/image':
            pass
        elif parsed_path.path == '/friends':
            encodingJson = self.getHandle.friends()
        print("#### getHandleJson :" + encodingJson)
        self.protocal_version = "HTTP/1.1"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(encodingJson, 'utf-8'))

    def do_POST(self):
        print(self.path)
        self.dataBase = dataBase()
        parsed_path = urlparse(self.path)
        self.urlParse = parsed_path
        self.postHandle = postHandle(self.urlParse)
        encodingJson = ''

        if parsed_path.path == '/register':
            encodingJson = self.postHandle.register()
        elif parsed_path.path == '/logout':
            encodingJson = self.postHandle.logout()
        elif parsed_path.path == '/delete':
            pass
        elif parsed_path.path == '/addFriends':
            pass
        print("#### " + encodingJson)
        self.protocal_version = "HTTP/1.1"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(encodingJson, 'utf-8'))

        # print parsed_path

        # print parsed_path


################################
#
# 修改信息
#
################################

    def editProfile(self):
        pass






Handler = TestHttpServer
httpd = socketserver.TCPServer(("127.0.0.1", PORT), Handler)
print("serving at port", PORT)
httpd.serve_forever()

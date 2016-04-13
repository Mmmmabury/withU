# encoding=utf-8
import socketserver
import http.server
from urllib.parse import urlparse
import urllib
from dataBaseHandle import *
from getHandle import *
from postHandle import *
import os

PORT = 8000
FILEPATH = "grade.json"


class TestHttpServer(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        self.path = urllib.parse.unquote(self.path)
        print("#### url = " + self.path)
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
        elif parsed_path.path == '/findUsers':
            encodingJson = self.getHandle.findUsersByQuery()
        elif parsed_path.path == '/image':
            pass
        elif parsed_path.path == '/friends':
            encodingJson = self.getHandle.friends()
        elif parsed_path.path == '/getAvatar':
            if os.path.isfile("avatars/" + self.urlParse.query):       
                with open("avatars/" + self.urlParse.query, 'rb') as f:
                    self.protocal_version = "HTTP/1.1"
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(f.read())
                    print("图片已发送")
                    return
            else:
                 with open("avatars/defaultAvatar", 'rb') as f:
                    self.protocal_version = "HTTP/1.1"
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(f.read())
                    print("图片已发送")
                    return
        print("#### getHandleJson :" + encodingJson)
        self.protocal_version = "HTTP/1.1"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(encodingJson, 'utf-8'))

    def do_POST(self):
        self.path = urllib.parse.unquote(self.path)
        print("#### url = " + self.path)
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
            encodingJson = self.postHandle.delete()
        elif parsed_path.path == '/addFriend':
            encodingJson = self.postHandle.addFriend()
        elif parsed_path.path == '/update':
            encodingJson = self.postHandle.update()
        elif parsed_path.path == '/postAvatar':
            avatarData = self.rfile.read()
            # print(self.rfile)
            with open("avatars/" + self.urlParse.query, 'wb') as f:
                f.write(avatarData)
            print("#### %s 图片已收到" % self.urlParse.query)
        print("#### " + encodingJson)
        self.protocal_version = "HTTP/1.1"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(encodingJson, 'utf-8'))

Handler = TestHttpServer
# httpd = socketserver.TCPServer(("127.0.0.1", PORT), Handler)
httpd = socketserver.TCPServer(("0.0.0.0", PORT), Handler)
print("#### serving at port", PORT)
httpd.serve_forever()

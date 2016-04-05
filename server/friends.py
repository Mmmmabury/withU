# encoding=utf-8
import json
import os


class Friends:
    def __init__(self, userId='default'):
        self.userId = userId
        self.listFriendsFromJson = []
        self.listFrinedsId = []
        self.listAddDate = []
        self.strjson = ''
        self.loadJson()

    def loadJson(self):
        path = str(self.userId) + '.json'
        # path = "friends.json"
        if os.path.isfile(path):
            with open(path, 'r') as f:
                self.strjson = f.read()
        else:
            open(path, 'w')
            self.strjson = "[]"
        self.listFriendsFromJson = json.loads(self.strjson)

# 返回好友数量
    def count(self):
        return len(self.listFriendsFromJson)

# 删除一个好友
    def deleteFriends(self, friendsId=[]):
        pass

# 添加一个好友
    def addFriends(self, friendsId=[]):
        pass

# 查找给定的 id，遇到第一个返回 1，如果查找不到，返回0
    def find(self, friendId=''):
        pass



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
        self.path = str(self.userId) + '.json'
        self.loadJson()

    def loadJson(self):
        # path = "friends.json"
        if os.path.isfile(self.path):
            with open(self.path, 'r') as f:
                self.strjson = f.read()
        else:
            open(self.path, 'w')
            self.strjson = "[]"
        self.listFriendsFromJson = json.loads(self.strjson)

# 返回好友数量
    def count(self):
        return len(self.listFriendsFromJson)

# 删除一个好友
    def deleteFriend(self, friendId=''):
        message = {"method": "delete", "status": "failed", "message": "删除失败"}
        try:
            for friendsDict in self.listFriendsFromJson:
                print(friendsDict)
                if friendsDict['userId'] == int(friendId):
                    print(friendsDict['userId'])
                    self.listFriendsFromJson.remove(friendsDict)
                    print(self.listFriendsFromJson)
            with open(self.path, 'w') as f:
                f.write(json.dumps(self.listFriendsFromJson))
            message['status'] = "success"
            message['message'] = "删除成功"
            return message
        except Exception as e:
            print("delete is wrong :" + str(e))

# 添加一个好友
    def addFriend(self, friendId=''):
        message = {"method": "addFriend", "status": "failed", "message": "添加失败"}
        try:
            friend = {"userId": int(friendId)}
            print(friend)
            for friendInList in self.listFriendsFromJson:
                if friendInList['userId'] == int(friendId):
                    message['message'] = "好友已存在"
                    return message
            print(self.listFriendsFromJson)
            self.listFriendsFromJson.append(friend)
            print(self.listFriendsFromJson)
            with open(self.path, 'w') as f:
                f.write(json.dumps(self.listFriendsFromJson))
                message['status'] = "success"
                message['message'] = "添加成功"
            return message
        except Exception as e:
            print("addFriend is wrong :" + str(e))
        return message


//
//  netWorkTool.m
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "netWorkTool.h"
#import "LoginMessage.h"
#import <MQTTKit.h>


#define HOST @"127.0.0.1"
//#define HOST @"139.129.119.91"
@interface netWorkTool()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) MQTTClient *client;
@end

@implementation netWorkTool
/**
 *  从服务器获取用户的好友数据
 */
- (void) getFriendsFromServer{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/friends?userId=%@", HOST, userId];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            
           NSArray *friendsList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"plist"];
            NSMutableDictionary *contacts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            // 好友数据路径，放在沙盒的 document 目录下
            NSString *docpath = [docpaths objectAtIndex:0];
            docpath = [docpath stringByAppendingString:@"c.plist"];
            
            // 取出数据中的字母索引
            NSArray *lettles = [[contacts allKeys] sortedArrayUsingSelector:@selector(compare:)];
            // 取出从服务器中获取的好友
            for (NSDictionary *friend in friendsList){
                NSString *nickName = friend[@"userNickName"];
                NSString *firstLettle = [[nickName substringToIndex:1] uppercaseString];
                // 如果好友昵称第一个字母和字母索引匹配，则将这个好友加入到字母索引的字典中
                for (NSString *lettle in lettles){
                    
                    if ([firstLettle isEqualToString:lettle]) {
                        
                        NSMutableArray *friendArray = contacts[lettle];
                        [friendArray addObject:friend];
                        [contacts setObject:friendArray forKey:lettle];
                        break;
                    }
                }
            }
           [contacts writeToFile:docpath atomically:YES];
        }
    }];
    [task resume];
}

/**
 *
 *
 *  @param nickName
 */
- (void) getFriendInfoFromServer: (NSString *) nickName{
    
}

/**
 *  从本地文件中获取好友的信息
 *
 *  @return 好友数组
 */

- (NSArray *) getFriendsFromFile{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"json"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"c.plist"];
//     [@"hh" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSData *dataJson = [NSData dataWithContentsOfFile:path];
    NSData *dataJson = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray *friendsList = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingAllowFragments error:nil];
    return friendsList;
}


- (void) updateInfo: (NSString *) method
              value: (NSString *) value
             userId: (NSString *) userId{
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/update?userId=%@&%@=%@", HOST, userId, method, value];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"status"] isEqualToString:@"success"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateFail" object:nil];
            }
        }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateFail" object:nil];
        }
    }];
    [task resume];
}


- (void) deleteFriend: (NSString *) friendId{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    // 通知服务器删除好友
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/delete?userId=%@&friendId=%@", HOST, userId, friendId];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"status"] isEqualToString:@"success"]) {
                [self deleteFriendInFile: friendId];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFail" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFail" object:nil];
        }
    }];
    [task resume];

}

// 本地删除好友
- (void) deleteFriendInFile: (NSString *) userId{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"c.plist"];
    NSMutableDictionary *contacts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSArray *lettles = [[contacts allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *lettle in lettles){
        
        NSMutableArray *contactsByLettle = [contacts[lettle] mutableCopy];
        for (NSDictionary *dict in contactsByLettle){
            
            NSString *name = [[NSString alloc] initWithFormat:@"%d", [dict[@"userId"] intValue]];
            if ([name isEqualToString:userId]) {
                
                [contactsByLettle removeObject:dict];
            }
        }
        [contacts setObject:contactsByLettle forKey:lettle];
    }
    [contacts writeToFile:path atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFriendSuccess" object:nil];
}

/**
 *  添加好友
 *
 *  @param friendId  好友 id
 */
- (void) addFriend: (NSString *) friendId{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    // 通知服务器添加好友
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/addFriend?userId=%@&friendId=%@", HOST, userId, friendId];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"status"] isEqualToString:@"success"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addFail" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addFail" object:nil];
        }
    }];
    [task resume];
}

/**
 初始化聊天数据
 */
- (void) initMessageData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chatMessages" ofType:@"plist"];
    NSDictionary *chatData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    // 聊天数据路径，放在沙盒的 document 目录下
    NSString *docpath = [docpaths objectAtIndex:0];
    docpath = [docpath stringByAppendingString:@"chatMessages.plist"];
    [chatData writeToFile:docpath atomically:YES];
}

- (instancetype) initWithMqttClientId: (NSString *) clientType{
    
    NSString *userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] stringValue];
    self  = [super init];
    if (self) {
        
        self.client = [[MQTTClient alloc] initWithClientId: [userId stringByAppendingString:clientType]];
      
    }
    return self;
}

- (void) mqttPubtext: (NSString *) message
        andTopic: (NSString *) topic{
    
//    self.client = [[MQTTClient alloc] initWithClientId: @"mqttPub"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code here
        [self.client connectToHost:HOST completionHandler:nil];
        if (self.client.connected == ConnectionAccepted) {
            
            [self.client publishString:message
                               toTopic:topic
                               withQos:AtMostOnce
                                retain:YES
                     completionHandler:nil];
        }
        [self.client disconnectWithCompletionHandler:nil];
    });



}

- (void) mqttSub{
//    self.client = [[MQTTClient alloc] initWithClientId: @"mqttsub"];
   [self.client connectToHost:HOST completionHandler:nil];
    NSString *userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] stringValue];
    NSLog(@"mqttSub");
    [self.client subscribe:[@"/ID/" stringByAppendingString:userId]
     withCompletionHandler:nil];
    
    
    [self.client setMessageHandler:^(MQTTMessage *mqtt) {
        NSString *text = [mqtt payloadString];
        NSString *senderId = [[text componentsSeparatedByString:@"&"] objectAtIndex:0];
        NSString *message = [[text componentsSeparatedByString:@"&"][0] stringByAppendingString:@"："];
        message = [message stringByAppendingString:[text componentsSeparatedByString:@"&"][1]];
        NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        // 好友数据路径，放在沙盒的 document 目录下
        NSString *docpath = [docpaths objectAtIndex:0];
        docpath = [docpath stringByAppendingString:@"c.plist"];
        NSDictionary *friendsDict = [NSDictionary dictionaryWithContentsOfFile:docpath];
        NSDictionary *f;
        NSArray *friends = [friendsDict allValues];
        for(NSArray *friendByKey in friends){
            
            if (friendByKey.count == 0) {
                
                continue;
            }else{
                
                for(NSDictionary *friendInfo in friendByKey){
                    
                    if ([[friendInfo[@"userId"] stringValue] isEqualToString:senderId]) {
                        
                        f = friendInfo;
                        break;
                    }
                }
            }
        }
                UILocalNotification *notification=[[UILocalNotification alloc] init];
                if (notification!=nil) {
                    
                    NSDate *now=[[NSDate alloc] init];
                    notification.fireDate=now; //触发通知的时间
                    
                    notification.timeZone=[NSTimeZone defaultTimeZone];
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.alertTitle = f[@"userNickName"];
                    notification.alertBody= message;
                    notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    NSDictionary *infoDict = @{@"text": [text componentsSeparatedByString:@"&"][1], @"userId": senderId};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:nil userInfo:infoDict];
                }
    }];
}

- (void) localNote: (NSString *) nickName
        andMessage: (NSString *) m{
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[[NSDate alloc] init];
        notification.fireDate=now; //触发通知的时间
        //        notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody=@"收到消息啦";
        
//        notification.alertAction = @"打开";  //提示框按钮
//        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        
        //下面设置本地通知发送的消息，这个消息可以接受
//        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
//        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end


//
//  netWorkTool.m
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "netWorkTool.h"
#import "LoginMessage.h"

#define HOST @"127.0.0.1"
//#define HOST @"139.129.119.91"
@interface netWorkTool()

@property NSString *name;

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
 *  @param nickName <#nickName description#>
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


- (void) updateInfo: (NSString *) method value: (NSString *) value userId: (NSString *) userId{
    
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
@end


//
//  netWorkTool.m
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "netWorkTool.h"

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
//            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"json"];
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *path = [paths objectAtIndex:0];
//            path = [path stringByAppendingString:@"/friends.json"];
//            [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
           NSArray *friendsList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"plist"];
//            NSMutableDictionary *contacts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
            NSArray *lettles = [[ allKeys] sortedArrayUsingSelector:@selector(compare:)];
//            if (![userId isEqualToString: contacts[@"userId"]]) {
                for (NSDictionary *friend in friendsList){
                    NSString *nickName = friend[@"userNickName"];
                    NSString *firstLettle = [[nickName substringToIndex:1] uppercaseString];
                    for (NSString *lettle in lettles){
                        if ([firstLettle isEqualToString:lettle]) {
                            NSMutableArray *friendArray = contacts[lettle];
                            [friendArray addObject:friend];
                            [contacts setObject:friendArray forKey:lettle];
                        }
                    }
                }
//            }
        }
    }];
    [task resume];
}

- (void) getFriendInfoFromServer{
    
}
/**
 *  从本地文件中获取好友数据
 *
 *  @return 好友数组
 */

- (NSArray *) getFriendsFromFile{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"json"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/friends.json"];
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

- (void) deleteFriend: (NSString *) userId{
    // 通知服务器删除好友
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/delete?userId=%@", HOST, userId];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"status"] isEqualToString:@"success"]) {
                // 本地删除好友
                NSMutableArray *friends = [[self getFriendsFromFile] mutableCopy];
                NSDictionary *friend;
                for(friend in friends){
                    if ([friend[@"userId"] isEqualToString:userId]) {
                        [friends removeObject:friend];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFriendSuccess" object:nil];
                    }
                }
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFail" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFail" object:nil];
        }
    }];
    [task resume];

}

- (void) deleteFriendInFile: (NSString *) userId{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"plist"];
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if([file_manager fileExistsAtPath:path]){
        NSLog(@"存在");
    }else{
        NSMutableDictionary *contacts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //        [contacts setObject:@"hh" forKey:@"c"];
        NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docpath = [docpaths objectAtIndex:0];
        docpath = [docpath stringByAppendingString:@"c.plist"];
        [contacts writeToFile:docpath atomically:YES];
        NSMutableDictionary *hh = [[NSMutableDictionary alloc] initWithContentsOfFile:docpath];
        NSLog(@"%@", hh);
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"c.plist"];
    NSMutableDictionary *contacts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSArray *lettles = [contacts allKeys];
    for (NSString *lettle in lettles){
        NSMutableArray *contactsByLettle = [contacts[lettle] mutableCopy];
        for (NSDictionary *dict in contactsByLettle){
            NSString *name = dict[@"userId"];
            if ([name isEqualToString:userId]) {
                [contactsByLettle removeObject:dict];
            }
        }
        [contacts setObject:contactsByLettle forKey:lettle];
    }
    NSArray *docpaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docpath = [docpaths objectAtIndex:0];
    docpath = [docpath stringByAppendingString:@"c.plist"];
    [contacts writeToFile:docpath atomically:YES];
}
- (void) addFriend: (NSString *) userId{
    
}


@end


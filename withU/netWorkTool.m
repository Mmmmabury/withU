//
//  netWorkTool.m
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "netWorkTool.h"
static NSString *host = @"127.0.0.1";

@implementation netWorkTool

- (void) getFriendsFromServer{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8000/friends?userId=%@", host, userId];
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"json"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [path stringByAppendingString:@"/friends.json"];
            [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
    [task resume];
}


- (NSArray *) friendsFromFile{
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
@end


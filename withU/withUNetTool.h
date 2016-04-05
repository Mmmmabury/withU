//
//  withUNetTool.h
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol withUNetTool <NSObject>
@optional
- (void) getFriendsFromServer;
- (NSDictionary *) getInfoByUserId:(NSString *)userId;
- (NSArray *) friendsFromFile;
- (void) getProfile;
@end
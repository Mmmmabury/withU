//
//  withUNetTool.h
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol withUNetTool <NSObject>
/**
 *  withUNetTool 协议
 */
@optional

- (void) getFriendsFromServer;
- (NSDictionary *) getInfoByUserId:(NSString *)userId;
- (NSArray *) getFriendsFromFile;
- (void) getProfile;
- (void) updateInfo: (NSString *) method value: (NSString *) value userId: (NSString *) userId;

@end

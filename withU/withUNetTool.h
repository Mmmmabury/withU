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
- (void) updateInfo: (NSString *) method value: (NSString *) value
             userId: (NSString *) userId;
- (void) deleteFriend: (NSString *) userId;
- (void) addFriend: (NSString *) friendId;
- (void) initMessageData;
- (void) mqttPubtext: (NSString *) message
        andTopic: (NSString *) topic;
- (void) mqttSub;
- (void) findUsersByQuery: (NSString *) query;
- (void) getAvatarById: (NSString *) userId;
- (void) uploadAvatarWithId: (NSString *) userId;

@end

//
//  MessageModel.h
//  WXChat
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMessageModelTypeOther,
    kMessageModelTypeMe
} MessageModelType;

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) MessageModelType type;
@property (nonatomic, assign) BOOL showTime;

+ (id)messageModelWithDict:(NSDictionary *)dict;

@end

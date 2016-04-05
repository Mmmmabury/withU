//
//  MessageModel.m
//  WXChat
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel *message = [[self alloc] init];
    message.text = dict[@"text"];
    message.time = dict[@"time"];
    message.type = [dict[@"type"] intValue];
    
    return message;
}

@end

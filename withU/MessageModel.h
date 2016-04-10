//
//  MessageModel.h
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
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

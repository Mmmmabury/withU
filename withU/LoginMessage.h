//
//  message.h
//  testbysj

//  message model 声明

//  Created by cby on 16/3/28.
//  Copyright © 2016年 cby. All rights reserved.
//

#ifndef message_h
#define message_h
#import <YYModel/YYModel.h>

@interface message : NSObject
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic,strong) NSString *message;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *method;
@end

#endif /* message_h */

//
//  Chat.h
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chat : UIViewController
@property (nonatomic,strong) NSDictionary *friendDic;
@property (nonatomic ,assign) BOOL isCall;
@property (nonatomic, strong) NSString *userId;
@end

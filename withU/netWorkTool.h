//
//  netWorkTool.h
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "withUNetTool.h"

@interface netWorkTool : NSObject <withUNetTool>


- (instancetype) initWithMqttClientId: (NSString *) clientId;
@end

//
//  CellFrameModel.h
//  WXChat
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel *message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;

@end

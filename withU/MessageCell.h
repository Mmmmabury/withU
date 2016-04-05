//
//  MessageCell.h
//  WXChat
//
//  Created by zsm on 14-11-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellFrameModel;
#define textPadding 15

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) CellFrameModel *cellFrame;

@property (nonatomic, strong) NSDictionary *friendDic;
@end

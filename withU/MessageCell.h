//
//  MessageCell.h
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellFrameModel;
#define textPadding 15

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) CellFrameModel *cellFrame;

@property (nonatomic, strong) NSDictionary *friendDic;
@end

//
//  chatTableViewCell.h
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* msg;
@property (copy, nonatomic) NSString* time;
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;
@property (copy, nonatomic) NSString* friendId;
@end

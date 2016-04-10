//
//  chatTableViewCell.m
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;




@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userIdLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setName:(NSString *)name{
    if (![name isEqualToString:_name]) {
        _name = [name copy];
        self.nameLabel.text = _name;
    }
}

- (void)setMsg:(NSString *)msg{
    if (![msg isEqualToString:_msg]) {
        _msg = [msg copy];
        self.msgLabel.text = _msg;
    }
}

- (void)setTime:(NSString *)time{
    if (![time isEqualToString:_time]) {
        _time = [time copy];
        self.timeLabel.text = _time;
        
    }
}

- (void) setFriendId:(NSString *)friendId{
    
    if (![friendId isEqualToString:_friendId]) {
        _friendId = [friendId copy];
        self.userIdLabel.text = _friendId;
    }
}
@end
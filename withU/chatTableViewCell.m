//
//  chatTableViewCell.m
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "chatTableViewCell.h"

@interface chatTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;




@end

@implementation chatTableViewCell

- (void)awakeFromNib {
    // Initialization code

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
@end
//
//  ProfileInfoCell.m
//  withU
//
//  Created by cby on 16/3/9.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ProfileInfoCell.h"

@interface ProfileInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;

@end

@implementation ProfileInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProfileName:(NSString *)profileName{
    if (![profileName isEqualToString:_profileName]) {
        _profileName = [profileName copy];
        self.labelName.text = _profileName;
    }
}


- (void)setProfileValue:(NSString *)profileValue{
    if (![profileValue isEqualToString:_profileValue]) {
        _profileValue = [profileValue copy];
        self.labelValue.text = _profileValue;
    }
}


@end

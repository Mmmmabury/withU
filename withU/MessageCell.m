//
//  MessageCell.m
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "MessageCell.h"

//@implementation NSString (Extension)
///** 测量文本的尺寸 */
//- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
//         NSDictionary *attrs = @{NSFontAttributeName: font};
//         CGSize size =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    
//         return size;
//    }
//@end


@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

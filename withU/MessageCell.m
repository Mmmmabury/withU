//
//  MessageCell.m
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "MessageCell.h"
#import "UIImage+ResizeImage.h"
#import "MessageModel.h"
#import "CellFrameModel.h"

@interface MessageCell()
{
    UILabel *_timeLabel;
//    UIImageView *_iconView;
    UIButton *_iconView;
    UIButton *_textView;
}
@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
//        _iconView = [[UIImageView alloc] init];
        _iconView = [[UIButton alloc]init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.enabled = YES;
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:16];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
    }
    return self;
}
- (void) fromChatToDetail{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDetail" object:nil];
    
}
- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    
//    获取头像
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent: @"/avatar"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileIsExist = [fileManager fileExistsAtPath: fullPathToFile];
    UIImage *image;
    if (fileIsExist) {
        
        image = [UIImage imageWithContentsOfFile:fullPathToFile];
    }else{
        
        image = [UIImage imageNamed:@"friend_icon"];
    }
    
    
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;
    NSString *iconStr = message.type ? @"other" : @"me";
//    _iconView.image = [UIImage imageNamed:iconStr];
    [_iconView addTarget:self action:@selector(fromChatToDetail) forControlEvents:UIControlEventTouchUpInside];
//    [self.loginBn addTarget:self action:@selector(loginHandler:)
//           forControlEvents:UIControlEventTouchUpInside];
    [_iconView setBackgroundImage:[UIImage imageNamed:iconStr] forState:UIControlStateNormal];
    if (message.type == kMessageModelTypeOther) {
//        _iconView.image = [UIImage imageNamed:@"me"];
        [_iconView setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        //        [_iconView sd_setImageWithURL:[NSURL URLWithString:self.friendDic[@"icon"]] placeholderImage:[UIImage imageNamed:@"friend_icon.png"]];
//        _iconView.image = [UIImage imageNamed:@"friend_icon.png"];
        [_iconView setBackgroundImage:[UIImage imageNamed:@"friend_icon.png"] forState:UIControlStateNormal];
    }
    
    _textView.frame = cellFrame.textFrame;
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_green";
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
//    [_textView setBackgroundImage:[UIImage resizeImage:@"chat_send_press"] forState:UIControlStateSelected];
    [_textView setTitle:message.text forState:UIControlStateNormal];
}

@end

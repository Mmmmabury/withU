//
//  ChatViewController.m
//  WXChat
//
//  Created by zsm on 14-12-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "Chat.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "UIView+ViewFrameGeometry.h"
#import "DetailViewController.h"

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kToolBarH 44
#define kTextFieldH 30

@interface Chat () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *_cellFrameDatas;
    UITableView *_chatView;
    UIImageView *_toolBar;
    UITextField *_textField;
}
@end

@implementation Chat

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 监听接受通知的方法
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMessageNotification:) name:kReceiveMessageNotification object:nil];
    
    // 监听状态栏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDetail) name:@"goToDetail" object:nil];

    //0.加载数据
    [self loadData];
    
    //1.tableView
    [self addChatView];
    
    //2.工具栏
    [self addToolBar];
}

- (void) goToDetail{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"detailView"];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  记载数据
 */
- (void)loadData
{
    _cellFrameDatas =[NSMutableArray array];
    NSURL *dataUrl = [[NSBundle mainBundle] URLForResource:@"messages.plist" withExtension:nil];
    NSArray *dataArray = [NSArray arrayWithContentsOfURL:dataUrl];
    for (NSDictionary *dict in dataArray) {
        MessageModel *message = [MessageModel messageModelWithDict:dict];
        CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
        cellFrame.message = message;
        [_cellFrameDatas addObject:cellFrame];
    }
}

/**
 *  添加TableView
 */
- (void)addChatView
{
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    UITableView *chatView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight - 0 - kToolBarH) style:UITableViewStylePlain];
    chatView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    chatView.delegate = self;
    chatView.dataSource = self;
    chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatView.allowsSelection = NO;
    _chatView = chatView;
    
    [self.view addSubview:chatView];
}

/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, kScreenHeight - (kStatusBarHeight - 20) - kToolBarH, kScreenWidth, kToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    UIButton *sendSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSoundBtn.frame = CGRectMake(0, 0, kToolBarH, kToolBarH);
    [sendSoundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [bgView addSubview:sendSoundBtn];
    
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH, 0, kToolBarH, kToolBarH);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [bgView addSubview:addMoreBtn];
    
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH * 2, 0, kToolBarH, kToolBarH);
    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressBtn];
    
    _textField = [[UITextField alloc] init];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.enablesReturnKeyAutomatically = YES;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.frame = CGRectMake(kToolBarH, (kToolBarH - kTextFieldH) * 0.5, self.view.frame.size.width - 3 * kToolBarH, kTextFieldH);
    _textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    _textField.delegate = self;
    [bgView addSubview:_textField];
}


#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellFrameDatas.count;
}

- (MessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.userInteractionEnabled = YES;
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    cell.friendDic = self.friendDic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_textField resignFirstResponder];
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 根据当前键盘的状态进行不同的设置
    if (_textField.isEditing == NO) {
        // 当前键盘在编辑状态，是否执行收起效果
        if (scrollView.contentSize.height + 10 <= scrollView.contentOffset.y + scrollView.height) {
            [_textField becomeFirstResponder];
        }
    } else {
        // 当前键盘在编辑状态，是否执行收起效果
        if (scrollView.contentSize.height - 20 >= scrollView.contentOffset.y + scrollView.height) {
            [_textField resignFirstResponder];
        }
    }
}

#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1.获得时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    //2.创建一个MessageModel类
    MessageModel *message = [[MessageModel alloc] init];
    message.text = textField.text;
    message.time = locationString;
    message.type = 0;
    
    //3.创建一个CellFrameModel类
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //4.添加进去，并且刷新数据
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    textField.text = @"";
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     //自动滚到最后一行
    if (_cellFrameDatas.count != 0) {
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
        [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}



/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = kScreenHeight - (0 + kStatusBarHeight) - keyFrame.size.height;
    
    _toolBar.bottom = moveY;
    _chatView.bottom = moveY - _toolBar.height;
    // 添加内填充让表示图的内容可以现实到下面
    _chatView.contentInset = UIEdgeInsetsMake(keyFrame.size.height, 0, 0, 0);
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    _toolBar.bottom = kScreenHeight - (kStatusBarHeight - 20);
    _chatView.bottom = kScreenHeight - (kStatusBarHeight - 75) -_toolBar.height;
    // 添加内填充让表示图的内容可以现实到下面
    _chatView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark - 按钮返回事件(重写父类的方法)
- (void)backAction:(UIButton *)button
{
    [_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘改变的通知
- (void)willChangeStatusBarFrameNotification:(NSNotification *)notif
{
    _isCall = kStatusBarHeight == 40 ? YES : NO;
    NSLog(@"notif=%@",notif.userInfo);
    [UIView animateWithDuration:.22 animations:^{
        _toolBar.top += _isCall == YES ? -20 : 20;
    }];
}

#pragma mark - myMessageNotification
//- (void)myMessageNotification:(NSNotification *)notif
//{
//    NSLog(@"notif:%@",notif.userInfo);
//    // 判断接受消息是来自当前好友
//    if ([notif.userInfo[@"fromUser"] isEqualToString:self.friendModel.friendId]) {
//        //1.获得时间
//        NSDate *senddate=[NSDate date];
//        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"HH:mm"];
//        NSString *locationString=[dateformatter stringFromDate:senddate];
//
//        //2.创建一个MessageModel类
//        MessageModel *message = [[MessageModel alloc] init];
//        message.text = notif.userInfo[@"text"];
//        message.time = locationString;
//        message.type = 1;
//
//        //3.创建一个CellFrameModel类
//        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
//        CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
//        message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
//        cellFrame.message = message;
//
//        //4.添加进去，并且刷新数据
//        [_cellFrameDatas addObject:cellFrame];
//        [_chatView reloadData];
//
//        //5.自动滚到最后一行
//        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
//        [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//}

@end
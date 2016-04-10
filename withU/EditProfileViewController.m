//
//  EditProfileViewController.m
//  withU
//
//  Created by cby on 16/3/9.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "EditProfileViewController.h"
#import "withUNetTool.h"
#import "netWorkTool.h"
#import <AFMinfoBanner.h>

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *editTextField;
@property (strong, nonatomic) id <withUNetTool> delegate;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [[netWorkTool alloc] init];
    self.editTextField.text = self.text;
    [self.editTextField becomeFirstResponder];
    UIBarButtonItem *rightButton = [[UIBarButtonItem   alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone target:self  action:@selector(completeAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccess) name:@"updateSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFail) name:@"updateFail" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)completeAction{
    if ([self.editTextField.text isEqualToString:self.text]) {
        
        return;
    }
    if ([self.info isEqualToString:@"昵称"]) {
        self.info = @"userNickName";
    }
    if ([self.info isEqualToString:@"性别"]) {
        self.info = @"userSex";
    }
    if ([self.info isEqualToString:@"地区"]) {
        self.info = @"userArea";
    }
    [self.delegate updateInfo:self.info value:self.editTextField.text userId:self.userId];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) updateSuccess{

        if ([self.info isEqualToString:@"userNickName"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.editTextField.text forKey:@"nickName"];
        }
        if ([self.info isEqualToString:@"userSex"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.editTextField.text forKey:@"sex"];
        }
        if ([self.info isEqualToString:@"userArea"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.editTextField.text forKey:@"area"];
        }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
//    if ([self.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
//        [[NSUserDefaults standardUserDefaults] setObject:self.editTextField.text forKey:@"userId"];
//    }
//    }else{
    
//    }
//   [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"updateSuccess");
}

- (void) updateFail{
    dispatch_sync(dispatch_get_main_queue(), ^{
       [AFMInfoBanner showAndHideWithText:@"修改出错啦，请稍后再试" style:AFMInfoBannerStyleError];
    });
}
@end

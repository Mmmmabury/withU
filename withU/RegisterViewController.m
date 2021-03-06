//
//  RegisterViewController.m
//  withU
//
//  Created by cby on 16/3/10.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "RegisterViewController.h"
#import "define.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *messageFromServer;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender {
    [self.phoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)registerHandle:(id)sender {
    
    if (self.phoneNumber.text.length == 0 || self.password.text.length == 0) {
        [AFMInfoBanner showAndHideWithText: @"请输入账号和密码" style:AFMInfoBannerStyleError];
    }else if(self.password.text.length < 6){
        
        [AFMInfoBanner showAndHideWithText:@"密码需要大于6位" style:AFMInfoBannerStyleError];
    }else{
    
        NSString *url = [[NSString alloc]initWithFormat:@"http://%@:8000/register?userPhoneNumber=%@&password=%@", HOST, self.phoneNumber.text, self.password.text];
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        NSURLSession *session = [NSURLSession sharedSession];
           NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error == nil) {
                   self.messageFromServer = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                   message *m = [message yy_modelWithJSON: self.messageFromServer];
                   if ([[m status] isEqualToString:@"success"]) {
                       [[NSUserDefaults standardUserDefaults]setObject:[m userId] forKey:@"userId"];
                       [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           [AFMInfoBanner showAndHideWithText:[m message] style:AFMInfoBannerStyleInfo];
                       });
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"registerSuccess" object:nil];
                       [self dismissViewControllerAnimated:YES completion:nil];
                   }else{
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           [AFMInfoBanner showAndHideWithText:[m message] style:AFMInfoBannerStyleError];
                       });
                   }
               }else{
                   dispatch_sync(dispatch_get_main_queue(), ^{
                       [AFMInfoBanner showAndHideWithText:@"服务器出错啦！请稍后连接" style:AFMInfoBannerStyleError];
                   });
               }
           }];
        
        [task resume];
    }
}

@end

//
//  LoginViewController.m
//  withU
//
//  Created by cby on 16/3/10.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "LoginViewController.h"
//static NSString *host = @"139.129.119.91";
static NSString *host = @"127.0.0.1";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginQuery;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) NSString* messageFromServer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
//    self.phoneNumber.layer.cornerRadius = 20;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backgroundTap:(id)sender {
    [self.loginQuery resignFirstResponder];
    [self.password resignFirstResponder];
}

-(IBAction)textFieldDidEdit:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)loginHandle:(id)sender {
    [self requestServerLogin];
//    [AFMInfoBanner showAndHideWithText:@"Error text" style:AFMInfoBannerStyleError];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getFriends" object:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"%@", self.messageFromServer);
//    [NSThread sleepForTimeInterval:2.0];


}
- (IBAction)start:(id)sender {
//    self.activityIndicator.hidden = NO;
//    [self.activityIndicator startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  向服务器请求登录
 */
- (void) requestServerLogin{
    NSString *url = [[NSString alloc]initWithFormat:@"http://%@:8000/login?query=%@&password=%@", host, self.loginQuery.text, self.password.text];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil){
            self.messageFromServer = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            message *m = [message yy_modelWithJSON: self.messageFromServer];
            if ([[m status] isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults]setObject:[m userId] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                [userDef setObject:infoDict[@"userNickName"] forKey:@"nickName"];
                [userDef setObject:infoDict[@"userArea"] forKey:@"area"];
                [userDef setObject:infoDict[@"userAge"] forKey:@"age"];
                [userDef setObject:infoDict[@"userSex"] forKey:@"sex"];
               [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:self]; 
                
                
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // __block variables aren't automatically retained
                    // so we'd better make sure we have a reference we can keep
//                    self.loginQuery.placeholder = @"错误";
                    [AFMInfoBanner showAndHideWithText:[m message] style:AFMInfoBannerStyleError];
//                     [self dismissViewControllerAnimated:YES completion:nil];
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

//- (void) hh:(NSString *) message{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action){
//        //                     [self dismissViewControllerAnimated:YES completion:nil];
//        //                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        //                     [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
//    }];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
//    
//}

@end

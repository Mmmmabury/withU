//
//  LoginViewController.m
//  withU
//
//  Created by cby on 16/3/10.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
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
- (IBAction)loginHandle:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    [NSThread sleepForTimeInterval:2.0];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
}
- (IBAction)start:(id)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

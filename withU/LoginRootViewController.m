//
//  LoginRootViewController.m
//  withU
//
//  Created by cby on 16/3/10.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "LoginRootViewController.h"

@interface LoginRootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIViewController *loginController;
@property (strong, nonatomic) UIViewController *registerController;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@end

@implementation LoginRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    self.registerController = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    self.loginController.view.frame = self.view.frame;
    //切换视图
    [self switchViewFromViewController:nil
                      toViewController:self.loginController];
    self.loginLabel.hidden = YES;
    self.loginButton.hidden = YES;
    self.registerButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toRegister:(id)sender{
   
    [UIView beginAnimations:@"View Flip" context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];

    self.registerController.view.frame = self.view.frame;
    [self switchViewFromViewController:self.loginController toViewController:self.registerController];
    [UIView commitAnimations];
    self.registerButton.hidden = YES;
    self.loginButton.hidden = NO;
    self.loginLabel.hidden = NO;

}



- (IBAction)toLogin:(id)sender{
    [UIView beginAnimations:@"View Flip" context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];

    self.loginController.view.frame = self.view.frame;
    [self switchViewFromViewController:self.registerController toViewController:self.loginController];
    [UIView commitAnimations];
    self.loginButton.hidden = YES;
    self.registerButton.hidden = NO;
    self.loginLabel.hidden = YES;
}


- (void) switchViewFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (fromVC != nil) {
        [fromVC willMoveToParentViewController:nil];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
    }
    if (toVC != nil) {
        [self addChildViewController:toVC];
        [self.view insertSubview:toVC.view atIndex:0];
        [toVC didMoveToParentViewController:self];//可以不写，但是如果子控制器重写改方法是必须加。
    }
}

@end

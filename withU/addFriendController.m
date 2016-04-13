//
//  addFriendController.m
//  withU
//
//  Created by cby on 16/4/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "addFriendController.h"
#import "withUNetTool.h"
#import "netWorkTool.h"


@interface addFriendController() <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addFriendTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *findResult;
@property (strong, nonatomic) id <withUNetTool> delegate;

@end

@implementation addFriendController

- (void) viewDidLoad{
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"findUsers"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findHandle:) name:@"findUsersSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findFail) name:@"findUsersFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFail:) name:@"addFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSuccess) name:@"addSuccess" object:nil];
    [self.addFriendTextField becomeFirstResponder];
    self.delegate = [[netWorkTool alloc] init];
}

- (void) findHandle: (NSNotification *) notification{
    
    self.findResult = [[notification userInfo] copy];
    [self.tableView reloadData];
}

- (void) findFail{
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [AFMInfoBanner showAndHideWithText:self.findResult[@"message"] style:AFMInfoBannerStyleError];
//    });
}

- (void) addSuccess{
    
    [self.delegate getFriendsFromServer];
}

- (void) addFail: (NSNotification *) notification{
    
    NSDictionary *m = [[notification userInfo] copy];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [AFMInfoBanner showAndHideWithText:m[@"message"] style:AFMInfoBannerStyleError];
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findUsers" forIndexPath:indexPath];
    NSArray *res = self.findResult[@"resultArray"];
    NSDictionary *dict = res[indexPath.row];
//    NSString *userId = [NSString stringWithFormat:@"%d", [dict[@"userId"] intValue]];
    cell.textLabel.text = dict[@"userNickName"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.findResult) {
        
        return 0;
    }else{
        
        NSArray *resultArray = self.findResult[@"resultArray"];
        return [resultArray count];
    }
    return 0;
}

- (IBAction)textFieldDidChange:(id)sender {
    
    UITextField *textField = sender;
    if (textField.text.length != 0) {
        
        [self.delegate findUsersByQuery:textField.text];
    }else{
        
        NSDictionary *d = @{};
        self.findResult = [d copy];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *res = self.findResult[@"resultArray"];
    NSDictionary *dict = res[indexPath.row];
    NSString *theId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] stringValue];
    if (![theId isEqualToString:[dict[@"userId"] stringValue]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"将要添加这个用户" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"是的" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action){

            [self.delegate addFriend:dict[@"userId"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
        [alert addAction: action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你忘了这是你自己吗！" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style: UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

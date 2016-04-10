//
//  DetailViewController.m
//  withU
//
//  Created by cby on 16/3/31.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "DetailViewController.h"
#import "Chat.h"
#import "DetailCell.h"
#import "DetailInfoCell.h"
#import "EditProfileViewController.h"
#import "netWorkTool.h"
#import "withUNetTool.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *nameLabelDict;
@property (strong, nonatomic) id <withUNetTool> delegate;

@end


@implementation DetailViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.nameLabelDict = @[@"昵称", @"性别", @"地区"];
    self.delegate = [[netWorkTool alloc] init];
//    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:@"DetailAvatar"];
//    [self.tableView registerClass:[DetailInfoCell class] forCellReuseIdentifier:@"DetailInfo"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"jumpChat"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deleteUser"];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keys = @[@"userNickName", @"userSex", @"userArea"];
    if (indexPath.section == 0) {
          DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailAvatar" forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[DetailCell alloc]init];
//        }
        cell.detailAvatar.image = [UIImage imageNamed:@"123"];
        return cell;
    }else if(indexPath.section == 1){
        DetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailInfo" forIndexPath:indexPath];
        cell.nameLabel.text = self.nameLabelDict[indexPath.row];
        cell.infoLabel.text = self.friendDict[keys[indexPath.row]];
        return cell;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            DetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jumpChat" forIndexPath:indexPath];
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deleteUser" forIndexPath:indexPath];
            return cell;
        }
        
    }else{
        return [[UITableViewCell alloc]init];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 2;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else{
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            Chat *cV = [[Chat alloc]init];
            cV.userId = [NSString stringWithFormat:@"%d", [self.friendDict[@"userId"] intValue]];
            cV.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cV animated:YES];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"将要删除好友" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"是的" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                NSString *userId = [[NSString alloc] initWithFormat:@"%d", [self.friendDict[@"userId"]   intValue]];
                [self.delegate deleteFriend:userId];
                
                NSLog(@"deleteUser");
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [paths objectAtIndex:0];
                path = [path stringByAppendingString:@"c.plist"];
                NSDictionary *d = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"%@", d);
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
            [alert addAction: action];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

// 我去根本不需要修改好友信息的嘛，傻逼了
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"editFriendInfo"]) {
//        EditProfileViewController *edit = segue.destinationViewController;
//        DetailInfoCell *cell = sender;
//        edit.text = cell.infoLabel.text;
//    }
//
//}

@end

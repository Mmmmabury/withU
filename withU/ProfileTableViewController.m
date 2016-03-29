//
//  ProfileTableViewController.m
//  withU
//
//  Created by cby on 16/3/9.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileAvatarCell.h"
#import "ProfileInfoCell.h"
#import "EditProfileViewController.h"

static NSString *profileAvatar = @"ProfileAvatar";
static NSString *profileInfo = @"ProfileInfo";

@interface ProfileTableViewController ()

@property (strong, nonatomic) NSArray *profileLabelText;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileLabelText = @[@"昵称", @"性别", @"地区"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:profileAvatar forIndexPath:indexPath];
        cell.avatarView.image = [UIImage imageNamed:@"123"];
        return cell;
    } else if(indexPath.section == 1){
        ProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:profileInfo forIndexPath:indexPath];
        cell.profileName = self.profileLabelText[indexPath.row];
        cell.profileValue = @"hhh";
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogOut" forIndexPath:indexPath];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70.0;
    }else{
        return 45.0;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定要注销账号吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"是的" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            UIViewController *cv = [storyboard instantiateViewControllerWithIdentifier:@"loginMain"];
            [self presentViewController:cv animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
        [alert addAction: action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EditInfo"]) {
        ProfileInfoCell *cell = sender;
        EditProfileViewController *viewController = segue.destinationViewController;
        viewController.text = cell.profileValue;
    }
}

@end


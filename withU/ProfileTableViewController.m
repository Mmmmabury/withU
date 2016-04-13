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
#import "withUNetTool.h"
#import "netWorkTool.h"

static NSString *profileAvatar = @"ProfileAvatar";
static NSString *profileInfo = @"ProfileInfo";

@interface ProfileTableViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *profileLabelText;
@property (strong, nonatomic) NSArray *friendsArray;
@property (strong, nonatomic) id <withUNetTool> delegate;
@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileLabelText = @[@"昵称", @"性别", @"地区"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.delegate = [[netWorkTool alloc] init];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sb) name:@"updateSuccess" object:nil];
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
        
        cell.avatarView.image = image;
        return cell;
    } else if(indexPath.section == 1){
        ProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:profileInfo forIndexPath:indexPath];
        cell.profileName = self.profileLabelText[indexPath.row];
        if (indexPath.row == 0) {
            NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
            if ([nickName isEqualToString:@"NULL"]) {
                cell.profileValue = @"未知";
            }else{
                cell.profileValue = nickName;
            }
        }
        if (indexPath.row == 1) {
            NSString *sex= [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
            if ([sex isEqualToString:@"NULL"]) {
                cell.profileValue = @"未知";
            }else{
                cell.profileValue = sex;
            }
        }
        if (indexPath.row == 2) {
            NSString *area = [[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
            if ([area isEqualToString:@"NULL"]) {
                cell.profileValue = @"未知";
            }else{
                cell.profileValue = area;
            }
        }
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
    if (indexPath.section == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (indexPath.section == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定要注销账号吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"是的" style: UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent: @"/avatar"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL fileIsExist = [fileManager fileExistsAtPath: fullPathToFile];
            if (fileIsExist) {
                
                [fileManager removeItemAtPath:fullPathToFile error:nil];
            }
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
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
        viewController.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        viewController.info = cell.profileName;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize size = {100, 100};
    image = [self imageWithImageSimple:image scaledToSize:size];
    NSData* imageData = UIImagePNGRepresentation(image);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent: @"/avatar"];
    [imageData writeToFile:fullPathToFile atomically:NO];
    NSNumber *Id = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *userId = [Id stringValue];
//    [self.delegate uploadAvatarWithId: userId];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end


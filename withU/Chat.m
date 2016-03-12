//
//  Chat.m
//  withU
//
//  Created by cby on 16/3/11.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "Chat.h"
#import "MessageCell.h"
@interface Chat ()
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@end

@implementation Chat

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"聊天ing";
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"simple"];
//    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"me"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 != 0) {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"me" forIndexPath:indexPath];
        return cell;
    }else{
//        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chater" forIndexPath:indexPath];
//        return cell;
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chater" forIndexPath:indexPath];
    return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

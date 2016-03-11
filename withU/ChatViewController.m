//
//  chatViewController.m
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatSearchResultController.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (copy, nonatomic) NSArray *chatData;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chatData = @[@{@"name" : @"我叫大 sb", @"msg" : @"hi", @"time" : @"01.01"},
                      @{@"name" : @"endif", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"吃吃吃吃吃", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"hhh", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"我叫大 sb", @"msg" : @"hi", @"time" : @"01.01"},
                      @{@"name" : @"endif", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"吃吃吃吃吃", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"hhh", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"我叫大 sb", @"msg" : @"hi", @"time" : @"01.01"},
                      @{@"name" : @"endif", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"吃吃吃吃吃", @"msg" : @"123", @"time" : @"01.01"},
                      @{@"name" : @"hhh", @"msg" : @"123", @"time" : @"01.01"}
                      ];
    
    UINib *nib = [UINib nibWithNibName:@"ChatTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"chatCellTableIdentifier"];

//    搜索栏
    NSMutableArray *names = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.chatData)
    {
        [names addObject:dict[@"name"]];
    }
    ChatSearchResultController *resultController = [[ChatSearchResultController alloc] initWithData:[NSArray arrayWithArray:names]];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultController];
    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    self.searchController.searchResultsUpdater = resultController;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCellTableIdentifier" forIndexPath:indexPath];
    
    NSDictionary *rowData = self.chatData[indexPath.row];
    
    cell.name = rowData[@"name"];
    cell.msg = rowData[@"msg"];
    cell.time = rowData[@"time"];
    cell.chatImageView.layer.masksToBounds = YES;
    cell.chatImageView.layer.cornerRadius = 4;
    return cell;

    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70.0;
//}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    


}
@end

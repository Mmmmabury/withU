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
#import "Chat.h"
#import "netWorkTool.h"
#import "withUNetTool.h"

static NSString *host = @"127.0.0.1";
//static NSString *host = @"139.129.119.91";

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource >
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (copy, nonatomic) NSArray *chatData;
@property (strong, nonatomic) id <withUNetTool> delegate;

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginView) name:@"presentLoginView" object:nil];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    if (!isLogin) {
        NSLog(@"islogin == no");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"presentLoginView" object:nil];
//        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        UIViewController *cv = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginMain"];
//        [self presentViewController:cv animated:YES completion:nil];
    }
    self.delegate = [[netWorkTool alloc] init];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSuccess) name:@"loginSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSuccess) name:@"registerSuccess" object:nil];
}

- (void) handleSuccess{
    [self.delegate getFriendsFromServer];
}

- (void) presentLoginView{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *cv = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginMain"];
    [self presentViewController:cv animated:YES completion:nil];
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

- (void) viewDidAppear:(BOOL)animated{

}

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
    Chat *chatView = [[Chat alloc]init];
//    chatView.view.frame = self.view.frame;
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];

}
@end

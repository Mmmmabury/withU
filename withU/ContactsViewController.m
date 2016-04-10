//
//  contactsViewController.m
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//  联系人页面控制器


#import "contactsViewController.h"
#import "ContactsSearchResultsController.h"
#import "ProfileTableViewController.h"
#import "DetailViewController.h"
#import "netWorkTool.h"
#import "withUNetTool.h"

static NSString *contactsTableViewIdentifier = @"ContactsTableViewIdentifier";

@interface contactsViewController () <UITableViewDelegate, withUNetTool>

@property (copy, nonatomic) NSDictionary *names;
@property (copy, nonatomic) NSArray *keys;
@property (strong, nonatomic) UIImage *avatar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) id <withUNetTool> delegate;
//@property (strong, nonatomic) NSDictionary *friend;

@end

@implementation contactsViewController

- (void) initData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"c.plist"];
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *mutableKeys = [[[self.names allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    NSArray *tempKeys = [mutableKeys copy];
    for (NSString *key in tempKeys){
        NSArray *friends = self.names[key];
        if ([friends count] == 0) {
            [mutableKeys removeObject:key];
        }
    }
    self.keys = [mutableKeys copy];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:contactsTableViewIdentifier];
    self.delegate = [[netWorkTool alloc] init];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"plist"];

    // 初始化数据
    [self initData];
// 导航栏添加右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem   alloc]initWithTitle:@"添加"style:UIBarButtonItemStyleDone target:self  action:@selector(add)];
    self.navigationItem.rightBarButtonItem = rightButton;
//    self.hidesBottomBarWhenPushed = YES;
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"json"];
//    NSString *friends = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray *friendsArray = [NSJSONSerialization JSONObjectWithData:[friends dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//    NSDictionary *friendDict;
//    for (friendDict in friendsArray){
    
//    }
//    搜索栏
    
    ContactsSearchResultsController *resultsController = [[ContactsSearchResultsController alloc] initWithNames:self.names keys:self.keys];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    
    UISearchBar *searchBar = self.searchController.searchBar;
//    searchBar.scopeButtonTitles = @[@"All", @"Short", @"Long"];
    searchBar.placeholder = @"搜索";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    self.searchController.searchResultsUpdater = resultsController;
    searchBar.delegate = resultsController;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//改变 Navigation 颜色
}

- (void) add{
    UIViewController *cV = [self.storyboard instantiateViewControllerWithIdentifier:@"addFriend"];
    cV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cV animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self initData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = self.keys[section];
    return [self.names[key] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactsTableViewIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactsTableViewIdentifier];
    }
    NSString *key = self.keys[indexPath.section];
    NSArray *nameSection = self.names[key];
    NSDictionary *friend = nameSection[indexPath.row];
    cell.textLabel.text = friend[@"userNickName"];
    cell.imageView.image = [UIImage imageNamed:@"1234"];
    cell.detailTextLabel.hidden = YES;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%d", [friend[@"userId"] intValue]];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keys[section];

}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.keys;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"fromContactToDetail"]) {
        UITableViewCell *cell = sender;
        DetailViewController *view = segue.destinationViewController;
        NSString *nickName = cell.textLabel.text;
        NSString *firstLettle = [[nickName substringToIndex:1] uppercaseString];
        NSArray *farray = self.names[firstLettle];
        for (NSDictionary *fdict in farray) {
           NSString *userId = [[NSString alloc] initWithFormat:@"%d", [fdict[@"userId"] intValue]];
            if ([userId isEqualToString: cell.detailTextLabel.text]) {
                view.friendDict = fdict;
                break;
            }
 
        }
    }
//    UIViewController *view = segue.destinationViewController;
//    view.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0;
}

@end

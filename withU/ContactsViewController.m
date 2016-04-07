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

@end

@implementation contactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:contactsTableViewIdentifier];
    self.delegate = [[netWorkTool alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"plist"];
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.names allKeys] sortedArrayUsingSelector:@selector(compare:)];
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
    searchBar.scopeButtonTitles = @[@"All", @"Short", @"Long"];
    searchBar.placeholder = @"搜索";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    self.searchController.searchResultsUpdater = resultsController;
    searchBar.delegate = resultsController;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//改变 Navigation 颜色
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
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactsTableViewIdentifier];
//    }
    // Configure the cell...
    NSString *key = self.keys[indexPath.section];
    NSArray *nameSection = self.names[key];
    cell.textLabel.text = nameSection[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"1234"];
    cell.detailTextLabel.text = @"123";
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return  self.keys[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.keys;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 19.0;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"fromContactToDetail"]) {
        UITableViewCell *cell = sender;
        DetailViewController *view = segue.destinationViewController;
        view.userId = cell.textLabel.text;
    }
//    UIViewController *view = segue.destinationViewController;
//    view.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)myFriends{
    NSArray *friends = [self.delegate getFriendsFromFile];
    NSMutableDictionary *contactsDict = [[NSMutableDictionary alloc] init];
//    NSArray *letter = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
//    for (NSString *l in letter){
//        NSMutableDictionary *friend = [[NSMutableDictionary alloc] init];
//        [contactsDict setObject:friend forKey:l];
//    }

}

@end

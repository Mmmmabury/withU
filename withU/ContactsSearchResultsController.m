//
//  SearchResultsController.m
//  Sections
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ContactsSearchResultsController.h"
#import "DetailViewController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";


@interface ContactsSearchResultsController ()

@property (strong, nonatomic) NSDictionary *names;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSMutableArray *filteredNames;
@property (strong, nonatomic) NSMutableArray *filteredNamesBackup;
//@property (strong, nonatomic)

@end

@implementation ContactsSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.filteredNamesBackup count];
    return [self.filteredNames count];
}

- (instancetype)initWithNames:(NSDictionary *)names keys:(NSArray *)keys{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.names = names;
        self.keys = keys;
        self.filteredNames = [[NSMutableArray alloc] init];
        self.filteredNamesBackup = [[NSMutableArray alloc] init];
        
    }
    return self;
}


// 实现代理，更新查询的数据
- (void)updateSearchResultsForSearchController:(UISearchController *)controller{
    NSString *searchString = controller.searchBar.text;
    [self.filteredNames removeAllObjects];
    [self.filteredNamesBackup removeAllObjects];
    if (searchString.length > 0) {
        // 使用谓词来进行过滤
        //predicateAll 是用来过滤出不判断 scope 的
        NSPredicate *predicateAll = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *name, NSDictionary *b){
            // 匹配字符串
            NSRange range = [name[@"userNickName"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }];
        // 提取每个字符串进行谓词检查
        for (NSString *key in self.keys) {
            NSArray *matchesAll = [self.names[key] filteredArrayUsingPredicate:predicateAll];
//            NSArray *matches = [self.names[key] filteredArrayUsingPredicate:predicate];
            [self.filteredNames addObjectsFromArray:matchesAll];//这是搜索出来全部的结果
//            [self.filteredNamesBackup addObjectsFromArray:matches];//这是搜索出来后对 scope 给的条件进行过滤后的结果
        }
    }
//    self.filteredNamesBackup = [self.filteredNames mutableCopy];
    // 重新加载数据
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
//    cell.textLabel.text = self.filteredNamesBackup[indexPath.row];
    NSDictionary *friend = self.filteredNames[indexPath.row];
    cell.textLabel.text = friend[@"userNickName"];
    cell.detailTextLabel.hidden = YES;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [friend[@"userId"] intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

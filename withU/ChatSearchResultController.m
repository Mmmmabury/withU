//
//  ChatSearchResultController.m
//  withU
//
//  Created by cby on 16/3/9.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "ChatSearchResultController.h"
#import "ChatTableViewCell.h"

@interface ChatSearchResultController ()

@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSMutableArray *filterResult;
@property (strong, nonatomic) NSMutableArray *filterResultAll;

@end

@implementation ChatSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterResultAll = [[NSMutableArray alloc] init];
    self.filterResult = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatSearchResultCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *chatSearchResultCell = @"chatSearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatSearchResultCell forIndexPath:indexPath];
    cell.textLabel.text = self.filterResult[indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (instancetype)initWithData:(NSArray *)names{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.names = names;
    }
    return self;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.filterResult removeAllObjects];
    [self.filterResultAll removeAllObjects];
    NSString *searchString = searchController.searchBar.text;
    for (NSString *str in self.names){
        NSRange range = [str rangeOfString:searchString options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [self.filterResult addObject:str];
            [self.filterResultAll addObject:str];
        }
    }
    NSLog(@"");
    [self.tableView reloadData];
}

@end

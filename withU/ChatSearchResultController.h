//
//  ChatSearchResultController.h
//  withU
//
//  Created by cby on 16/3/9.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatSearchResultController : UITableViewController <UISearchResultsUpdating>

- (instancetype) initWithData: (NSArray *)names;

@end

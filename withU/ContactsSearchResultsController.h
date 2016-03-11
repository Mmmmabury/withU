//
//  SearchResultsController.h
//  withU
//
//  Created by cby on 16/3/7.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsSearchResultsController : UITableViewController  <UISearchBarDelegate, UISearchResultsUpdating>

- (instancetype) initWithNames:(NSDictionary *) names keys:(NSArray *) keys;
@end

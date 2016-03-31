//
//  sqliteHandle.h
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface sqliteHandle : NSObject

@property sqlite3 *database;


+ (NSString *) pathWithDatabase;
- (void) createEditableDatabase;
- (void) initializeDatabase;

@end


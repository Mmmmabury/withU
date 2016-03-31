//
//  sqliteHandle.m
//  withU
//
//  Created by cby on 16/3/30.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "sqliteHandle.h"

@implementation sqliteHandle



/** 要操作的数据库文件路径 */
+ (NSString *) pathWithDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentDirectory = [paths lastObject];
    return [documentDirectory stringByAppendingPathComponent:@"catalog.db"];
}

/** 创建数据库 */
- (void) createEditableDatabase{
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 数据库文件路径
    NSString *writableDB = [sqliteHandle pathWithDatabase];
    // 文件是否存在
    success = [fileManager fileExistsAtPath:writableDB];
    if (!success) {
        // 不存在就创建
        NSString *defaultPath = [[[NSBundle mainBundle]
                                  resourcePath]
                                 stringByAppendingPathComponent:@"catalog.db"];
        // 拷贝文件到某文件路径
        success = [fileManager copyItemAtPath:defaultPath
                                       toPath:writableDB
                                        error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file:'%@'.",
                      [error localizedDescription]);
        }
    }
}

/** 打开数据库 */
- (void)initializeDatabase{
    // 确认可操作数据是否存在
    [self createEditableDatabase];
    // 数据库路径
    NSString *path = [sqliteHandle pathWithDatabase];
    // 是否打开成功
    if (sqlite3_open([path UTF8String], &_database) == SQLITE_OK)
    {
        NSLog(@"Opening Database");
    }
    else
    {
        // 打开数据库失败
        sqlite3_close(_database);
        NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(_database));
    }
}

- (NSMutableArray *)getAllProducts
{
    // 查询语句
    char *const sql = "SELECT product.ID, product.Name, Manufacturer.name, \
    product.details, product.price, product.quantityonhand, country.country, \
    product.image FROM Product, Manufacturer, Country WHERE \
    manufacturer.manufacturerid=product.manufacturerid AND \
    product.countryoforiginid=country.countryid";
    // 将sql文本转换成一个准备语句
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
    // 装查询结果的可变数组
    NSMutableArray *arrayM = [NSMutableArray array];
    // 结果状态为OK时，开始取出每条数据
    if ( sqlResult == SQLITE_OK) {
        // 只要还有下一行，就取出数据。
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //            Product *product = [[Product alloc] init];
            // 每列数据
            //            char *name = (char *)sqlite3_column_text(statement, 1);
            //            char *manufacturer = (char *)sqlite3_column_text(statement, 2);
            //            char *details = (char *)sqlite3_column_text(statement, 3);
            //            char *countryOfOrigin = (char *)sqlite3_column_text(statement, 6);
            //            char *image = (char *)sqlite3_column_text(statement, 7);
            //            // 为模型赋值
            //            product.ID = sqlite3_column_int(statement, 0);
            //            product.name = [self stringWithCharString:name];
            //            product.manufacturer = [self stringWithCharString:manufacturer];
            //            product.details = [self stringWithCharString:details];
            //            product.price = sqlite3_column_double(statement, 4);
            //            product.quantity = sqlite3_column_int(statement, 5);
            //            product.countryOfOrigin = [self stringWithCharString:countryOfOrigin];
            //            product.image = [self stringWithCharString:image];
            // 添加进数组
            //            [arrayM addObject:product];
        }
        // 完成后释放prepare创建的准备语句
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"Problem with database:");
        NSLog(@"%d",sqlResult);
    }
    return arrayM;
}
/** C字符串转换OC字符串 */
- (NSString *) stringWithCharString:(char *)string
{
    return (string) ? [NSString stringWithUTF8String:string] : @"";
}

@end
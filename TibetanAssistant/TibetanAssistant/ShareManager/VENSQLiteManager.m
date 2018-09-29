//
//  VENSQLiteManager.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/28.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSQLiteManager.h"
#import <sqlite3.h>

@implementation VENSQLiteManager {
    sqlite3 *db;
}

+ (instancetype)sharedSQLiteManager {
    static VENSQLiteManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)openDB {
    
    NSString *SQLPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/db/tibetan.db"];
    
    int result = sqlite3_open(SQLPath.UTF8String, &db);
    
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        
    } else {
        NSLog(@"数据库打开失败");
    }
}

- (NSMutableArray *)queryDBWithSQL:(NSString *)SQL {
    
    // 结果集
    sqlite3_stmt *ppStmt = NULL;
    // 执行查询语句
    int result = sqlite3_prepare_v2(db, SQL.UTF8String, -1, &ppStmt, NULL);
    
    // 取出某一个行数的数据
    NSMutableArray *tempMuArr = [NSMutableArray array];
    
    if (result == SQLITE_OK) {
        NSLog(@"查询数据成功");
        // 获取字段的个数
        int count = sqlite3_column_count(ppStmt);
        while (sqlite3_step(ppStmt) == SQLITE_ROW) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (int i = 0; i < count; i++) {
                // 1.取出当前字段的名称(key)
                NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(ppStmt, i)];
                
                // 2.取出当前字段对应的值(value)
                const char *cValue = (const char *)sqlite3_column_text(ppStmt, i);
                NSString *value = [NSString stringWithUTF8String:cValue];
                
                // 3.将键值对放入字典中
                [dict setObject:value forKey:key];
            }
            
            [tempMuArr addObject:dict];
        }
    } else {
        NSLog(@"查询数据失败");
    }

    // 释放结果集 : 不然会内存泄露
    sqlite3_finalize(ppStmt);
    
    return tempMuArr;
}

@end

//
//  VENSQLiteManager.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/28.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENSQLiteManager : NSObject
+ (instancetype)sharedSQLiteManager;
- (void)openDB;
- (NSMutableArray *)queryDBWithSQL:(NSString *)SQL;

@end

NS_ASSUME_NONNULL_END

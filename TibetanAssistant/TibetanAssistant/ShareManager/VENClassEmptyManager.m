//
//  VENClassEmptyManager.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/21.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassEmptyManager.h"

@implementation VENClassEmptyManager

+ (instancetype)sharedManager {
    static VENClassEmptyManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)isEmptyString:(NSString *)string {
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!string.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmptyArray:(NSArray *)array {
    if (!array) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!array.count) {
        return YES;
    }
    return NO;
}

@end

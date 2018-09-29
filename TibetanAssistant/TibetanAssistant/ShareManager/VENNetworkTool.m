//
//  VENNetworkTool.m
//  EDAWCulture
//
//  Created by YVEN on 2018/9/16.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkTool.h"

@implementation VENNetworkTool

+ (instancetype)sharedNetworkToolManager {
    static VENNetworkTool *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"http://yidao.ahaiba.com.cn/api/index.php/"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15;
        instance = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
        [instance.requestSerializer setValue:@"user_ios_lower_key" forHTTPHeaderField:@"X-API-KEY"];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    });
    return instance;
}

@end

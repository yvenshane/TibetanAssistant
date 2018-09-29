//
//  VENNetworkTool.h
//  EDAWCulture
//
//  Created by YVEN on 2018/9/16.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface VENNetworkTool : AFHTTPSessionManager
+ (instancetype)sharedNetworkToolManager;

@end

//
//  VENMBProgressHUDManager.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/30.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMBProgressHUDManager : MBProgressHUD
+ (instancetype)sharedMBProgressHUDManager;
- (void)showText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

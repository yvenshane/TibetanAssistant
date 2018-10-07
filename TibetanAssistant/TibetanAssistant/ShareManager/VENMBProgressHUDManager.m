//
//  VENMBProgressHUDManager.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/30.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMBProgressHUDManager.h"

@implementation VENMBProgressHUDManager

+ (instancetype)sharedMBProgressHUDManager {
    static VENMBProgressHUDManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:2.0f];
    hud.userInteractionEnabled = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

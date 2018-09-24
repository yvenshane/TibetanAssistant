//
//  VENTabBarView.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^finishBlock)(NSString *);
@interface VENTabBarView : UIView
@property (nonatomic, copy) finishBlock blk;

@end

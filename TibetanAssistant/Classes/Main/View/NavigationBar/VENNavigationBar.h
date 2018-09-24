//
//  VENNavigationBar.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueBlock) (NSString *strValue, NSInteger buttonTag, NSString *buttonTitle);
@interface VENNavigationBar : UIView
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@end

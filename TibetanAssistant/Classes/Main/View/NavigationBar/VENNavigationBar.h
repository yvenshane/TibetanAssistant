//
//  VENNavigationBar.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^finishBlock3)(NSString *);
typedef void (^finishBlock2)(NSArray *, NSString *);
typedef void (^ReturnValueBlock) (NSString *strValue, NSInteger buttonTag, NSString *buttonTitle);

@interface VENNavigationBar : UIView

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic, copy) finishBlock2 blk;
@property (nonatomic, copy) finishBlock3 blk3;

@end


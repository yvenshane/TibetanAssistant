//
//  VENPopView.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnButtonTagBlock) (NSInteger buttonTag, NSString *buttonTitle);
@interface VENPopView : UIView
@property(nonatomic, copy) ReturnButtonTagBlock returnButtonTagBlock;

- (instancetype)initWithFrame:(CGRect)frame setPopViewData:(NSArray *)dataArr;

@end

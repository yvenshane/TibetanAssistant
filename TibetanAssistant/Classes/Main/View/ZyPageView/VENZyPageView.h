//
//  VENZyPageView.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/10/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^pushWebViewBlock)(NSString *, NSString *);
@interface VENZyPageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property (nonatomic, copy) pushWebViewBlock block;

@end

NS_ASSUME_NONNULL_END



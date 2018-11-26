//
//  VENWebViewController.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/10/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^finishBlock)(NSString *);
@interface VENWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (nonatomic, copy) NSString *fileNumber;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) finishBlock blk;

@end

NS_ASSUME_NONNULL_END

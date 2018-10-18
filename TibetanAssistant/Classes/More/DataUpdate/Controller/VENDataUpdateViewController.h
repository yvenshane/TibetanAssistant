//
//  VENDataUpdateViewController.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^finishBlock)(NSString *);
@interface VENDataUpdateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *navigationLeftButton;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (weak, nonatomic) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet UIButton *suspendButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (nonatomic, copy) NSString *serverStr;
@property (nonatomic, copy) finishBlock blk;

@end

NS_ASSUME_NONNULL_END

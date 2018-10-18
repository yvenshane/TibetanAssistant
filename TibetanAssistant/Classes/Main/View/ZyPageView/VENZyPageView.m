//
//  VENZyPageView.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/10/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENZyPageView.h"
#import "VENWebViewController.h"

@implementation VENZyPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect {
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    
    self.button1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.button3.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.button4.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.button5.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    [self.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    self.button4.tag = 4;
    self.button5.tag = 5;
}

- (void)buttonClick:(UIButton *)button {
    self.block([NSString stringWithFormat:@"%ld", (long)button.tag], button.titleLabel.text);
}

@end

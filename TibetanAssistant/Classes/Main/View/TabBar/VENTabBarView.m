//
//  VENTabBarView.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTabBarView.h"

@interface VENTabBarView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *tabBarButtonsMuArr;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation VENTabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *titleArr = @[@"首页", @"收藏", @"更多"];
        NSArray *imageArr = @[@"tabBar1", @"tabBar2", @"tabBar3"];
        
        
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i + 1;
            
            button.selected = button.tag == 1 ? YES : NO;
            
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_nor", imageArr[i]]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on", imageArr[i]]] forState:UIControlStateSelected];
            
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            
            [button setTitleColor:UIColorFromRGB(0x818181) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x61C0B5) forState:UIControlStateSelected];
            
            button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize buttonSize = button.frame.size;
            CGSize titleSize = button.titleLabel.intrinsicContentSize;
            CGSize imageSize = button.imageView.intrinsicContentSize;
            CGFloat buttonSpace = 3.0;
            
            CGFloat verticalSpace = (buttonSize.height - titleSize.height - imageSize.height - buttonSpace)/2.0;
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(verticalSpace, (buttonSize.width-imageSize.width)/2.0, verticalSpace + titleSize.height + buttonSpace, (buttonSize.width-imageSize.width)/2.0-titleSize.width)];
            
            [button setTitleEdgeInsets:UIEdgeInsetsMake(verticalSpace + imageSize.height + buttonSpace, (buttonSize.width - titleSize.width)/2.0 - imageSize.width, verticalSpace, (buttonSize.width - titleSize.width)/2.0)];
            
            [self addSubview:button];
            [self.tabBarButtonsMuArr addObject:button];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self addSubview:lineView];
        
        self.lineView = lineView;
    }
    return self;
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *btn in _tabBarButtonsMuArr) {
        button.selected = YES;
        btn.selected = btn.tag == button.tag ? YES : NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = kMainScreenWidth / 3;
    
    for (NSInteger i = 0; i < _tabBarButtonsMuArr.count; i++) {
        _tabBarButtonsMuArr[i].frame = CGRectMake(buttonWidth * i, 1, buttonWidth, 49);
    }
    
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 1);
}

- (NSMutableArray *)tabBarButtonsMuArr {
    if (_tabBarButtonsMuArr == nil) {
        _tabBarButtonsMuArr = [NSMutableArray array];
    }
    return _tabBarButtonsMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

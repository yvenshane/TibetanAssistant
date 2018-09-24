//
//  VENPopView.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPopView.h"

@interface VENPopView ()
@property (nonatomic, strong) NSMutableArray<UIView *> *viewsMuArr;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonsMuArr;
@property (nonatomic, strong) NSMutableArray *dataMuArr;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, copy) NSString *titleButtonTitle;

@end

@implementation VENPopView

- (instancetype)initWithFrame:(CGRect)frame setPopViewData:(NSArray *)dataArr {
    if (self == [super initWithFrame:frame]) {
        
        self.titleButtonTitle = dataArr.lastObject;
        
        [self.dataMuArr addObjectsFromArray:dataArr];
        [self.dataMuArr removeLastObject];
        
        self.backgroundColor = UIColorMake(248, 245, 247);
        
        for (NSInteger i = 0; i < self.dataMuArr.count; i++) {
            
            UIView *view = [[UIButton alloc] init];
//            view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            [self addSubview:view];
            
            UIButton *button = [[UIButton alloc] init];
            button.tag = i + 1;
            [button setTitle:self.dataMuArr[i] forState:UIControlStateNormal];

            [button setTitleColor:UIColorMake(129, 129, 129) forState:UIControlStateNormal];
            [button setTitleColor:UIColorMake(0, 111, 106) forState:UIControlStateSelected];

            button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            [self.viewsMuArr addObject:view];
            [self.buttonsMuArr addObject:button];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorMake(221, 221, 221);
        [self addSubview:lineView];
        
        UIButton *titleButton = [[UIButton alloc] init];
        [titleButton setTitle:self.titleButtonTitle forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorMake(0, 111, 106) forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:titleButton];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorMake(221, 221, 221);
        [self addSubview:lineView2];
        
        self.lineView = lineView;
        self.titleButton = titleButton;
        self.lineView2 = lineView2;
    }
    return self;
}

- (void)buttonClick:(UIButton* )button {
    for (UIButton *btn in _buttonsMuArr) {
        button.selected = YES;
        btn.selected = btn.tag == button.tag ? YES : NO;
        
        if (btn.selected == YES) {
            btn.layer.borderColor = UIColorMake(221, 221, 221).CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 25.0 / 2.0f;
            btn.layer.masksToBounds = YES;
            
            [self.titleButton setTitle:[NSString stringWithFormat:@"%@ - %@", self.titleButtonTitle, button.titleLabel.text] forState:UIControlStateNormal];
        } else {
            btn.layer.borderColor = UIColorMake(248, 245, 247).CGColor;
//            btn.layer.masksToBounds = NO;
        }
    }
    self.returnButtonTagBlock(button.tag, button.titleLabel.text);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewWidth = kMainScreenWidth / 4;

    for (NSInteger i = 0; i < self.viewsMuArr.count; i++) {
        int row = i / 4;
        int column = i % 4;
        self.viewsMuArr[i].frame = CGRectMake(column * viewWidth, row * 44, viewWidth, 44);
    }
    
    CGFloat x = viewWidth / 2  - 60 / 2;
    CGFloat y = 44 / 2 - 25 / 2;
    
    for (NSInteger i = 0; i < self.buttonsMuArr.count; i++) {
        self.buttonsMuArr[i].frame = CGRectMake(x, y, 60, 25);
    }

    self.lineView.frame = CGRectMake(0, ceil(self.dataMuArr.count / 4.0) * 44, kMainScreenWidth, 1);
    self.titleButton.frame = CGRectMake(25, ceil(self.dataMuArr.count / 4.0) * 44, kMainScreenWidth - 50, 44);
    self.lineView2.frame = CGRectMake(0, ceil(self.dataMuArr.count / 4.0) * 44 + 44, kMainScreenWidth, 1);
}

- (NSMutableArray *)dataMuArr {
    if (_dataMuArr == nil) {
        _dataMuArr = [NSMutableArray array];
    }
    return _dataMuArr;
}

- (NSMutableArray *)viewsMuArr {
    if (_viewsMuArr == nil) {
        _viewsMuArr = [NSMutableArray array];
    }
    return _viewsMuArr;
}

- (NSMutableArray *)buttonsMuArr {
    if (_buttonsMuArr == nil) {
        _buttonsMuArr = [NSMutableArray array];
    }
    return _buttonsMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  VENNavigationBar.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNavigationBar.h"

@interface VENNavigationBar ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *searchBarTextField;
@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonsMuArr;
@property (nonatomic, strong) NSMutableArray *buttonsTitleMuArr;

@end

@implementation VENNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        // logo
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:@"nav_logo"];
        [self addSubview:logoImageView];
        
        // 搜索
        UITextField *searchBarTextField = [[UITextField alloc] init];
        searchBarTextField.backgroundColor = [UIColor whiteColor];
        searchBarTextField.font = [UIFont systemFontOfSize:14.0f];
        searchBarTextField.placeholder = @"搜索";
        searchBarTextField.layer.cornerRadius = 4.0f;
        searchBarTextField.layer.masksToBounds = YES;
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        searchBarTextField.leftView = tempView;
        searchBarTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        searchButton.backgroundColor = UIColorMake(246, 171, 0);
        [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
        searchBarTextField.rightView = searchButton;
        searchBarTextField.rightViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:searchBarTextField];
        
        // toolsView
        UIView *toolsView = [[UIView alloc] init];
//        toolsView.backgroundColor = [UIColor redColor];
        [self addSubview:toolsView];
        
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:self.buttonsTitleMuArr[i] forState:UIControlStateNormal];
            button.tag = i + 1;
            
            [button setTitleColor:UIColorMake(166, 238, 227) forState:UIControlStateNormal];
            [button setTitleColor:UIColorMake(0, 112, 107) forState:UIControlStateSelected];
            
            [button setBackgroundImage:[UIImage imageNamed:@"nav_lv"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"nav_bai"] forState:UIControlStateSelected];
            
            [self.buttonsMuArr addObject:button];
            [toolsView addSubview:button];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.logoImageView = logoImageView;
        self.searchBarTextField = searchBarTextField;
        self.toolsView = toolsView;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.logoImageView.frame = CGRectMake(16, 20 + 16, 237 / 2, 73 / 2);
    self.searchBarTextField.frame = CGRectMake(16 + 237 / 2 + 25 / 2, 20 + 16 + 3.25, kMainScreenWidth - 16 - 237 / 2 - 25 / 2 - 16, 30);
    self.toolsView.frame = CGRectMake(0, 20 + 16 + 73 / 2 + 8, kMainScreenWidth, 40);
    
    for (NSInteger i = 0; i < 3; i++) {
        _buttonsMuArr[i].frame = CGRectMake(i * kMainScreenWidth / 3, 0, kMainScreenWidth / 3, 40.5);
    }
}

- (void)buttonClick:(UIButton *)button {
    
    for (UIButton *btn in _buttonsMuArr) {
        button.selected = YES;
        btn.selected = btn.tag == button.tag ? YES : NO;
    }
}

- (NSMutableArray *)buttonsMuArr {
    if (_buttonsMuArr == nil) {
        _buttonsMuArr = [NSMutableArray array];
    }
    return _buttonsMuArr;
}

- (NSMutableArray *)buttonsTitleMuArr {
    if (_buttonsTitleMuArr == nil) {
        _buttonsTitleMuArr = [NSMutableArray arrayWithArray:@[@"日常用语", @"电力用语", @"常用词汇"]];
    }
    return _buttonsTitleMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

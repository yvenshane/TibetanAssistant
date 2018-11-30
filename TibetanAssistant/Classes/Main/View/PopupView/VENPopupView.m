//
//  VENPopupView.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/11/30.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPopupView.h"

@implementation VENPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4.0f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"1、“藏语日常用语学习助手”手机应用软件旨在响应国网青海省电力公司员工学习藏语口活动的开展，做为职工学习藏语口语的小工具。本助手收集了日常生活用语、电力服务常用语句及基本的常用词汇，以方便使用者查阅和学习；\n2、本助手发音为安多方言，但汉藏语系形式较多，即便是安多方言，也会存在着不同的差异，其书面语和口语之间也会有所不同，助手中个别播音与文字内容稍有差异，请学习者注意；\n3、助手中提供了藏语的谐音读法，但因藏语发音丰富，很多音节无法用汉字准确表述，所以仅供学习者参考，正确读音应以播音为准；\n4、本助手收集的词汇有限，今后将逐步扩充；\n5、我们期待您对本助手提出宝贵的意见，我们会不断完善和改进，以期对您的藏语之行有所助益。";
        label.font = [UIFont systemFontOfSize:17.0f];
        label.numberOfLines = 0;
        [view addSubview:label];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [view addSubview:button];
        
        self.view = view;
        self.label = label;
        self.button = button;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"1、“藏语日常用语学习助手”手机应用软件旨在响应国网青海省电力公司员工学习藏语口活动的开展，做为职工学习藏语口语的小工具。本助手收集了日常生活用语、电力服务常用语句及基本的常用词汇，以方便使用者查阅和学习；\n2、本助手发音为安多方言，但汉藏语系形式较多，即便是安多方言，也会存在着不同的差异，其书面语和口语之间也会有所不同，助手中个别播音与文字内容稍有差异，请学习者注意；\n3、助手中提供了藏语的谐音读法，但因藏语发音丰富，很多音节无法用汉字准确表述，所以仅供学习者参考，正确读音应以播音为准；\n4、本助手收集的词汇有限，今后将逐步扩充；\n5、我们期待您对本助手提出宝贵的意见，我们会不断完善和改进，以期对您的藏语之行有所助益。";
    label.font = [UIFont systemFontOfSize:17.0f];
    label.numberOfLines = 0;
    CGFloat height = [self label:label setHeightToWidth:kMainScreenWidth - 64 - 32];
    
    self.view.frame = CGRectMake(32, 72, kMainScreenWidth - 64, height + 16 + 16 + 44);
    self.label.frame = CGRectMake(16, 16, kMainScreenWidth - 64 - 32, height);
    self.button.frame = CGRectMake(0, height + 16 + 16 + 1, kMainScreenWidth - 64, 43);
    
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

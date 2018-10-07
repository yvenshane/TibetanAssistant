//
//  VENHelpViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/29.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHelpViewController.h"

@interface VENHelpViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;

@end

@implementation VENHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = UIColorMake(248, 245, 247);
    
    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"img_help"];
//    imageView.contentMode = UIViewContentModeCenter;
    CGFloat imgW = kMainScreenWidth;
    CGFloat imgH = imageView.image.size.height; // 图片的高度
    imageView.frame = CGRectMake(0, 0, imgW, imgH - 1600);
    [self.scrollView addSubview:imageView];
    
    // 设置UIScrollView的滚动范围（内容大小）
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, imgH - 1600);
    
    // 隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    // 用来记录scrollview滚动的位置
    //    scrollView.contentOffset = ;
    
    // 去掉弹簧效果
    //    scrollView.bounces = NO;
    
    // 增加额外的滚动区域（逆时针，上、左、下、右）
    // top  left  bottom  right
//    self.scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

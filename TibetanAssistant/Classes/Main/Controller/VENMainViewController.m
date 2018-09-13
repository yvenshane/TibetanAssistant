//
//  VENMainViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMainViewController.h"
#import "VENTabBarView.h"

@interface VENMainViewController ()

@end

@implementation VENMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupTabBar];
}

- (void)setupTabBar {
    VENTabBarView *tabBar = [[VENTabBarView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49)];
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  VENDataUpdateViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDataUpdateViewController.h"

@interface VENDataUpdateViewController ()

@end

@implementation VENDataUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomButton.layer.cornerRadius = 44.5 / 2;
    self.bottomButton.layer.masksToBounds = YES;
    
}

- (IBAction)navigationLeftButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bottomButtonClick:(id)sender {
    
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

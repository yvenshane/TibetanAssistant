//
//  VENWebViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/10/18.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENWebViewController.h"

@interface VENWebViewController ()

@end

@implementation VENWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"part%@.html", self.fileNumber] withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.titleButton setTitle:self.title forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
}

- (IBAction)bacbuttonClick:(id)sender {
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

//
//  VENAboutViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/29.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAboutViewController.h"

@interface VENAboutViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;

@end

@implementation VENAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.view.backgroundColor = UIColorMake(248, 245, 247);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"V %@.%@", app_Version, localStr];
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

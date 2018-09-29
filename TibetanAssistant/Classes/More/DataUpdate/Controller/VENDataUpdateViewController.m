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
    
    [self downloadDataBase];
    [self createDir];
}

- (void)downloadDataBase {
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/tibetan.db"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[[VENNetworkTool sharedNetworkToolManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //        NSLog(@"打印下下载进度:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/db/%@", response.suggestedFilename]];
        
        //        NSLog(@"\n targetPath:%@ \n \n", targetPath);
        //        NSLog(@"\n fullPath:%@----%@ \n \n", fullPath,[NSURL fileURLWithPath:fullPath]);
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"\n 完成：\n %@ \n \n%@", response, filePath);
        NSHTTPURLResponse *response1 = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [response1 statusCode];
        
        if (statusCode == 200) {
            
        } else {
            
        }
    }] resume];
}

- (void)createDir {
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    NSString *dataFilePath = [cachesDir stringByAppendingPathComponent:@"/zyzs/db/"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
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

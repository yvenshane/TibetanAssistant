//
//  VENDataUpdateViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDataUpdateViewController.h"

@interface VENDataUpdateViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;

@property (nonatomic, assign) NSInteger downloadCount;
@property (nonatomic, copy) NSString *serverStr;

@end

@implementation VENDataUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.downloadButton.layer.cornerRadius = 44.5 / 2;
    self.downloadButton.layer.masksToBounds = YES;
    
    [self downloadVersionFile];
}

- (IBAction)navigationLeftButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downloadButtonClick:(id)sender {
    [self downloadDataBase];
    
    self.downloadButton.hidden = YES;
}

- (void)downloadVersionFile {
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/Ver.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self createDirWithPath:@"version"];
    
    [[[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/version/%@", response.suggestedFilename]];
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/version/Ver.txt"];
        
        NSString *serverStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
        NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        
        self.serverStr = serverStr;
        
        NSLog(@"%@", serverStr);
        NSLog(@"%@", localStr);
        
        
//        [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"正在比对版本信息"];
        
        if ([localStr isEqualToString:serverStr]) {
            
        } else {
            
        }
        
    }] resume];
}

- (void)downloadDataBase {
    
    self.progressView.hidden = NO;
    self.progressLabel.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/tibetan.db"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self createDirWithPath:@"db"];
    
    [[[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
                __weak typeof(self) weakSelf = self;

                // 获取主线程，不然无法正确显示进度。
                NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
                [mainQueue addOperationWithBlock:^{
                    // 下载进度
                    weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
                }];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/db/%@", response.suggestedFilename]];
        
        //        NSLog(@"\n targetPath:%@ \n \n", targetPath);
        //        NSLog(@"\n fullPath:%@----%@ \n \n", fullPath,[NSURL fileURLWithPath:fullPath]);
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"\n 完成：\n %@ \n \n%@", response, filePath);
        [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"数据库下载完成"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"准备下载音频文件"];
        });
        
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
        
        [self downloadVoice];
        
    }] resume];
    
    
    
//    // 写入版本号
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:_serverStr forKey:@"version"];
//    [defaults synchronize];
    
    
}

- (void)downloadVoice {
    // 打开数据库
    [[VENSQLiteManager sharedSQLiteManager] openDB];
    // 查询语句
    NSString *querySQL2 = @"SELECT number FROM tablewords;";
    
    NSArray *tempArr = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL2];
    
    self.downloadCount = 0;
    
    // 拿到所有 MP3 文件名
    for (NSDictionary *dict in tempArr) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.92.225.21/py/%@.mp3", dict[@"number"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self createDirWithPath:@"py"];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
            
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/py/%@", response.suggestedFilename]];
            
            //        NSLog(@"\n targetPath:%@ \n \n", targetPath);
            //        NSLog(@"\n fullPath:%@----%@ \n \n", fullPath,[NSURL fileURLWithPath:fullPath]);
            
            return [NSURL fileURLWithPath:fullPath];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            //                NSLog(@"%@", error.userInfo);
            
            if (error) {
                [self deleteFileWithPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/py/%@", response.suggestedFilename]]];
            } else {
                self.downloadCount++;
                //                    NSLog(@"%ld", (long)self->_downloadCount);
                
                __weak typeof(self) weakSelf = self;
                
                // 获取主线程，不然无法正确显示进度。
                NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
                [mainQueue addOperationWithBlock:^{
                    // 下载进度
                    
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        weakSelf.progressView.hidden = NO;
                        weakSelf.progressLabel.hidden = NO;
                    });
                    
                    weakSelf.progressView.progress = 1.0 *  self.downloadCount / tempArr.count;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 *  self.downloadCount / tempArr.count];
                }];
                
            }
        }];
        
        // 4. 开启下载任务
        [downloadTask resume];
    }
}

- (void)deleteFileWithPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    } else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"dele success");
        } else {
            NSLog(@"dele fail");
        }
    }
}

- (void)createDirWithPath:(NSString *)path {
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    NSString *dataFilePath = [cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/%@/", path]];
    
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

//
//  VENDataUpdateViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDataUpdateViewController.h"
#import "SSZipArchive.h"

@interface VENDataUpdateViewController () <SSZipArchiveDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;

@property (nonatomic, copy) NSString *serverStr;
@property (nonatomic, copy) NSString *logStr;

@end

@implementation VENDataUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.downloadButton.layer.cornerRadius = 44.5 / 2;
    self.downloadButton.layer.masksToBounds = YES;
    
    self.continueButton.layer.cornerRadius = 44.5 / 2;
    self.continueButton.layer.masksToBounds = YES;
    
    self.suspendButton.layer.cornerRadius = 44.5 / 2;
    self.suspendButton.layer.masksToBounds = YES;
    
    [self downloadVersionFile];
}

- (IBAction)navigationLeftButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downloadButtonClick:(UIButton *)btn {
    if (btn.selected == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self downloadDataBase];
        self.downloadButton.hidden = YES;
    }
}

- (IBAction)suspendButtonClick:(id)sender {
    
}

- (IBAction)continueButtonClick:(id)sender {
    
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
        
        NSLog(@"serverStr - %@", serverStr);
        NSLog(@"localStr - %@", localStr);

        if ([localStr isEqualToString:serverStr]) {
            self.topLabel.text = @"当前已是最近版本";
            self.imageButton.selected = YES;
            [self.downloadButton setTitle:@"我知道了" forState:UIControlStateNormal];
            self.downloadButton.backgroundColor = COLOR_THEME;
            self.downloadButton.hidden = NO;
            self.downloadButton.selected = YES;
        } else {
            if (localStr != nil) {
                self.downloadButton.hidden = YES;
                [self downloadDataBase];
            }
        }
        
        self.coverView.hidden = YES;
        
    }] resume];
}

- (void)downloadDataBase {
    
    _logTextView.hidden = NO;
    _logStr = @"正在下载数据库";
    _logTextView.text = _logStr;
    
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

        self.logStr = [self.logStr stringByAppendingString:@"\n数据库下载完成"];
        self.logTextView.text = _logStr;
        
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
        
        [self downloadVoice];
        
    }] resume];
}

- (void)downloadVoice {
    
    self.logStr = [self.logStr stringByAppendingString:@"\n正在下载音频文件"];
    self.logTextView.text = _logStr;
    
    self.progressView.hidden = NO;
    self.progressLabel.hidden = NO;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/vp.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        __weak typeof(self) weakSelf = self;
        
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            // 下载进度
            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        }];
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/%@", response.suggestedFilename]];
        
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"\n 完成：\n %@ \n \n%@", response, filePath);
        
        self.logStr = [self.logStr stringByAppendingString:@"\n音频文件下载完成"];
        self.logTextView.text = self.logStr;
        
        NSString *zipFilePath = [filePath path];
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py"];
        [self createDirWithPath:@"py"];
        [self releaseZipFilesWithUnzipFileAtPath:zipFilePath Destination:fullPath];
    }];
    
    [downloadTask resume];
}

// 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",unzipPath);
    } else {
        NSLog(@"%@",error);
    }
}

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    self.logStr = [self.logStr stringByAppendingString:@"\n正在解压音频文件"];
    self.logTextView.text = self.logStr;
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    self.logStr = [self.logStr stringByAppendingString:@"\n音频文件解压完成"];
    self.logTextView.text = self.logStr;
    
    self.logTextView.hidden = YES;
    self.progressView.hidden = YES;
    self.progressLabel.hidden = YES;
    
    self.topLabel.text = @"当前已是最近版本";
    self.imageButton.selected = YES;
    [self.downloadButton setTitle:@"我知道了" forState:UIControlStateNormal];
    self.downloadButton.backgroundColor = COLOR_THEME;
    self.downloadButton.selected = YES;
    self.downloadButton.hidden = NO;
    
    // 写入版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serverStr forKey:@"version"];
    [defaults synchronize];
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

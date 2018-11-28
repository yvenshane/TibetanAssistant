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
@property (weak, nonatomic) IBOutlet UIProgressView *progressView; // 进度条
@property (weak, nonatomic) IBOutlet UILabel *progressLabel; // 进度描述文字
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarLayoutConstraint;

@property (nonatomic , strong) AFURLSessionManager *manager;
@property (nonatomic , strong) NSURLSessionDataTask *downloadTask; // 下载任务
@property (nonatomic , assign) NSInteger currentLength; // 当前长度
@property (nonatomic , assign) NSInteger totalLength; // 总长度
@property (nonatomic , strong) NSFileHandle *fileHandle; // 文件句柄对象

@property (nonatomic, assign) BOOL networkDisabled;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation VENDataUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.statusBarLayoutConstraint.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.downloadButton.layer.cornerRadius = 44.5 / 2;
    self.downloadButton.layer.masksToBounds = YES;
    
    self.continueDownloadButton.layer.cornerRadius = 44.5 / 2;
    self.continueDownloadButton.layer.masksToBounds = YES;
    
    self.redownloadButton.layer.cornerRadius = 44.5 / 2;
    self.redownloadButton.layer.masksToBounds = YES;
    
    NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
//    NSLog(@"serverStr - %@", self.serverStr);
    NSLog(@"localStr - %@", localStr);
    
    // 有下载内容
    NSString *currentLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLength"];
    self.currentLength = [currentLength integerValue];
    
    NSString *totalLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalLength"];
    
    if (self.currentLength != 0) {
        self.topLabel.text = @"数据传输意外中断";
        [self.imageButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateNormal];
        
        self.downloadButton.hidden = YES;
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        self.downloadView.hidden = NO;
        
        self.progressView.progress =  1.0 * self.currentLength / [totalLength integerValue];
        self.progressLabel.text = [NSString stringWithFormat:@"下载音频文件压缩包%.2fMB/%.2fMB", [currentLength floatValue] / 1024 /1024, [totalLength floatValue] / 1024 /1024];
    } else {
        
        // 检查服务器最新数据
        NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/Ver.txt"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        // 文件路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/version"];
        
        // 创建文件夹
        [self createDirWithPath:@"version"];
        
        // 删除文件
        BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        if (isDelete) {
            // 创建文件夹
            [self createDirWithPath:@"version"];
            
            // 下载版本信息
            [[[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/version/%@", response.suggestedFilename]];
                
                return [NSURL fileURLWithPath:fullPath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
                NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/version/Ver.txt"];
                
                NSString *serverStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
                
                if ([serverStr isEqualToString:localStr]) {
                    self.topLabel.text = @"当前已是最近版本";
                    self.imageButton.selected = YES;
                    self.logLabel.hidden = YES;
                    
                    self.downloadView.hidden = NO;
                    self.continueDownloadButton.backgroundColor = COLOR_THEME;
                    [self.continueDownloadButton setTitle:@"知道了" forState:UIControlStateNormal];
                    self.isFinish = YES;
                    
                } else {
                    self.topLabel.text = @"发现最新离线数据包";
                    self.imageButton.selected = NO;
                    self.logLabel.hidden = YES;
                    
                    self.downloadView.hidden = YES;
                    self.downloadButton.hidden = NO;
                }
                
            }] resume];
        }
    }
    
    [self AFNReachability];
}

// 返回按钮
- (IBAction)navigationLeftButtonClick:(id)sender {
    [self.downloadTask suspend];
    self.downloadTask = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击下载
- (IBAction)downloadButtonClick:(UIButton *)btn {
    
    if (self.networkDisabled) {
        [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"网络不可用"];
    } else {
        
        // 创建 文件夹
        [self createDirWithPath:@"db"];
        [self createDirWithPath:@"py"];
        
        // 删除 文件夹
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/db"];
        NSString *pyPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py"];
        
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
        BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:pyPath error:nil];
        if (isDelete) {
            
            // 创建 文件夹
            [self createDirWithPath:@"db"];
            [self createDirWithPath:@"py"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"数据更新会清空收藏夹内容，是否继续？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.progressView.hidden = NO;
                self.progressLabel.hidden = NO;
                //        self.downloadView.hidden = NO;
                
                [self downloadDataBase];
            }];
            
            [alert addAction:appropriateAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

// 继续下载
- (IBAction)continueDownloadButtonClick:(id)sender {
    
    if (self.isFinish) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.networkDisabled) {
            [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"网络不可用"];
        } else {
            [self.downloadTask resume];
        }
    }
}

// 重新下载
- (IBAction)redownloadButtonClick:(id)sender {
    
    if (self.networkDisabled) {
        [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"网络不可用"];
    } else {
        
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        
        // 创建 文件夹
        [self createDirWithPath:@"db"];
        [self createDirWithPath:@"py"];
        
        // 删除 文件夹
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/db"];
        NSString *pyPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py"];
        
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
        BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:pyPath error:nil];
        if (isDelete) {
            
            // 创建 文件夹
            [self createDirWithPath:@"db"];
            [self createDirWithPath:@"py"];
            
            [self.downloadTask cancel];
            self.currentLength = 0;
            self.downloadTask = nil;
            self.manager = nil;
            
            [self downloadDataBase];
        }
    }
}

- (void)downloadDataBase {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/tibetan.db"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self createDirWithPath:@"db"];

    // 删除 db
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/db"];

    BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    if (isDelete) {

        [self createDirWithPath:@"db"];
        
        __weak typeof(self) weakSelf = self;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 下载进度
                weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
            }];
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/db/%@", response.suggestedFilename]];
            
            //        NSLog(@"\n targetPath:%@ \n \n", targetPath);
            //        NSLog(@"\n fullPath:%@----%@ \n \n", fullPath,[NSURL fileURLWithPath:fullPath]);
            
            return [NSURL fileURLWithPath:fullPath];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            
            
//            [self.downloadTask cancel];
            self.currentLength = 0;
            self.downloadTask = nil;
            self.manager = nil;
            
            [self.downloadTask resume];
        }];
        
        [downloadTask resume];
    }
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 1. 创建会话管理者
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        
        // 创建下载URL
        NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/vp.zip"];
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"dataTaskWithRequest");
            
            // 下载完成回调block
            NSLog(@"完成");
            
            [self.downloadTask cancel];
            
            // 清空长度
            weakSelf.currentLength = 0;
            weakSelf.totalLength = 0;
            
            // 关闭fileHandle
            [weakSelf.fileHandle closeFile];
            weakSelf.fileHandle = nil;
            
            // 解压
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py/vp.zip"];
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py"];
            
            [self releaseZipFilesWithUnzipFileAtPath:path Destination:fullPath];
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            // 每次唤醒task的时候会回调这个block
            NSLog(@"NSURLSessionResponseDisposition");
            NSLog(@"启动任务");
            
            // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            weakSelf.totalLength = response.expectedContentLength + self.currentLength;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%ld", (long)weakSelf.totalLength] forKey:@"totalLength"];
            [defaults synchronize];
            
            // 沙盒文件路径
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/py/vp.zip"];
            
            NSLog(@"File downloaded to: %@",path);
            
            // 创建一个空的文件到沙盒中
            NSFileManager *manager = [NSFileManager defaultManager];
            
            if (![manager fileExistsAtPath:path]) {
                // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
                [manager createFileAtPath:path contents:nil attributes:nil];
            }
            
            // 创建文件句柄
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
            
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return NSURLSessionResponseAllow;
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            // 一直回调，直到下载完成
//            NSLog(@"setDataTaskDidReceiveDataBlock");
            
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%ld", (long)weakSelf.currentLength] forKey:@"currentLength"];
            [defaults synchronize];
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                
                CGFloat currentLength = weakSelf.currentLength;
                CGFloat totalLength = weakSelf.totalLength;
                
                // 下载进度
                if (weakSelf.totalLength == 0) {
                    weakSelf.progressView.progress = 0.0;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:00.00%%"];
                } else {
                    weakSelf.progressView.progress =  1.0 * weakSelf.currentLength / weakSelf.totalLength;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"下载音频文件压缩包%.2fMB/%.2fMB", currentLength / 1024 / 1024, totalLength / 1024 / 1024];
                }
                
            }];
        }];
    }
    return _downloadTask;
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
// 将要解压
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    
    // 检查服务器最新数据
    NSURL *url = [NSURL URLWithString:@"http://47.92.225.21/Ver.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 文件路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/version"];
    
    // 创建文件夹
    [self createDirWithPath:@"version"];
    
    // 删除文件
    BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    if (isDelete) {
        // 创建文件夹
        [self createDirWithPath:@"version"];
        
        // 下载版本信息
        [[[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/version/%@", response.suggestedFilename]];
            
            return [NSURL fileURLWithPath:fullPath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/zyzs/version/Ver.txt"];
            
            NSString *serverStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"0" forKey:@"currentLength"];
            // 写入版本号
            [defaults setObject:serverStr forKey:@"version"];
            [defaults synchronize];
            
            NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
            NSLog(@"serverStr %@", serverStr);
            NSLog(@"localStr %@", localStr);
            
            // 首页刷新
            self.blk(@"");
            
            self.progressView.hidden = YES;
            self.progressLabel.hidden = YES;
            
            self.topLabel.text = @"当前已是最近版本";
            self.imageButton.selected = YES;
            self.downloadView.hidden = NO;
            self.logLabel.hidden = YES;
            self.continueDownloadButton.backgroundColor = COLOR_THEME;
            [self.continueDownloadButton setTitle:@"知道了" forState:UIControlStateNormal];
            self.isFinish = YES;
            
        }] resume];
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

#pragma mark - Navigation
- (void)AFNReachability {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [self.downloadTask suspend];
        self.downloadTask = nil;
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                
                self.networkDisabled = YES;
                if (self.currentLength != 0) {
                    self.topLabel.text = @"数据传输意外中断";
                    [self.imageButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateNormal];
                    [self.imageButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateSelected];
                    
                    self.downloadButton.hidden = YES;
                    self.downloadView.hidden = NO;
                    
//                    self.continueDownloadButton.backgroundColor = UIColorMake(247, 172, 0);
                    [self.continueDownloadButton setTitle:@"继续下载" forState:UIControlStateNormal];
                    self.logLabel.hidden = NO;
                    self.isFinish = NO;
                }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4G");
                
                self.networkDisabled = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");

                self.networkDisabled = NO;
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

@end

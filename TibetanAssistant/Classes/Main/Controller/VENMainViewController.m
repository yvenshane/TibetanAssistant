//
//  VENMainViewController.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMainViewController.h"
#import "VENTabBarView.h"
#import "VENNavigationBar.h"
#import "VENPopView.h"
#import "VENMainTableViewCell.h"
#import "VENDataUpdateViewController.h"
#import "VENHomePageTableViewCell.h"
#import "VENAboutViewController.h"
#import "VENHelpViewController.h"
#import "VENZyPageView.h"
#import "VENWebViewController.h"

@interface VENMainViewController () <UITableViewDelegate , UITableViewDataSource>
@property (nonatomic, strong) VENPopView *popView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tablesmallstyleArr; // 所有二级类
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr1; // 日常用语
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr2; // 电力用语
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr3; // 常用词汇
@property (nonatomic, strong) NSMutableArray *dataMuArr;

@property (nonatomic, strong) NSMutableArray *tablewordsArr; // 所有三级类

@property (nonatomic, strong) NSMutableArray *dataSource; // tableView 数据源

@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, assign) BOOL showCollectionButton;
@property (nonatomic, assign) BOOL changLabelTitle;
@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, copy) NSString *serverStr;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL isRefresh;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier1 = @"cellIdentifier1";
@implementation VENMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.isRefresh) {
        NSString *alert = [[NSUserDefaults standardUserDefaults] objectForKey:@"alert"];
        
        if ([[VENClassEmptyManager sharedManager] isEmptyString:alert]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"alert"];
            [defaults synchronize];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"1、“藏语日常用语学习助手”手机应用软件旨在响应国网青海省电力公司员工学习藏语口活动的开展，做为职工学习藏语口语的小工具。本助手收集了日常生活用语、电力服务常用语句及基本的常用词汇，以方便使用者查阅和学习；\n2、本助手发音为安多方言，但汉藏语系形式较多，即便是安多方言，也会存在着不同的差异，其书面语和口语之间也会有所不同，助手中个别播音与文字内容稍有差异，请学习者注意；\n3、助手中提供了藏语的谐音读法，但因藏语发音丰富，很多音节无法用汉字准确表述，所以仅供学习者参考，正确读音应以播音为准；\n4、本助手收集的词汇有限，今后将逐步扩充；\n5、我们期待您对本助手提出宝贵的意见，我们会不断完善和改进，以期对您的藏语之行有所助益。"  preferredStyle:UIAlertControllerStyleAlert];
            
            NSArray *subViews = alert.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews;
//            UILabel *titleLb = subViews[0];
            UILabel *messageLb = subViews[1];
            messageLb.textAlignment = NSTextAlignmentLeft;
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self setupData];
            }];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            NSString *currentLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLength"];
            if ([currentLength integerValue] != 0) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"数据传输意外中断，必须更新数据库以使其完整。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:nil];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    VENDataUpdateViewController *vc = [[VENDataUpdateViewController alloc] init];
                    vc.blk = ^(NSString *str) {
                        // 打开数据库
                        if ([[VENSQLiteManager sharedSQLiteManager] openDB]) {
                            [self setupHomePageData];
                        }
                    };
                    [self presentViewController:vc animated:YES completion:nil];
                }];
                
                [alert addAction:appropriateAction];
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            [self setupData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigation];
    [self setupTabBar];
    [self setupTableView];
    [self setupTableHeaderView];
    
    self.indexPathRow = -1; // 设置展开 cell 初始值
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _indexPathRow) {
        VENMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.dataSource = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.titleButton addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        
        cell.starButton.hidden = self.showCollectionButton ? NO : YES;
        cell.starButton.selected = [_dataSource[indexPath.row][@"collection"] isEqualToString:@"1"] ? NO : YES;
        cell.starButton.tag = indexPath.row;
        [cell.starButton addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 搜索 改变关键字颜色
        if (_changLabelTitle) {
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _dataSource[indexPath.row][@"name"]]];
            
            for (NSString *keyWord in [_keyWord componentsSeparatedByString:@" "]) {
//                NSLog(@"%lu", (unsigned long)[_dataSource[indexPath.row][@"name"] rangeOfString:keyWord].location);
                
                [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([_dataSource[indexPath.row][@"name"] rangeOfString:keyWord].location, keyWord.length)];
            }
            
            cell.titleLabel.attributedText = attributedStr;
        } else {
            cell.titleLabel.text = _dataSource[indexPath.row][@"name"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)titleButtonClick {
    self.indexPathRow = -1;
    [self.tableView reloadData];
}

- (void)starButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    // 更改收藏状态
    NSString *SQL = [NSString stringWithFormat:@"update 'tablewords' set collection='%d' where id='%@'", !button.selected, _dataSource[button.tag][@"id"]];
    
    if ([[VENSQLiteManager sharedSQLiteManager] execSQL:SQL]) {
        NSLog(@"对应数据修改成功");
    }
    
    _dataSource[button.tag][@"collection"] = button.selected == YES ? @"0" : @"1";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPathRow = indexPath.row;
    
    [tableView reloadData];
    
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.view endEditing:YES];
    return self.indexPathRow == indexPath.row ? 200 : 50;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - 120.5 - tabBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[VENMainTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView = tableView;
}

- (void)setupTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 380)];
    
    VENZyPageView *backgroundView = [[[NSBundle mainBundle] loadNibNamed:@"VENZyPageView" owner:self options:nil] lastObject];
    backgroundView.frame = CGRectMake(32, 50, kMainScreenWidth - 64, 325);
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.masksToBounds = YES;
    
    backgroundView.block = ^(NSString *str, NSString *str2) {
        VENWebViewController *vc = [[VENWebViewController alloc] init];
        vc.fileNumber = str;
        vc.title = str2;
        [self presentViewController:vc animated:YES completion:nil];
        
        vc.blk = ^(NSString *str) {
            self.isRefresh = YES;
        };
    };
    
    [headerView addSubview:backgroundView];
    
    _headerView = headerView;
}

- (VENPopView *)popView {
    if (_popView == nil) {
        
        self.tableView.tableHeaderView = nil;
        
        CGFloat height = ceil(self.dataMuArr.count / 4.0) * 44 + 44;
        VENPopView *popView = [[VENPopView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, height) setPopViewData:self.dataMuArr]; // 必须除以 4.0
        
        popView.returnButtonTagBlock = ^(NSInteger buttonTag, NSString *buttonTitle) {
//            NSLog(@"%@", buttonTitle);
            for (NSDictionary *tempDict in self.tablesmallstyleArr) { // tempDict 点击的二级类
                if ([buttonTitle isEqualToString:tempDict[@"name"]]) {
                    [self.dataSource removeAllObjects]; // 恢复 数据源
//                    NSLog(@"%@", tempDict[@"id"]);
                    
                    for (NSDictionary *tempDict2 in self.tablewordsArr) { //
                        if ([tempDict[@"id"] isEqualToString:tempDict2[@"styleid"]]) {
//                            NSLog(@"%@", tempDict2[@"name"]);
                            
                            [self.dataSource addObject:tempDict2];
                            self.indexPathRow = -1; // 更换三级类 取消展开 cell
                            self.showCollectionButton = NO;
                            self.changLabelTitle = NO;
                            [self.tableView reloadData];
                        }
                    }
                }
            }
        };
        
        [self.view addSubview:popView];
        
        _popView = popView;
        
        self.tableView.frame = CGRectMake(0, 120.5 + height, kMainScreenWidth, kMainScreenHeight - 120.5 - height - tabBarHeight);
    }
    return _popView;
}

- (void)setupData {
    
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
            NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
            
            NSLog(@"serverStr - %@", serverStr);
            NSLog(@"localStr - %@", localStr);
            
            if ([[VENClassEmptyManager sharedManager] isEmptyString:serverStr]) {
                [[VENMBProgressHUDManager sharedMBProgressHUDManager] showText:@"网络不可用"];
            } else {
                
                self.serverStr = serverStr;
                
                // 最新版本
                if ([localStr isEqualToString:serverStr]) {
                    
                    // 打开数据库
                    if ([[VENSQLiteManager sharedSQLiteManager] openDB]) {
                        [self setupHomePageData];
                    }
                } else {
                    
                    NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
                    NSString *alertTitle = localStr == nil && localStr.length < 1 ? @"需要更新数据才能建立本地词库！" : @"检测到词库有更新，是否去更新？";
                    
                    // 需要更新数据库
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 打开数据库
                        if ([[VENSQLiteManager sharedSQLiteManager] openDB]) {
                            [self setupHomePageData];
                        }
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        VENDataUpdateViewController *vc = [[VENDataUpdateViewController alloc] init];
                        vc.blk = ^(NSString *str) {
                            // 打开数据库
                            if ([[VENSQLiteManager sharedSQLiteManager] openDB]) {
                                [self setupHomePageData];
                            }
                        };
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                    
                    [alert addAction:appropriateAction];
                    [alert addAction:cancelAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        }] resume];
    }
}

- (void)setupHomePageData {
    // 查询数据库
    // 查询语句
    NSString *querySQL = @"select id,name,parentid from tablesmallstyle;";
    self.tablesmallstyleArr = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL];
    
    NSString *querySQL2 = @"select id,name,tibetan,homophonic,number,styleid,collection from tablewords;";
    self.tablewordsArr = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL2];
    
    // 解决 二级目录 进入更多页面返回后 条数增加问题
    [self.secondTableTitleMuArr1 removeAllObjects];
    [self.secondTableTitleMuArr2 removeAllObjects];
    [self.secondTableTitleMuArr3 removeAllObjects];
    
    for (NSDictionary *tempDict in self.tablesmallstyleArr) {
        if ([tempDict[@"parentid"] isEqualToString:@"1"]) {
            [self.secondTableTitleMuArr1 addObject:tempDict[@"name"]];
        } else if ([tempDict[@"parentid"] isEqualToString:@"2"]) {
            [self.secondTableTitleMuArr2 addObject:tempDict[@"name"]];
        } else if ([tempDict[@"parentid"] isEqualToString:@"3"]) {
            [self.secondTableTitleMuArr3 addObject:tempDict[@"name"]];
        }
    }
    
    // 进入 APP 显示所有数据
    [self.dataSource addObjectsFromArray:self.tablewordsArr];
    [self.tableView reloadData];
}

- (void)setupTabBar {
    VENTabBarView *tabBar = [[VENTabBarView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - tabBarHeight, kMainScreenWidth, tabBarHeight)];
    tabBar.blk = ^(NSString *str) {
        
        [self.dataSource removeAllObjects];
        
        self.indexPathRow = -1;
        [self.popView removeFromSuperview];
        self.popView = nil;
        
        self.tableView.tableHeaderView = nil;
        
        self.tableView.frame = CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - tabBarHeight - 120.5);
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"hiddenNavButton" object:nil]];
        
        if ([str isEqualToString:@"sjgx"]) {
            VENDataUpdateViewController *vc = [[VENDataUpdateViewController alloc] init];
            vc.blk = ^(NSString *str) {
                // 打开数据库
                if ([[VENSQLiteManager sharedSQLiteManager] openDB]) {
                    [self setupHomePageData];
                }
            };
            [self presentViewController:vc animated:YES completion:nil];
            self.showCollectionButton = NO;
            self.changLabelTitle = NO;
        } else if ([str isEqualToString:@"gy"]) {
            VENAboutViewController *vc = [[VENAboutViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            self.showCollectionButton = NO;
            self.changLabelTitle = NO;
        } else if ([str isEqualToString:@"bz"]) {
            VENHelpViewController *vc = [[VENHelpViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            self.showCollectionButton = NO;
            self.changLabelTitle = NO;
        } else if ([str isEqualToString:@"sy"]) {
            NSString *querySQL = @"select id,name,tibetan,homophonic,number,styleid,collection from tablewords;";
            self.dataSource = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL];
            self.showCollectionButton = NO;
            self.changLabelTitle = NO;
        } else if ([str isEqualToString:@"sc"]) {
            NSString *querySQL = @"select * from tablewords where collection > 0;";
            self.dataSource = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL];
            self.showCollectionButton = YES;
            self.changLabelTitle = NO;
        } else if ([str isEqualToString:@"zy"]){
            self.tableView.backgroundColor = UIColorMake(242, 238, 241);
            self.tableView.tableHeaderView = self.headerView;
        } else if ([str isEqualToString:@"rjsm"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"1、“藏语日常用语学习助手”手机应用软件旨在响应国网青海省电力公司员工学习藏语口活动的开展，做为职工学习藏语口语的小工具。本助手收集了日常生活用语、电力服务常用语句及基本的常用词汇，以方便使用者查阅和学习；\n2、本助手发音为安多方言，但汉藏语系形式较多，即便是安多方言，也会存在着不同的差异，其书面语和口语之间也会有所不同，助手中个别播音与文字内容稍有差异，请学习者注意；\n3、助手中提供了藏语的谐音读法，但因藏语发音丰富，很多音节无法用汉字准确表述，所以仅供学习者参考，正确读音应以播音为准；\n4、本助手收集的词汇有限，今后将逐步扩充；\n5、我们期待您对本助手提出宝贵的意见，我们会不断完善和改进，以期对您的藏语之行有所助益。"  preferredStyle:UIAlertControllerStyleAlert];
            
            NSArray *subViews = alert.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews;
//            UILabel *titleLb = subViews[0];
            UILabel *messageLb = subViews[1];
            messageLb.textAlignment = NSTextAlignmentLeft;
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self.tableView reloadData];
    };
    [self.view addSubview:tabBar];
}

- (void)setupNavigation {
    VENNavigationBar *navBar = [[VENNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120.5)];
    
    __weak typeof(self) weakSelf = self;
    navBar.returnValueBlock = ^(NSString *strValue, NSInteger buttonTag, NSString *buttonTitle) {
        if ([strValue isEqualToString:@"show"]) {
            
            [weakSelf.dataSource removeAllObjects];
            weakSelf.indexPathRow = -1;
            weakSelf.showCollectionButton = NO;
            weakSelf.changLabelTitle = NO;
            
            [weakSelf.popView removeFromSuperview];
            weakSelf.popView = nil;
            [weakSelf.dataMuArr removeAllObjects];
            
            if (buttonTag == 1) [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr1];
            else if (buttonTag == 2) [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr2];
            else [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr3];
            
            [weakSelf.dataMuArr addObject:buttonTitle];
            
            [weakSelf popView];
            
            // 点击 Nav 按钮 显示 一级类下所有二级类下的 三级数据
            NSString *querySQL = @"select id,name,tibetan,homophonic,number,styleid,collection from tablewords;";
//            [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL];
            
            for (NSDictionary *arr in [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL]) {
                if (buttonTag == 1) {
                    if ([arr[@"styleid"] integerValue] <= weakSelf.secondTableTitleMuArr1.count) {
                        [weakSelf.dataSource addObject:arr];
                    }
                } else if (buttonTag == 2) {
                    if ([arr[@"styleid"] integerValue] > weakSelf.secondTableTitleMuArr1.count && [arr[@"styleid"] integerValue] <= weakSelf.secondTableTitleMuArr1.count + weakSelf.secondTableTitleMuArr2.count) {
                        [weakSelf.dataSource addObject:arr];
                    }
                } else {
                    if ([arr[@"styleid"] integerValue] > weakSelf.secondTableTitleMuArr1.count + weakSelf.secondTableTitleMuArr2.count) {
                        [weakSelf.dataSource addObject:arr];
                    }
                }
            }
            
            // 每次滚到顶部
            [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            
            [weakSelf.tableView reloadData];
        }
    };
    
    // 搜索
    navBar.blk = ^(NSArray *arr, NSString *keyWord) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:arr];
        weakSelf.indexPathRow = -1;
        weakSelf.showCollectionButton = NO;
        self.changLabelTitle = YES;
        [weakSelf.tableView reloadData];
        
        self.keyWord = keyWord;
        
        NSLog(@"%@", self.keyWord);
    };
    
    navBar.blk3 = ^(NSString *str) {
        [weakSelf.popView removeFromSuperview];
        weakSelf.popView = nil;
        
        self.tableView.tableHeaderView = nil;
        
//        [weakSelf.dataSource removeAllObjects];
        weakSelf.tableView.frame = CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - tabBarHeight - 120.5);
        
        
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:navBar];
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

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)secondTableTitleMuArr1 {
    if (_secondTableTitleMuArr1 == nil) {
        _secondTableTitleMuArr1 = [NSMutableArray array];
    }
    return _secondTableTitleMuArr1;
}

- (NSMutableArray *)secondTableTitleMuArr2 {
    if (_secondTableTitleMuArr2 == nil) {
        _secondTableTitleMuArr2 = [NSMutableArray array];
    }
    return _secondTableTitleMuArr2;
}

- (NSMutableArray *)secondTableTitleMuArr3 {
    if (_secondTableTitleMuArr3 == nil) {
        _secondTableTitleMuArr3 = [NSMutableArray array];
    }
    return _secondTableTitleMuArr3;
}

- (NSMutableArray *)tablesmallstyleArr {
    if (_tablesmallstyleArr == nil) {
        _tablesmallstyleArr = [NSMutableArray array];
    }
    return _tablesmallstyleArr;
}

- (NSMutableArray *)tablewordsArr {
    if (_tablewordsArr == nil) {
        _tablewordsArr = [NSMutableArray array];
    }
    return _tablewordsArr;
}

- (NSMutableArray *)dataMuArr {
    if (_dataMuArr == nil) {
        _dataMuArr = [NSMutableArray array];
    }
    return _dataMuArr;
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 内存告警 清楚所有缓存的Response
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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

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
#import "sqlite3.h"
#import "VENDataUpdateViewController.h"

@interface VENMainViewController () <UITableViewDelegate , UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr1;
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr2;
@property (nonatomic, strong) NSMutableArray *secondTableTitleMuArr3;

@property (nonatomic, strong) NSMutableArray *dataMuArr;

@property (nonatomic, assign) CGFloat cellMaxHeight;

@property (nonatomic, strong) VENNavigationBar *popView;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMainViewController {
    sqlite3 *db;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 底部
    VENNavigationBar *navBar = [[VENNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120.5)];
    
    __weak typeof(self) weakSelf = self;
    navBar.returnValueBlock = ^(NSString *strValue, NSInteger buttonTag, NSString *buttonTitle) {
        if ([strValue isEqualToString:@"show"]) {
            
            [weakSelf.popView removeFromSuperview];
            weakSelf.popView = nil;
            [weakSelf.dataMuArr removeAllObjects];
            
            if (buttonTag == 1) [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr1];
            else if (buttonTag == 2) [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr2];
            else [weakSelf.dataMuArr addObjectsFromArray:self.secondTableTitleMuArr3];
            
            [weakSelf.dataMuArr addObject:buttonTitle];
            
            [weakSelf popView];
        }
    };
    [self.view addSubview:navBar];

    // 顶部
    VENTabBarView *tabBar = [[VENTabBarView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49)];
    tabBar.blk = ^(NSString *str) {
        if ([str isEqualToString:@"sjgx"]) {
            VENDataUpdateViewController *vc = [[VENDataUpdateViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    };
    [self.view addSubview:tabBar];
    
    [self setupTableView];
    
    // 计算 cell 高度
    VENMainTableViewCell *cell = [[VENMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell layoutSubviews];
    self.cellMaxHeight = cell.cellMaxHeight;
    
    
//    NSString *SQLPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SQL.db"];
//    int result = sqlite3_open(SQLPath.UTF8String, &db);
//    
//    if (result == SQLITE_OK) {
//        NSLog(@"数据库创建打开成功");
//        
//        NSString *createSQL = @"create table if not exists tablewords(id integer primary key,homophonic text not null,name text not null,styleid integer);";
//        
//        char *errmsg = NULL;
//        
//        sqlite3_exec(db, createSQL.UTF8String, NULL, NULL, &errmsg);
//        if (errmsg == nil) {
//            NSLog(@"建表成功");
//        }
//    }
    

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    // 新增SQL语句
//    NSString *insertSQL = @"insert into tablewords(homophonic,name,styleid) values('叽里呱啦','吃了没','3');";
//    // 保存错误信息
//    char *errmsg = NULL;
//    
//    sqlite3_exec(db, insertSQL.UTF8String, NULL, NULL, &errmsg);
//    if (errmsg == nil) {
//        
//        // 获取影响的行数
//        int changes = sqlite3_changes(db);
//        NSLog(@"insert影响的行数 %d",changes);
//        
//        NSLog(@"新增成功");
//    }
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    VENMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@", self.secondTableTitleMuArr3[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.cellMaxHeight;
    return 44;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - 120.5 - 49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[VENMainTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView = tableView;
}

- (VENPopView *)popView {
    if (_popView == nil) {
        CGFloat height = ceil(self.dataMuArr.count / 4.0) * 44 + 44;
        VENPopView *popView = [[VENPopView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, height) setPopViewData:self.dataMuArr]; // 必须除以 4.0
        
        __weak typeof(self) weakSelf = self;
        popView.returnButtonTagBlock = ^(NSInteger buttonTag, NSString *buttonTitle) {
            NSLog(@"%ld", (long)buttonTag);
            NSLog(@"%@", buttonTitle);
        };
        
        [self.view addSubview:popView];
        
        _popView = popView;
        
        self.tableView.frame = CGRectMake(0, 120.5 + height, kMainScreenWidth, kMainScreenHeight - 120.5 - height - 49);
    }
    return _popView;
}

- (NSMutableArray *)dataMuArr {
    if (_dataMuArr == nil) {
        _dataMuArr = [NSMutableArray array];
    }
    return _dataMuArr;
}

- (NSMutableArray *)secondTableTitleMuArr1 {
    if (_secondTableTitleMuArr1 == nil) {
        _secondTableTitleMuArr1 = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"]];
    }
    return _secondTableTitleMuArr1;
}

- (NSMutableArray *)secondTableTitleMuArr2 {
    if (_secondTableTitleMuArr2 == nil) {
        _secondTableTitleMuArr2 = [NSMutableArray arrayWithArray:@[@"A", @"B", @"C", @"D", @"E", @"F"]];
    }
    return _secondTableTitleMuArr2;
}

- (NSMutableArray *)secondTableTitleMuArr3 {
    if (_secondTableTitleMuArr3 == nil) {
        _secondTableTitleMuArr3 = [NSMutableArray arrayWithArray:@[@"称谓", @"数字", @"时间", @"日期", @"季节", @"天气", @"交通", @"地名", @"民族", @"职业", @"单位", @"职业", @"单位"]];
    }
    return _secondTableTitleMuArr3;
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

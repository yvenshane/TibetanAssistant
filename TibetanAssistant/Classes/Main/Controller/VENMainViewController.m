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
#import "sqlite3.h"

@interface VENMainViewController () <UITableViewDelegate , UITableViewDataSource>

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
    
    [self setupNavigationBar];
    [self setupTabBar];
    [self setupTableView];
    
    NSString *SQLPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SQL.db"];
    int result = sqlite3_open(SQLPath.UTF8String, &db);
    
    if (result == SQLITE_OK) {
        NSLog(@"数据库创建打开成功");
        
        NSString *createSQL = @"create table if not exists tablewords(id integer primary key,homophonic text not null,name text not null,styleid integer);";
        
        char *errmsg = NULL;
        
        sqlite3_exec(db, createSQL.UTF8String, NULL, NULL, &errmsg);
        if (errmsg == nil) {
            NSLog(@"建表成功");
        }
    }
    
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - 120.5 - 49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupNavigationBar {
    VENNavigationBar *navBar = [[VENNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120.5)];
    navBar.backgroundColor = UIColorMake(0, 156, 132);
    [self.view addSubview:navBar];
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

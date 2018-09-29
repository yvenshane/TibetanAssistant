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
#import "VENHomePageModel.h"

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

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier1 = @"cellIdentifier1";
@implementation VENMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupData];
    
    [self setupNavigation];
    [self setupTabBar];
    [self setupTableView];
    
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
        return cell;
    } else {
        VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        cell.titleLabel.text = _dataSource[indexPath.row][@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPathRow = indexPath.row;
    
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    if (self.indexPathRow == indexPath.row) {
        return 190;
    }
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _indexPathRow) {
////        NSLog(@"%@", _dataSource[_indexPathRow]);
//
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:13.0f];
//        label.text = _dataSource[_indexPathRow][@"name"];
//        CGFloat width = kMainScreenWidth - 10 - 10 - 25 - 10 - 10 - 10 - 10 - 18 - 10;
//        CGFloat height = [self label:label setHeightToWidth:width];
//
//        UILabel *label2 = [[UILabel alloc] init];
//        label2.font = [UIFont systemFontOfSize:13.0f];
//        label2.text = _dataSource[_indexPathRow][@"tibetan"];
//        CGFloat height2 = [self label:label2 setHeightToWidth:width];
//
//        UILabel *label3 = [[UILabel alloc] init];
//        label3.font = [UIFont systemFontOfSize:13.0f];
//        label3.text = _dataSource[_indexPathRow][@"homophonic"];
//        CGFloat width2 = kMainScreenWidth - 10 - 10 - 25 - 10 - 10 - 10;
//        CGFloat height3 = [self label:label3 setHeightToWidth:width2];
//
//        NSLog(@"%f - %f - %f", height, height2, height3);
//
//        return 190 - 45 + height + height2 + height3;
//    }
//    return 50;
//}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - 120.5 - 49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[VENMainTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView = tableView;
}

- (VENPopView *)popView {
    if (_popView == nil) {
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
                            [self.tableView reloadData];
                        }
                    }
                }
            }
            
//            // 计算 cell 高度
//            VENMainTableViewCell *cell = [[VENMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.dataSource = self.dataSource[];
//            [cell layoutSubviews];
//            self.cellMaxHeight = cell.cellMaxHeight;
        };
        
        [self.view addSubview:popView];
        
        _popView = popView;
        
        self.tableView.frame = CGRectMake(0, 120.5 + height, kMainScreenWidth, kMainScreenHeight - 120.5 - height - 49);
    }
    return _popView;
}

- (void)setupData {
    // 打开数据库
    [[VENSQLiteManager sharedSQLiteManager] openDB];
    // 查询数据库
    
    // 查询语句
    NSString *querySQL = @"select id,name,parentid from tablesmallstyle;";
    self.tablesmallstyleArr = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL];
    
    NSString *querySQL2 = @"select id,name,tibetan,homophonic,number,styleid,collection from tablewords;";
    self.tablewordsArr = [[VENSQLiteManager sharedSQLiteManager] queryDBWithSQL:querySQL2];

    for (NSDictionary *tempDict in _tablesmallstyleArr) {
        if ([tempDict[@"parentid"] isEqualToString:@"1"]) {
            [self.secondTableTitleMuArr1 addObject:tempDict[@"name"]];
        } else if ([tempDict[@"parentid"] isEqualToString:@"2"]) {
            [self.secondTableTitleMuArr2 addObject:tempDict[@"name"]];
        } else if ([tempDict[@"parentid"] isEqualToString:@"3"]) {
            [self.secondTableTitleMuArr3 addObject:tempDict[@"name"]];
        }
    }
    
    [self.dataSource addObjectsFromArray:self.tablewordsArr];
    
    
    
    
    
    
    
    
//    int secondTableTitleMuArr1Count = 0;
//    int secondTableTitleMuArr2Count = 0;
//    int secondTableTitleMuArr3Count = 0;
//    
//    for (NSString *str in parentidArr) {

//    }
//    
//    for (NSInteger i = 0; i < secondTableTitleMuArr1Count; i++) {

//    }
//    
//    for (NSInteger i = secondTableTitleMuArr1Count; i < secondTableTitleMuArr1Count + secondTableTitleMuArr2Count; i++) {
//        [self.secondTableTitleMuArr2 addObject:nameArr[i]];
//    }
//    
//    for (NSInteger i = secondTableTitleMuArr1Count + secondTableTitleMuArr2Count; i < secondTableTitleMuArr1Count + secondTableTitleMuArr2Count + secondTableTitleMuArr3Count; i++) {
//        [self.secondTableTitleMuArr3 addObject:nameArr[i]];
//    }
//    
//    // ----------------------------------------------------------------------------------------------------------
//    
//    // 查询数据库
//    NSArray *nameArr2 = [[VENSQLiteManager sharedSQLiteManager] queryDataBaseWithParam:@"name" atTable:@"tablewords"];
//    
//    NSLog(@"%@", nameArr2);
}



- (void)setupTabBar {
    VENTabBarView *tabBar = [[VENTabBarView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49)];
    tabBar.blk = ^(NSString *str) {
        if ([str isEqualToString:@"sjgx"]) {
            VENDataUpdateViewController *vc = [[VENDataUpdateViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    };
    [self.view addSubview:tabBar];
}

- (void)setupNavigation {
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
    
    navBar.blk = ^(NSArray *arr) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:arr];
        weakSelf.indexPathRow = -1;
        [weakSelf.tableView reloadData];
    };
    
    navBar.blk3 = ^(NSString *str) {
        [weakSelf.popView removeFromSuperview];
        weakSelf.popView = nil;
//        [weakSelf.dataSource removeAllObjects];
        weakSelf.tableView.frame = CGRectMake(0, 120.5, kMainScreenWidth, kMainScreenHeight - 49 - 120.5);
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:navBar];
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

//
//  VENMainTableViewCell.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENMainTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *chineseContentLabel;
@property (nonatomic, strong) UIButton *collectionButton;

@property (nonatomic, strong) UILabel *tibetanContentLabel;
@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UILabel *homophonicContentLabel;

@property (nonatomic, copy) NSDictionary *dataSource;

@end

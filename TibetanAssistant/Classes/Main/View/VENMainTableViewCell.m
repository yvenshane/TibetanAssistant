//
//  VENMainTableViewCell.m
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMainTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface VENMainTableViewCell () {
    AVAudioPlayer *musicPlayer;
}

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *detailBackgroundView;

@property (nonatomic, strong) UILabel *chineseTitleLabel;
@property (nonatomic, strong) UILabel *tibetanTitleLabel;
@property (nonatomic, strong) UILabel *homophonicTitleLabel;

@property (nonatomic, copy) NSString *fullPath;

@end

@implementation VENMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorMake(248, 245, 247);
        
        // 标题
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = UIColorMake(247, 172, 0);
        [self addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"标题标题标题标题标题标";
        titleLabel.textColor = UIColorMake(0, 111, 106);
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        // 内容
        UIView *detailBackgroundView = [[UIView alloc] init];
        detailBackgroundView.backgroundColor = [UIColor whiteColor];
        detailBackgroundView.layer.cornerRadius = 8.0f;
        detailBackgroundView.layer.masksToBounds = YES;
        detailBackgroundView.layer.borderWidth = 1.0f;
        detailBackgroundView.layer.borderColor = UIColorMake(221, 221, 221).CGColor;
        [self addSubview:detailBackgroundView];
        
        // 汉
        UILabel *chineseTitleLabel = [[UILabel alloc] init];
        chineseTitleLabel.text = @"汉";
        chineseTitleLabel.textColor = [UIColor whiteColor];
        chineseTitleLabel.textAlignment = NSTextAlignmentCenter;
        chineseTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        chineseTitleLabel.backgroundColor = UIColorMake(97, 192, 181);
        chineseTitleLabel.layer.cornerRadius = 25 / 2;
        chineseTitleLabel.layer.masksToBounds = YES;
        [detailBackgroundView addSubview:chineseTitleLabel];
        
        UILabel *chineseContentLabel = [[UILabel alloc] init];
        chineseContentLabel.text = @"汉字汉字汉字汉汉汉汉字汉字汉字汉汉汉汉字汉字汉字汉汉汉汉字汉字汉字汉汉汉汉字汉字汉";
        chineseContentLabel.textColor = [UIColor blackColor];
        chineseContentLabel.font = [UIFont systemFontOfSize:13.0f];
        chineseContentLabel.numberOfLines = 0;
        [detailBackgroundView addSubview:chineseContentLabel];
        
        // 收藏
        UIButton *collectionButton = [[UIButton alloc] init];
        [collectionButton setImage:[UIImage imageNamed:@"uncollection"] forState:UIControlStateNormal];
        [collectionButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateSelected];
        [detailBackgroundView addSubview:collectionButton];
        [collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 藏
        UILabel *tibetanTitleLabel = [[UILabel alloc] init];
        tibetanTitleLabel.text = @"藏";
        tibetanTitleLabel.textColor = [UIColor whiteColor];
        tibetanTitleLabel.textAlignment = NSTextAlignmentCenter;
        tibetanTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        tibetanTitleLabel.backgroundColor = UIColorMake(97, 192, 181);
        tibetanTitleLabel.layer.cornerRadius = 25 / 2;
        tibetanTitleLabel.layer.masksToBounds = YES;
        [detailBackgroundView addSubview:tibetanTitleLabel];
        
        UILabel *tibetanContentLabel = [[UILabel alloc] init];
        tibetanContentLabel.text = @"藏语藏语藏语藏藏语藏藏语藏藏语藏语语藏藏语藏藏语藏藏语藏语语藏藏语藏藏语藏藏语藏语";
        tibetanContentLabel.textColor = [UIColor blackColor];
        tibetanContentLabel.font = [UIFont systemFontOfSize:13.0f];
        tibetanContentLabel.numberOfLines = 0;
        [detailBackgroundView addSubview:tibetanContentLabel];
        
        // 播放
        UIButton *voiceButton = [[UIButton alloc] init];
        [voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [detailBackgroundView addSubview:voiceButton];
        [voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 谐
        UILabel *homophonicTitleLabel = [[UILabel alloc] init];
        homophonicTitleLabel.text = @"谐";
        homophonicTitleLabel.textColor = [UIColor whiteColor];
        homophonicTitleLabel.textAlignment = NSTextAlignmentCenter;
        homophonicTitleLabel.font = [UIFont systemFontOfSize:13.0f];
        homophonicTitleLabel.backgroundColor = UIColorMake(97, 192, 181);
        homophonicTitleLabel.layer.cornerRadius = 25 / 2;
        homophonicTitleLabel.layer.masksToBounds = YES;
        [detailBackgroundView addSubview:homophonicTitleLabel];
        
        UILabel *homophonicContentLabel = [[UILabel alloc] init];
        homophonicContentLabel.text = @"谐音谐音谐谐音谐音谐谐音谐音";
        homophonicContentLabel.textColor = [UIColor blackColor];
        homophonicContentLabel.font = [UIFont systemFontOfSize:13.0f];
        homophonicContentLabel.numberOfLines = 0;
        [detailBackgroundView addSubview:homophonicContentLabel];
        
        self.titleView = titleView;
        self.titleLabel = titleLabel;
        self.detailBackgroundView = detailBackgroundView;
        
        self.chineseTitleLabel = chineseTitleLabel;
        self.chineseContentLabel = chineseContentLabel;
        self.collectionButton = collectionButton;
        
        self.tibetanTitleLabel = tibetanTitleLabel;
        self.tibetanContentLabel = tibetanContentLabel;
        self.voiceButton = voiceButton;
        
        self.homophonicTitleLabel = homophonicTitleLabel;
        self.homophonicContentLabel = homophonicContentLabel;
    }
    return self;
}

- (void)voiceButtonClick:(UIButton *)button {
    
    self.voiceButton.userInteractionEnabled = NO;
    
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.fullPath]];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];

    [self.contentView.layer addSublayer:playerLayer];
    
    [player play];
    
    // 监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
}

- (void)playbackFinished:(NSNotification *)noti {
    self.voiceButton.userInteractionEnabled = YES;
}

- (void)collectionButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    // 更改收藏状态
    NSString *SQL = [NSString stringWithFormat:@"update 'tablewords' set collection='%d' where id='%@'", button.selected, _dataSource[@"id"]];
    
    if ([[VENSQLiteManager sharedSQLiteManager] execSQL:SQL]) {
        NSLog(@"对应数据修改成功");
    }
    
    _dataSource[@"collection"] = button.selected == YES ? @"1" : @"0";
}

- (void)setDataSource:(NSMutableDictionary *)dataSource {
    _dataSource = dataSource;
    
    self.titleLabel.text = dataSource[@"name"];
    self.chineseContentLabel.text = dataSource[@"name"];
    self.tibetanContentLabel.text = dataSource[@"tibetan"];
    self.homophonicContentLabel.text = dataSource[@"homophonic"];
    self.collectionButton.selected = [dataSource[@"collection"] integerValue] == 1 ? YES : NO;
    
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/zyzs/py/VP/%@.mp3", dataSource[@"number"]]];
    
    self.fullPath = fullPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleView.frame = CGRectMake(10, 15, 5, 15);
    
    CGFloat height = [self label:self.titleLabel setHeightToWidth:kMainScreenWidth - 10 - 5 - 10 - 10];
    self.titleLabel.frame = CGRectMake(10 + 5 + 10, 15, kMainScreenWidth - 10 - 5 - 10 - 10, height);
    
    CGFloat detailBackgroundViewMaxHeight;
    // 汉
    self.chineseTitleLabel.frame = CGRectMake(10, 15, 25, 25);
    CGFloat width = kMainScreenWidth - 10 - 10 - 25 - 10 - 10 - 10 - 10 - 36 - 10;
    CGFloat height1 = [self label:self.chineseContentLabel setHeightToWidth:width];
    self.chineseContentLabel.frame = CGRectMake(10 + 25 + 10, 15 + 25 / 2 - 15 / 2, width + 10, height1);
    
    detailBackgroundViewMaxHeight = height1 < 25 ? self.chineseContentLabel.frame.origin.y + self.chineseContentLabel.frame.size.height + 10 : self.chineseContentLabel.frame.origin.y + self.chineseContentLabel.frame.size.height;
    
    // 收藏
    self.collectionButton.frame = CGRectMake(width + 10 + 10 + 25 + 10, 15 + 25 / 2 - 36 / 2, 36, 36);
    
    // 藏
    self.tibetanTitleLabel.frame = CGRectMake(10, detailBackgroundViewMaxHeight, 25, 25);
    CGFloat height2 = [self label:self.tibetanContentLabel setHeightToWidth:width];
    self.tibetanContentLabel.frame = CGRectMake(10 + 25 + 10, detailBackgroundViewMaxHeight + 25 / 2 - 15 / 2, width + 10, height2);
    detailBackgroundViewMaxHeight = height2 < 25 ? self.tibetanContentLabel.frame.origin.y + self.tibetanContentLabel.frame.size.height + 10 : self.tibetanContentLabel.frame.origin.y + self.tibetanContentLabel.frame.size.height;
    
    // 播放
    CGFloat tempHeight = height1 > 25 ? height1 : height1 + 10;
    self.voiceButton.frame = CGRectMake(width + 10 + 10 + 25 + 10, 15 + 25 / 2 - 15 / 2 + 25 / 2 - 36 / 2 + tempHeight + 5, 36, 36);
    
    //   ↑ Y + 5 
    
    // 谐
    self.homophonicTitleLabel.frame = CGRectMake(10, detailBackgroundViewMaxHeight, 25, 25);
    CGFloat height3 = [self label:self.homophonicContentLabel setHeightToWidth:kMainScreenWidth - 10 - 10 - 25 - 10 - 10 - 10];
    self.homophonicContentLabel.frame = CGRectMake(10 + 25 + 10, detailBackgroundViewMaxHeight + 25 / 2 - 15 / 2, kMainScreenWidth - 10 - 10 - 25 - 10 - 10 - 10, height3);
    detailBackgroundViewMaxHeight = height3 < 25 ? self.homophonicContentLabel.frame.origin.y + self.homophonicContentLabel.frame.size.height + 15 + 5 : self.homophonicContentLabel.frame.origin.y + self.homophonicContentLabel.frame.size.height + 15;
    
    // 背景
    self.detailBackgroundView.frame = CGRectMake(10, height + 15 + 15, kMainScreenWidth - 20, detailBackgroundViewMaxHeight);
}

- (CGFloat)label:(UILabel *)label setHeightToWidth:(CGFloat)width {
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

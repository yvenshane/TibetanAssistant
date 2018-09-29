//
//  VENHomePageModel.h
//  TibetanAssistant
//
//  Created by YVEN on 2018/9/28.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tibetan;
@property (nonatomic, copy) NSString *homophonic;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *styleid;
@property (nonatomic, copy) NSString *collection;

@end

NS_ASSUME_NONNULL_END

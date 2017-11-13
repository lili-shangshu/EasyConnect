//
//  SPSettingManager.m
//  IosBasic
//
//  Created by Nathan Ou on 15/4/14.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPSettingManager.h"

static NSString * kMainColorKey = @"主题颜色";

// TabBar
static NSString * kTabBarTitlesSetting = @"底部标签栏";

// 首页项
static NSString * kBannerHidden = @"是否隐藏Banners";
static NSString * kMainToolsHiddenKey = @"是否隐藏主页工具栏";
static NSString * kRecommendGoodsTitle = @"好货推荐的名称";
static NSString * kRecommendGoodsHidden = @"好货推荐是否隐藏";
static NSString * kNewsTitle = @"最新资讯的名称";
static NSString * kNewsHidden = @"最新资讯是否隐藏";

@implementation SPSettingManager

+ (SPSettingManager *)shareManager
{
    static dispatch_once_t once;
    static SPSettingManager* shareManager;
    dispatch_once(&once, ^ {
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (NSDictionary *)settingDictionary
{
    if (!_settingDictionary) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SettingProperty" ofType:@"plist"];
        _settingDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return _settingDictionary;
}

@end

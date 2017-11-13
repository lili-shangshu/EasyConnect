//
//  SPSettingManager.h
//  IosBasic
//
//  Created by Nathan Ou on 15/4/14.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSettingManager : NSObject

@property (nonatomic, strong) NSDictionary *settingDictionary;

@property (nonatomic, strong) UIColor *mainColor;

@property (nonatomic, strong) NSArray *tabbarTitles;

//主页选项

@property (nonatomic, assign) BOOL showBanner; // 显示Banner

@property (nonatomic, assign) BOOL showMainTools; // 显示主页工具栏

@property (nonatomic, strong) NSString *recommendGoodsTitle; // 推荐商品标题
@property (nonatomic, assign) BOOL showRecommendGoods;  // 显示推荐商品

@property (nonatomic, strong) NSString *infoTitle; // 资讯标题
@property (nonatomic, assign) BOOL showInfo; // 显示资讯

@end
